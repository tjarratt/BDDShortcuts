import Foundation
import XcodeKit

class ToggleTestFocusCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(NSError(domain: "glg.error-xcode-contract-changed-whoops!", code: 1, userInfo: nil))
            return
        }

        var rewriter : ToggleTestLineRewriter
        switch invocation.commandIdentifier {
        case "com.glg.BDDShortcuts.BDDShortcutsXcodeExtension.ToggleTestFocusCommand":
            rewriter = FocusTestLineRewriter()
        case "com.glg.BDDShortcuts.BDDShortcutsXcodeExtension.ToggleTestDisableCommand":
            rewriter = DisableTestLineRewriter()
        default:
            let info = [
                NSLocalizedDescriptionKey: "unknown command \(invocation.commandIdentifier)"
            ]
            completionHandler(NSError(domain: "glg.error-xcode-unknown-command-identifier", code: 1, userInfo: info))
            return
        }

        let line = selection.start.line
        let column = selection.start.column
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
