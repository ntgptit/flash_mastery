package com.flash.mastery.service.impl;

import com.flash.mastery.constant.MessageKeys;
import com.flash.mastery.constant.NumberConstants;
import com.flash.mastery.dto.request.DeckCreateRequest;
import com.flash.mastery.dto.request.DeckUpdateRequest;
import com.flash.mastery.dto.response.DeckResponse;
import com.flash.mastery.entity.Deck;
import com.flash.mastery.entity.Flashcard;
import com.flash.mastery.entity.FlashcardType;
import com.flash.mastery.entity.Folder;
import com.flash.mastery.exception.NotFoundException;
import com.flash.mastery.mapper.DeckMapper;
import com.flash.mastery.repository.DeckRepository;
import com.flash.mastery.repository.FlashcardRepository;
import com.flash.mastery.repository.FolderRepository;
import com.flash.mastery.service.DeckService;
import com.flash.mastery.util.DeckSortOption;
import com.flash.mastery.util.SortMapper;
import com.flash.mastery.util.importer.ImportResult;
import com.flash.mastery.util.importer.ImporterFactory;
import com.flash.mastery.util.importer.RowContext;
import java.util.List;
import java.util.UUID;
import java.util.ArrayList;
import org.apache.commons.lang3.StringUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@Transactional
@RequiredArgsConstructor
public class DeckServiceImpl implements DeckService {

  private static final int TEXT_LIMIT = 255;

  private final DeckRepository deckRepository;
  private final FlashcardRepository flashcardRepository;
  private final FolderRepository folderRepository;
  private final DeckMapper deckMapper;
  private final MessageSource messageSource;

  @Override
  @Transactional(readOnly = true)
  public List<DeckResponse> getDecks(UUID folderId, String sort, int page, int size, String query) {
    DeckSortOption sortOption = DeckSortOption.from(sort);
    Pageable pageable = PageRequest.of(page, size, SortMapper.toSort(sortOption));
    Page<Deck> deckPage;
    boolean hasQuery = query != null && !query.isBlank();
    if (folderId == null) {
      deckPage = hasQuery
          ? deckRepository.findByNameContainingIgnoreCase(query, pageable)
          : deckRepository.findAll(pageable);
      return deckPage.stream().map(deckMapper::toResponse).toList();
    }

    if (hasQuery) {
      deckPage = deckRepository.findByFolderIdAndNameContainingIgnoreCase(folderId, query, pageable);
      return deckPage.stream().map(deckMapper::toResponse).toList();
    }

    deckPage = deckRepository.findByFolderId(folderId, pageable);
    return deckPage.stream().map(deckMapper::toResponse).toList();
  }

