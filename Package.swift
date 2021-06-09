// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ScreenObject",
    platforms: [ .iOS(.v13) ],
    products: [
        .library(name: "ScreenObject", targets: ["ScreenObject"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "ScreenObject", exclude: ["Info.plist"]),
    ],
    swiftLanguageVersions: [.v5]
)
