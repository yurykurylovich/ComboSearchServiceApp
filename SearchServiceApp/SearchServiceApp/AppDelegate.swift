import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        customizeAppearance()
        return true
    }
    
    func customizeAppearance() {
        let barTintColor = UIColor(red: 235/255, green: 180/255,
                                blue: 205/255, alpha: 1)
        UISearchBar.appearance().barTintColor = barTintColor
    }

}

