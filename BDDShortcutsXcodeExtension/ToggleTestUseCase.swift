import Foundation

struct ToggleTestUseCase {
    let lineRewriter: ToggleTestLineRewriter

    init(rewriter: ToggleTestLineRewriter) {
        lineRewriter = rewriter
    }

    func toggleFocusOfBDDFunction(inLines lines: NSMutableArray, cursor: Cursor) throws {
        for i in (0 ..< cursor.line + 1).reversed() {
            let element = lines[i]
            guard let line: String = element as? String else {
                return
            }

            let columnIndex = String.IndexDistance.init(cursor.column)
            let endOfLineIndex = String.IndexDistance.init(line.characters.count)
            let offset = i == cursor.line ? columnIndex : endOfLineIndex
            let index = line.index(line.startIndex, offsetBy: offset)
            let substring = line.substring(to: index)

            if lineRewriter.replacesFunc(in: lines, fullLine: line, searchIn: substring, index: i) {
                return
            }
        }
    }
}
