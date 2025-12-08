package com.flash.mastery.service.impl;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.apache.commons.lang3.StringUtils;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.flash.mastery.constant.MessageKeys;
import com.flash.mastery.constant.NumberConstants;
import com.flash.mastery.constant.RepositoryConstants;
import com.flash.mastery.constant.ValidationConstants;
import com.flash.mastery.dto.criteria.DeckSearchCriteria;
import com.flash.mastery.dto.request.DeckCreateRequest;
import com.flash.mastery.dto.request.DeckUpdateRequest;
import com.flash.mastery.dto.response.DeckResponse;
import com.flash.mastery.entity.Deck;
import com.flash.mastery.entity.Flashcard;
import com.flash.mastery.entity.enums.FlashcardType;
import com.flash.mastery.entity.Folder;
import com.flash.mastery.exception.NotFoundException;
import com.flash.mastery.mapper.DeckMapper;
import com.flash.mastery.repository.DeckRepository;
import com.flash.mastery.repository.FlashcardRepository;
import com.flash.mastery.repository.FolderRepository;
import com.flash.mastery.service.BaseService;
import com.flash.mastery.service.DeckService;
import com.flash.mastery.entity.enums.DeckSortOption;
import com.flash.mastery.util.NaturalOrderComparator;
import com.flash.mastery.util.importer.ImportResult;
import com.flash.mastery.util.importer.ImporterFactory;
import com.flash.mastery.util.importer.RowContext;

@Service
@Transactional
public class DeckServiceImpl extends BaseService implements DeckService {


    private final DeckRepository deckRepository;
    private final FlashcardRepository flashcardRepository;
    private final FolderRepository folderRepository;
    private final DeckMapper deckMapper;

    public DeckServiceImpl(
            DeckRepository deckRepository,
            FlashcardRepository flashcardRepository,
            FolderRepository folderRepository,
            DeckMapper deckMapper,
            MessageSource messageSource) {
        super(messageSource);
        this.deckRepository = deckRepository;
        this.flashcardRepository = flashcardRepository;
        this.folderRepository = folderRepository;
        this.deckMapper = deckMapper;
    }

    @Override
    @Transactional(readOnly = true)
    public List<DeckResponse> getDecks(UUID folderId, String sort, int page, int size, String query) {
        final var sortOption = DeckSortOption.from(sort);
        final var isNameSort = (sortOption == DeckSortOption.NAME_ASC) || (sortOption == DeckSortOption.NAME_DESC);

        // Build search criteria
        final var criteria = DeckSearchCriteria.builder()
                .folderId(folderId)
                .query(query)
                .build();

        // Execute search based on criteria
        List<Deck> decks;
        if (isNameSort) {
            // For name sorting, fetch all data to sort in memory with natural order
            decks = fetchAllDecksForCriteria(criteria);
            decks = applyNaturalOrderSort(decks, sortOption);
            decks = applyPagination(decks, page, size);
        } else {
            // For other sorts, use database sorting with pagination
            final int offset = page * size;
            final int limit = size;
            decks = fetchDecksForCriteriaWithPagination(criteria, offset, limit);
        }

        return decks.stream().map(this.deckMapper::toResponse).toList();
    }

    private List<Deck> fetchAllDecksForCriteria(DeckSearchCriteria criteria) {
        final boolean hasFolder = criteria.hasFolderFilter();
        final boolean hasQuery = criteria.hasQueryFilter();

        if (hasFolder && hasQuery) {
            // Get all with default offset and max limit
            return this.deckRepository.findByFolderIdAndNameContainingIgnoreCase(
                    criteria.getFolderId(),
                    criteria.getQuery(),
                    RepositoryConstants.DEFAULT_OFFSET,
                    RepositoryConstants.MAX_LIMIT);
        } else if (hasFolder) {
            return this.deckRepository.findByFolderId(criteria.getFolderId(), RepositoryConstants.DEFAULT_OFFSET, RepositoryConstants.MAX_LIMIT);
        } else if (hasQuery) {
            return this.deckRepository.findByNameContainingIgnoreCase(criteria.getQuery(), RepositoryConstants.DEFAULT_OFFSET, RepositoryConstants.MAX_LIMIT);
        } else {
            return this.deckRepository.findAll(RepositoryConstants.DEFAULT_OFFSET, RepositoryConstants.MAX_LIMIT);
        }
    }

    private List<Deck> fetchDecksForCriteriaWithPagination(DeckSearchCriteria criteria, int offset, int limit) {
        final boolean hasFolder = criteria.hasFolderFilter();
        final boolean hasQuery = criteria.hasQueryFilter();

        if (hasFolder && hasQuery) {
            return this.deckRepository.findByFolderIdAndNameContainingIgnoreCase(
                    criteria.getFolderId(),
                    criteria.getQuery(),
                    offset,
                    limit);
        } else if (hasFolder) {
            return this.deckRepository.findByFolderId(criteria.getFolderId(), offset, limit);
        } else if (hasQuery) {
            return this.deckRepository.findByNameContainingIgnoreCase(criteria.getQuery(), offset, limit);
        } else {
            return this.deckRepository.findAll(offset, limit);
        }
    }

