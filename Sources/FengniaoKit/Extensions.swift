//
//  Extensions.swift
//  FengniaoKit
//
//  Created by youzhenbei on 2017/11/30.
//

import Foundation
import PathKit

extension String {
    var fullRange: NSRange {
        return NSMakeRange(0, self.utf16.count)
    }
    
    func plainName(extenions: [String]) -> String {
        let p = Path(self.lowercased())
        var result: String!
        for ext in extenions {
            if hasSuffix(".\(ext)") {
                result = p.lastComponentWithoutExtension
                break
            }
        }
        
        if result == nil {
            result = p.lastComponent
        }
        
        if result.hasSuffix("@2x") || result.hasSuffix("@3x") ||
           result.hasSuffix("@2X") || result.hasSuffix("@3X") {
            let endIndex = result.index(result.endIndex, offsetBy: -3)
            result = result.substring(to: endIndex)
        }
        return result
    }
    
    
    var plainName1: String {
        let p = Path(self.lowercased())
        var result = p.lastComponentWithoutExtension
        if result.hasSuffix("@2x") || result.hasSuffix("@3x") {
            let endIndex = result.index(result.endIndex, offsetBy: -3)
            result = result.substring(to: endIndex)
        }
        return result
    }
    
}
let fileSizeSuffix = ["B", "KB", "MB", "GB"]


extension Int {
    public var fn_readableSize: String {
        var level = 0
        var num = Float(self)
        while num > 1000 && level < 3 {
            num = num / 1000.0
            level += 1
        }
        
        if level == 0 {
            return "\(Int(num)) \(fileSizeSuffix[level])"
        }
        return String(format: "%.2f \(fileSizeSuffix[level])", num)
    }
}


extension Path {
    var size: Int {
        if isDirectory {
            let childrenPaths = try? children()
            return (childrenPaths ?? []).reduce(0) { $0 + $1.size}
        }else {
            if lastComponent.hasPrefix(".") { return 0 }
            let attr = try? FileManager.default.attributesOfItem(atPath: absolute().string)
            if let num = attr?[.size] as? NSNumber {
                return num.intValue
            }
            return 0
        }
    }
}
