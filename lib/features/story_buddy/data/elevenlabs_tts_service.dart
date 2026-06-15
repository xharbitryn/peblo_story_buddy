import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import 'flutter_tts_service.dart';
import 'tts_service.dart';

class CachingElevenLabsTtsService implements TtsService {
  CachingElevenLabsTtsService({required String apiKey})
    : _apiKey = apiKey,
      _player = AudioPlayer(),
      _fallback = FlutterTtsService();

  final String _apiKey;
  final AudioPlayer _player;
  final FlutterTtsService _fallback;

  void Function()? _onStart;
  void Function()? _onComplete;
  void Function(String)? _onError;

  bool _stopped = false;
  bool _disposed = false;

  /// Rachel : clear, warm, reliable narrator voice on ElevenLabs free tier.
  static const _voiceId = '21m00Tcm4TlvDq8ikWAM';
  static const _modelId = 'eleven_turbo_v2_5';

  @override
  Future<void> init() async {
    // AudioPlayer initialises lazily.
  }

  @override
  void setCallbacks({
    required void Function() onStart,
    required void Function() onComplete,
    required void Function(String message) onError,
  }) {
    _onStart = onStart;
    _onComplete = onComplete;
    _onError = onError;

    _fallback.setCallbacks(
      onStart: onStart,
      onComplete: onComplete,
      onError: onError,
    );
  }

  @override
  Future<void> speak(String text) async {
    _stopped = false;
    try {
      await _speakViaElevenLabs(text);
    } catch (_) {
      // Network error, API error : fall back to native silently.
      if (_stopped || _disposed) return;
      await _fallback.init();
      await _fallback.speak(text);
    }
  }

  Future<void> _speakViaElevenLabs(String text) async {
    // Resolve cache file
    final file = await _resolveCache(text);

    if (!file.existsSync()) {
      await _downloadAndCache(text, file);
    }

    if (_stopped || _disposed) return;

    // Load the audio source
    await _player.setFilePath(file.path);

    if (_stopped || _disposed) return;

    // Gate that completes when playback finishes or is stopped.
    final gate = Completer<void>();

    final sub = _player.playerStateStream.listen((state) {
      if (gate.isCompleted) return;
      if (state.processingState == ProcessingState.completed ||
          state.processingState == ProcessingState.idle) {
        gate.complete();
      }
    });

    _onStart?.call();

    _player.play().catchError((_) {
      if (!gate.isCompleted) gate.complete();
    });

    // Wait for completion
    await gate.future.timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        if (!gate.isCompleted) gate.complete();
      },
    );

    await sub.cancel();

    if (!_stopped && !_disposed) {
      _onComplete?.call();
    }
  }

  Future<File> _resolveCache(String text) async {
    final base = await getApplicationCacheDirectory();
    final dir = Directory('${base.path}/tts_cache');
    await dir.create(recursive: true);

    return File('${dir.path}/${text.hashCode.abs()}.mp3');
  }

  Future<void> _downloadAndCache(String text, File dest) async {
    final response = await http
        .post(
          Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$_voiceId'),
          headers: {
            'xi-api-key': _apiKey,
            'Content-Type': 'application/json',
            'Accept': 'audio/mpeg',
          },
          body: jsonEncode({
            'text': text,
            'model_id': _modelId,
            'voice_settings': {'stability': 0.50, 'similarity_boost': 0.75},
          }),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('ElevenLabs API error: ${response.statusCode}');
    }

    await dest.writeAsBytes(response.bodyBytes);
  }

  @override
  Future<void> stop() async {
    _stopped = true;
    await _player.stop(); // transitions to idle and completes the gate above
    await _fallback.stop();
  }

  @override
  Future<void> dispose() async {
    _disposed = true;
    _stopped = true;
    await _player.stop();
    await _player.dispose();
    await _fallback.dispose();
    _onStart = null;
    _onComplete = null;
    _onError = null;
  }
}
