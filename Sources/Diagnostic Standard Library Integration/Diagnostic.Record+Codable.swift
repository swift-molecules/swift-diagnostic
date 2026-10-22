#if !hasFeature(Embedded)
    public import Diagnostic
    public import Source_Standard_Library_Integration

    extension Diagnostic.Record {

        @usableFromInline
        internal enum CodingKeys: Swift::String, CodingKey {
            case location
            case severity
            case identifier
            case message
        }
    }

    extension Diagnostic.Record: Codable {

        @inlinable
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.init(
                location: try container.decode(Source.Location.self, forKey: .location),
                severity: try container.decode(Diagnostic.Severity.self, forKey: .severity),
                identifier: try container.decode(Swift::String.self, forKey: .identifier),
                message: try container.decode(Swift::String.self, forKey: .message)
            )
        }

        @inlinable
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(location, forKey: .location)
            try container.encode(severity, forKey: .severity)
            try container.encode(identifier, forKey: .identifier)
            try container.encode(message, forKey: .message)
        }
    }
#endif
