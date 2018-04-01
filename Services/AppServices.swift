//
//  Copyright © 2018 Frallware. All rights reserved.
//

import Foundation
import Frallware

public final class AppServices {

    private var services: [String : Any] = [:]

    public init() {
        add(service: _FeedRepository(), ofType: FeedRepository.self)
    }

    private func add<S>(service: S, ofType type: S.Type) {
        services[String(describing: type)] = service
    }
}

extension AppServices: ServiceContainer {

    public func service<T>(ofType type: T.Type) -> Any {
        return services[String(describing: type)]!
    }
}
