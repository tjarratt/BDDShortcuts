import Foundation

let bddFuncRegex = try! RegularExpression(
    pattern: "\\s*(f?)(it|describe|context)\\(",
    options: .useUnixLineSeparators
)

let focusedBDDFuncRegex = try! RegularExpression(
    pattern: "\\s*f(it|describe|context)\\(",
    options: .useUnixLineSeparators
)

struct ToggleTestUseCase {
    func toggleClosestBDDFunction(inLines: NSMutableArray, fromLine: Int, column: Int) throws {
        for i in 0 ..< fromLine + 1 {
            let reversedIndex = fromLine - i

            let element = inLines[reversedIndex]
            guard var line: String = element as? String else {
                return
            }

            let lengthOfLineToMatch = reversedIndex == fromLine ? column : line.characters.count
            let range = NSRange(location: 0, length: lengthOfLineToMatch)

            let focusedMatches = focusedBDDFuncRegex.matches(in: line, range: range)
            if focusedMatches.count != 0 {
                line = line.replacingOccurrences(of: "fit(", with: "it(")
                line = line.replacingOccurrences(of: "fdescribe(", with: "describe(")
                line = line.replacingOccurrences(of: "fcontext(", with: "context(")
                inLines[reversedIndex] = line
                return
            }

            let unfocusedMatches = bddFuncRegex.matches(in: line, range: range)
            if unfocusedMatches.count == 0 {
                continue
            }

            line = line.replacingOccurrences(of: "it(", with: "fit(")
            line = line.replacingOccurrences(of: "describe(", with: "fdescribe(")
            line = line.replacingOccurrences(of: "context(", with: "fcontext(")
            inLines[reversedIndex] = line
            return
        }
    }
}
