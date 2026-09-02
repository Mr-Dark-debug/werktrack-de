# WerkTrack DE Implementation Plan

> **For agentic workers:** Implement task-by-task with tests and review gates.

**Goal:** Build a production-oriented offline-first Flutter application for Germany-specific work, earnings, configured student thresholds, compliance warnings, export, backup, and optional cloud synchronization.

**Architecture:** Feature-first Flutter application with Riverpod and GoRouter. Drift/SQLite is authoritative; focused domain calculators resolve date-versioned rules and never depend on widgets or Firebase.

**Tech Stack:** Flutter 3.41+, Dart 3.11+, Riverpod, GoRouter, Drift, SQLite, timezone, intl, UUID, share_plus, file_picker, flutter_local_notifications, Firebase boundary interfaces.

## Global Constraints

- Currency is integer euro cents; no binary floating-point totals.
- UTC persistence and Europe/Berlin presentation; timer state is timestamp-based.
- Residence, student weekly hours, Working Time Act, Minijob, and tax remain independent calculators.
- Local-only operation is complete; network and accounts are optional.
- Every statutory value is date-versioned with an official source and verification date.
- Legal copy is advisory and includes uncertainty where inputs are insufficient.

---

### Task 1: Project foundation and legal evidence

Create the Flutter project, dependencies, lints, localization shell, semantic Material 3 theme, research documentation, architecture decisions, and versioned built-in rules. Verify the app boots and rule fixtures resolve for 2026.

### Task 2: Domain model and calculation engines

Create focused entities for employers, entries, periods, payslips, rules, settings, compliance issues, and simulations. Implement duration/money, residence-day, weekly-hours, 26-week, working-time, Minijob, income-tax, net-estimate, academic-context, projection, and insight calculators using rule inputs. Write boundary-first unit tests before connecting persistence.

### Task 3: Drift persistence and repositories

Create normalized Drift tables for all brief-required records plus tombstones, migrations, repository interfaces, local implementations, seeded rules, aggregate streams, and safe transaction semantics. Test historical rate snapshots, edits/deletes, restart persistence, and migration/backup invariants.

### Task 4: Application state, routing, and design system

Create Riverpod providers/controllers, onboarding gate, GoRouter shell, semantic palette, reusable metric/warning/list cards, empty/error states, and responsive navigation. Ensure widgets consume repositories and calculators only through providers.

### Task 5: Entry, timer, employer, semester, and payslip flows

Build validated CRUD screens and persisted timer start/stop/relaunch behavior. Add confirmations and undo for destructive history operations. Verify multi-employer and historical-wage behavior end-to-end.

### Task 6: Dashboard, Can I Work, calendar, work history, and insights

Build real aggregate views using the reference visual language. Implement non-persisting simulation with explicit save actions, month/week calendar modes, searchable filters, useful charts, and detail lists. Verify all totals refresh from Drift streams.

### Task 7: Export, backup/import, notifications, rules, settings, and sync boundary

Implement CSV/JSON export, complete schema-versioned backup and validate-before-replace import, configurable local notification evaluation, source UI with clickable official links, theme/language preferences, and deterministic optional Firebase sync contracts/policy.

### Task 8: Quality and release readiness

Run format, analyzer, unit/widget/integration tests, Android build, UX/accessibility review, data-integrity review, legal-calculation review, and documentation audit. Fix meaningful failures and report genuine external blockers such as missing Firebase credentials, signing, or physical-device verification.
