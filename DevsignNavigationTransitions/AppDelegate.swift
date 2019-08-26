import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_: UIApplication) {}
    func applicationDidEnterBackground(_: UIApplication) {}
    func applicationWillEnterForeground(_: UIApplication) {}
    func applicationDidBecomeActive(_: UIApplication) {}
    func applicationWillTerminate(_: UIApplication) {}
}
