# Permissions and privacy

WerkTrack works without an account, Firebase configuration, notifications or network access. SQLite is stored in the application's private sandbox, without application-level database encryption. Use device encryption and a screen lock.

## Android permissions

- Notifications are requested only when the user enables advisories. Android 13+ uses `POST_NOTIFICATIONS`; denial does not block work tracking. The notification library also contributes `VIBRATE`.
- `INTERNET` permits optional user-enabled Firebase sync and source links. Firebase Auth contributes `ACCESS_NETWORK_STATE`, and its reCAPTCHA dependency contributes Google's `READ_GSERVICES`. None of these permissions prompt the user, and no cloud account is required for local use.
- `RECEIVE_BOOT_COMPLETED` restores scheduled reminders. Timer correctness uses a saved timestamp, not a continuously running service.
- AndroidX contributes an app-signature-scoped dynamic-receiver permission so other applications cannot send to internal receivers.
- The document picker/share sheet grants access only to chosen files. No broad storage, device calendar, contacts, location, camera, microphone or package-install permissions are requested. Kalender is an in-app display.
- Reminders use inexact scheduling; no exact-alarm permission is requested. OS/OEM battery policy can delay delivery.
- Automatic Android cloud backup/device-transfer extraction is disabled in app configuration. Users can deliberately export backups.

The packaged debug APK was inspected after manifest merging; the permissions above are the complete merged list. This must be rechecked whenever Android dependencies change.

See the official [document access model](https://developer.android.com/training/data-storage/shared/documents-files) and [notification permission guide](https://developer.android.com/develop/ui/compose/notifications/notification-permission).

## Other platforms and sharing

iOS notification initialization does not prompt; enabling the setting requests permission. Sharing includes an iPad anchor. iOS has not been built/device-tested here; platform scaffolding does not imply support. Android is the verified target.

Exports contain personal data in clear text. Firebase sync is optional, authenticated and scoped to the user's path, with owner-only rules supplied in the repository. Deploy those rules to a project you own before enabling it. Live cloud isolation and end-to-end sync remain unverified. No end-to-end encryption is claimed.

The public repository excludes databases, build output, signing keys, provider credentials and personal exports. Do not attach personal CSV/JSON files to public issues. Verify privacy disclosures and cloud ownership/access controls again before a store release.
