import XCTest
@testable import FengniaoKit
class FengNiaoKitTests: XCTestCase {
    
    func testFengNiaoKitSpecs() {
        specFengNiaoKit()
    }
    
    func testFirstCase() {
        let a = 1 + 2
        XCTAssertEqual(a, 3, "1 + 2 == 3")
    }
    
}


