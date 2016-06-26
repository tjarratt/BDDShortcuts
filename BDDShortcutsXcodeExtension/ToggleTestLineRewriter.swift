import Foundation

protocol ToggleTestLineRewriter {
    func replacesFunc(in lines: NSMutableArray, fullLine: String, searchIn: String, index: Int) -> Bool
}

