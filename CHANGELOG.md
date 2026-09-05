# Changelog

## 0.1.0 - 2026-09-05

First public engineering preview of WerkTrack DE.

### Included

- Offline-first Drift/SQLite records for employers, completed and planned shifts, running timers, academic periods, payslips, settings and rule overrides.
- Kalender 0.29.1 month, week and day views using Europe/Berlin time, with event editing and per-day summaries.
- Employer-scoped or all-employer CSV, TXT and JSON work-log export, plus selected-employer import with validation, preview, duplicate protection and atomic writes.
- All-employer monthly-hours planning target with completed/planned separation, lecture and lecture-free weighting, colour states and per-month overrides.
- Residence-day, student weekly-hour, Working Time Act, Minijob, gross-income and estimated-net advisory calculations with independently versioned 2026 reference values.
- Optional authenticated Firebase synchronization adapter, deterministic conflict handling and owner-only Firestore rules. Firebase remains opt-in and requires an owner-configured project.
- English/German localization foundation, light/dark themes, notifications, full JSON backup/restore and Android document-picker/share-sheet integration.
- Simplified Home, Work and Calendar screens; rounded Work search/status controls; collapsible secondary filters; and a floating add button positioned above navigation.

### Verification

- Flutter 3.41.9 / Dart 3.11.5.
- Static analysis completed without issues.
- 45 unit, repository and widget tests passed.
- Offline Android API 36 emulator flow passed at 360 x 640, including all three portable formats, calendar rendering, SQLite reopen and timer persistence.
- Screenshot-enabled device flow and same-installed-APK force-stop/relaunch timer harness passed.
- Debug APK build and independent GitHub Actions Linux verification passed.

### Important limitations

- The attached APK is debug-signed and intended for evaluation. It is not a production-signed or store-certified release.
- Calculations and warnings are planning/advisory tools, not legal, tax, immigration or payroll advice. The monthly bar is a personal target, not a legal monthly-hours limit.
- Live Firebase deployment/isolation, OEM notification delivery, physical-device share-sheet combinations, macOS execution and iOS builds have not been certified.
- Several secondary screens still contain English-only text.
- Exports and local SQLite data are not application-level encrypted. Protect the device and exported files appropriately.

See the repository documentation for setup, data-transfer contracts, permissions, calculation boundaries and complete testing limits.
