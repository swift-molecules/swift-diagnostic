import Diagnostic
import Source
import Testing

extension Diagnostic.Record {
    @Suite
    struct Test {
        @Suite struct Unit {}
    }
}

extension Diagnostic.Record.Test.Unit {
    @Test
    func `Record stores location severity identifier and message`() {
        let location = Source.Location(
            fileID: "Module/File.swift",
            filePath: "/abs/Module/File.swift",
            line: 42,
            column: 7
        )
        let record = Diagnostic.Record(
            location: location,
            severity: .warning,
            identifier: "unchecked_call_site",
            message: "test"
        )
        #expect(record.location == location)
        #expect(record.severity == .warning)
        #expect(record.identifier == "unchecked_call_site")
        #expect(record.message == "test")
    }

    @Test
    func `Records sort by location then severity then identifier`() {
        let earlier = Source.Location(fileID: "A", line: 1, column: 1)
        let later = Source.Location(fileID: "A", line: 5, column: 1)
        let a = Diagnostic.Record(
            location: earlier,
            severity: .warning,
            identifier: "r1",
            message: "m"
        )
        let b = Diagnostic.Record(location: later, severity: .error, identifier: "r1", message: "m")
        #expect(a < b)
    }

    @Test
    func `Same location severity and id with different message orders by message`() {
        let location = Source.Location(fileID: "A", line: 1, column: 1)
        let a = Diagnostic.Record(
            location: location,
            severity: .warning,
            identifier: "r",
            message: "alpha"
        )
        let b = Diagnostic.Record(
            location: location,
            severity: .warning,
            identifier: "r",
            message: "beta"
        )
        #expect(a < b)
    }

    @Test
    func `Hashable equality round-trips`() {
        let location = Source.Location(fileID: "A", line: 1, column: 1)
        let record = Diagnostic.Record(
            location: location,
            severity: .error,
            identifier: "r1",
            message: "m"
        )
        let same = Diagnostic.Record(
            location: location,
            severity: .error,
            identifier: "r1",
            message: "m"
        )
        #expect(record == same)
        #expect(record.hashValue == same.hashValue)
    }

    @Test
    func `Description renders as colon-separated form`() {
        let location = Source.Location(fileID: "Module/File.swift", line: 42, column: 7)
        let record = Diagnostic.Record(
            location: location,
            severity: .warning,
            identifier: "r1",
            message: "msg"
        )
        #expect(record.description == "Module/File.swift:42:7: warning: r1: msg")
    }
}
