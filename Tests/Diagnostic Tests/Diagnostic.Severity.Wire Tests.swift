import Diagnostic
import Testing

extension Diagnostic.Severity.Wire {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}

extension Diagnostic.Severity.Wire.Test.Unit {
    @Test
    func `error token is "error"`() {
        #expect(Diagnostic.Severity.error.wire.token == "error")
    }

    @Test
    func `warning token is "warning"`() {
        #expect(Diagnostic.Severity.warning.wire.token == "warning")
    }

    @Test
    func `note token is "note"`() {
        #expect(Diagnostic.Severity.note.wire.token == "note")
    }

    @Test
    func `remark token is "remark"`() {
        #expect(Diagnostic.Severity.remark.wire.token == "remark")
    }

    @Test
    func `token is total over allCases`() {
        for severity in Diagnostic.Severity.allCases {
            #expect(!severity.wire.token.isEmpty)
        }
    }
}
