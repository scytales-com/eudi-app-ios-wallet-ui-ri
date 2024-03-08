// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-test",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "logic-test",
      targets: ["logic-test"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/Brightify/Cuckoo.git",
      from: "1.10.4"
    ),
    .package(
      url: "https://github.com/groue/CombineExpectations.git",
      from: "0.10.0"
    ),
    .package(name: "logic-core", path: "./logic-core"),
  ],
  targets: [
    .target(
      name: "logic-test",
      dependencies: [
        "CombineExpectations",
        "logic-core",
        .product(
          name: "Cuckoo",
          package: "Cuckoo"
        )
      ],
      path: "./Sources"
    )
  ]
)
