import PerfectLib
import Foundation


func bash(_ cmd: String) throws -> [String: Any] {
  let task = Process()
  task.launchPath = "/bin/bash"
  task.arguments = ["-c", cmd]
  let oup = Pipe()
  task.standardOutput = oup
  task.launch()
  task.waitUntilExit()
  let data = oup.fileHandleForReading.readDataToEndOfFile()
  let string = data.withUnsafeBytes { (pointer: UnsafePointer<CChar>) -> String? in
    guard data.count > 0 else { return nil }
    return String(cString: pointer)
  }
  return try string?.jsonDecode() as? [String: Any] ?? [:]
}

public enum SwiftPackageParserError: Error {
  case InvalidSourcePath
}

public func SwiftPackageParse(_ path: String, xcodePrefix: String = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain") throws -> [String: Any] {

  let uuid = UUID().string
  let tempFilePath = "/tmp/\(uuid).swift"
  let sourcePackageFile = File(path)
  guard sourcePackageFile.exists else { throw SwiftPackageParserError.InvalidSourcePath }
  try sourcePackageFile.copyTo(path: tempFilePath, overWrite: true)
  let tempFile = File(tempFilePath)
  try tempFile.open(.append)
  try tempFile.write(string: "\nprint(jsonString(package: package))\n")
  tempFile.close()

  var result: [String: Any] = [:]
  let pmLib = "/usr/lib/swift/pm"
  let pmFlag = "-lPackageDescription"
  result ["mac"] = try bash("swift -I \(xcodePrefix)\(pmLib) -L \(xcodePrefix)\(pmLib) \(pmFlag) \(tempFilePath)")
  result ["linux"] = try bash("/usr/local/bin/docker run -it -v /tmp:/tmp rockywei/swift:3.1 /bin/bash -c \"swift -I \(pmLib) -L \(pmLib) \(pmFlag) \(tempFilePath)\"")
  unlink(tempFilePath)
  return result
}
