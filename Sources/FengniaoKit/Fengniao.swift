import Foundation
import PathKit

public struct FileInfo {
    let Path: String
}


public struct Fengniao {
    let projectPath: Path
    let excludedPaths: [Path]
    let resourcsExt: [String]
    let fileExtensions:[String]
    
    public init(projectPath: String, excludedPaths: [String], resourcsExt: [String], fileExtensions:[String]){
        let path = Path(projectPath).absolute()
        self.projectPath = path
        self.excludedPaths = excludedPaths.map{ path + Path($0) }
        self.resourcsExt = resourcsExt
        self.fileExtensions = fileExtensions
    }
    
    public func unusedResource() -> [FileInfo] {
        fatalError()
    }
    
    func stringsInUse() -> [String] {
        
        return []
    }
    
    func resourceInUse() -> [String: String] {
        fatalError()
    }
    
    public func delete() -> () {
        
    }
    
}
