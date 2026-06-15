# AI Story Buddy

Flutter assignment for Peblo. Pip the robot reads a short story out loud, then a quiz appears once the narration finishes. The quiz is built entirely from a JSON file and works with any number of options without changing any code. Built with children aged 6 to 10 in mind, on mid-range Android phones.

---

## Getting started

```bash
git clone https://github.com/xharbitryn/peblo_story_buddy.git
cd peblo_story_buddy
flutter pub get
flutter run
```

Tested on the iOS Simulator (iPhone 17 Pro) and a Pixel 2 Android emulator set to around 3GB RAM. Flutter 3.x and Dart 3 required. Run `flutter doctor` first if anything looks off with your setup.

To use the ElevenLabs audio path instead of native TTS:

```bash
flutter run --dart-define=ELEVENLABS_API_KEY=your_key_here
```

---

## Project structure

```
lib/
  main.dart
  core/theme/                   # colour tokens, type scale, ThemeData

  features/story_buddy/
    data/
      models/quiz_question.dart       # QuizQuestion: fromJson, isCorrect, immutable
      quiz_repository.dart            # loads from assets; one line to swap for HTTP
      story_content.dart
      tts_service.dart                # abstract interface so backends are interchangeable
      flutter_tts_service.dart        # native on-device TTS
      elevenlabs_tts_service.dart     # ElevenLabs + local MP3 cache + native fallback

    application/
      narration_controller.dart       # audio state machine (Riverpod Notifier)
      quiz_controller.dart            # selection state: unanswered, wrong, correct

    presentation/
      story_buddy_screen.dart
      widgets/                        # BuddyCharacter, StoryCard, ReadStoryButton,
                                      # QuizView, OptionTile, SuccessConfetti

assets/
  data/quiz.json        # the question lives here, not in Dart code
  fonts/Poppins-*.ttf   # bundled locally, four weights

screenshots/            # option-count proof screenshots + Android frame timing
test/                   # 17 tests across unit and widget levels
```

---

## Framework choice

I built this in Flutter. The main reason is a single codebase for iOS and Android, and the animation APIs give enough control for a kids app where small interactions carry a lot of weight.

For state management I picked Riverpod. Audio narration has a natural sequence of states: idle, preparing, speaking, finished, and error. A Notifier with an enum models that sequence clearly. It also lets me watch narrow slices of state, so a button label change does not trigger a rebuild of the quiz section. That kind of thing matters when you are watching frame times on a lower-end device.

---

## How the audio to quiz transition works

The narration controller holds a NarrationStatus enum. Tapping the button sets it to `preparing`. The flutter_tts start handler sets it to `speaking`. The completion handler sets it to `finished`.

The screen watches `isFinished`. When that flips true, an AnimatedSwitcher replaces a SizedBox.shrink with the QuizView using a fade and a slight upward slide (450ms, easeOutCubic). The quiz is not in the widget tree at all before narration ends, not just hidden with opacity.

---

## Data-driven quiz

The question is in `assets/data/quiz.json`. QuizRepository loads it with rootBundle.loadString and parses it into a QuizQuestion model. QuizView then renders:

```dart
...question.options.map((o) => OptionTile(label: o, ...))
```

No index assumptions. No hardcoded count. I tested by editing the JSON to 3 options and then 5. The UI updated both times without any code change. Screenshots of each variant are in `screenshots/`. If the data ever needed to come from a backend, you would change one line in quiz_repository.dart. The UI and controller would not need to be touched.

---

## Caching

With native TTS, flutter_tts synthesises audio on device. There is no file produced and no file to cache. Replays are instant. I am stating that plainly rather than claiming a caching mechanism that does not exist.

The ElevenLabs path in CachingElevenLabsTtsService works differently. On the first play it calls the API and writes the MP3 response to `getApplicationCacheDirectory()/tts_cache/<text.hashCode>.mp3`. On any later play that file is already there, so it plays from disk with no network call. If the API fails for any reason, the service catches the exception and falls back to native TTS automatically.

---

## Audio loading and failure states

When the engine is starting: the button shows a spinner and the label "Waking up Buddy..." so the child can see something is happening.

While it is speaking: the label changes to "Reading..." and the button is disabled. Rapid taps are ignored by an `isBusy` check in the controller so audio cannot overlap itself.

