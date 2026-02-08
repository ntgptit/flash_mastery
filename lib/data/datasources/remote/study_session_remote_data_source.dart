import 'package:dio/dio.dart';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/core/network/api_error_parser.dart';
import 'package:flash_mastery/data/models/study_session_model.dart';
import 'package:flash_mastery/domain/entities/study_progress_update.dart';

abstract class StudySessionRemoteDataSource {
  Future<StudySessionModel> startSession(String deckId, {List<String>? flashcardIds});
  Future<StudySessionModel> getSession(String sessionId);
  Future<StudySessionModel> updateSession(
    String sessionId, {
    String? currentMode,
    String? nextMode,
    int? currentBatchIndex,
    List<StudyProgressUpdate>? progressUpdates,
  });
  Future<void> completeSession(String sessionId);
  Future<void> cancelSession(String sessionId);
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
    throw _serverException(response);
  }

  @override
  Future<StudySessionModel> getSession(String sessionId) async {
    final response = await dio.get(ApiConstants.sessionById(sessionId));
    if (response.statusCode == 200) {
      return StudySessionModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw _notFoundException(response);
    }
    throw _serverException(response);
  }

  @override
  Future<StudySessionModel> updateSession(
    String sessionId, {
    String? currentMode,
    String? nextMode,
    int? currentBatchIndex,
    List<StudyProgressUpdate>? progressUpdates,
  }) async {
    final data = <String, dynamic>{};
    if (currentMode != null) data['currentMode'] = currentMode;
    if (nextMode != null) data['nextMode'] = nextMode;
    if (currentBatchIndex != null) data['currentBatchIndex'] = currentBatchIndex;
    if (progressUpdates != null) {
      data['progressUpdates'] = progressUpdates.map(_mapUpdateToJson).toList();
    }

    final response = await dio.put(
      ApiConstants.updateSession(sessionId),
      data: data,
    );
    if (response.statusCode == 200) {
      return StudySessionModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw _notFoundException(response);
    }
    throw _serverException(response);
  }

  Map<String, dynamic> _mapUpdateToJson(StudyProgressUpdate update) {
    return {
      'flashcardId': update.flashcardId,
      if (update.completedModes.isNotEmpty)
        'completedModes': update.completedModes.map((mode) => studyModeToJson(mode)).toList(),
      if (update.correctAnswers != null) 'correctAnswers': update.correctAnswers,
      if (update.totalAttempts != null) 'totalAttempts': update.totalAttempts,
    };
  }

  @override
  Future<void> completeSession(String sessionId) async {
    final response = await dio.post(ApiConstants.completeSession(sessionId));
    if (response.statusCode == 204) return;
    if (response.statusCode == 404) {
      throw _notFoundException(response);
    }
    throw _serverException(response);
  }

  @override
  Future<void> cancelSession(String sessionId) async {
    final response = await dio.post(ApiConstants.cancelSession(sessionId));
    if (response.statusCode == 204 || response.statusCode == 200) return;
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
