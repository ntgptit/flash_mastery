package com.flash.mastery.service.impl;

import com.flash.mastery.constant.MessageKeys;
import com.flash.mastery.constant.NumberConstants;
import com.flash.mastery.dto.request.DeckCreateRequest;
import com.flash.mastery.dto.request.DeckUpdateRequest;
import com.flash.mastery.dto.response.DeckResponse;
import com.flash.mastery.entity.Deck;
import com.flash.mastery.entity.Folder;
import com.flash.mastery.exception.NotFoundException;
import com.flash.mastery.mapper.DeckMapper;
import com.flash.mastery.repository.DeckRepository;
import com.flash.mastery.repository.FolderRepository;
import com.flash.mastery.service.DeckService;
import java.util.List;
import java.util.UUID;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class DeckServiceImpl implements DeckService {

  private final DeckRepository deckRepository;
  private final FolderRepository folderRepository;
  private final DeckMapper deckMapper;
  private final MessageSource messageSource;

  @Override
  @Transactional(readOnly = true)
  public List<DeckResponse> getDecks(UUID folderId) {
    List<Deck> decks = folderId == null ? deckRepository.findAll() : deckRepository.findByFolderId(folderId);
    return decks.stream().map(deckMapper::toResponse).toList();
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
}
