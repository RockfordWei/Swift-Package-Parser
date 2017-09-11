# Package.swift Parser

This Project is a support repo for Perfect Assistant.

# Methodology

It will copy the Package.swift file provided by the end user to /tmp/{uuid}.swift, and appending `print(jsonString(package: package))` as defined in github/apple/swift-package-manager, then run this new script in Swift REPL with both Xcode tool chain and Docker, and yield a Swift dictionary if succeed.

By this mean, it can resolve everything of the package definition including compilation flags.

# NOTE

The result is subject to Swift Version.


# Usage

``` swift

let path = "/path/to/Package.swift"
let dic = try SwiftPackageParse(path)

print(dic)

```

For example, if the `/path/to/Package.swift` is:

``` swift

import PackageDescription
#if os(Linux)
let package = Package(name: "FakeProj",dependencies: [.Package(url: "https://linux.repo.git", majorVersion: 1)])
#else
let package = Package(name: "FakeProj",dependencies: [.Package(url: "https://mac.repo.git", majorVersion: 1)])
#endif

```

The it should be resolved as an dictionary:

```
["mac": ["dependencies": [["version": ["lowerBound": "1.0.0", "upperBound": "1.9223372036854775807.9223372036854775807"], "url": "https://mac.repo.git"]], "name": "FakeProj", "exclude": [], "targets": []], "linux": ["dependencies": [["version": ["lowerBound": "1.0.0", "upperBound": "1.9223372036854775807.9223372036854775807"], "url": "https://linux.repo.git"]], "name": "FakeProj", "exclude": [], "targets": []]]
```
