# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0]

### Added

- Added protocols
- Added Codable support

### Changed

- Changed output type for method returning AnyPublisher<Bool, Never> to AnyPublisher<Void, PersistentStorageError>
- Changed type of returned value from optional type to non-optional for read methods. Marked methods with optional return type as deprecated.
- Version increased

### Fixed

- Removing value actually removes object for a given key

## [1.0.0]

### Added

- Created first version of persistent storage framework

### Changed

- SPM Support
