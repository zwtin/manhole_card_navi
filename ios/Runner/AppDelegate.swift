import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    #if development
    if let path = Bundle.main.path(forResource: "DevelopmentKeys", ofType: "plist"),
       let keys = NSDictionary(contentsOfFile: path),
       let key = keys["Google Maps API key"] as? String {
        GMSServices.provideAPIKey(key)
    }
    #elseif production
    if let path = Bundle.main.path(forResource: "ProductionKeys", ofType: "plist"),
       let keys = NSDictionary(contentsOfFile: path),
       let key = keys["Google Maps API key"] as? String {
        GMSServices.provideAPIKey(key)
    }
    #endif

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
