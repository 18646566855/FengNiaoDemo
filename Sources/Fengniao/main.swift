import Foundation
import FengniaoKit
import CommandLineKit
import Rainbow

let appVersion = "0.4.1"

let cli = CommandLineKit.CommandLine()

let projectPathOption = StringOption(
    shortFlag: "p",
    longFlag: "project",
    helpMessage: "Root path of your Xcode project." +
                 "Default is current folder.")
cli.addOption(projectPathOption)

let excludePathOption = MultiStringOption(
    shortFlag: "e",
    longFlag: "exclude",
    helpMessage: "Exclude paths from search.")
cli.addOption(excludePathOption)

let resourceExtOption = MultiStringOption(
    shortFlag: "r",
    longFlag: "resource-extensions",
    helpMessage: "Resource file extensions need to be searched." +
                 "Default is 'imageset jpg png gif'")
cli.addOption(resourceExtOption)

let fileExtOption = MultiStringOption(
    shortFlag: "f",
    longFlag: "file-extensions",
    helpMessage: "In which types of files we should search for resource usage." +
                 "Default is 'm mm swift xib storyboard'")
cli.addOption(fileExtOption)

let helpOption = BoolOption(shortFlag: "h",
                            longFlag: "help",
                            helpMessage: "Print this help message.")
cli.addOption(helpOption)

let versionOption = BoolOption(longFlag: "version",
                               helpMessage: "Print version.")
cli.addOption(versionOption)

let isForceOption = BoolOption(
    longFlag: "force",
    helpMessage: "Delete the found unused files without asking.")
cli.addOption(isForceOption)



cli.formatOutput = {s, type in
    var str : String
    switch (type) {
    case .error:
        str = s.red.bold
    case .optionFlag:
        str = s.green.underline
    case .optionHelp:
        str = s.lightBlue
    default:
        str = s
    }
    return cli.defaultFormat(s: str, type: type)
}

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

if helpOption.value {
    cli.printUsage()
    exit(EX_OK)
}

if versionOption.value {
    print(appVersion)
    exit(EX_OK)
}


let project = projectPathOption.value ?? "."
let resourceExt = resourceExtOption.value ?? ["imageset", "jpg", "png", "gif"]
let fileExt = fileExtOption.value ?? ["m", "mm", "swift", "xib", "storyboard", "plist"]

let excloudePaths = excludePathOption.value ?? []

print(fileExt)
print(fileExt.count)

let fengniao = Fengniao(projectPath: project,
                        excludedPaths: excloudePaths,
                        resourcsExts: resourceExt,
                        searchInFileExtensions: fileExt)

let unusedFiles: [FileInfo]
do {
    try unusedFiles = fengniao.unusedFiles()
}catch{
    guard let e = error as? FengNiaoError else {
        print("Unknow Error:\(error)")
        exit(EX_USAGE)
    }
    switch e {
    case .noResourceExtension:
        print("You need to specify some resource extensions as search target. Use --resource-extensions to specify.".red.bold)
    case .noFileExtension:
        print("You need to specify some file extensions to search in. Use --file-extensions to specify.".red.bold)
    }
    exit(EX_USAGE)
}

if unusedFiles.isEmpty {
    print("🤗")
    exit(EX_OK)
}

if !false {
    var result = promptResult(files: unusedFiles)
    while result == .list {
        for file in unusedFiles {
            print("\(file.readableSize) \(file.path.string)")
        }
        result = promptResult(files: unusedFiles)
    }
    switch result {
    case .list:
        fatalError()
    case .delete:
        break
    case .ignore:
        print("Ignored. Nothing to do, bye!".green.bold)
        exit(EX_OK)
    }
}












