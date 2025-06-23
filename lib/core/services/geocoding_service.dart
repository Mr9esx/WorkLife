import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// 地址解析服务
/// 使用高德地图API进行反向地理编码（坐标转地址）
class GeocodingService {
  static final GeocodingService _instance = GeocodingService._internal();
  factory GeocodingService() => _instance;
  GeocodingService._internal();

  // 高德地图API密钥 - 您需要申请一个免费的高德地图API Key
  // 申请地址：https://console.amap.com/dev/key/app
  static const String _apiKey = 'YOUR_AMAP_API_KEY'; // 请替换为您的API Key

  // 高德地图逆地理编码API
  static const String _baseUrl = 'https://restapi.amap.com/v3/geocode/regeo';

  /// 根据坐标获取地址信息
  /// [latitude] 纬度
  /// [longitude] 经度
  /// 返回详细地址字符串，如"广东省广州市天河区xx街道"
  Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    if (_apiKey == 'YOUR_AMAP_API_KEY') {
      debugPrint('⚠️ GeocodingService: 请先配置高德地图API Key');
      return _getMockAddress(latitude, longitude);
    }

    try {
      debugPrint('🌍 GeocodingService: 开始地址解析 ($latitude, $longitude)');

      // 构建请求URL
      final url = Uri.parse('$_baseUrl?location=$longitude,$latitude&key=$_apiKey&radius=1000&extensions=all');

      // 发送HTTP请求
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == '1' && data['regeocode'] != null) {
          final regeocode = data['regeocode'];

          // 获取格式化地址
          String? formattedAddress = regeocode['formatted_address'];

          // 如果有详细地址信息，拼接更完整的地址
          if (regeocode['addressComponent'] != null) {
            final addressComponent = regeocode['addressComponent'];
            final province = addressComponent['province'] ?? '';
            final city = addressComponent['city'] ?? '';
            final district = addressComponent['district'] ?? '';
            final township = addressComponent['township'] ?? '';
            final streetNumber = regeocode['addressComponent']['streetNumber'] ?? {};
            final street = streetNumber['street'] ?? '';
            final number = streetNumber['number'] ?? '';

            // 拼接详细地址
            String detailedAddress = '';
            if (province.isNotEmpty) detailedAddress += province;
            if (city.isNotEmpty && city != province) detailedAddress += city;
            if (district.isNotEmpty) detailedAddress += district;
            if (township.isNotEmpty) detailedAddress += township;
            if (street.isNotEmpty) detailedAddress += street;
            if (number.isNotEmpty) detailedAddress += number;

            if (detailedAddress.isNotEmpty) {
              formattedAddress = detailedAddress;
            }
          }

          debugPrint('✅ GeocodingService: 地址解析成功 - $formattedAddress');
          return formattedAddress;
        } else {
          debugPrint('❌ GeocodingService: API返回错误 - ${data['info']}');
          return null;
        }
      } else {
        debugPrint('❌ GeocodingService: HTTP请求失败 - ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ GeocodingService: 地址解析异常 - $e');
      return null;
    }
  }

  /// 模拟地址数据（用于演示）
  String? _getMockAddress(double latitude, double longitude) {
    debugPrint('🎭 GeocodingService: 使用模拟地址数据');

    // 根据坐标范围返回模拟地址
    if (latitude >= 22.0 && latitude <= 25.0 && longitude >= 113.0 && longitude <= 115.0) {
      return '广东省广州市天河区珠江新城花城大道';
    } else if (latitude >= 39.0 && latitude <= 41.0 && longitude >= 116.0 && longitude <= 117.0) {
      return '北京市朝阳区建国门外大街';
    } else if (latitude >= 31.0 && latitude <= 32.0 && longitude >= 121.0 && longitude <= 122.0) {
      return '上海市浦东新区陆家嘴环路';
    } else if (latitude >= 30.0 && latitude <= 31.0 && longitude >= 120.0 && longitude <= 121.0) {
      return '浙江省杭州市西湖区文三路';
    } else if (latitude >= 37.7 && latitude <= 37.8 && longitude >= -122.5 && longitude <= -122.4) {
      return '美国加利福尼亚州旧金山市联合广场'; // iOS模拟器默认位置
    } else {
      return '位置信息解析中...';
    }
  }

  /// 批量地址解析
  Future<List<String?>> batchGetAddresses(List<Map<String, double>> coordinates) async {
    List<String?> addresses = [];

    for (var coord in coordinates) {
      final address = await getAddressFromCoordinates(coord['latitude']!, coord['longitude']!);
      addresses.add(address);

      // 避免API调用过于频繁
      await Future.delayed(const Duration(milliseconds: 200));
    }

    return addresses;
  }
}

/// 地址信息类
class AddressInfo {
  final String? formattedAddress;
  final String? province;
  final String? city;
  final String? district;
  final String? township;
  final String? street;
  final String? number;

  AddressInfo({
    this.formattedAddress,
    this.province,
    this.city,
    this.district,
    this.township,
    this.street,
    this.number,
  });

  @override
  String toString() {
    return formattedAddress ?? '未知地址';
  }
}
