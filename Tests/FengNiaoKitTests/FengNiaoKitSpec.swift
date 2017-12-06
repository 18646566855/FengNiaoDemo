import XCTest
import Spectre
import Rainbow
@testable import FengniaoKit

public func specFengNiaoKit() {
    describe("FengNiaoKit") {
        $0.describe("String Extension") {
            $0.it("should return plain name") {
                let s1 = "image@2x.png"
                let s2 = "/usr/local/bin/find"
                let s3 = "image@3x.jpg"
                let s4 = "local.host"
                let s5 = "local.host.png"
                
                let exts = ["png"]
                try expect(s1.plainName(extenions: exts)) == "image"
                try expect(s2.plainName(extenions: exts)) == "find"
                try expect(s3.plainName(extenions: exts)) == "image@3x.jpg"
                try expect(s4.plainName(extenions: exts)) == "local.host"
                try expect(s5.plainName(extenions: exts)) == "local.host"
            }
        }
        
        $0.describe("String Searchers") {
            $0.it("Swift Searher works") {
                let s0 = "UIImage(named: \"image\")"
                let s1 = "adadada ads addads\"_asda\""
                let s2 = "let name = \"close_btn@2x\"/nlet image = UIImage(name: name)"
                let s3 = "test String: \"local.png\""
                let s4 = "test String: \"local.host\""
                let s5 = "test String: \"local.host.png\""
                
                let exts = ["png"]
                let searcher = SwiftImageSearchRule(extensions: exts)
            
                let result = [s0, s1, s2, s3, s4, s5].map{searcher.searcher(in: $0)}
                
                try expect((result[0])) == Set(["image"])
                try expect((result[1])) == Set(["_asda"])
                try expect((result[2])) == Set(["close_btn"])
                try expect((result[3])) == Set(["local"])
                try expect((result[4])) == Set(["local.host"])
                try expect((result[5])) == Set(["local.host"])
                
            }
        }
        
        
        $0.describe("String image_number.ext") {
            $0.it("String similarPatternWithNumberIndex") {
                let s1 = "image_01"
                let s2 = "image_index_01"
                let s3 = "image_01_index"
                let s4 = "01_image"
                
                let n1 = "image_%zd"
                let n2 = "image_index_%zd"
                let n3 = "image_%zd_index"
                let n4 = "%zd_image"
                
                try expect(n1.similarPatternWithNumberIndex(other: s1)) == true
                try expect(n2.similarPatternWithNumberIndex(other: s2)) == true
                try expect(n3.similarPatternWithNumberIndex(other: s3)) == true
                try expect(n4.similarPatternWithNumberIndex(other: s4)) == true
                
                print("111")
                
            }
            
            
        }
        
        $0.describe("file Size Int Extesnions") {
            $0.describe("Int Extesnions") {
                $0.it("should parse for 0 byte") {
                    try expect(0.fn_readableSize) == "0 B"
                }
                $0.it("should parse several bytes") {
                    try expect(123.fn_readableSize) == "123 B"
                }
                $0.it("should parse serveral kb") {
                    try expect(123_456.fn_readableSize) == "123.46 KB"
                }
                $0.it("should parse serveral mb") {
                    try expect(123_456_789.fn_readableSize) == "123.46 MB"
                }
                $0.it("should parse serveral gb") {
                    try expect(1_123_456_789.fn_readableSize) == "1.12 GB"
                }
                $0.it("should parse more than tb") {
                    try expect(1_321_123_456_789.fn_readableSize) == "1321.12 GB"
                }
            }
            
        }
    }
}
