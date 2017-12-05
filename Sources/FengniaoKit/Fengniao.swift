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
        case "swift":
            self = .swift
        case "m", "mm":
            self = .objc
        case "xib", "storyboard":
            self = .xib
        case "plist":
            self = .plist
        default: return nil
        }
    }
    
    func searchRule(extensions: [String]) -> [FileSearchRule] {
        switch self {
        case .swift: return [SwiftImageSearchRule(extensions: extensions)]
        case .objc:  return [ObjcImageSearchRule(extensions: extensions)]
        case .xib:   return [XibImageSearchRule()]
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
    let resourcsExts: [String]
    let searchInFileExts:[String]
    
    let regularDirExtensions = ["imageset", "launchimage", "appiconset", "bundle"]
    var nonDirExtensions: [String] {
        return resourcsExts.filter{ !regularDirExtensions.contains($0) }
    }
    
    public init(projectPath: String, excludedPaths: [String], resourcsExts: [String], searchInFileExtensions:[String]){
        let path = Path(projectPath).absolute()
        self.projectPath = path
        self.excludedPaths = excludedPaths.map{ path + Path($0) }
        self.resourcsExts = resourcsExts
        self.searchInFileExts = searchInFileExtensions
    }
    
    public func unusedFiles() throws-> [FileInfo] {
        guard !resourcsExts.isEmpty else {
            throw FengNiaoError.noResourceExtension
        }
        guard !searchInFileExts.isEmpty else {
            throw FengNiaoError.noFileExtension
        }
        
        let allResources = allResourcsFiles()
        let usedNames = allUsedStringNames()
        
        return Fengniao.filterUnused(from: allResources, used: usedNames).map { FileInfo.init(path: $0)}
    }
    
    func allResourcsFiles() -> [String: Set<String>] {
        let find = ExtensionFindProcess(path: projectPath, extensions: resourcsExts, excluded: excludedPaths)
        guard let result = find?.execute() else {
            print("Resource finding failed.".red)
            return [:]
        }
        
        var files = [String: Set<String>]()
        fileLoop: for file in result {
    
            let dirPaths = regularDirExtensions.map { ".\($0)/" }
            for dir in dirPaths where file.contains(dir) {
                continue fileLoop
            }
            
            let filePath = Path(file)
            if let ext = filePath.extension, filePath.isDirectory && nonDirExtensions.contains(ext)  {
                continue
            }
            
            let key = file.plainName(extenions: resourcsExts)
            if let existing = files[key] {
                files[key] = existing.union([file])
            } else {
                files[key] = [file]
            }
        }
        return files
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
                guard searchInFileExts.contains(fileExt) else {
                    continue
                }
                let fileType = Filetype(ext: fileExt)
                let searchRules = fileType?.searchRule(extensions: resourcsExts) ?? [PlainImageSearchRule(extensions: resourcsExts)]
                let content = (try? subPath.read()) ?? ""
                result.append(contentsOf: searchRules.flatMap { $0.searcher(in: content) })
            }
        }
        return Set(result)
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
    
    static func filterUnused(from all: [String: Set<String>], used: Set<String>) -> Set<String> {
        let unusedPairs = all.filter { key, _ in
            return !used.contains(key) &&
                !used.contains { $0.similarPatternWithNumberIndex(other: key) }
        }
        return Set( unusedPairs.flatMap { $0.value } )
    }
}