Missing TTS engine: flutter_tts.speak() returns 0 on some budget Android devices that do not have a TTS engine installed. This is caught and moves the state to error.

Error state: a soft coral card appears with a friendly message and a retry button. No crash, no hang, no raw error text on screen.

Backgrounding: a WidgetsBindingObserver catches AppLifecycleState.paused and calls stop() on the controller so the audio does not keep playing into the home screen or lock screen.

Rotation: all state lives in Riverpod providers, not in widget fields, so orientation changes preserve everything automatically.

---

## Performance

I ran the app in `flutter run --profile` mode on a Pixel 2 Android emulator during the heaviest moment: wrong-answer shake and confetti burst running at the same time.

**58 FPS average. All frames under 16.67ms. Impeller was active** (shown in DevTools, top right).

Frame timing screenshot is in `screenshots/performance_profile_android.png`.

A few things that kept the frame times there:

**RepaintBoundary on BuddyCharacter.** The idle float is a looping animation that ticks on every frame. Without a boundary it would repaint the entire screen constantly.

**RepaintBoundary on SuccessConfetti** for the same reason.

**Particle count set to 20.** I tried higher values and saw the frame bars spike. 20 looked fine visually and kept the graph flat.

**const constructors throughout**, and pre-baked colour constants instead of calling withOpacity at runtime.

**Narrow Riverpod watches** so a narration state change does not rebuild the quiz, and a quiz selection does not rebuild the narration button.

Impeller on Android also removes the shader compilation pause that used to cause visible stutter on the first animation. If you have ever seen a Flutter app jank on the first button tap and then run smoothly after, that was usually shader compilation. Impeller compiles them ahead of time.

---

## Keeping it light on mid-range devices

Poppins is bundled as local ttf files rather than fetched from Google Fonts at startup. Four weights, around 280KB total. First launch renders the font immediately with no network dependency.

I used Flutter's built-in HapticFeedback instead of a third-party haptics package. One less dependency and no extra Android permission.

The wrong-answer shake is hand-rolled with AnimationController and a damped sine:

```dart
math.sin(_shake.value * math.pi * 4) * 12 * (1 - _shake.value)
```

Four oscillations that decay to zero over around 400ms. Writing it from scratch meant I could tune it exactly, and the dispose call is explicit so nothing leaks.

---

## AI usage and judgment

I worked with Claude as a build partner through this project for planning, scaffolding, and code. Here is an honest account of where I made different calls.

**Fonts:** The first version of the project loaded Poppins via the google_fonts package. I switched to bundled ttf files because google_fonts fetches at runtime. A child on a slow or patchy connection should not have to wait for a font download before the app is usable. Bundling also means the font is identical on every device regardless of network.

**Shake animation:** Claude initially suggested using a prebuilt animation library for the wrong-answer shake. I wrote it by hand instead. The formula above is about five lines of code, I could tune the amplitude and decay directly, and disposal is explicit. A library would have added weight and an abstraction I did not need.

**Something that did not go smoothly:** On the iOS Simulator the flutter_tts completion callback occasionally fired slightly before the audio actually finished, so the quiz revealed while the last word was still being spoken. I caught it with log statements and confirmed it was a simulator timing quirk. The Android emulator did not have the same issue. It was a useful reminder that the iOS Simulator is not representative of a real device, especially for anything timing-sensitive like audio callbacks.

---

## Design

Peblo's brand colours are violet (#6F2BC2) and deep purple (#36165E). Those two together read a bit serious for a six year old, so I brought in a small accent set: warm gold (#FFC24B) for the success state and confetti, soft coral (#FF8A7A) for wrong answers (not red, because getting something wrong should feel like "try again" not "you failed"), and mint (#5FD0B8) for the correct highlight. The background is a faint lilac (#F7F4FD), which is easier on young eyes than pure white.

Body text is Poppins at 19sp with a 1.5 line height. Option tiles are 18sp. Everything tappable is at least 60dp tall. Corners are rounded throughout because round shapes read as friendly at that age. All colour and type tokens are in `lib/core/theme/` so there is one place to update anything.

---

## Credits

Poppins typeface by Indian Type Foundry and Jonny Pinhorn, SIL Open Font License 1.1.
Source: fonts.google.com/specimen/Poppins

confetti package by Emil Tholin, MIT License.

All animations and UI are built with Flutter's own APIs. No licensed character assets or third-party illustrations used.