//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit
import Services
import Frallware

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var services: AppServices!
    private var appNavigator: AppNavigator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setupServices()
        setupUI()

        return true
    }

    private func setupServices() {
        services = AppServices()
        Service.install(container: services)
    }

    private func setupUI() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        appNavigator = AppNavigator(window: window)
        appNavigator.setupWindowContent()
        window.makeKeyAndVisible()
        self.window = window
    }
}
