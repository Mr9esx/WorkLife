import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private let sharedDefaults = UserDefaults(suiteName: "group.com.weeklife.app")
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50 // 50米最小距离
    }
    
    func getCurrentLocation(completion: @escaping (CLLocation?, String?, Error?) -> Void) {
        // 检查定位权限
        guard locationManager.authorizationStatus == .authorizedAlways ||
              locationManager.authorizationStatus == .authorizedWhenInUse else {
            completion(nil, nil, LocationError.permissionDenied)
            return
        }
        
        // 检查定位服务是否可用
        guard CLLocationManager.locationServicesEnabled() else {
            completion(nil, nil, LocationError.serviceDisabled)
            return
        }
        
        // 获取最后已知位置
        if let lastLocation = locationManager.location {
            // 检查位置是否太旧（超过10分钟）
            let locationAge = Date().timeIntervalSince(lastLocation.timestamp)
            if locationAge < 600 { // 10分钟
                // 使用缓存的位置
                getAddressFromLocation(lastLocation) { address in
                    self.saveLocationToSharedStorage(lastLocation, address: address)
                    completion(lastLocation, address, nil)
                }
                return
            }
        }
        
        // 请求新的位置
        locationManager.requestLocation()
        
        // 设置超时
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if let location = self.locationManager.location {
                self.getAddressFromLocation(location) { address in
                    self.saveLocationToSharedStorage(location, address: address)
                    completion(location, address, nil)
                }
            } else {
                completion(nil, nil, LocationError.timeout)
            }
        }
    }
    
    private func getAddressFromLocation(_ location: CLLocation, completion: @escaping (String?) -> Void) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            
            var addressComponents: [String] = []
            
            if let country = placemark.country {
                addressComponents.append(country)
            }
            if let administrativeArea = placemark.administrativeArea {
                addressComponents.append(administrativeArea)
            }
            if let locality = placemark.locality {
                addressComponents.append(locality)
            }
            if let subLocality = placemark.subLocality {
                addressComponents.append(subLocality)
            }
            if let thoroughfare = placemark.thoroughfare {
                addressComponents.append(thoroughfare)
            }
            
            let address = addressComponents.joined(separator: " ")
            completion(address.isEmpty ? nil : address)
        }
    }
    
    private func saveLocationToSharedStorage(_ location: CLLocation, address: String?) {
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "timestamp": location.timestamp.timeIntervalSince1970,
            "accuracy": location.horizontalAccuracy,
            "altitude": location.altitude,
            "address": address ?? ""
        ]
        
        var locations = sharedDefaults?.array(forKey: "widget_locations") as? [[String: Any]] ?? []
        locations.append(locationData)
        
        // 只保留最近50条记录
        if locations.count > 50 {
            locations = Array(locations.suffix(50))
        }
        
        sharedDefaults?.set(locations, forKey: "widget_locations")
        
        print("Widget定位数据已保存: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        getAddressFromLocation(location) { address in
            self.saveLocationToSharedStorage(location, address: address)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Widget定位失败: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("Widget定位权限被拒绝")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Widget定位权限已授权")
        @unknown default:
            break
        }
    }
}

enum LocationError: Error, LocalizedError {
    case permissionDenied
    case serviceDisabled
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "定位权限被拒绝"
        case .serviceDisabled:
            return "定位服务未开启"
        case .timeout:
            return "定位超时"
        }
    }
} 