import Foundation

struct DisableTestLineRewriter : ToggleTestLineRewriter {
    func replacesFunc(in lines: NSMutableArray, fullLine: String, searchIn substring: String, index: Int) -> Bool {
        let pairs = [
            disabledBDDSubstring(substring),
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

    private func disabledBDDSubstring(_ string: String) -> (String, String)? {
        if string.contains("xit(") {
            return ("xit(", "it(")
        } else if string.contains("xdescribe(") {
            return ("xdescribe(", "describe(")
        } else if string.contains("xcontext(") {
            return ("xcontext(", "context(")
        }

        return nil
    }

    private func focusedBDDSubstring(_ string: String) -> (String, String)? {
        if string.contains("fit(") {
            return ("fit(", "xit(")
        } else if string.contains("fdescribe(") {
            return ("fdescribe(", "xdescribe(")
        } else if string.contains("fcontext(") {
            return ("fcontext(", "xcontext(")
        }

        return nil
    }

    private func pendingBDDSubstring(_ string: String) -> (String, String)? {
        if string.contains("pit(") {
            return ("pit(", "xit(")
        } else if string.contains("pdescribe(") {
            return ("pdescribe(", "xdescribe(")
        } else if string.contains("pcontext(") {
            return ("pcontext(", "xcontext(")
        }

        return nil
    }

    private func unfocusedBDDSubstring(_ string: String) -> (String, String)? {
        if string.contains("it(") {
            return ("it(", "xit(")
        } else if string.contains("describe(") {
            return ("describe(", "xdescribe(")
        } else if string.contains("context(") {
            return ("context(", "xcontext(")
        }

        return nil
    }
}
