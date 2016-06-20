import XCTest

class ToggleTestUseCaseTest: XCTestCase {

    var subject: ToggleTestUseCase?

    override func setUp() {
        super.setUp()

        subject = ToggleTestUseCase()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testItFocusesASingleIt() {
        let lines = NSMutableArray(array: ["it(\"definitely is a test\")"])
        try! subject?.toggleClosestBDDFunction(inLines: lines, fromLine: 0, column: 12)

        let firstLine = lines[0] as! String
        XCTAssertEqual(firstLine, "fit(\"definitely is a test\")")
    }

    func testItUnfocusesAFocusedIt() {
        let lines = NSMutableArray(array: ["fit(\"definitely is a test\")"])
        try! subject?.toggleClosestBDDFunction(inLines: lines, fromLine: 0, column: 12)

        let firstLine = lines[0] as! String
        XCTAssertEqual(firstLine, "it(\"definitely is a test\")")
    }

    func testItRewritesTheFirstItAboveTheCursor() {
        let lines = NSMutableArray(array: [
            "it(\"definitely is a test\")",
            "it(\"most assuredly is a test\")",
            "it(\"still is a test\")"
            ])
        try! subject?.toggleClosestBDDFunction(inLines: lines, fromLine: 1, column: 12)

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
        try! subject?.toggleClosestBDDFunction(inLines: lines, fromLine: 1, column: 0)

        let firstLine = lines[0] as! String
        let secondLine = lines[1] as! String
        let thirdLine = lines[2] as! String

        XCTAssertEqual(firstLine, "fit(\"definitely is a test\")")
        XCTAssertEqual(secondLine, "    it(\"most assuredly is a test\")")
        XCTAssertEqual(thirdLine, "it(\"still is a test\")")
    }

    func testItMakesNoChangesWhenNoTestsArePresent() {
        let lines = NSMutableArray(array: ["try! goodCode(isDefinitely: inTheBuilding)"])
        try! subject?.toggleClosestBDDFunction(inLines: lines, fromLine: 0, column: 12)

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
            try! self.subject?.toggleClosestBDDFunction(inLines: lines, fromLine: 53, column: 0)
        }
    }

}
