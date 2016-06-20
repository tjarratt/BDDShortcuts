import Foundation

let itExpression = try! RegularExpression(pattern: "\\s*(f?)it\\(", options: .useUnixLineSeparators)
let contextExpression = try! RegularExpression(pattern: "\\s*context\\(", options: .useUnixLineSeparators)
let describeExpression = try! RegularExpression(pattern: "\\s*describe\\(", options: .useUnixLineSeparators)

struct ToggleTestUseCase {
    func toggleClosestBDDFunction(inLines: NSMutableArray, fromLine: Int, column: Int) throws {
        for i in 0 ..< fromLine + 1 {
            let reversedIndex = fromLine - i

            let element = inLines[reversedIndex]
            guard let line: String = element as? String else {
                return
            }

            let lengthOfLineToMatch = reversedIndex == fromLine ? column : line.characters.count
            let range = NSRange(location: 0, length: lengthOfLineToMatch)
            let numberOfMatches = itExpression.numberOfMatches(in: line, range: range)

            if numberOfMatches > 0 {
                let hasFocus = line.contains("fit(")
                if hasFocus {
                    inLines[reversedIndex] = line.replacingOccurrences(of: "fit(", with: "it(")
                } else {
                    inLines[reversedIndex] = line.replacingOccurrences(of: "it(", with: "fit(")
                }

                return
            }
        }
    }
}
