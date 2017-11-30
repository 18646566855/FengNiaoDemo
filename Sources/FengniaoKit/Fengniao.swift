import Foundation
import PathKit

public enum FengNiaoError: Error {
    case noResourceExtension
    case noFileExtension
}

public struct FileInfo {
    public let path: Path
    public let size: Int
    public let fileName: String
    
    init(path: String) {
        self.path = Path(path)
        self.size = self.path.size
        self.fileName = self.path.lastComponent
    }
    
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
    
    public func unusedFiles() throws-> [FileInfo] {
        guard !resourcsExt.isEmpty else {
            throw FengNiaoError.noResourceExtension
        }
        
//        let allResources = allResources
        
        
        fatalError("错误信息")
    }
    
    func stringsInUse() -> [String] {
        
        return []
    }
    
    func resourceInUse() -> [String: String] {
        fatalError()
    }
    
    
    public func delete(_ unusedFiles: [FileInfo]) -> (deleted: [FileInfo], failed: [(FileInfo, Error)]) {
        var deleted = [FileInfo]()
        var failed = [(FileInfo, Error)]()
        for file in unusedFiles {
            do {
                try file.path.delete()
                deleted.append(file)
            }catch {
                failed.append((file, error))
            }
        }
        return (deleted, failed)
    }
    
    public func allResourcsFiles() -> [String: Set<String>] {
        
        fatalError()
    }
}
