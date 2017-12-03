//
//  StringSearchRule.swift
//  FengniaoKit
//
//  Created by youzhenbei on 2017/11/30.
//

import Foundation

protocol FileSearchRule {
    func searcher(in content: String) -> Set<String>
}

protocol RegPatternSearchRule: FileSearchRule {
    var extensions: [String] { get }
    var patterns: [String] { get }
    
}


extension RegPatternSearchRule {
    func searcher(in content: String) -> Set<String> {
        var result = Set<String>()
        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
                print("Failed to creat regular expression: \(pattern)")
                continue
            }
            let matches = regex.matches(in: content, options: [], range: content.fullRange)
            for checkingResult in matches {
                let range = checkingResult.range(at: 1)
                let extracted = NSString(string: content).substring(with: range)
                result.insert(extracted.plainName(extenions: extensions))
            }
        }
        return result
    }
}

struct SwiftImageSearchRule: RegPatternSearchRule {
    let extensions: [String]
    let patterns = ["\"(.+?)\""]
}

struct ObjcImageSearchRule: RegPatternSearchRule {
    let extensions: [String]
    let patterns = ["@\"(.+?)\"", "\"(.+?)\""]
}

struct XibImageSearchRule: RegPatternSearchRule {
    let extensions = [String]()
    let patterns = ["image name=\"(.*?)\"", "image=\"(.*?)\"", "value=\"(.*?)\""]
}

struct PlistImageSearchRule: RegPatternSearchRule {
    let extensions: [String]
    let patterns = ["<key>UIApplicationShortcutItemIconFile</key>[^<]*<string>(.*?)</string>"]
}

struct PlainImageSearchRule: RegPatternSearchRule {
    let extensions: [String]
    var patterns: [String] {
        if extensions.isEmpty {
            return []
        }
        let join = extensions.joined(separator: "|")
        return ["\"(.+?)\\.(\(join))\"" ]
    }
}
