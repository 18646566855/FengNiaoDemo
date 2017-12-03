import Foundation
import PathKit
import Rainbow

enum Filetype {
    case swift
    case objc
    case xib
    case plist
    
    init?(ext: String) {
        switch ext.lowercased() {
        case "swift": self = .swift
        case "m", "mm": self = .objc
        case "xib", "storyboard": self = .xib
        case "plist": self = .plist
        default: return nil
        }
    }
    
    func searchRule(extensions: [String]) -> [FileSearchRule] {
        switch self {
        case .swift: return [SwiftImageSearchRule(extensions: extensions)]
        case .objc: return [ObjcImageSearchRule(extensions: extensions)]
        case .xib:  return [XibImageSearchRule()]
        case .plist: return [PlistImageSearchRule(extensions: extensions)]
        }
    }
}

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
    
    public var readableSize: String {
        return size.fn_readableSize
    }
}

public struct Fengniao {
    let projectPath: Path
    let excludedPaths: [Path]
    let resourcsExt: [String]
    let searchInFileExtensions:[String]
    
    public init(projectPath: String, excludedPaths: [String], resourcsExt: [String], searchInFileExtensions:[String]){
        let path = Path(projectPath).absolute()
        self.projectPath = path
        self.excludedPaths = excludedPaths.map{ path + Path($0) }
        self.resourcsExt = resourcsExt
        self.searchInFileExtensions = searchInFileExtensions
    }
    
    public func unusedFiles() throws-> [FileInfo] {
        guard !resourcsExt.isEmpty else {
            throw FengNiaoError.noResourceExtension
        }
        
        //        let allResources = allResources
        
        
        fatalError("错误信息")
    }
    
    func allUsedStringNames() -> Set<String> {
        
        return usedStringNames(at: projectPath)
    }
    
    func usedStringNames(at path: Path) -> Set<String> {
        guard let subpaths = try? path.children() else {
            print("Path reading error. \(path)".red)
            return []
        }
        
        var result = [String]()
        for subPath in subpaths {
            if subPath.lastComponent.hasPrefix(".") {
                continue
            }
            if excludedPaths.contains(subPath) {
                continue
            }
            if subPath.isDirectory {
                result.append(contentsOf: usedStringNames(at: subPath))
            } else {
                let fileExt = subPath.extension ?? ""
                guard searchInFileExtensions.contains(fileExt) else {
                    continue
                }
                let fileType = Filetype(ext: fileExt)
                let searchRules = fileType?.searchRule(extensions: resourcsExt) ?? [PlainImageSearchRule(extensions: resourcsExt)]
                let content = (try? subPath.read()) ?? ""
                result.append(contentsOf: searchRules.flatMap { $0.searcher(in: content) })
            }
        }
        return Set(result)
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
