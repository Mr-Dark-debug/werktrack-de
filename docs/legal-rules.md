# Legal rule versioning

`LegalRules` stores a key, effective interval, numeric value, unit, official URL/title, verification date, and metadata JSON. New years add rows; they do not overwrite history. Calculations must resolve the row whose interval contains the work date.

Built-in 2026 keys cover minimum wage, Minijob month/year references, residence full/half-day representations, the four-hour boundary, student weekly reference, 26-week reference, standard/extended workday, break triggers and requirements, minimum rest, and tax basic allowance.

User overrides should be added as separately identified versions with provenance. They must never mutate the bundled source record.
