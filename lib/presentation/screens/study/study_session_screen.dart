import 'package:flash_mastery/core/error/failure_messages.dart';
import 'package:flash_mastery/data/models/study_session_model.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/study_mode.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/domain/usecases/study_sessions/study_session_usecases.dart';
import 'package:flash_mastery/presentation/screens/study/widgets/overview_mode_widget.dart';
import 'package:flash_mastery/presentation/screens/study/widgets/matching_mode_widget.dart';
import 'package:flash_mastery/presentation/screens/study/widgets/guess_mode_widget.dart';
import 'package:flash_mastery/presentation/screens/study/widgets/recall_mode_widget.dart';
import 'package:flash_mastery/presentation/screens/study/widgets/fill_in_blank_mode_widget.dart';
import 'package:flash_mastery/presentation/viewmodels/flashcard_view_model.dart';
import 'package:flash_mastery/presentation/viewmodels/study_session_view_model.dart';
import 'package:flash_mastery/presentation/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StudySessionScreen extends ConsumerStatefulWidget {
  final String deckId;
  final bool testMode;

  const StudySessionScreen({
    super.key,
    required this.deckId,
    this.testMode = false,
  });

  @override
  ConsumerState<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends ConsumerState<StudySessionScreen> {
  String? _sessionId;
  List<Flashcard> _flashcards = [];

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    // Load flashcards first
    final flashcardsResult = await ref.read(getFlashcardsUseCaseProvider).call(widget.deckId);
    flashcardsResult.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load flashcards: ${failure.toDisplayMessage()}')),
          );
        }
      },
      (flashcards) {
        setState(() {
          _flashcards = flashcards;
        });
        // Start study session
        _startSession();
      },
    );
  }

  Future<void> _startSession() async {
    if (!mounted) return;

    // Get unstudied flashcards (for now, use all flashcards)
    final unstudiedIds = _flashcards.map((f) => f.id).toList();

    final viewModel = ref.read(studySessionViewModelProvider(null).notifier);
    final error = await viewModel.startSession(widget.deckId, flashcardIds: unstudiedIds);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
      context.pop();
      return;
    }

    // Check state after a short delay to get session ID
    await Future.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;

    final sessionState = ref.read(studySessionViewModelProvider(null));
    sessionState.maybeWhen(
      success: (session) {
        if (mounted && _sessionId == null) {
          setState(() {
            _sessionId = session.id;
          });
        }
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the temporary provider to get session ID
    final tempSessionState = ref.watch(studySessionViewModelProvider(null));

    // Update sessionId when we get a successful session
    tempSessionState.maybeWhen(
      success: (session) {
        if (_sessionId == null && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _sessionId = session.id;
              });
            }
          });
        }
      },
      orElse: () {},
    );

    if (_sessionId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Starting Study Session')),
        body: tempSessionState.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          success: (_) => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $message'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final sessionState = ref.watch(studySessionViewModelProvider(_sessionId));

    return sessionState.when(
      initial: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      success: (session) {
        final flashcards = _flashcards.where((f) => session.flashcardIds.contains(f.id)).toList();
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.testMode ? 'Test Mode' : 'Study - ${session.currentMode.displayName}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _showExitDialog(context, session),
              ),
            ],
          ),
          body: _buildModeWidget(session, flashcards),
        );
      },
      error: (message) => Scaffold(
        appBar: AppBar(title: const Text('Study Session')),
        body: AppErrorWidget(
          message: message,
          onRetry: () => _initializeSession(),
        ),
      ),
    );
  }

  Widget _buildModeWidget(StudySession session, List<Flashcard> flashcards) {
    final batch = session.getCurrentBatch();
    final batchFlashcards = flashcards.where((f) => batch.contains(f.id)).toList();

    // If test mode, only show FillInBlank mode
    if (widget.testMode) {
      return FillInBlankModeWidget(
        session: session,
        flashcards: batchFlashcards,
        onComplete: () => _completeSession(),
      );
    }

    switch (session.currentMode) {
      case StudyMode.overview:
        return OverviewModeWidget(
          session: session,
          flashcards: batchFlashcards,
          onNext: () => _handleNext(session),
          onComplete: () => _handleModeComplete(session),
        );
      case StudyMode.matching:
        return MatchingModeWidget(
          session: session,
          flashcards: batchFlashcards,
          onComplete: () => _handleModeComplete(session),
        );
      case StudyMode.guess:
        return GuessModeWidget(
          session: session,
          flashcards: batchFlashcards,
          allFlashcards: flashcards,
          onComplete: () => _handleModeComplete(session),
        );
      case StudyMode.recall:
        return RecallModeWidget(
          session: session,
          flashcards: batchFlashcards,
          onComplete: () => _handleModeComplete(session),
        );
      case StudyMode.fillInBlank:
        return FillInBlankModeWidget(
          session: session,
          flashcards: batchFlashcards,
          onComplete: () => _handleModeComplete(session),
        );
    }
  }

  Future<void> _handleNext(StudySession session) async {
    // Move to next flashcard in batch
    // This is handled by individual mode widgets
  }

  Future<void> _handleModeComplete(StudySession session) async {
    final nextMode = session.getNextMode();
    if (nextMode == null) {
      // All modes completed
      await _completeSession();
      return;
    }

    // Move to next mode
    final viewModel = ref.read(studySessionViewModelProvider(_sessionId).notifier);
    await viewModel.updateSession(
      UpdateStudySessionParams(
        sessionId: session.id,
        currentMode: studyModeToJson(nextMode),
        currentBatchIndex: 0,
      ),
    );
  }

  Future<void> _completeSession() async {
    if (_sessionId == null) return;

    final viewModel = ref.read(studySessionViewModelProvider(_sessionId).notifier);
    final error = await viewModel.completeSession(_sessionId!);

    if (mounted) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Study session completed!')),
        );
        context.pop();
      }
    }
  }

  Future<void> _showExitDialog(BuildContext context, StudySession session) async {
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.testMode ? 'Exit Test?' : 'Exit Study Session?'),
        content: Text(widget.testMode
            ? 'Do you want to save your progress?'
            : 'Do you want to save your progress?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Có'),
          ),
        ],
      ),
    );

    if (shouldSave == null || !mounted) return;

    if (shouldSave == true) {
      // User wants to save - complete the session
      if (_sessionId != null) {
        final viewModel = ref.read(studySessionViewModelProvider(_sessionId).notifier);
        final error = await viewModel.completeSession(_sessionId!);
        if (mounted) {
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $error')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã lưu tiến trình học tập')),
            );
          }
        }
      }
      if (mounted) {
        context.pop();
      }
    } else {
      // User doesn't want to save - cancel the session
      if (_sessionId != null) {
        final viewModel = ref.read(studySessionViewModelProvider(_sessionId).notifier);
        final error = await viewModel.cancelSession(_sessionId!);
        if (mounted) {
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $error')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã hủy phiên học tập')),
            );
          }
        }
      }
      if (mounted) {
        context.pop();
      }
    }
  }
}

