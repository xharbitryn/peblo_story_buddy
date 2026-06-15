import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peblo_story_buddy/features/story_buddy/application/narration_controller.dart';
import 'package:peblo_story_buddy/features/story_buddy/data/tts_service.dart';

class _AutoCompleteTts implements TtsService {
  void Function()? _onComplete;
  @override
  Future<void> init() async {}
  @override
  void setCallbacks({
    required void Function() onStart,
    required void Function() onComplete,
    required void Function(String message) onError,
  }) => _onComplete = onComplete;
  @override
  Future<void> speak(String text) async => _onComplete?.call();
  @override
  Future<void> stop() async {}
  @override
  Future<void> dispose() async {}
}

class _FailingTts implements TtsService {
  @override
  Future<void> init() async {}
  @override
  void setCallbacks({
    required void Function() onStart,
    required void Function() onComplete,
    required void Function(String message) onError,
  }) {}
  @override
  Future<void> speak(String text) async => throw Exception('no engine');
  @override
  Future<void> stop() async {}
  @override
  Future<void> dispose() async {}
}

void main() {
  test('readStory reaches finished on success', () async {
    final container = ProviderContainer(
      overrides: [ttsServiceProvider.overrideWith((ref) => _AutoCompleteTts())],
    );
    addTearDown(container.dispose);

    await container.read(narrationControllerProvider.notifier).readStory('hi');

    expect(
      container.read(narrationControllerProvider).status,
      NarrationStatus.finished,
    );
  });

  test('readStory reaches error when the engine fails', () async {
    final container = ProviderContainer(
      overrides: [ttsServiceProvider.overrideWith((ref) => _FailingTts())],
    );
    addTearDown(container.dispose);

    await container.read(narrationControllerProvider.notifier).readStory('hi');

    expect(
      container.read(narrationControllerProvider).status,
      NarrationStatus.error,
    );
  });
}
