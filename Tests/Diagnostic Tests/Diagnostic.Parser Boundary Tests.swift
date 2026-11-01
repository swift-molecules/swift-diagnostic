import Source
import Testing
import Text

@testable import Diagnostic

extension Diagnostic.Parser.Test.`Edge Case` {
    @Test
    func `empty input and blank lines give no records`() {
        #expect(Diagnostic.Parser.parse(stderr: "").isEmpty)
        #expect(Diagnostic.Parser.parse(stderr: "\n\r\n\n").isEmpty)
    }

    @Test
    func `colons inside the message are kept`() {
        let records = Diagnostic.Parser.parse(stderr: "/a.swift:1:2: error: expected ':' in 'a: b'")
        #expect(records.count == 1)
        #expect(records.first?.message == "expected ':' in 'a: b'")
    }

    @Test
    func `unknown severities and non-numeric positions are skipped`() {
        #expect(Diagnostic.Parser.parse(stderr: "/a.swift:1:2: fatal: nope").isEmpty)
        #expect(Diagnostic.Parser.parse(stderr: "/a.swift:x:2: error: nope").isEmpty)
        #expect(Diagnostic.Parser.parse(stderr: "Compiling module A").isEmpty)
    }

    @Test
    func `CRLF line endings are accepted`() {
        let records = Diagnostic.Parser.parse(stderr: "/a.swift:1:2: warning: w\r\n/b.swift:3:4: note: n\r\n")
        #expect(records.map(\.severity) == [.warning, .note])
        #expect(records.map(\.message) == ["w", "n"])
    }

    @Test
    func `a Windows drive-letter path keeps its line and column`() {
        let records = Diagnostic.Parser.parse(stderr: #"C:\src\a.swift:3:4: error: bad"#)
        #expect(records.count == 1)
        #expect(records.first?.location.filePath == #"C:\src\a.swift"#)
        #expect(records.first?.location.line.underlying == 3)
        #expect(records.first?.location.column.underlying == 4)
        #expect(records.first?.message == "bad")
    }
}