    /**
     * Apply natural order sorting for name sorts.
     */
    private List<Deck> applyNaturalOrderSort(List<Deck> decks, DeckSortOption sortOption) {
        final var comparator = NaturalOrderComparator.comparing(Deck::getName);
        if (sortOption == DeckSortOption.NAME_DESC) {
            return decks.stream()
                    .sorted(comparator.reversed())
                    .toList();
        }
        if (sortOption == DeckSortOption.NAME_ASC) {
            return decks.stream()
                    .sorted(comparator)
                    .toList();
        }
        return decks;
    }

    /**
     * Apply pagination manually after sorting.
     */
    private List<Deck> applyPagination(List<Deck> decks, int page, int size) {
        final int start = page * size;
        final int end = Math.min(start + size, decks.size());
        if (start >= decks.size()) {
            return List.of();
        }
        return decks.subList(start, end);
    }

    @Override
    @Transactional(readOnly = true)
    public DeckResponse getDeck(UUID id) {
        final var deck = this.deckRepository.findById(id);
        if (deck == null) {
            throw new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_DECK));
        }
        return this.deckMapper.toResponse(deck);
    }

    @Override
    public DeckResponse create(DeckCreateRequest request) {
        final var folder = this.folderRepository.findById(request.getFolderId());
        if (folder == null) {
            throw new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER));
        }

        final var deck = this.deckMapper.fromCreate(request, folder);
        deck.setFolderId(request.getFolderId());
        deck.onCreate();
        this.deckRepository.insert(deck);

        // Update folder deck count
        folder.setDeckCount(incrementCount(folder.getDeckCount(), NumberConstants.ONE));
        folder.onUpdate();
        this.folderRepository.update(folder);

        return this.deckMapper.toResponse(deck);
    }

    @Override
    public DeckResponse update(UUID id, DeckUpdateRequest request) {
        final var deck = this.deckRepository.findById(id);
        if (deck == null) {
            throw new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_DECK));
        }

        // Load folder if needed
        Folder folder = null;
        if (request.getFolderId() != null) {
            folder = this.folderRepository.findById(request.getFolderId());
            if (folder == null) {
                throw new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER));
            }
            deck.setFolderId(request.getFolderId());
        }

        this.deckMapper.update(deck, request, folder);
        if (request.getType() != null) {
            deck.setType(request.getType());
        }

        deck.onUpdate();
        this.deckRepository.update(deck);

        return this.deckMapper.toResponse(deck);
    }

    @Override
    public void delete(UUID id) {
        final var deck = this.deckRepository.findById(id);
        if (deck == null) {
            throw new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_DECK));
        }

        this.deckRepository.deleteById(id);

        // Update folder deck count
        if (deck.getFolderId() != null) {
            final var folder = this.folderRepository.findById(deck.getFolderId());
            if ((folder != null) && (folder.getDeckCount() > NumberConstants.ZERO)) {
                folder.setDeckCount(decrementCount(folder.getDeckCount(), NumberConstants.ONE));
                folder.onUpdate();
                this.folderRepository.update(folder);
            }
        }
    }

    @Override
    public ImportResult<ImportRow> importDecks(UUID folderId, MultipartFile file, FlashcardType type,
            boolean skipHeader) throws java.io.IOException {
        final var folder = this.folderRepository.findById(folderId);
        if (folder == null) {
            throw new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER));
        }

        final var importer = ImporterFactory.<ImportRow>forFilename(file.getOriginalFilename());
        final var parsed = importer.importStream(file.getInputStream(), this::mapRow, skipHeader);

        // Get all existing deck names in this folder
        final Set<String> existingDeckNames = new HashSet<>();
        final var existingDecks = this.deckRepository.findByFolderId(folderId, RepositoryConstants.DEFAULT_OFFSET, RepositoryConstants.MAX_LIMIT);
        existingDecks.forEach(deck -> existingDeckNames.add(StringUtils.lowerCase(deck.getName())));

        persistRows(parsed, folder, type, existingDeckNames);
        return parsed;
    }

    private ImportRow mapRow(RowContext ctx) {
        if (ctx.cells().isEmpty()) {
            return null;
        }
        final var first = StringUtils.trimToEmpty(ctx.cell(0));
        if (first.isEmpty()) {
            return null;
        }
        if (first.startsWith("*")) {
            var deckName = StringUtils.trimToEmpty(first.substring(1));
            if (deckName.isEmpty()) {
                deckName = "Imported Deck";
            }
            return ImportRow.deck(ctx.rowIndex(), clamp(deckName));
        }
        if (ctx.cells().size() < 2) {
            throw new IllegalArgumentException("Missing vocabulary or meaning");
        }
        final var vocab = StringUtils.trimToNull(ctx.cell(0));
        final var meaning = StringUtils.trimToNull(ctx.cell(1));
        if ((vocab == null) || (meaning == null)) {
            throw new IllegalArgumentException("Vocabulary/meaning is blank");
        }
        return ImportRow.card(ctx.rowIndex(), clamp(vocab), clamp(meaning));
    }

    private void persistRows(ImportResult<ImportRow> summary, Folder folder, FlashcardType defaultType,
            Set<String> existingDeckNames) {
        final List<Flashcard> buffer = new ArrayList<>();
        Deck currentDeck = null;
        final Set<String> currentTerms = new HashSet<>();
        var skipCurrentDeck = false;
        var defaultDeckSkipLogged = false;
        for (final ImportRow row : summary.getItems()) {
            if (row.kind == ImportRow.Kind.DECK) {
                flushBatch(buffer, currentDeck);
                currentTerms.clear();
                final var deckName = row.deckName;
                final var deckKey = StringUtils.lowerCase(deckName);
                if (existingDeckNames.contains(deckKey)) {
                    summary.addDeckSkipped(deckName, row.rowIndex);
                    skipCurrentDeck = true;
                    currentDeck = null;
                    continue;
                }
                currentDeck = createDeck(deckName, folder, defaultType);
                existingDeckNames.add(deckKey);
                summary.addDeckCreated();
                skipCurrentDeck = false;
                continue;
            }
            if (currentDeck == null) {
                final var defaultDeckName = "Imported Deck";
                final var deckKey = StringUtils.lowerCase(defaultDeckName);
                if (existingDeckNames.contains(deckKey)) {
                    if (!defaultDeckSkipLogged) {
                        summary.addDeckSkipped(defaultDeckName, row.rowIndex);
                        defaultDeckSkipLogged = true;
                    }
                    skipCurrentDeck = true;
                    continue;
                }
                currentDeck = createDeck(defaultDeckName, folder, defaultType);
                existingDeckNames.add(deckKey);
                summary.addDeckCreated();
                skipCurrentDeck = false;
                defaultDeckSkipLogged = false;
            }
            if (skipCurrentDeck) {
                continue;
            }
            final var termKey = StringUtils.lowerCase(row.vocab);
            if (currentTerms.contains(termKey)) {
                summary.addCardDuplicate(row.rowIndex, row.vocab, currentDeck.getName());
                continue;
            }
            buffer.add(
                    Flashcard.builder()
                            .deckId(currentDeck.getId())
                            .question(row.vocab)
                            .answer(row.meaning)
                            .type(defaultType)
                            .build());
            currentTerms.add(termKey);
            summary.addCardImported();
            if (buffer.size() >= RepositoryConstants.BATCH_SIZE) {
                flushBatch(buffer, currentDeck);
            }
        }
        flushBatch(buffer, currentDeck);
    }

    private void flushBatch(List<Flashcard> buffer, Deck currentDeck) {
        if ((currentDeck == null) || buffer.isEmpty()) {
            return;
        }

        // Insert all flashcards in batch
        for (Flashcard flashcard : buffer) {
            flashcard.onCreate();
            this.flashcardRepository.insert(flashcard);
        }

        // Update deck card count
        currentDeck.setCardCount(currentDeck.getCardCount() + buffer.size());
        currentDeck.onUpdate();
        this.deckRepository.update(currentDeck);

        buffer.clear();
    }

    private Deck createDeck(String name, Folder folder, FlashcardType type) {
        final var deck = Deck.builder()
                .name(clamp(name))
                .description("Imported deck")
                .folderId(folder.getId())
                .cardCount(0)
                .type(type)
                .build();

        deck.onCreate();
        this.deckRepository.insert(deck);

        // Update folder deck count
        folder.setDeckCount(folder.getDeckCount() + 1);
        folder.onUpdate();
        this.folderRepository.update(folder);

        return deck;
    }

    private String clamp(String value) {
        if (value == null) {
            return null;
        }
        return value.length() > ValidationConstants.NAME_MAX_LENGTH ? value.substring(0, ValidationConstants.NAME_MAX_LENGTH) : value;
    }

    private record ImportRow(int rowIndex, Kind kind, String deckName, String vocab, String meaning) {
        enum Kind {
            DECK, CARD
        }

        static ImportRow deck(int rowIndex, String name) {
            return new ImportRow(rowIndex, Kind.DECK, name, null, null);
        }

        static ImportRow card(int rowIndex, String vocab, String meaning) {
            return new ImportRow(rowIndex, Kind.CARD, null, vocab, meaning);
        }
    }
}
