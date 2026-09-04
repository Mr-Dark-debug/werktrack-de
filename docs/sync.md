# Optional Firebase sync

Local SQLite remains authoritative for UI reads. Sync is opt-in and requires operator-provided Firebase platform configuration. The app can run indefinitely without Firebase initialization.

Each synchronizable record uses UUID identity, UTC `updatedAt`, device ID, status, and a tombstone. Merge order is: newer timestamp wins; at equal timestamps a tombstone wins; remaining ties use lexical device ID for deterministic convergence. The winning remote record is committed locally before the watermark advances. Uploads are idempotent document sets using UUID document IDs.

Conflicts do not merge individual fields because doing so can create a record that existed on neither device. A future conflict-history collection may retain losing payloads. Authentication uses an explicit user action; anonymous auth may be offered, but the app never creates accounts or accepts terms without the user.

## Runtime setup

The Settings > Optional cloud sync screen initializes Firebase only after a user action. It offers email/password sign-in or account creation, explicit anonymous sync, manual reconciliation, and disabling/sign-out. Disabling retains both local and previously uploaded records. The core app does not require any Firebase values.

For an operator-configured build, pass `FIREBASE_API_KEY`, `FIREBASE_APP_ID`, `FIREBASE_PROJECT_ID`, and `FIREBASE_MESSAGING_SENDER_ID` using `--dart-define` or a private `--dart-define-from-file` configuration. Enable the intended Firebase Auth providers and deploy the supplied `firestore.rules` to restrict each `/users/{uid}/records` collection to its authenticated owner. No Firebase project, credentials, authentication provider, or rules deployment has been fabricated or provisioned by this implementation.

The Drift adapter reconciles profiles, employers (including tombstones), work records (including tombstones), academic periods, payslips, rule versions, and non-device-specific settings. `sync.*` settings remain device-local. Planned records are persisted as work records with planned status. Server writes compare the deterministic winner inside a Firestore transaction. Full reconciliation is intentional for a personal-scale database: relying on a client-clock cursor alone can miss delayed offline changes. Parents are applied before foreign-key children.

Primary API references: [Firebase Flutter setup](https://firebase.google.com/docs/flutter/setup) and [Firestore transactions](https://firebase.google.com/docs/firestore/manage-data/transactions), checked 2026-09-04. Local merge/Drift adapter behavior is tested; live Firebase authentication, rules enforcement, and two-device network convergence require a configured project and have not been verified here.
