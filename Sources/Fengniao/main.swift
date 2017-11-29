import Foundation
import FengniaoKit
import CommandLineKit
import Rainbow

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

let helpOption = BoolOption(shortFlag: "h", longFlag: "help",
                            helpMessage: "Print this help message.")
cli.addOption(helpOption)

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
    exit(EX_USAGE)
}

let project = projectPathOption.value ?? "."
let resourceExt = resourceExtOption.value ?? ["png", "jpg", "imageset"]
let fileExt = fileExtOption.value ?? ["m", "mm", "xib", "stroyboard"]


print(CommandLine.arguments);
