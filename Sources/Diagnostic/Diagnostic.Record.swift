extension Diagnostic {

    public struct Record: Sendable, Equatable, Hashable, Codable {

        public let location: Source.Location

        public let severity: Severity

        public let identifier: Swift.String

        public let message: Swift.String

        @inlinable
        public init(
            location: Source.Location,
            severity: Severity,
            identifier: Swift.String,
            message: Swift.String
        ) {
            self.location = location
            self.severity = severity
            self.identifier = identifier
            self.message = message
        }
    }
}

extension Diagnostic.Record: Comparable {

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.location != rhs.location { return lhs.location < rhs.location }
        if lhs.severity != rhs.severity { return lhs.severity < rhs.severity }
        if lhs.identifier != rhs.identifier { return lhs.identifier < rhs.identifier }
        return lhs.message < rhs.message
    }
}

extension Diagnostic.Record: CustomStringConvertible {

    @inlinable
    public var description: Swift.String {
        "\(location): \(severity): \(identifier): \(message)"
    }
}
