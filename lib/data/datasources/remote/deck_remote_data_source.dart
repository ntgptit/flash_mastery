import 'package:dio/dio.dart';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/core/network/api_error_parser.dart';
import 'package:flash_mastery/data/models/deck_model.dart';
import 'package:flash_mastery/data/models/import_summary_model.dart';
import 'package:flash_mastery/domain/entities/flashcard_type.dart';
import 'package:flutter/foundation.dart';

abstract class DeckRemoteDataSource {
  Future<List<DeckModel>> getDecks({
    String? folderId,
    String? sort,
    String? query,
    int page,
    int size,
  });
  Future<DeckModel> getDeckById(String id);
  Future<DeckModel> createDeck(DeckModel deck);
  Future<DeckModel> updateDeck(String id, DeckModel deck);
  Future<void> deleteDeck(String id);
  Future<List<DeckModel>> searchDecks(String query, {String? folderId});
  Future<ImportSummaryModel> importDecks({
    required String folderId,
    required String type,
    required String fileName,
    String? filePath,
    List<int>? bytes,
    bool hasHeader = true,
  });
}

class DeckRemoteDataSourceImpl implements DeckRemoteDataSource {
  DeckRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<DeckModel>> getDecks({
    String? folderId,
    String? sort,
    String? query,
    int page = 0,
    int size = 20,
  }) async {
    final response = await dio.get(
      ApiConstants.decks,
      queryParameters: {
        if (folderId != null) 'folderId': folderId,
        if (sort != null) 'sort': sort,
        if (query != null && query.isNotEmpty) 'q': query,
        'page': page,
        'size': size,
      },
    );
    if (response.statusCode == 200) {
      final data = (response.data as List).cast<Map<String, dynamic>>();
      return data.map(DeckModel.fromJson).toList();
    }
    throw _serverException(response);
  }

  @override
  Future<DeckModel> getDeckById(String id) async {
    final response = await dio.get(ApiConstants.deckById(id));
    if (response.statusCode == 200) {
      return DeckModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw _notFoundException(response);
    }
    throw _serverException(response);
  }

  @override
  Future<DeckModel> createDeck(DeckModel deck) async {
    final response = await dio.post(
      ApiConstants.createDeck,
      data: {
        'name': deck.name,
        'description': deck.description,
        'folderId': deck.folderId,
        'type': (deck.type ?? FlashcardType.vocabulary).name.toUpperCase(),
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return DeckModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw _serverException(response);
  }

  @override
  Future<DeckModel> updateDeck(String id, DeckModel deck) async {
    final response = await dio.put(
      ApiConstants.updateDeck(id),
      data: {
        'name': deck.name,
        'description': deck.description,
        'folderId': deck.folderId,
        'type': (deck.type ?? FlashcardType.vocabulary).name.toUpperCase(),
      },
    );
    if (response.statusCode == 200) {
      return DeckModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw _notFoundException(response);
    }
    throw _serverException(response);
  }

  @override
  Future<void> deleteDeck(String id) async {
    final response = await dio.delete(ApiConstants.deleteDeck(id));
    if (response.statusCode == 204) return;
    if (response.statusCode == 404) {
      throw _notFoundException(response);
    }
    throw _serverException(response);
  }

  @override
  Future<List<DeckModel>> searchDecks(String query, {String? folderId}) async {
    return getDecks(folderId: folderId, query: query, page: 0, size: 50);
  }

  @override
  Future<ImportSummaryModel> importDecks({
    required String folderId,
    required String type,
    required String fileName,
    String? filePath,
    List<int>? bytes,
    bool hasHeader = true,
  }) async {
    MultipartFile file;
    if (filePath != null && filePath.isNotEmpty && !kIsWeb) {
      file = await MultipartFile.fromFile(filePath, filename: fileName);
    } else if (bytes != null && bytes.isNotEmpty) {
      file = MultipartFile.fromBytes(bytes, filename: fileName);
    } else {
      throw ArgumentError('No file data provided for import');
    }

    final formData = FormData.fromMap({
      'file': file,
      'type': type,
    });
    final response = await dio.post(
      ApiConstants.importDecks(folderId),
      data: formData,
      queryParameters: {'skipHeader': hasHeader},
      options: Options(contentType: 'multipart/form-data'),
    );
    if (response.statusCode == 200) {
      return ImportSummaryModel.fromJson(response.data as Map<String, dynamic>);
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
