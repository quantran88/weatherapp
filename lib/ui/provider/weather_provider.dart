import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/data/weather/weather.dart';
import 'package:weatherapp/data/weather_repository.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _weatherRepository;

  WeatherProvider(this._weatherRepository);

  Future<Weather> fetchWeather(String location) async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateTime.now().toIso8601String().split('T')[0]; 

    // Kiểm tra xem dữ liệu thời tiết đã có trong local storage chưa
    final String? cachedWeather = prefs.getString('$location-$today');
    if (cachedWeather != null) {
      // Nếu có, trả về dữ liệu từ local storage, giải mã thành đối tượng Weather
      return Weather.fromJson(json.decode(cachedWeather));
    }

    // Nếu không có, gọi hàm fetchWeather từ repository
    try {
      Weather weather = await _weatherRepository.fetchWeather(location);
      // Lưu dữ liệu vào local storage
      await prefs.setString('$location-$today', json.encode(weather));
      return weather;
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled.';
    }
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
