# WerkTrack DE Product Design

## Product direction

WerkTrack DE is an offline-first personal work and income ledger for students in Germany. It answers four separate questions without collapsing their legal meaning: worked time, earned and forecast income, configured student/residence thresholds, and working-time warnings. The application is an organisational and estimation tool, never a legal-status oracle.

The supplied UI reference defines the visual language: warm ivory surfaces, near-black typography and navigation, large editorial headings, softly rounded cards, compact controls, and a restrained pastel palette of yellow, pink, sage, periwinkle, aqua, and coral. The interface uses these colors to identify information categories, not legal outcomes.

## Architecture

The application uses feature-first clean architecture with Riverpod state, GoRouter navigation, and Drift/SQLite as the source of truth. Immutable domain records use UUIDs and UTC timestamps. Money is stored as integer cents. Completed entries capture an hourly-rate snapshot so employer changes never rewrite history.

Rules are date-versioned records resolved by key and effective interval. Independent calculators consume entries plus resolved rule values and return typed results. UI and persistence do not embed statutory thresholds.

Cloud sync is an optional boundary behind a repository interface. Local-only mode is complete. A deterministic conflict policy uses UUID identity, `updatedAt`, tombstones, and device IDs; cloud activation requires an operator-provided Firebase project configuration.

## Core flows

1. Onboarding collects profile flags and the disclaimer acknowledgement.
2. Users configure academic periods and employers.
3. Work can be completed, planned, or clocked with a persisted active timestamp.
4. Dashboard aggregates the selected month/week/year and shows advisory threshold cards.
5. Can I Work simulates a prospective entry without writing it, then optionally saves it.
6. Calendar, Work, Insights, payslips, rules/sources, export, backup, restore, and settings operate on the same local records.

## Data integrity and calculations

Overlaps remain visible and generate issues; they are not silently de-duplicated. Residence allowance is calculated per Berlin calendar day after aggregating qualifying intervals across employers. Student weekly hours aggregate qualifying entries across employers by ISO week. Working-time checks aggregate daily work across employers and compare chronologically adjacent shifts for rest. Minijob advice distinguishes combined Minijobs with and without a liable main job. Annual income tax uses the official year-specific tariff and remains separate from payroll withholding and social-insurance estimates.

Imports are decoded and schema-validated before any transaction modifies current data. Deletion is confirmed and offers undo where practical. Database schema upgrades are explicit and tested.

## UX and error handling

The bottom navigation contains Home, Calendar, Work, Insights, and Settings, with a centered add action. Forms validate times, breaks, rates, and required relations before saving. Empty states explain the next useful action. Warnings use neutral language such as “Threshold exceeded — review may be required.” Source links open the official page.

## Verification

Unit tests cover all mandatory calculator boundaries, multi-employer aggregation, ISO year boundaries, leap years, DST/overnight duration, money rounding, historical rates, edits/deletes, and semester context. Widget/integration-style tests cover onboarding through dashboard aggregation, non-persisting simulation, timer persistence, and export contents. Release checks run formatting, analysis, tests, and an Android debug build.

## Approved scope decision

The supplied product brief and the user's instruction to continue autonomously constitute approval of this design. External Firebase credentials, store signing, and device-specific notification permission remain deployment inputs, not fabricated project assets.
