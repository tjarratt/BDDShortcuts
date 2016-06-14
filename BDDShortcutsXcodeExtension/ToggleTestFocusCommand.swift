import Foundation
import XcodeKit

class ToggleTestFocusCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (NSError?) -> Void ) -> Void {
        NSLog("whoops -- this is not implemented yet")
        completionHandler(nil)
    }

}
