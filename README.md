# swift-diagnostic

Use this package when a tool needs compiler-style diagnostics as values: to turn the standard-error text of `swift build` or the Swift compiler into records, or to report its own findings (a linter, a checker) in the same shape so they sort, deduplicate and print alongside the compiler's. Start from `Diagnostic.Record`, which pairs a `Source.Location` with a `Diagnostic.Severity`, and from `Diagnostic.Parser` for compiler output. For a bare position without a severity or message, use `Source.Location` from swift-source directly.

## Laws

- `Diagnostic.Parser` reads line by line: lines split on LF, a trailing CR is dropped, and empty lines are skipped. Records come out in input order.
- A line becomes a record only if it has the form `path:line:column: severity: message`, with integer line and column and a severity of exactly `error`, `warning`, `note` or `remark`. Every other line (progress output, unknown severities such as `fatal`, non-numeric positions) is skipped silently; parsing never fails.
- The message is everything after the fourth colon, so colons inside it are kept. Leading spaces and tabs before the severity and the message are trimmed.
- A Windows drive-letter prefix (`C:\` or `C:/`) belongs to the path, not to the field separators.
- A parsed record's location has the path as both file ID and file path, and its identifier is always `swift_build_diagnostic`.
- `Diagnostic.Severity` orders from most to least severe: error, warning, note, remark.
- `Diagnostic.Record` orders lexicographically by location, then severity, then identifier, then message, and prints as `<location>: <severity>: <identifier>: <message>`.
- `Diagnostic.Severity.Wire` tokens are the same four keywords the parser accepts.
- With the Standard Library Integration, `Diagnostic.Severity` encodes as its integer raw value (error 0 through remark 3), so the declaration order of its cases is a wire format; decoding any other integer fails.
