import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/elevenlabs_tts_service.dart';
import '../data/flutter_tts_service.dart';
import '../data/tts_service.dart';

/// The narration state machine: 1. idle, 2. preparing, 3. speaking, 4. finished,
/// with error reachable from preparing or speaking.
enum NarrationStatus { idle, preparing, speaking, finished, error }

class NarrationState {
  final NarrationStatus status;
  final String? errorMessage;

  const NarrationState({this.status = NarrationStatus.idle, this.errorMessage});

  bool get isBusy =>
      status == NarrationStatus.preparing || status == NarrationStatus.speaking;
  bool get isFinished => status == NarrationStatus.finished;
}

/// API key injected at run time and never committed to source.

/// When the key is absent (default), the app uses the native TTS engine.
/// When the key is present, it uses ElevenLabs with MP3 caching and
/// automatic native fallback on any failure.
const _elevenLabsKey = String.fromEnvironment(
  'ELEVENLABS_API_KEY',
  defaultValue: '',
);

final ttsServiceProvider = Provider<TtsService>((ref) {
  final TtsService service = _elevenLabsKey.isNotEmpty
      ? CachingElevenLabsTtsService(apiKey: _elevenLabsKey)
      : FlutterTtsService();
  ref.onDispose(service.dispose);
  return service;
});

class NarrationController extends Notifier<NarrationState> {
  late final TtsService _tts;

  @override
  NarrationState build() {
    _tts = ref.watch(ttsServiceProvider);
    _tts.setCallbacks(
      onStart: () =>
          state = const NarrationState(status: NarrationStatus.speaking),
      onComplete: () =>
          state = const NarrationState(status: NarrationStatus.finished),
      onError: (msg) => state = NarrationState(
        status: NarrationStatus.error,
        errorMessage: "Oops! I couldn't read the story. Let's try again.",
      ),
    );
    return const NarrationState();
  }

  /// Tap handler for "Read Me a Story"
  /// never overlap audio.
  Future<void> readStory(String text) async {
    if (state.isBusy) return;
    state = const NarrationState(status: NarrationStatus.preparing);
    try {
      await _tts.init();
      await _tts.speak(text);
    } catch (_) {
      state = const NarrationState(
        status: NarrationStatus.error,
        errorMessage: "Oops! I couldn't read the story. Let's try again.",
      );
    }
  }

  /// Stop playback (used on retry)
  Future<void> stop() async {
    await _tts.stop();
    if (state.isBusy) {
      state = const NarrationState();
    }
  }
}

final narrationControllerProvider =
    NotifierProvider<NarrationController, NarrationState>(
      NarrationController.new,
    );
