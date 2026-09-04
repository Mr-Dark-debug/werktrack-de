# Build an Android APK on macOS

Android is the verified target. macOS desktop is not currently supported; iOS source is included but unverified. You do not need a paid Apple developer account or CocoaPods to build the Android APK.

## Install the toolchain

Install Git, [Flutter 3.41.9 from the archive](https://docs.flutter.dev/install/archive), and [Android Studio](https://developer.android.com/studio). Choose the Flutter archive for Apple Silicon or Intel, extract it, and add its `bin` directory to your shell PATH. The lockfile is verified with Flutter 3.41.9 / Dart 3.11.5; do not start by upgrading all packages. If Git is missing, run `xcode-select --install` and complete Apple's installation dialog.

In Android Studio → SDK Manager install Android SDK Platform 36, Build-Tools, Platform-Tools, Command-line Tools, CMake and the side-by-side NDK requested by Flutter. An emulator is optional: use ARM64 on Apple Silicon and x86_64 on Intel. The app's minimum Android version is 7.0 / API 24.

```bash
flutter --version
flutter doctor --android-licenses
flutter doctor -v
```

Read and accept the SDK licenses yourself. Resolve Android toolchain errors before building. A missing Xcode/iOS toolchain does not block Android. Follow the [official Android setup guide](https://docs.flutter.dev/platform-integration/android/setup) if needed.

Flutter normally detects Android Studio's bundled Java runtime. The project uses AGP 8.11.1 and Java 17 source compatibility. If Flutter detects an incompatible Java installation, run:

```bash
flutter config --jdk-dir "/Applications/Android Studio.app/Contents/jbr/Contents/Home"
flutter doctor -v
```

## Clone, test and build

```bash
git clone https://github.com/Mr-Dark-debug/werktrack-de.git
cd werktrack-de
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter build apk --debug --target=lib/main.dart
```

Do not copy `android/local.properties` from another computer; Flutter creates it using your SDK paths. Generated database/localization sources and `pubspec.lock` are committed. No Firebase credentials are needed for offline use. If you change a Drift table, regenerate its code with `dart run build_runner build --delete-conflicting-outputs`.

Find the APK at `build/app/outputs/flutter-apk/app-debug.apk`. It is signed with a local development key: suitable for testing, not a production store release. Connect an Android device with USB debugging enabled, authorize that computer on the device, then run:

```bash
flutter devices
flutter install --debug -d YOUR_ANDROID_DEVICE_ID
flutter run -d YOUR_ANDROID_DEVICE_ID
```

Alternatively, transfer the APK to your phone. Android may ask you to allow installation from the specific file manager/browser; only do so for an APK you trust and disable that allowance afterwards. WerkTrack does not request package-install permission itself. A different development signing key cannot update an existing installation; back up your records before uninstalling anything.

## Device tests

Use a dedicated emulator/test device. The integration runner installs and removes its app, so never run it over personal records.

```bash
flutter test integration_test/offline_flow_test.dart -d YOUR_ANDROID_DEVICE_ID
flutter build apk --debug --target=lib/main.dart
```

Rebuild `lib/main.dart` after integration tests so the last APK does not contain a test harness.

## Production signing

Create and securely retain an owner-managed key using [Flutter's signing guide](https://docs.flutter.dev/deployment/android#sign-the-app). Put real values in an untracked `android/key.properties`:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=/absolute/private/path/upload-keystore.jks
```

Never commit passwords or the keystore. Release builds intentionally do not fall back to debug signing.

```bash
flutter build apk --release --split-per-abi --target=lib/main.dart
flutter build appbundle --release --target=lib/main.dart
```

Signing does not establish release readiness. Review [testing limitations](testing.md), privacy and legal rule sources first. Optional Firebase requires a project you own; see [sync setup](sync.md).

## Troubleshooting

- `flutter` missing: add the SDK `bin` directory to `~/.zshrc` and reopen Terminal.
- SDK/licenses missing: use SDK Manager, then `flutter doctor --android-licenses`.
- Java errors: inspect `flutter doctor -v` and use Android Studio's bundled runtime.
- Stale build output: stop other Flutter processes, run `flutter clean`, then `flutter pub get` and rebuild.
- Dependency conflict: retain `pubspec.lock`. Kalender 0.29.1 uses timezone 0.11; notifications were migrated to 22.3 for compatibility.

Instructions were checked against this repository and official Flutter documentation on 2026-09-05. The build was executed on Windows, not on a Mac; macOS execution remains unverified.
