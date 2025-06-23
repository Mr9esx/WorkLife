import 'dart:convert';

/// 位置信息数据模型
class LocationData {
  final double latitude;    // 纬度
  final double longitude;   // 经度
  final double? altitude;   // 海拔（可选）
  final double? accuracy;   // 精度（可选）
  final String? address;    // 地址信息（可选）
  final String? city;       // 城市（可选）
  final String? province;   // 省份（可选）
  final String? country;    // 国家（可选）
  final DateTime timestamp; // 获取时间

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    this.address,
    this.city,
    this.province,
    this.country,
    required this.timestamp,
  });

  /// 从JSON字符串创建LocationData
  factory LocationData.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return LocationData.fromMap(json);
  }

  /// 从Map创建LocationData
  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      altitude: map['altitude'] != null ? (map['altitude'] as num).toDouble() : null,
      accuracy: map['accuracy'] != null ? (map['accuracy'] as num).toDouble() : null,
      address: map['address'] as String?,
      city: map['city'] as String?,
      province: map['province'] as String?,
      country: map['country'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  /// 转换为JSON字符串
  String toJson() {
    return jsonEncode(toMap());
  }

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'accuracy': accuracy,
      'address': address,
      'city': city,
      'province': province,
      'country': country,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// 获取简短的地址描述
  String get shortAddress {
    if (address != null && address!.isNotEmpty) {
      return address!;
    }
    
    List<String> parts = [];
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (province != null && province!.isNotEmpty) parts.add(province!);
    
    return parts.isEmpty ? '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}' : parts.join(', ');
  }

  /// 获取完整的地址描述
  String get fullAddress {
    List<String> parts = [];
    if (country != null && country!.isNotEmpty) parts.add(country!);
    if (province != null && province!.isNotEmpty) parts.add(province!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (address != null && address!.isNotEmpty) parts.add(address!);
    
    return parts.isEmpty ? '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}' : parts.join(' ');
  }

  /// 检查位置是否有效
  bool get isValid {
    return latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180;
  }

  @override
  String toString() {
    return 'LocationData(lat: $latitude, lng: $longitude, address: $shortAddress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationData &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.altitude == altitude &&
        other.accuracy == accuracy &&
        other.address == address &&
        other.city == city &&
        other.province == province &&
        other.country == country &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(
      latitude,
      longitude,
      altitude,
      accuracy,
      address,
      city,
      province,
      country,
      timestamp,
    );
  }

  LocationData copyWith({
    double? latitude,
    double? longitude,
    double? altitude,
    double? accuracy,
    String? address,
    String? city,
    String? province,
    String? country,
    DateTime? timestamp,
  }) {
    return LocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      accuracy: accuracy ?? this.accuracy,
      address: address ?? this.address,
      city: city ?? this.city,
      province: province ?? this.province,
      country: country ?? this.country,
      timestamp: timestamp ?? this.timestamp,
    );
  }
} 