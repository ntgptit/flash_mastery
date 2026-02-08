import 'package:dio/dio.dart';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/core/network/api_error_parser.dart';
import 'package:flash_mastery/data/models/flashcard_model.dart';

abstract class FlashcardRemoteDataSource {
  Future<List<FlashcardModel>> getByDeck(String deckId, {int? page, int? size});
  Future<FlashcardModel> getById(String id);
  Future<FlashcardModel> createFlashcard(String deckId, FlashcardModel flashcard);
  Future<FlashcardModel> updateFlashcard(String id, FlashcardModel flashcard);
  Future<void> deleteFlashcard(String id);
}

class FlashcardRemoteDataSourceImpl implements FlashcardRemoteDataSource {
  FlashcardRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<FlashcardModel>> getByDeck(String deckId, {int? page, int? size}) async {
    final query = <String, dynamic>{};
    if (page != null) query['page'] = page;
    if (size != null) query['size'] = size;
    final response = await dio.get(
      ApiConstants.deckFlashcards(deckId),
      queryParameters: query.isEmpty ? null : query,
    );
    if (response.statusCode == 200) {
      final data = (response.data as List).cast<Map<String, dynamic>>();
      return data.map(FlashcardModel.fromJson).toList();
    }
    throw _serverException(response);
  }

  @override
  Future<FlashcardModel> getById(String id) async {
    final response = await dio.get(ApiConstants.flashcardById(id));
    if (response.statusCode == 200) {
      return FlashcardModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw _notFoundException(response);
    }
    throw _serverException(response);
  }

  @override
  Future<FlashcardModel> createFlashcard(String deckId, FlashcardModel flashcard) async {
    final response = await dio.post(
      ApiConstants.createFlashcard(deckId),
      data: {
        'question': flashcard.question,
        'answer': flashcard.answer,
        'hint': flashcard.hint,
        'type': flashcard.type.name.toUpperCase(),
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return FlashcardModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw _serverException(response);
  }

  @override
  Future<FlashcardModel> updateFlashcard(String id, FlashcardModel flashcard) async {
    final response = await dio.put(
      ApiConstants.updateFlashcard(id),
      data: {
        'question': flashcard.question,
        'answer': flashcard.answer,
        'hint': flashcard.hint,
        'type': flashcard.type.name.toUpperCase(),
      },
    );
    if (response.statusCode == 200) {
      return FlashcardModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw _notFoundException(response);
    }
    throw _serverException(response);
  }

  @override
  Future<void> deleteFlashcard(String id) async {
    final response = await dio.delete(ApiConstants.deleteFlashcard(id));
    if (response.statusCode == 204) return;
    if (response.statusCode == 404) {
      throw _notFoundException(response);
    }
    throw _serverException(response);
  }
}

NotFoundException _notFoundException(Response response) {
  return NotFoundException(
    message: ApiErrorParser.extractMessage(response.data) ?? 'Resource not found',
    errorCode: ApiErrorParser.extractCode(response.data),
  );
}

ServerException _serverException(Response response) {
  return ServerException(
    message: ApiErrorParser.extractMessage(response.data) ?? response.statusMessage ?? 'Request failed',
    statusCode: response.statusCode,
    errorCode: ApiErrorParser.extractCode(response.data),
  );
}
