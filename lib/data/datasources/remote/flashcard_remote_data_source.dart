import 'package:dio/dio.dart';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/data/models/flashcard_model.dart';

abstract class FlashcardRemoteDataSource {
  Future<List<FlashcardModel>> getByDeck(String deckId);
  Future<FlashcardModel> getById(String id);
  Future<FlashcardModel> createFlashcard(String deckId, FlashcardModel flashcard);
  Future<FlashcardModel> updateFlashcard(String id, FlashcardModel flashcard);
  Future<void> deleteFlashcard(String id);
}

class FlashcardRemoteDataSourceImpl implements FlashcardRemoteDataSource {
  FlashcardRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<FlashcardModel>> getByDeck(String deckId) async {
    final response = await dio.get(ApiConstants.deckFlashcards(deckId));
    if (response.statusCode == 200) {
      final data = (response.data as List).cast<Map<String, dynamic>>();
      return data.map(FlashcardModel.fromJson).toList();
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to load flashcards');
  }

  @override
  Future<FlashcardModel> getById(String id) async {
    final response = await dio.get(ApiConstants.flashcardById(id));
    if (response.statusCode == 200) {
      return FlashcardModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw const NotFoundException(message: 'Flashcard not found');
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to load flashcard');
  }

  @override
  Future<FlashcardModel> createFlashcard(String deckId, FlashcardModel flashcard) async {
    final response = await dio.post(
      ApiConstants.createFlashcard(deckId),
      data: {
        'question': flashcard.question,
        'answer': flashcard.answer,
        'hint': flashcard.hint,
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return FlashcardModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to create flashcard');
  }

  @override
  Future<FlashcardModel> updateFlashcard(String id, FlashcardModel flashcard) async {
    final response = await dio.put(
      ApiConstants.updateFlashcard(id),
      data: {
        'question': flashcard.question,
        'answer': flashcard.answer,
        'hint': flashcard.hint,
      },
    );
    if (response.statusCode == 200) {
      return FlashcardModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw const NotFoundException(message: 'Flashcard not found');
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to update flashcard');
  }

  @override
  Future<void> deleteFlashcard(String id) async {
    final response = await dio.delete(ApiConstants.deleteFlashcard(id));
    if (response.statusCode == 204) return;
    if (response.statusCode == 404) {
      throw const NotFoundException(message: 'Flashcard not found');
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to delete flashcard');
  }
}
