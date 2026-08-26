extension Diagnostic {

    public enum Severity: Int, Sendable, Hashable, Comparable, CaseIterable, Codable {
        case error
        case warning
        case note
        case remark
    }
}

extension Diagnostic.Severity {

    public static func < (lhs: Self, rhs: Self) -> Bool {

        lhs.rawValue < rhs.rawValue
    }
}
