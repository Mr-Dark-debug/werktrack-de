# Database

The schema contains `UserProfiles`, `Employers`, `WorkEntries`, `AcademicPeriods`, `Payslips`, `LegalRules`, `PlannedShifts`, `AppSettings`, and `SyncMetadata`. Identifiers are UUID strings. Foreign keys are enabled on every open.

Completed work stores `hourlyRateSnapshotCents`. Employer rate changes therefore do not change historical gross pay. Work and employer deletions use tombstones. Backup restore validates schema shape, employer references, and rule presence before starting a single replacement transaction.

Schema version 1 is the initial release. Future migrations must preserve existing rows and add a migration test and pre-destructive backup path when necessary.
