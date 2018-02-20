// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "web3swift",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "web3swift", targets: ["web3swift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/lorentey/BigInt.git", from: "3.0.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMinor(from: "0.8.0")),
        .package(url: "https://github.com/balancemymoney/Sodium.git", .upToNextMinor(from: "1.1.1")),
        .package(url: "https://github.com/balancemymoney/secp256k1_swift.git", .upToNextMinor(from: "1.0.2")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "web3swift", dependencies: ["BigInt", "CryptoSwift", "Sodium", "secp256k1_swift"], path: "Sources"),
        .testTarget(name: "web3swiftlinuxTests", dependencies: ["web3swift"]),
    ]
)
