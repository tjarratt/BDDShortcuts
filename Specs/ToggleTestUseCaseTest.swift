import XCTest

class ToggleTestUseCaseTest: XCTestCase {

    var subject: ToggleTestUseCase?

    override func setUp() {
        super.setUp()

        let rewriter = FocusTestLineRewriterImpl()

        subject = ToggleTestUseCase(rewriter: rewriter)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testItFocusesASingleIt() {
        let lines = NSMutableArray(array: ["it(\"definitely is a test\")"])
        try! subject?.toggleFocusOfBDDFunction(inLines: lines, cursor: Cursor(line: 0, column: 12))

        let firstLine = lines[0] as! String
        XCTAssertEqual(firstLine, "fit(\"definitely is a test\")")
    }

    func testitFocusesAPendingIt() {
        let lines = NSMutableArray(array: ["pit(\"definitely is a test\")"])
        try! subject?.toggleFocusOfBDDFunction(inLines: lines, cursor: Cursor(line: 0, column: 12))

        let firstLine = lines[0] as! String
        XCTAssertEqual(firstLine, "fit(\"definitely is a test\")")
    }

    func testitFocusesADisabledIt() {
        let lines = NSMutableArray(array: ["xit(\"definitely is a test\")"])
        try! subject?.toggleFocusOfBDDFunction(inLines: lines, cursor: Cursor(line: 0, column: 12))

        let firstLine = lines[0] as! String
        XCTAssertEqual(firstLine, "fit(\"definitely is a test\")")
    }

    func testItUnfocusesAFocusedIt() {
        let lines = NSMutableArray(array: ["fit(\"definitely is a test\")"])
        try! subject?.toggleFocusOfBDDFunction(inLines: lines, cursor: Cursor(line: 0, column: 12))

        let firstLine = lines[0] as! String
        XCTAssertEqual(firstLine, "it(\"definitely is a test\")")
    }

    func testItFocusesADescribe() {
        let lines = NSMutableArray(array: ["describe(\"good tests are definitely in the building\")"])
        try! subject?.toggleFocusOfBDDFunction(inLines: lines, cursor: Cursor(line: 0, column: 12))

        let firstLine = lines[0] as! String
        XCTAssertEqual(firstLine, "fdescribe(\"good tests are definitely in the building\")")
    }

    func testItUnfocusesAFocusedDescribe() {
        let lines = NSMutableArray(array: ["fdescribe(\"sure thing boss\")"])
        try! subject?.toggleFocusOfBDDFunction(inLines: lines, cursor: Cursor(line: 0, column: 12))

        let firstLine = lines[0] as! String
        XCTAssertEqual(firstLine, "describe(\"sure thing boss\")")
    }

    func testItFocusesAContext() {
        let lines = NSMutableArray(array: ["context(\"when tests are definitely in the building\")"])
        try! subject?.toggleFocusOfBDDFunction(inLines: lines, cursor: Cursor(line: 0, column: 12))

        let firstLine = lines[0] as! String
        XCTAssertEqual(firstLine, "fcontext(\"when tests are definitely in the building\")")
    }

    func testItUnfocusesAFocusedContext() {
        let lines = NSMutableArray(array: ["fcontext(\"when in rome\")"])
        try! subject?.toggleFocusOfBDDFunction(inLines: lines, cursor: Cursor(line: 0, column: 12))

        let firstLine = lines[0] as! String
        XCTAssertEqual(firstLine, "context(\"when in rome\")")
    }

    func testItRewritesTheFirstItAboveTheCursor() {
        let lines = NSMutableArray(array: [
            "it(\"definitely is a test\")",
            "it(\"most assuredly is a test\")",
            "it(\"still is a test\")"
            ])
        try! subject?.toggleFocusOfBDDFunction(inLines: lines, cursor: Cursor(line: 1, column: 12))

        let firstLine = lines[0] as! String
        let secondLine = lines[1] as! String
        let thirdLine = lines[2] as! String

        XCTAssertEqual(firstLine, "it(\"definitely is a test\")")
        XCTAssertEqual(secondLine, "fit(\"most assuredly is a test\")")
        XCTAssertEqual(thirdLine, "it(\"still is a test\")")
    }

    func testItRespectsThePositionOfTheCursor() {
        let lines = NSMutableArray(array: [
            "it(\"definitely is a test\")",
            "    it(\"most assuredly is a test\")",
            "it(\"still is a test\")"
            ])
        try! subject?.toggleFocusOfBDDFunction(inLines: lines, cursor: Cursor(line: 1, column: 0))

        let firstLine = lines[0] as! String
        let secondLine = lines[1] as! String
        let thirdLine = lines[2] as! String

        XCTAssertEqual(firstLine, "fit(\"definitely is a test\")")
        XCTAssertEqual(secondLine, "    it(\"most assuredly is a test\")")
        XCTAssertEqual(thirdLine, "it(\"still is a test\")")
    }

    func testItMakesNoChangesWhenNoTestsArePresent() {
        let lines = NSMutableArray(array: ["try! goodCode(isDefinitely: inTheBuilding)"])
        try! subject?.toggleFocusOfBDDFunction(inLines: lines, cursor: Cursor(line: 0, column: 12))

        let firstLine = lines[0] as! String
        XCTAssertEqual(firstLine, "try! goodCode(isDefinitely: inTheBuilding)")
    }

    func testEditingManyLines() {
        self.measure {
            let lines = NSMutableArray(array: [
                "import Quick\n",
                "import Nimble\n",
                "\n",
                "class TableOfContentsSpec: QuickSpec {\n",
                "  override func spec() {\n",
                "    describe(\"the 'Documentation' directory\") {\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "      // so many comments\n",
                "    }\n",
                "  }\n",
                "}\n"
                ])
            try! self.subject?.toggleFocusOfBDDFunction(inLines: lines, cursor: Cursor(line: 53, column: 0))
        }
    }

}
