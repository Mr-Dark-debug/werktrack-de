# Testing

Unit tests cover residence 3:59/4:00/4:01 boundaries, same-day multi-employer aggregation, 12h+9h weekly aggregation, ISO week-year rollover, Working Time Act 8/10-hour, break, and rest boundaries, DST elapsed time, overnight/leap-year duration, integer-cent rounding, Minijob combinations, academic boundaries, and the 2026 income-tax tariff.

Repository tests use an in-memory Drift database to verify seeded legal rules, edits, immediate stream changes, tombstone deletion/restore, and historical wage snapshots. Release checks are `dart format --set-exit-if-changed lib test`, `flutter analyze`, `flutter test`, and `flutter build apk --debug`.

Physical-device checks remain necessary for notification delivery, background timer presentation, file sharing, and OEM-specific process behavior. Timer correctness itself is timestamp-based and does not depend on a process-resident counter.

## September 5 verification

- 45 unit/repository/widget tests passed after the Kalender/data-transfer update. Coverage includes CSV/TXT/JSON round-trips, historical cents and paid breaks, DST instants, malformed import rejection, atomic conflicts, duplicate/tombstone handling, mixed-month planning budgets, month overrides and overnight month splits.
- Compact-page widget checks at 360 x 640 verify that the floating add button is entirely above the navigation bar, Work's search and status filters affect the records shown, and Kalender month/week/day switches and month navigation render without Flutter errors.
- The analyzer is clean. The two-database sync test emits Drift's multiple-database diagnostic; it deliberately uses separate in-memory executors to simulate devices.
- The Android API 36 emulator integration flow passed with Wi-Fi and mobile data disabled. It exercises real SQLite files, onboarding/employer/period/shift forms, all-employer residence accounting, planned simulation, CSV output and timer close/reopen persistence. The expanded flow also writes/reimports all three portable formats, renders Kalender at 360 x 640 and visits the export page.
- A separate same-installed-APK harness was seeded, force-stopped, and relaunched in two distinct Android processes. The persisted active timer timestamp survived (`RESTART_TEST_SEEDED`, then `RESTART_TEST_PASS`). The harness is gated by `ENABLE_RESTART_HARNESS` and is not the production entrypoint.

Capture actual emulator screenshots while running the device flow:

```bash
flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/offline_flow_test.dart --dart-define=CAPTURE_DEVICE_QA=true -d YOUR_TEST_EMULATOR_ID
flutter build apk --debug --target=lib/main.dart
```

The driver stores screenshots under ignored `build/qa/device/`. Only automated test fixtures appear in them. Use a dedicated emulator because test runners may replace/remove their app. Do not run restart/integration harnesses over personal records.

## Release limits

No production signing key is configured. Debug APKs are development builds. macOS/iOS builds, live Firebase rule deployment and cloud isolation, real device file-provider/share-sheet combinations, and OEM notification delivery have not been certified. Several secondary screens still contain English-only text; the EN/DE localization foundation is not a claim that every label is translated. Verify large-text accessibility and screen-reader behavior on physical devices before a store release.
