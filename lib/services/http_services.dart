import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'ebf5554477f3420f92890327241411';
  final String baseUrl = 'http://api.weatherapi.com/v1';

  Future<Map<String, dynamic>> fetchWeather(String location) async {
    final response = await http.get(Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$location&days=5'));
    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print('Failed to load weather data. Status code: ${response.statusCode}');
      throw Exception('Failed to load weather data');
    }
  }
}
