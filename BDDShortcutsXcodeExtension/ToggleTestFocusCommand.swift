import Foundation
import XcodeKit

class ToggleTestFocusCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (NSError?) -> Void ) -> Void {

        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(NSError(domain: "glg.error-xcode-contract-changed", code: 1, userInfo: nil))
            return
        }

        let line = selection.start.line
        let column = selection.start.column

        let rewriter = FocusTestLineRewriterImpl()
        let toggleTestUseCase = ToggleTestUseCase(rewriter: rewriter)

        do {
            try toggleTestUseCase.toggleFocusOfBDDFunction(
                inLines: invocation.buffer.lines,
                cursor: Cursor(line: line, column: column)
            )
        } catch {
            completionHandler(NSError(domain: "glg.error.invocation-failed", code: 2, userInfo: nil))
            return
        }

        completionHandler(nil)
    }

}
