# WerkTrack DE

WerkTrack DE is an offline-first Flutter application for tracking work time, gross earnings, planned shifts, academic context, and independently calculated Germany-specific reference thresholds.

The local Drift/SQLite database is the source of truth. No account or network is required. Optional Firebase sync has a local adapter, deterministic conflict handling and a sign-in/settings flow; enabling it requires a separately configured Firebase project.

## Download

Development APKs are published on the [GitHub Releases page](https://github.com/Mr-Dark-debug/werktrack-de/releases). They are debug-signed engineering previews for testing, not production/store releases. Back up existing records before replacing or uninstalling an app build.

## Run

**On a Mac?** Follow the [macOS clone, setup and APK build guide](docs/macos-setup.md). Verified toolchain: Flutter 3.41.9 / Dart 3.11.5. Android minimum: API 24.

```powershell
flutter pub get
flutter run
```

## Verify

```powershell
dart format --set-exit-if-changed lib test integration_test test_driver
flutter analyze
flutter test
flutter test integration_test/offline_flow_test.dart -d <android-device-id>
flutter build apk --debug
```

## Product boundaries

The app keeps five systems separate: residence-permit day accounting, student/Werkstudent weekly-hour guidance, Working Time Act checks, Minijob earnings references, and income-tax/net estimation. A warning is an advisory signal, not a conclusion that a user is working illegally.

The monthly progress bar is a personal planning target across all employers, not a legal monthly-hours cap. It weights lecture and lecture-free dates using editable weekly budgets and per-month overrides. Unconfigured dates do not silently become lecture-free.

## Calendar and portable records

The calendar uses [Kalender 0.29.1](https://pub.dev/packages/kalender/versions/0.29.1), with month/week/day views in Europe/Berlin. Tap a shift to edit or a day for details. Drag/resizing is disabled to prevent accidental payroll-time changes.

Export CSV/TXT/JSON for one or all employers and optionally filter dates. Import v2 work logs into a selected employer with validation, preview and duplicate protection. See [data-transfer formats](docs/data-transfer.md).

MIT licensed; dependency licenses remain their respective owners'. This is an engineering preview, not a signed store release. CI runs analyzer/tests and produces a development APK. Live Firebase, physical-device notifications, macOS builds and iOS builds need further verification.

See [permissions and privacy](docs/permissions-and-privacy.md), [research](docs/research.md), [calculations](docs/calculations.md), [database](docs/database.md), [sync](docs/sync.md), and [testing](docs/testing.md).
