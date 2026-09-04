# Architectural decisions

## ADR-001 — Local-first source of truth

Accepted 2026-09-02. Drift/SQLite is authoritative; optional cloud sync cannot be required for any core flow.

## ADR-002 — Integer money and rate snapshots

Accepted 2026-09-02. Store euro cents and capture the work-entry rate. Round minute-based pay once per entry.

## ADR-003 — Independent compliance calculators

Accepted 2026-09-02. Residence, student weekly hours, Working Time Act, Minijob, and tax have separate inputs/results and neutral warning copy.

## ADR-004 — Berlin calendar context over local device zone

Accepted 2026-09-02. Persist UTC; use Europe/Berlin for German calendar-day and ISO-week calculations, including DST.

## ADR-005 — Deterministic whole-record sync

Accepted 2026-09-02. Use updated timestamp, tombstone precedence, and device-ID tie-breaking. Do not synthesize field-level conflict merges.

## ADR-006 — Superseding decisions

Accepted 2026-09-02. Never delete an ADR. Mark it superseded and add a replacement entry when a decision changes.

## ADR-007 — Date-scoped legal coverage

Accepted 2026-09-04. Resolve the most recent applicable rule within its effective interval for the actual Berlin work date. Future versions never rewrite old results. Dates without a complete verified rule set retain time/pay records but show unavailable regulatory coverage. The bundled reference set currently begins in 2026; it is not a claim of verified coverage for earlier years.

## ADR-008 — Transactional cloud reconciliation

Accepted 2026-09-04. Extend ADR-005 with a server transaction before each write, so a stale upload cannot erase a newer remote record before comparison. Reconcile the full personal dataset rather than relying on a device-clock watermark; delayed offline edits must remain discoverable. Apply parent entities before children. Sync is user-triggered and requires operator configuration; no live cloud deployment is implied.

## ADR-009 — Exact monetary input and tariff arithmetic

Accepted 2026-09-04. Parse at most two decimal digits directly into integer cents. Reject malformed, negative and over-precision input. Shift pay uses integer division with one half-up rounding step. The 2026 tariff polynomial uses scaled integer coefficients before statutory whole-euro truncation.

## ADR-010 — Academic dates must be supplied

Accepted 2026-09-04. New semester date pickers start at today, not at a guessed German university calendar. Users can edit a semester and add multiple exceptional lecture-free ranges. All ranges must remain within the configured semester.

## ADR-011 — Kalender and less crowded main pages

Accepted 2026-09-04. Use Kalender 0.29.1 month/week/day views with UTC events and Europe/Berlin display. Editing uses the validated work-entry form; gesture rescheduling stays disabled. Move contextual detail to day sheets and collapsed reference panels. Show the timer only when requested/running. Rounded search/status pills follow the existing pastel theme; place the central add button above the navigation bar.

## ADR-012 — Monthly planning is not a legal cap

Accepted 2026-09-04. Sum completed working minutes across every employer, splitting overnight work at Berlin month boundaries. Planned work is separate. Compute a personal target as the sum of each date's configured weekly budget divided by seven, with a per-month override. Defaults are 20 lecture / 40 lecture-free hours per week, explicitly editable planning values. Unconfigured dates use the lecture budget and remain identified as unknown. Weekly/residence/Minijob systems remain separate.

## ADR-013 — Employer-scoped portable records

Accepted 2026-09-04. CSV, tab-separated TXT and JSON v2 preserve payroll inputs and stable source ids. The selected employer owns every imported row. Validate/preview first, recheck duplicates/conflicts transactionally, never overwrite changed saved records, and never resurrect deleted ids. Separate full backup restore remains explicitly destructive. Do not request broad storage/calendar permissions for file access or calendar display.
