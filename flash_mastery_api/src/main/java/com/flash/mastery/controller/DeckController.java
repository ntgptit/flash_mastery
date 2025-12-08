package com.flash.mastery.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.flash.mastery.dto.request.DeckCreateRequest;
import com.flash.mastery.dto.request.DeckUpdateRequest;
import com.flash.mastery.dto.response.DeckResponse;
import com.flash.mastery.dto.response.ImportSummaryResponse;
import com.flash.mastery.entity.enums.FlashcardType;
import com.flash.mastery.service.DeckService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/decks")
@RequiredArgsConstructor
@Tag(name = "Decks", description = "Manage decks")
public class DeckController {

    private final DeckService deckService;

    @GetMapping
    @Operation(summary = "List decks", description = "Optionally filter by folder", responses = @ApiResponse(responseCode = "200", description = "List of decks"))
    public List<DeckResponse> list(
            @RequestParam(value = "folderId", required = false) UUID folderId,
            @RequestParam(value = "sort", required = false, defaultValue = "latest") String sort,
            @RequestParam(value = "page", required = false, defaultValue = "0") int page,
            @RequestParam(value = "size", required = false, defaultValue = "20") int size,
            @RequestParam(value = "q", required = false, defaultValue = "") String query) {
        return this.deckService.getDecks(folderId, sort, page, size, query);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get deck detail", responses = {
            @ApiResponse(responseCode = "200", description = "Deck found"),
            @ApiResponse(responseCode = "404", description = "Deck not found", content = @Content(schema = @Schema(hidden = true)))
    })
    public DeckResponse get(@PathVariable UUID id) {
        return this.deckService.getDeck(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Create deck", responses = @ApiResponse(responseCode = "201", description = "Deck created"))
    public DeckResponse create(@Valid @RequestBody DeckCreateRequest request) {
        return this.deckService.create(request);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update deck", responses = {
            @ApiResponse(responseCode = "200", description = "Deck updated"),
            @ApiResponse(responseCode = "404", description = "Deck not found", content = @Content(schema = @Schema(hidden = true)))
    })
    public DeckResponse update(@PathVariable UUID id, @Valid @RequestBody DeckUpdateRequest request) {
        return this.deckService.update(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @Operation(summary = "Delete deck", responses = {
            @ApiResponse(responseCode = "204", description = "Deck deleted"),
            @ApiResponse(responseCode = "404", description = "Deck not found", content = @Content(schema = @Schema(hidden = true)))
    })
    public void delete(@PathVariable UUID id) {
        this.deckService.delete(id);
    }

    @PostMapping("/import/{folderId}")
    @Operation(summary = "Import decks + flashcards from CSV/Excel into a folder")
    public ImportSummaryResponse importDecks(
            @PathVariable UUID folderId,
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "type", defaultValue = "VOCABULARY") FlashcardType type,
            @RequestParam(value = "skipHeader", defaultValue = "false") boolean skipHeader) throws java.io.IOException {
        final var result = this.deckService.importDecks(folderId, file, type, skipHeader);
        return ImportSummaryResponse.builder()
                .successCount(result.getCardsImported())
                .cardsImported(result.getCardsImported())
                .cardsSkippedDuplicate(result.getCardsSkippedDuplicate())
                .invalidRows(result.getInvalidRows())
                .decksCreated(result.getDecksCreated())
                .decksSkipped(result.getDecksSkipped())
                .skippedDeckNames(result.getSkippedDeckNames())
                .errors(result.getErrors())
                .build();
    }
}
