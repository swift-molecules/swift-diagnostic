import Source
import Testing
import Text

@testable import Diagnostic

extension Diagnostic.Parser {
    @Suite struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension Diagnostic.Parser.Test.Unit {
    @Test
    func `Single error line yields one record with expected fields`() throws {
        let stderr = "/path/to/File.swift:12:5: error: cannot find 'foo' in scope"
        let records = Diagnostic.Parser.parse(stderr: stderr)

        #expect(records.count == 1)
        let record = try #require(records.first)
        #expect(record.severity == .error)
        #expect(record.identifier == "swift_build_diagnostic")
        #expect(record.message == "cannot find 'foo' in scope")
        #expect(record.location.fileID == "/path/to/File.swift")
        #expect(record.location.filePath == "/path/to/File.swift")
        #expect(record.location.line.underlying == 12)
    }

    @Test
    func `Multiple lines mixed severities preserve order and counts`() {
        let stderr = """
            /A.swift:1:1: error: bad
            /B.swift:2:2: warning: meh
            /C.swift:3:3: note: fyi
            /D.swift:4:4: remark: hint
            """
        let records = Diagnostic.Parser.parse(stderr: stderr)
        #expect(records.count == 4)
        #expect(records.map(\.severity) == [.error, .warning, .note, .remark])
        #expect(records.map(\.message) == ["bad", "meh", "fyi", "hint"])
    }

    @Test
    func `Severity-keyword mapper covers all four wire keywords`() {
        #expect(Diagnostic.Parser.Line.severity(forKeyword: "error") == .error)
        #expect(Diagnostic.Parser.Line.severity(forKeyword: "warning") == .warning)
        #expect(Diagnostic.Parser.Line.severity(forKeyword: "note") == .note)
        #expect(Diagnostic.Parser.Line.severity(forKeyword: "remark") == .remark)
        #expect(Diagnostic.Parser.Line.severity(forKeyword: "unknown") == nil)
        #expect(Diagnostic.Parser.Line.severity(forKeyword: "") == nil)
    }
}

extension Diagnostic.Parser.Test.`Edge Case` {
    @Test
    func `Empty stderr yields no records`() {
        let records = Diagnostic.Parser.parse(stderr: "")
        #expect(records.isEmpty)
    }

    @Test
    func `Malformed lines are silently skipped`() throws {
        let stderr = """
            Building swift-foo
            /Real.swift:7:3: warning: shadowed
            not a diagnostic
            /BadColumn.swift:9:NotANumber: error: nope
            Compiling File.swift
            /Unknown.swift:1:1: bogus: not a real severity
            """
        let records = Diagnostic.Parser.parse(stderr: stderr)

        #expect(records.count == 1)
        let record = try #require(records.first)
        #expect(record.severity == .warning)
        #expect(record.message == "shadowed")
    }

    @Test
    func `CRLF line endings leave no carriage-return residue`() throws {
        let stderr = "/A.swift:1:1: error: bad\r\n"
        let records = Diagnostic.Parser.parse(stderr: stderr)

        #expect(records.count == 1)
        let record = try #require(records.first)
        #expect(record.message == "bad")
    }
}
