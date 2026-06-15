import 'package:flutter_tts/flutter_tts.dart';
import 'tts_service.dart';

/// Native, on device implementation backed by `flutter_tts`. Reliable offline,

class FlutterTtsService implements TtsService {
  FlutterTtsService([FlutterTts? tts]) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;
  bool _initialised = false;

  @override
  Future<void> init() async {
    if (_initialised) return;
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    _initialised = true;
  }

  @override
  void setCallbacks({
    required void Function() onStart,
    required void Function() onComplete,
    required void Function(String message) onError,
  }) {
    _tts.setStartHandler(onStart);
    _tts.setCompletionHandler(onComplete);
    _tts.setErrorHandler((msg) => onError(msg?.toString() ?? 'TTS error'));
  }

  @override
  Future<void> speak(String text) async {
    await init();
    final result = await _tts.speak(text);
    // Some engines return 0 when they fail to start (e.g. no engine installed).
    if (result == 0) {
      throw Exception('TTS engine failed to start.');
    }
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }

  @override
  Future<void> dispose() async {
    await _tts.stop();
    // Clear handlers so no late callback fires after disposal.
    _tts.setStartHandler(() {});
    _tts.setCompletionHandler(() {});
    _tts.setErrorHandler((_) {});
  }
}
