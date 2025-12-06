import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  TtsService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isSupported = true;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // TTS is not well supported on web, so disable it
    if (kIsWeb) {
      _isSupported = false;
      _isInitialized = true;
      return;
    }

    try {
      _flutterTts = FlutterTts();

      // Set default language to Korean for better pronunciation
      await _flutterTts!.setLanguage('ko-KR');

      // Set speech rate (0.45 is slower for better comprehension)
      await _flutterTts!.setSpeechRate(0.45);

      // Set volume (0.0 to 1.0)
      await _flutterTts!.setVolume(1.0);

      // Set pitch (0.5 to 2.0, 1.0 is normal)
      await _flutterTts!.setPitch(1.0);

      _isInitialized = true;
      _isSupported = true;
    } catch (e) {
      _isSupported = false;
      _isInitialized = true;
    }
  }

  /// Detect if text is primarily Korean
  bool _isKoreanText(String text) {
    // Korean Unicode ranges: Hangul Syllables (AC00–D7AF), Hangul Jamo (1100–11FF)
    final koreanPattern = RegExp(r'[\uAC00-\uD7AF\u1100-\u11FF]');
    final koreanMatches = koreanPattern.allMatches(text).length;

    // If more than 30% of characters are Korean, treat as Korean text
    return koreanMatches > (text.length * 0.3);
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (!_isSupported || _flutterTts == null) {
      return;
    }

    try {
      // Auto-detect language and set appropriate language
      final isKorean = _isKoreanText(text);
      if (isKorean) {
        await _flutterTts!.setLanguage('ko-KR');
        await _flutterTts!.setSpeechRate(0.45); // Slower for Korean
      } else {
        await _flutterTts!.setLanguage('en-US');
        await _flutterTts!.setSpeechRate(0.5); // Slightly faster for English
      }

      await _flutterTts!.speak(text);
    } catch (e) {
      // Ignore speak errors
    }
  }

  Future<void> stop() async {
    if (!_isSupported || _flutterTts == null) return;

    try {
      await _flutterTts!.stop();
    } catch (e) {
      // Ignore stop errors
    }
  }

  Future<void> setLanguage(String language) async {
    if (!_isSupported || _flutterTts == null) return;

    try {
      await _flutterTts!.setLanguage(language);
    } catch (e) {
      // Ignore language change errors
    }
  }

  Future<void> setSpeechRate(double rate) async {
    if (!_isSupported || _flutterTts == null) return;

    try {
      await _flutterTts!.setSpeechRate(rate);
    } catch (e) {
      // Ignore rate change errors
    }
  }

  void dispose() {
    _flutterTts?.stop();
  }
}
