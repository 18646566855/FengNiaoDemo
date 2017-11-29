//
//  StringSearchRule.swift
//  FengniaoKit
//
//  Created by youzhenbei on 2017/11/30.
//

import Foundation

protocol StringsSearcher {
    func searcher(in content: String) -> Set<String>
}

protocol RegexStringsSearcher: StringsSearcher {
    var patterns: [String] { get }
    
}


extension RegexStringsSearcher {
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
                result.insert(extracted.plainName)
            }
        }
        return result
    }
}
