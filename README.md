# Diagnostic

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

A `Diagnostic` namespace of structured-finding value types for Swift — a typed source location, a semantic severity, a stable identifier, and a message — for linters, audits, and build-graph checkers, with zero platform dependencies.

---

## Quick Start

A `Diagnostic.Record` is one finding: *where* it was emitted (a typed `Source.Location`, never a raw `Int` line number), *how severe* it is, *which* rule emitted it, and *why*. It renders in the canonical `file:line:col: severity: identifier: message` form that compilers and linters share.

```swift
import Diagnostic

let record = Diagnostic.Record(
    location: Source.Location(
        fileID: "App/Parser.swift",
        filePath: "/src/App/Parser.swift",
        line: 42,
        column: 7
    ),
    severity: .warning,
    identifier: "unchecked_call_site",
    message: "call site is not bounds-checked"
)

print(record)
// App/Parser.swift:42:7: warning: unchecked_call_site: call site is not bounds-checked
```

`Diagnostic.Severity` is `Comparable`, ordered most-to-least severe, and `Diagnostic.Record` is `Comparable` lexicographically by location, then severity, then identifier, then message — so a batch of findings sorts straight into a stable reporter order. Each severity also carries its canonical wire-format token for reporters targeting SARIF, SwiftLint-textual, or GCC-style `file:line:col: severity:` output.

```swift
import Diagnostic

let ordered = [Diagnostic.Severity.note, .error, .warning].sorted()
print(ordered)   // [error, warning, note]

print(Diagnostic.Severity.warning.wire.token)   // "warning"
```

Records are `Equatable` and `Hashable` (deduplication), `Codable` (serialization to disk or IPC), and `Sendable` — the conformances are derived from the field types, so the same value travels unchanged from the tool that emits it through every layer that reports it.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-molecules/swift-diagnostic.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Diagnostic", package: "swift-diagnostic"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Two library products. Depends only on `Source.Location` from `swift-source`.

| Product | Target | Purpose |
|---------|--------|---------|
| `Diagnostic` | `Sources/Diagnostic/` | The `Diagnostic` namespace: `Diagnostic.Record` (typed `Source.Location` + `Diagnostic.Severity` + identifier + message, with a `description` rendering) and `Diagnostic.Severity` (`error` / `warning` / `note` / `remark`) with its `wire.token` wire-format mapping. |
| `Diagnostic Test Support` | `Tests/Support/` | Re-exports the main target (and `Source Test Support`) for test consumers. |

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
