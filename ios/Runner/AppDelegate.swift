import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // 设置Widget通信通道
    setupWidgetChannel()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  /// 设置Widget通信通道
  private func setupWidgetChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }
    
    let widgetChannel = FlutterMethodChannel(
      name: "ios_widget_location",
      binaryMessenger: controller.binaryMessenger
    )
    
    widgetChannel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "getWidgetLocations":
        self?.getWidgetLocations(result: result)
      case "clearWidgetLocations":
        self?.clearWidgetLocations(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  /// 获取Widget收集的定位数据
  private func getWidgetLocations(result: @escaping FlutterResult) {
    let sharedDefaults = UserDefaults(suiteName: "group.com.weeklife.app")
    let locations = sharedDefaults?.array(forKey: "widget_locations") as? [[String: Any]] ?? []
    result(locations)
  }
  
  /// 清理Widget定位数据
  private func clearWidgetLocations(result: @escaping FlutterResult) {
    let sharedDefaults = UserDefaults(suiteName: "group.com.weeklife.app")
    sharedDefaults?.removeObject(forKey: "widget_locations")
    result(nil)
  }
}
