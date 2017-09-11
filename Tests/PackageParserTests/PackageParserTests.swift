import XCTest
import PerfectLib
@testable import PackageParser

class PackageParserTests: XCTestCase {
  func testExample() {
    do {
      let content = "import PackageDescription\n#if os(Linux)\nlet package = Package(name: \"FakeProj\",dependencies: [.Package(url: \"https://linux.repo.git\", majorVersion: 1)])\n#else\nlet package = Package(name: \"FakeProj\",dependencies: [.Package(url: \"https://mac.repo.git\", majorVersion: 1)])\n#endif\n"
      let path = "/tmp/FakePackage.swift"
      let fakePackage = File(path)
      try fakePackage.open(.write)
      try fakePackage.write(string: content)
      fakePackage.close()
      let dic = try SwiftPackageParse(path)
      print(dic)
      fakePackage.delete()
    } catch {
      XCTFail(error.localizedDescription)
    }
  }


  static var allTests = [
    ("testExample", testExample),
    ]
}
