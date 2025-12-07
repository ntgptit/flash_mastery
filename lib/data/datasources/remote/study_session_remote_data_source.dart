import 'package:dio/dio.dart';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/data/models/study_session_model.dart';

abstract class StudySessionRemoteDataSource {
  Future<StudySessionModel> startSession(String deckId, {List<String>? flashcardIds});
  Future<StudySessionModel> getSession(String sessionId);
  Future<StudySessionModel> updateSession(String sessionId, {
    String? currentMode,
    int? currentBatchIndex,
    Map<String, String>? progressData,
  });
  Future<void> completeSession(String sessionId);
}

class StudySessionRemoteDataSourceImpl implements StudySessionRemoteDataSource {
  StudySessionRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<StudySessionModel> startSession(String deckId, {List<String>? flashcardIds}) async {
    final response = await dio.post(
      ApiConstants.startSession,
      data: {
        'deckId': deckId,
        if (flashcardIds != null) 'flashcardIds': flashcardIds,
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return StudySessionModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to start study session');
  }

  @override
  Future<StudySessionModel> getSession(String sessionId) async {
    final response = await dio.get(ApiConstants.sessionById(sessionId));
    if (response.statusCode == 200) {
      return StudySessionModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw const NotFoundException(message: 'Study session not found');
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to load study session');
  }

  @override
  Future<StudySessionModel> updateSession(String sessionId, {
    String? currentMode,
    int? currentBatchIndex,
    Map<String, String>? progressData,
  }) async {
    final data = <String, dynamic>{};
    if (currentMode != null) data['currentMode'] = currentMode;
    if (currentBatchIndex != null) data['currentBatchIndex'] = currentBatchIndex;
    if (progressData != null) data['progressData'] = progressData;

    final response = await dio.put(
      ApiConstants.updateSession(sessionId),
      data: data,
    );
    if (response.statusCode == 200) {
      return StudySessionModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw const NotFoundException(message: 'Study session not found');
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to update study session');
  }

  @override
  Future<void> completeSession(String sessionId) async {
    final response = await dio.post(ApiConstants.completeSession(sessionId));
    if (response.statusCode == 204) return;
    if (response.statusCode == 404) {
      throw const NotFoundException(message: 'Study session not found');
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to complete study session');
  }
}

