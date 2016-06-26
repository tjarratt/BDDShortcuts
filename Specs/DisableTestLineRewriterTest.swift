import XCTest

class DisableTestLineRewriterTest: XCTestCase {
    var subject: DisableTestLineRewriter?
    let itLines: NSMutableArray = NSMutableArray(
        array: [
            "it(\"is definitely a test\")","\n"
        ])
    let describeLines: NSMutableArray = NSMutableArray(
        array: [
            "describe(\"yo im in your tests\")",
        ])
    let contextLines: NSMutableArray = NSMutableArray(
        array: [
            "context(\"dont let me into my zone\")",
        ])

    override func setUp() {
        super.setUp()

        subject = DisableTestLineRewriter()
    }

    func focus(lines: NSMutableArray, withPrefix prefix: String) -> NSMutableArray {
        return edit(lines: lines, withPrefix: prefix, toHaveNewPrefix: "f")
    }

    func disables(lines: NSMutableArray, withPrefix prefix: String) -> NSMutableArray {
        return edit(lines: lines, withPrefix: prefix, toHaveNewPrefix: "x")
    }

    func pends(lines: NSMutableArray, withPrefix prefix: String) -> NSMutableArray {
        return edit(lines: lines, withPrefix: prefix, toHaveNewPrefix: "p")
    }

    func edit(lines: NSMutableArray, withPrefix prefix: String, toHaveNewPrefix newPrefix: String) -> NSMutableArray {
        return NSMutableArray(array: lines.map({ (element) -> String in
            guard let line = element as? String else {
                return ""
            }
            return line.hasPrefix("\(prefix)(") ? newPrefix + line : line
        }))
    }

    func testItIsALineRewriter() {
        guard let _ = subject as? ToggleTestLineRewriter else {
            XCTFail("expected subject to be a line rewriter")
            return
        }
    }

    func testItDisablesIts() {
        let result = subject!.replacesFunc(
            in: itLines,
            fullLine: "it(\"is definitely a test\")",
            searchIn: "it(\"is definitely a test\")",
            index: 0
        )
        XCTAssertTrue(result)
        XCTAssertEqual(itLines, NSMutableArray(array: ["xit(\"is definitely a test\")","\n"]))
    }

    func testItDisablesDescribes() {
        let result = subject!.replacesFunc(
            in: describeLines,
            fullLine: "describe(\"yo im in your tests\")",
            searchIn: "describe(\"yo im in your tests\")",
            index: 0
        )
        XCTAssertTrue(result)
        XCTAssertEqual(describeLines, NSMutableArray(array: ["xdescribe(\"yo im in your tests\")",]))
    }

    func testItDisablesContexts() {
        let result = subject!.replacesFunc(
            in: contextLines,
            fullLine: "context(\"dont let me into my zone\"",
            searchIn: "context(\"dont let me into my zone\"",
            index: 0
        )
        XCTAssertTrue(result)
        XCTAssertEqual(contextLines, NSMutableArray(array: ["xcontext(\"dont let me into my zone\""]))
    }

    func testItDisablesFocusedIts() {
        let lines = focus(lines: itLines, withPrefix: "it(")
        let result = subject!.replacesFunc(
            in: lines,
            fullLine: "fit(\"is definitely a test\")",
            searchIn: "fit(\"is definitely a test\")",
            index: 0
        )
        XCTAssertTrue(result)
        XCTAssertEqual(lines, NSMutableArray(array: ["xit(\"is definitely a test\")","\n"]))
    }

    func testItDisablesFocusedDescribes() {
        let lines = focus(lines: describeLines, withPrefix: "describe(")
        let result = subject!.replacesFunc(
            in: lines,
            fullLine: "fdescribe(\"yo im in your tests\")",
            searchIn: "fdescribe(\"yo im in your tests\")",
            index: 0
        )
        XCTAssertTrue(result)
        XCTAssertEqual(lines, NSMutableArray(array: ["xdescribe(\"yo im in your tests\")"]))
    }

    func testItDisablesFocusedContexts() {
        let lines = focus(lines: contextLines, withPrefix: "context(")
        let result = subject!.replacesFunc(
            in: lines,
            fullLine: "fcontext(\"dont let me into my zone\")",
            searchIn: "fcontext(\"dont let me into my zone\")",
            index: 0
        )
        XCTAssertTrue(result)
        XCTAssertEqual(lines, NSMutableArray(array: ["xcontext(\"dont let me into my zone\")",]))
    }

    func testItEnablesDisabledIts() {
        let lines = disables(lines: itLines, withPrefix: "it(")
        let result = subject!.replacesFunc(
            in: lines,
            fullLine: "xit(\"definitely is a test\")",
            searchIn: "xit(\"definitely is a test\")",
            index: 0
        )
        XCTAssertTrue(result)
        XCTAssertEqual(lines, NSMutableArray(array: ["it(\"definitely is a test\")", "\n"]))
    }

    func testItEnablesDisabledDescribes() {
        let lines = disables(lines: describeLines, withPrefix: "describe(")
        let result = subject!.replacesFunc(
            in: lines,
            fullLine: "xdescribe(\"yo im in your tests\")",
            searchIn: "xdescribe(\"yo im in your tests\")",
            index: 0
        )
        XCTAssertTrue(result)
        XCTAssertEqual(lines, NSMutableArray(array: ["describe(\"yo im in your tests\")"]))
    }

    func testItEnablesDisabledContexts() {
        let lines = disables(lines: contextLines, withPrefix: "context(")
        let result = subject!.replacesFunc(
            in: lines,
            fullLine: "xcontext(\"dont let me into my zone\")",
            searchIn: "xcontext(\"dont let me into my zone\")",
            index: 0
        )
        XCTAssertTrue(result)
        XCTAssertEqual(lines, NSMutableArray(array: ["context(\"dont let me into my zone\")"]))
    }

    func testItDisblesPendingIts() {
        let lines = pends(lines: itLines, withPrefix: "it(")
        let result = subject!.replacesFunc(
            in: lines,
            fullLine: "pit(\"definitely is a test\")",
            searchIn: "pit(\"definitely is a test\")",
            index: 0
        )
        XCTAssertTrue(result)
        XCTAssertEqual(lines, NSMutableArray(array: ["xit(\"definitely is a test\")", "\n"]))
    }

    func testItDisablesPendingDescribes() {
        let lines = pends(lines: describeLines, withPrefix: "describe(")
        let result = subject!.replacesFunc(
            in: lines,
            fullLine: "pdescribe(\"yo im in your tests\")",
            searchIn: "pdescribe(\"yo im in your tests\")",
            index: 0
        )
        XCTAssertTrue(result)
        XCTAssertEqual(lines, NSMutableArray(array: ["xdescribe(\"yo im in your tests\")"]))
    }

    func testItDisablesPendingContexts() {
        let lines = pends(lines: contextLines, withPrefix: "context(")
        let result = subject!.replacesFunc(
            in: lines,
            fullLine: "pcontext(\"dont let me into my zone\")",
            searchIn: "pcontext(\"dont let me into my zone\")",
            index: 0
        )
        XCTAssertTrue(result)
        XCTAssertEqual(lines, NSMutableArray(array: ["xcontext(\"dont let me into my zone\")"]))
    }

    func testItReturnsFalseWhenItHasNothingToMatch() {
        let result = subject!.replacesFunc(
            in: itLines,
            fullLine: "\n",
            searchIn: "\n",
            index: 1
        )
        XCTAssertFalse(result)
        XCTAssertEqual(itLines, NSMutableArray(array: ["it(\"is definitely a test\")","\n"]))
    }
}
