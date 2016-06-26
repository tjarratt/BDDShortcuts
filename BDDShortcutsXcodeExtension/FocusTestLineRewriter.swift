import Foundation

struct FocusTestLineRewriter : ToggleTestLineRewriter {
    func replacesFunc(in lines: NSMutableArray, fullLine: String, searchIn substring: String, index: Int) -> Bool {
        let pairs = [
            focusedBDDSubstring(substring),
            pendingBDDSubstring(substring),
            unfocusedBDDSubstring(substring),
            ]

        for i in 0 ..< pairs.count {
            if let (old, new) = pairs[i] {
                lines[index] = fullLine.replacingOccurrences(of: old, with: new)
                return true
            }
        }

        return false
    }

    private func focusedBDDSubstring(_ string: String) -> (String, String)? {
        if string.contains("fit(") {
            return ("fit(", "it(")
        } else if string.contains("fdescribe(") {
            return ("fdescribe(", "describe(")
        } else if string.contains("fcontext(") {
            return ("fcontext(", "context(")
        }

        return nil
    }

    private func unfocusedBDDSubstring(_ string: String) -> (String, String)? {
        if string.contains("it(") {
            return ("it(", "fit(")
        } else if string.contains("describe(") {
            return ("describe(", "fdescribe(")
        } else if string.contains("context(") {
            return ("context(", "fcontext(")
        }

        return nil
    }

    private func pendingBDDSubstring(_ string: String) -> (String, String)? {
        var result: String?
        ["pit(", "xit(", "pdescribe(", "xdescribe(", "pcontext(", "xcontext("].forEach { (pendingFunc) in
            if string.contains(pendingFunc) {
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
