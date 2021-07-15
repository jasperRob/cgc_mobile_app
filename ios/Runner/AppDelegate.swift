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
	GMSServices.provideAPIKey("AIzaSyAtVhjLGxE9DDgiovEOuEbXZa_GzeQdHNE")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
