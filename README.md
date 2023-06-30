# PersistentStorage

PersistentStorage is a Swift package that provides a simple of working with storing non-sensitive data using UserDefaults.

## Installation

To use PersistentStorage in your project, add the following line to your `Package.swift` file:

```
.package(url: "https://github.com/EtneteraMobile/PersistentStorage", .upToNextMajor(from: "2.0.0"))
```

Then, include "PersistentStorage" as a dependency for your target:

```
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "PersistentStorage", package: "PersistentStorage")
    ]
)
```

## Usage

First register the `PersistentStorage` into your container:

```
container.register(PersistentStorage.self) { _ in
    MainPersistentStorage(logConfiguration: ...)
}
```

Then to use `PersistentStorage` resolve the current instance by using:

```
container.resolve(PersistentStorage.self)
```

## License

PersistentStorage is available under the MIT license.
