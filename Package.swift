import PackageDescription

let package = Package(
    name: "PackageParser",
    dependencies: [
      .Package(url: "https://github.com/PerfectlySoft/Perfect.git", majorVersion: 2)
    ]
)
