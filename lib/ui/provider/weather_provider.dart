import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/data/weather/weather.dart';

class WeatherProvider extends ChangeNotifier {
  Future<Weather> fetchWeather(String location) async {
  final prefs = await SharedPreferences.getInstance();
  final String today = DateTime.now()
      .toIso8601String()
      .split('T')[0]; // lấy ngày hiện tại (YYYY-MM-DD)
  
  // Kiểm tra xem dữ liệu thời tiết đã có trong local storage chưa
  final String? cachedWeather = prefs.getString('$location-$today');
  if (cachedWeather != null) {
    // Nếu có, trả về dữ liệu từ local storage, giải mã thành đối tượng Weather
    return Weather.fromJson(json.decode(cachedWeather));
  }
  
  // Nếu không có, gọi API để lấy dữ liệu
  final String apiKey = 'ebf5554477f3420f92890327241411';
  final String baseUrl = 'https://api.weatherapi.com/v1';
  final response = await http.get(
      Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$location&days=5'));

  if (response.statusCode == 200) {
    // Lưu dữ liệu vào local storage
    await prefs.setString('$location-$today', response.body);
    // Trả về dữ liệu từ API đã chuyển thành đối tượng Weather
    return Weather.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load weather data');
  }
}


  Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra xem dịch vụ định vị có bật không
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled.';
    }

    // Kiểm tra quyền truy cập vị trí
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied';
    }

    // Lấy vị trí hiện tại
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return '${position.latitude},${position.longitude}'; // Trả về vị trí dưới dạng "latitude,longitude"
  }
}
