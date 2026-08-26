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
            name: "Diagnostic Test Support",
            targets: ["Diagnostic Test Support"]
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
                .product(name: "Source", package: "swift-source")
            ]
        ),
        .target(
            name: "Diagnostic Test Support",
            dependencies: [
                "Diagnostic",
                .product(
                    name: "Source Test Support",
                    package: "swift-source"
                ),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Diagnostic Tests",
            dependencies: [
                "Diagnostic",
                "Diagnostic Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
