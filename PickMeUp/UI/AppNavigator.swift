//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit

final class AppNavigator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func setupWindowContent() {
        window.rootViewController = ViewController.create()
    }

}
