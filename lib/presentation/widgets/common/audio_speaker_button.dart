import 'package:flash_mastery/core/services/tts_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// A button that plays text using Text-to-Speech (TTS).
/// Only visible on mobile platforms (Android/iOS), hidden on web.
class AudioSpeakerButton extends StatefulWidget {
  /// The text to be spoken when the button is pressed
  final String text;

  /// Optional custom icon size, defaults to 24
  final double? iconSize;

  /// Optional custom icon color
  final Color? iconColor;

  /// Optional padding around the icon, defaults to 8
  final double? padding;

  const AudioSpeakerButton({
    super.key,
    required this.text,
    this.iconSize,
    this.iconColor,
    this.padding,
  });

  @override
  State<AudioSpeakerButton> createState() => _AudioSpeakerButtonState();
}

class _AudioSpeakerButtonState extends State<AudioSpeakerButton> {
  final TtsService _ttsService = TtsService();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _ttsService.initialize();
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _ttsService.stop();
    }
    super.dispose();
  }

  Future<void> _handleSpeak() async {
    if (_isSpeaking) {
      // If already speaking, stop
      await _ttsService.stop();
      setState(() => _isSpeaking = false);
    } else {
      // Start speaking
      setState(() => _isSpeaking = true);
      await _ttsService.speak(widget.text);
      // After speaking completes, reset state
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hide on web since TTS is not well supported
    if (kIsWeb) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleSpeak,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(widget.padding ?? 8),
          child: Icon(
            _isSpeaking ? Icons.volume_off : Icons.volume_up,
            size: widget.iconSize ?? 24,
            color: widget.iconColor ?? colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
