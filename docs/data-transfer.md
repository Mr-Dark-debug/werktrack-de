# Work-log import and export

Open **Settings → Export & Backup** (page title **Your data**). Choose one/all employers, CSV/TXT/JSON, and an optional Berlin shift-start-date range. Export uses the system share sheet. Completed, planned and cancelled records are included; active timers are excluded.

For import, choose one existing employer, select the format and pick a file. Review the new-record count, completed hours and duplicates, then confirm. Every row is assigned to that employer regardless of its original employer. No employers are created. Profile, payslips, rules and settings are unchanged. Export date filters do not limit imports.

## Format v2

All formats preserve UTC start/end instants, IANA timezone, total/paid breaks, historical hourly-rate cents, bonuses/tips, status and notes. Imports use the file's historical wage, not today's employer wage. Derived totals are recalculated, not trusted.

CSV uses comma-separated quoted fields; TXT uses tab-separated quoted fields. Both are UTF-8 with this header (tabs instead of commas in TXT):

```text
schemaVersion,id,employerId,employer,startTimeUtc,endTimeUtc,timezone,breakMinutes,paidBreakMinutes,hourlyRateSnapshotCents,bonusCents,tipsCents,status,notes,workingMinutes,paidMinutes,grossCents
```

Use an export as a template. Columns must be present and unique but can be reordered. Use version `2`, unique stable record ids, ISO timestamps with Z/explicit offset, integer cents/minutes, and `completed`, `planned` or `cancelled`. A reversible apostrophe prefix protects formula-like user text when opened in spreadsheets. Quotes, Unicode and multiline notes round-trip.

JSON contains `format: "werktrack-worklogs"`, `schemaVersion: 2` and a `workEntries` array. It is distinct from a full backup. Legacy v1 reports and arbitrary payroll files must be explicitly converted to this schema before import.

Limits: 10 MiB and 20,000 records. Validation rejects malformed quoting/JSON, invalid dates/timezones, negative values, excessive breaks, missing employers, active timers and durations outside zero-to-seven-days. The database has second-level timestamp precision. Money uses integer cents.

Everything validates before any write. Duplicate content within an employer is skipped. Changed content for an existing source id rejects the batch instead of overwriting it. Deleted ids are skipped to avoid resurrecting tombstones. Conflicts are rechecked inside the commit transaction. The batch either succeeds completely or changes nothing.

## Full backups

Expand **Complete backup** for full database JSON export/restore. A restore replaces all local records after validation and explicit confirmation; it is not an employer-scoped merge. Back up first. Exports contain personal employment and earnings data in **unencrypted clear text**; store privately and share only with trusted recipients.
