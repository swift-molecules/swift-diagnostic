extension Diagnostic.Severity {

    public struct Wire {
        @usableFromInline
        let severity: Diagnostic.Severity

        @inlinable
        package init(_ severity: Diagnostic.Severity) {
            self.severity = severity
        }
    }

    @inlinable
    public var wire: Wire { Wire(self) }
}

extension Diagnostic.Severity.Wire {

    @inlinable
    public var token: Swift.String {
        switch severity {
        case .error: "error"
        case .warning: "warning"
        case .note: "note"
        case .remark: "remark"
        }
    }
}
