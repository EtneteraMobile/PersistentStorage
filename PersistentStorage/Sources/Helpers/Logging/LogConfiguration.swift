import Foundation

/// TODO
public struct LogConfiguration {
    let logSetup: LogSetup
    let logger: (String) -> Void

    public init(
        logSetup: LogSetup,
        logger: @escaping (String) -> Void
    ) {
        self.logSetup = logSetup
        self.logger = logger
    }
}
