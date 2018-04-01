//
//  Copyright © 2018 Frallware. All rights reserved.
//

import Foundation
import Frallware

public final class AppServices {

    private var services: [String : Any] = [:]

    public init() {

    }

}

extension AppServices: ServiceContainer {

    public func service<T>(ofType type: T.Type) -> Any {
        return services[String(describing: type)]!
    }
}
