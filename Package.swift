import PackageDescription

let package = Package(
    name: "Kitura-ComputerDatabase",
    targets: [
        Target(
            name: "Deploy",
            dependencies: [.Target(name: "ComputerDatabase")]
        ),
        Target(
            name: "ComputerDatabase"
        )
    ],
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 3),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 3),
        .Package(url: "https://github.com/Zewo/PostgreSQL", majorVersion: 0, minor: 14)
    ]
)
