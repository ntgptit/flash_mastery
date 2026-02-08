import 'package:flash_mastery/core/error/failure_messages.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/domain/usecases/study_sessions/study_session_usecases.dart';
import 'package:flash_mastery/presentation/providers/study_session_providers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_session_view_model.freezed.dart';
part 'study_session_view_model.g.dart';

@freezed
class StudySessionState with _$StudySessionState {
  const factory StudySessionState.initial() = _Initial;
  const factory StudySessionState.loading() = _Loading;
  const factory StudySessionState.success(StudySession session) = _Success;
  const factory StudySessionState.error(Failure failure) = _Error;
}

@riverpod
StartStudySessionUseCase startStudySessionUseCase(Ref ref) {
  return StartStudySessionUseCase(ref.watch(studySessionRepositoryProvider));
}

@riverpod
GetStudySessionUseCase getStudySessionUseCase(Ref ref) {
  return GetStudySessionUseCase(ref.watch(studySessionRepositoryProvider));
}

@riverpod
UpdateStudySessionUseCase updateStudySessionUseCase(Ref ref) {
  return UpdateStudySessionUseCase(ref.watch(studySessionRepositoryProvider));
}

@riverpod
CompleteStudySessionUseCase completeStudySessionUseCase(Ref ref) {
  return CompleteStudySessionUseCase(ref.watch(studySessionRepositoryProvider));
}

@riverpod
CancelStudySessionUseCase cancelStudySessionUseCase(Ref ref) {
  return CancelStudySessionUseCase(ref.watch(studySessionRepositoryProvider));
}

@riverpod
class StudySessionViewModel extends _$StudySessionViewModel {
  @override
  StudySessionState build(String? sessionId) {
    if (sessionId != null) {
      Future.microtask(() => loadSession(sessionId));
    }
    return const StudySessionState.initial();
  }

  Future<void> loadSession(String sessionId) async {
    state = const StudySessionState.loading();
    final result = await ref.read(getStudySessionUseCaseProvider).call(sessionId);
    state = result.fold(
      (failure) => StudySessionState.error(failure),
      (session) => StudySessionState.success(session),
    );
  }

  Future<String?> startSession(String deckId, {List<String>? flashcardIds}) async {
    state = const StudySessionState.loading();
    final result = await ref.read(startStudySessionUseCaseProvider).call(
          StartStudySessionParams(deckId: deckId, flashcardIds: flashcardIds),
        );
    return result.fold(
      (failure) => failure.toDisplayMessage(),
      (session) {
        state = StudySessionState.success(session);
        return null;
      },
    );
  }

  Future<String?> updateSession(UpdateStudySessionParams params) async {
    final result = await ref.read(updateStudySessionUseCaseProvider).call(params);
    return result.fold(
      (failure) => failure.toDisplayMessage(),
      (session) {
        state = StudySessionState.success(session);
        return null;
      },
    );
  }

  Future<String?> completeSession(String sessionId) async {
    final result = await ref.read(completeStudySessionUseCaseProvider).call(sessionId);
    final message = result.fold(
      (failure) => failure.toDisplayMessage(),
      (_) => null,
    );
    if (message == null) {
      await loadSession(sessionId);
    }
    return message;
  }

  Future<String?> cancelSession(String sessionId) async {
    final result = await ref.read(cancelStudySessionUseCaseProvider).call(sessionId);
    final message = result.fold(
      (failure) => failure.toDisplayMessage(),
      (_) => null,
    );
    if (message == null) {
      await loadSession(sessionId);
    }
    return message;
  }
}
