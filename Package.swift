// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "auto-sendable",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "auto-sendable", targets: ["AutoSendableExec"]),
        .executable(name: "auto-unchecked-sendable", targets: ["AutoUncheckedSendableExec"]),
        .plugin(name: "AutoSendablePlugin", targets: ["AutoSendablePlugin"]),
        .plugin(name: "AutoUncheckedSendablePlugin", targets: ["AutoUncheckedSendablePlugin"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-syntax.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "AutoSendableExec",
            dependencies: [
                .target(name: "AutoSendable"),
                .target(name: "Util")
            ]
        ),
        .executableTarget(
            name: "AutoUncheckedSendableExec",
            dependencies: [
                .target(name: "AutoUncheckedSendable"),
                .target(name: "Util")
            ]
        ),
        .target(
            name: "AutoSendable",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .target(name: "RewriterCore"),
                .target(name: "Util")
            ]
        ),
        .target(
            name: "AutoUncheckedSendable",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .target(name: "RewriterCore"),
                .target(name: "Util")
            ]
        ),
        .target(
            name: "RewriterCore",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .target(name: "Util")
            ]
        ),
        .plugin(
            name: "AutoSendablePlugin",
            capability: .command(
                intent: .custom(
                    verb: "auto-sendable",
                    description: "Inherit Sendable for public structs and enums."
                ),
                permissions: [
                    .writeToPackageDirectory(reason: "This command write swift files that structs and enums inherit Sendable.")
                ]
            ),
            dependencies: ["AutoSendableExec"]
        ),
        .plugin(
            name: "AutoUncheckedSendablePlugin",
            capability: .command(
                intent: .custom(
                    verb: "auto-unchecked-sendable",
                    description: "Inherit @unchecked Sendable for classes."
                ),
                permissions: [
                    .writeToPackageDirectory(reason: "This command write swift files that classes inherit @unchecked Sendable.")
                ]
            ),
            dependencies: ["AutoUncheckedSendableExec"]
        ),
        .target(name: "Util"),
        .testTarget(
          name: "AutoSendableTests",
          dependencies: ["AutoSendable"]
        ),
        .testTarget(
          name: "AutoUncheckedSendableTests",
          dependencies: ["AutoUncheckedSendable"]
        ),
    ]
)
