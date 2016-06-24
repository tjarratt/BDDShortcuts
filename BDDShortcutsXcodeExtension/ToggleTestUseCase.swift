import Foundation

struct ToggleTestUseCase {
    func toggleFocusOfBDDFunction(inLines lines: NSMutableArray, cursor: Cursor) throws {
        for i in 0 ..< cursor.line + 1 {
            let reversedIndex = cursor.line - i

            let element = lines[reversedIndex]
            guard var line: String = element as? String else {
                return
            }

            let lengthOfLineToMatch = reversedIndex == cursor.line ? cursor.column : line.characters.count
            let range = NSRange(location: 0, length: lengthOfLineToMatch)

            let focusedMatches = focusedBDDFuncRegex.matches(in: line, range: range)
            if focusedMatches.count != 0 {
                line = line.replacingOccurrences(of: "fit(", with: "it(")
                line = line.replacingOccurrences(of: "fdescribe(", with: "describe(")
                line = line.replacingOccurrences(of: "fcontext(", with: "context(")
                lines[reversedIndex] = line
                return
            }

            let unfocusedMatches = bddFuncRegex.matches(in: line, range: range)
            if unfocusedMatches.count == 0 {
                continue
            }

            line = line.replacingOccurrences(of: "it(", with: "fit(")
            line = line.replacingOccurrences(of: "describe(", with: "fdescribe(")
            line = line.replacingOccurrences(of: "context(", with: "fcontext(")
            lines[reversedIndex] = line
            return
        }
    }
}

let bddFuncRegex = try! RegularExpression(
    pattern: "\\s*(it|describe|context)\\(",
    options: .useUnixLineSeparators
)

let focusedBDDFuncRegex = try! RegularExpression(
    pattern: "\\s*f(it|describe|context)\\(",
    options: .useUnixLineSeparators
)
