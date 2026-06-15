abstract interface class TtsService {
  /// Prepare the engine (language, rate, pitch)
  Future<void> init();

  Future<void> speak(String text);

  /// Stop any in progress speech immediately.
  Future<void> stop();

  /// Register lifecycle callbacks driven by the engine.
  void setCallbacks({
    required void Function() onStart,
    required void Function() onComplete,
    required void Function(String message) onError,
  });

  /// Release engine resources and clear callbacks.
  Future<void> dispose();
}
