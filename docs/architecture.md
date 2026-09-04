# Architecture

The app uses feature-first presentation modules, Riverpod providers, domain entities/calculators, repository interfaces, and Drift-backed infrastructure. GoRouter owns navigation. Widgets do not query SQLite directly.

UTC timestamps and integer cents cross every boundary. `Europe/Berlin` is used for calendar aggregation and display. Calculators receive a resolved rule set and remain deterministic pure Dart code. Live database streams cause dashboard, calendar, work history, and insights to recompute after each mutation.

Firebase remains behind the sync gateway. It is never initialized in local-only mode, so missing network access or Firebase files cannot degrade core use.