  @Override
  @Transactional(readOnly = true)
  public DeckResponse getDeck(UUID id) {
    Deck deck = deckRepository.findById(id)
        .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_DECK)));
    return deckMapper.toResponse(deck);
  }

  @Override
  public DeckResponse create(DeckCreateRequest request) {
    Folder folder = folderRepository.findById(request.getFolderId())
        .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
    Deck deck = deckMapper.fromCreate(request, folder);
    Deck saved = deckRepository.save(deck);
    folder.setDeckCount(folder.getDeckCount() + NumberConstants.ONE);
    folderRepository.save(folder);
    return deckMapper.toResponse(saved);
  }

  @Override
  public DeckResponse update(UUID id, DeckUpdateRequest request) {
    Deck deck = deckRepository.findById(id)
        .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_DECK)));
    Folder folder = deck.getFolder();
    if (request.getFolderId() != null) {
      folder = folderRepository.findById(request.getFolderId())
          .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
    }
    deckMapper.update(deck, request, folder);
    if (request.getType() != null) {
      deck.setType(request.getType());
    }
    Deck saved = deckRepository.save(deck);
    return deckMapper.toResponse(saved);
  }

  @Override
  public void delete(UUID id) {
    Deck deck = deckRepository.findById(id)
        .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_DECK)));
    deckRepository.delete(deck);
    Folder folder = deck.getFolder();
    if (folder != null && folder.getDeckCount() > NumberConstants.ZERO) {
      folder.setDeckCount(folder.getDeckCount() - NumberConstants.ONE);
      folderRepository.save(folder);
    }
  }

  private String msg(String key) {
    return messageSource.getMessage(key, null, LocaleContextHolder.getLocale());
  }

  @Override
  public ImportResult<ImportRow> importDecks(UUID folderId, MultipartFile file, FlashcardType type) throws java.io.IOException {
    Folder folder = folderRepository.findById(folderId)
        .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
    var importer = ImporterFactory.<ImportRow>forFilename(file.getOriginalFilename());
    ImportResult<ImportRow> parsed = importer.importStream(file.getInputStream(), ctx -> mapRow(ctx));
    persistRows(parsed.getItems(), folder, type);
    return parsed;
  }

  private ImportRow mapRow(RowContext ctx) {
    if (ctx.cells().isEmpty()) return null;
    String first = StringUtils.trimToEmpty(ctx.cell(0));
    if (first.isEmpty()) return null;
    if (first.startsWith("*")) {
      String deckName = StringUtils.trimToEmpty(first.substring(1));
      if (deckName.isEmpty()) deckName = "Imported Deck";
      return ImportRow.deck(ctx.rowIndex(), clamp(deckName));
    }
    if (ctx.cells().size() < 2) {
      throw new IllegalArgumentException("Missing vocabulary or meaning");
    }
    String vocab = StringUtils.trimToNull(ctx.cell(0));
    String meaning = StringUtils.trimToNull(ctx.cell(1));
    if (vocab == null || meaning == null) {
      throw new IllegalArgumentException("Vocabulary/meaning is blank");
    }
    return ImportRow.card(ctx.rowIndex(), clamp(vocab), clamp(meaning));
  }

  private void persistRows(List<ImportRow> rows, Folder folder, FlashcardType defaultType) {
    List<Flashcard> buffer = new ArrayList<>();
    Deck currentDeck = null;
    final int batchSize = 500;
    for (ImportRow row : rows) {
      if (row.kind == ImportRow.Kind.DECK) {
        flushBatch(buffer, currentDeck);
        currentDeck = createDeck(row.deckName, folder, defaultType);
        continue;
      }
      if (currentDeck == null) {
        currentDeck = createDeck("Imported Deck", folder, defaultType);
      }
      buffer.add(
          Flashcard.builder()
              .question(row.vocab)
              .answer(row.meaning)
              .type(defaultType)
              .deck(currentDeck)
              .build());
      if (buffer.size() >= batchSize) {
        flushBatch(buffer, currentDeck);
      }
    }
    flushBatch(buffer, currentDeck);
  }

  private void flushBatch(List<Flashcard> buffer, Deck currentDeck) {
    if (currentDeck == null || buffer.isEmpty()) return;
    flashcardRepository.saveAll(buffer);
    currentDeck.setCardCount(currentDeck.getCardCount() + buffer.size());
    deckRepository.save(currentDeck);
    buffer.clear();
  }

  private Deck createDeck(String name, Folder folder, FlashcardType type) {
    Deck deck = Deck.builder()
        .name(clamp(name))
        .description("Imported deck")
        .folder(folder)
        .cardCount(0)
        .type(type)
        .build();
    Deck saved = deckRepository.save(deck);
    folder.setDeckCount(folder.getDeckCount() + 1);
    folderRepository.save(folder);
    return saved;
  }

  private String clamp(String value) {
    if (value == null) {
      return null;
    }
    return value.length() > TEXT_LIMIT ? value.substring(0, TEXT_LIMIT) : value;
  }

  private record ImportRow(int rowIndex, Kind kind, String deckName, String vocab, String meaning) {
    enum Kind { DECK, CARD }

    static ImportRow deck(int rowIndex, String name) {
      return new ImportRow(rowIndex, Kind.DECK, name, null, null);
    }

    static ImportRow card(int rowIndex, String vocab, String meaning) {
      return new ImportRow(rowIndex, Kind.CARD, null, vocab, meaning);
    }
  }
}
