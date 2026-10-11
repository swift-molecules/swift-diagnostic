// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-diagnostic",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Diagnostic",
            targets: ["Diagnostic"]
        ),
        .library(
            name: "Diagnostic Standard Library Integration",
            targets: ["Diagnostic Standard Library Integration"]
        ),
        .library(
            name: "Diagnostic Apple Foundation Integration",
            targets: ["Diagnostic Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-source.git",
            branch: "main"
        )

    ],
    targets: [
        .target(
            name: "Diagnostic",
            dependencies: [
                .product(name: "Source", package: "swift-source"),
                .product(name: "Source Standard Library Integration", package: "swift-source")
            ]
        ),
        .target(
            name: "Diagnostic Standard Library Integration",
            dependencies: [.target(name: "Diagnostic")]
        ),
        .target(
            name: "Diagnostic Apple Foundation Integration",
            dependencies: [
                .target(name: "Diagnostic"),
                .target(name: "Diagnostic Standard Library Integration"),
            ]
        ),
        .testTarget(
            name: "Diagnostic Tests",
            dependencies: [.target(name: "Diagnostic"), .product(name: "Source", package: "swift-source")]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
        .treatAllWarnings(as: .error),
    ]
}
