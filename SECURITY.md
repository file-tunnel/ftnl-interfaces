# Security policy

Please report vulnerabilities privately through GitHub Security Advisories in
the affected `file-tunnel` repository. Do not include live capabilities,
pairing secrets, uploaded files, or personal data in a public issue.

The supported line is the latest `main` revision until tagged releases begin.

## Security invariants

- A tunnel UUID is never authorization.
- Pairing secrets are short-lived, single-use, and stored only as hashes.
- Desktop, phone, upload, download, and event-ticket capabilities are scoped
  independently.
- Long-lived capabilities must not appear in URLs. One-time event tickets may.
- Portal responses use a restrictive CSP and `Referrer-Policy: no-referrer`.
- Uploads have allowlisted size/count limits, content sniffing, and expiry.
- Filenames are display metadata, never filesystem paths.
- File contents are excluded from logs, telemetry, crash reports, and sync.
