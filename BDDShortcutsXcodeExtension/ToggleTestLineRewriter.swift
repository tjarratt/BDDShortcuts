import Foundation

protocol ToggleTestLineRewriter {
    func replacesFunc(in lines: NSMutableArray, fullLine: String, searchIn: String, index: Int) -> Bool
}

struct FocusTestLineRewriterImpl : ToggleTestLineRewriter {
    func replacesFunc(in lines: NSMutableArray, fullLine: String, searchIn: String, index: Int) -> Bool {
        let pairs = [
            searchIn.focusedBDDSubstring(),
            searchIn.pendingBDDSubstring(),
            searchIn.unfocusedBDDSubstring(),
            ]

        for i in 0 ..< pairs.count {
            if let (old, new) = pairs[i] {
                lines[index] = fullLine.replacingOccurrences(of: old, with: new)
                return true
            }
        }

        return false
    }
}


extension String {
    func focusedBDDSubstring() -> (String, String)? {
        if self.contains("fit(") {
            return ("fit(", "it(")
        } else if self.contains("fdescribe(") {
            return ("fdescribe(", "describe(")
        } else if self.contains("fcontext(") {
            return ("fcontext(", "context(")
        }

        return nil
    }

    func unfocusedBDDSubstring() -> (String, String)? {
        if self.contains("it(") {
            return ("it(", "fit(")
        } else if self.contains("describe(") {
            return ("describe(", "fdescribe(")
        } else if self.contains("context(") {
            return ("context(", "fcontext(")
        }

        return nil
    }

    func pendingBDDSubstring() -> (String, String)? {
        var result: String?
        ["pit(", "xit(", "pdescribe(", "xdescribe(", "pcontext(", "xcontext("].forEach { (pendingFunc) in
            if self.contains(pendingFunc) {
                result = pendingFunc
            }
        }

        if var r = result {
            let pendingFunc = r
            r.remove(at: r.startIndex)
            let focusedFunc = "f" + r
            return (pendingFunc, focusedFunc)
        }

        return nil
    }
}
