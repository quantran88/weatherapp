import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/screens/EmailSubscriptionWidget.dart';


class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}
const TextStyle headlineStyle = TextStyle(color: Colors.white);
class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  Future<Map<String, dynamic>>? _futureWeatherData;
  

  Future<Map<String, dynamic>> fetchWeather(String location) async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateTime.now().toIso8601String().split('T')[0]; // lấy ngày hiện tại (YYYY-MM-DD)

    // Kiểm tra xem dữ liệu thời tiết đã có trong local storage chưa
    final String? cachedWeather = prefs.getString('$location-$today');
    if (cachedWeather != null) {
      // Nếu có, trả về dữ liệu từ local storage
      return json.decode(cachedWeather);
    }

    // Nếu không có, gọi API để lấy dữ liệu
    final String apiKey = 'ebf5554477f3420f92890327241411';
    final String baseUrl = 'https://api.weatherapi.com/v1';
    final response = await http.get(Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$location&days=5'));
  
    if (response.statusCode == 200) {
      // Lưu dữ liệu vào local storage
      await prefs.setString('$location-$today', response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
  
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.blue[50],
    appBar: AppBar(
      title: const Text('Weather Dashboard', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
      backgroundColor: Colors.blue[500],
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(42.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter a City Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 350,
                      height: 35,
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'E.g., New York, London, Tokyo',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 350,
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _futureWeatherData = fetchWeather(_controller.text);
                          });
                        },
                        child: Text('Search'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 350,
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () {
                            // Thêm hành động khi nhấn nút mới này
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EmailSubscriptionWidget()),
                            );
                          },
                          child: Text('Sign up to receive information'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green[500],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(width: 20), 
            Expanded(
              flex: 3,
              child: _futureWeatherData == null
                  ? Text('')
                  : FutureBuilder<Map<String, dynamic>>(
                      future: _futureWeatherData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final weatherData = snapshot.data!;
                          return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,                             
                                    children: [       
                                    Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                      color: Colors.blue[500],
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                padding: EdgeInsets.all(16.0),
                                 child: Row( 
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded( 
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${weatherData['location']['name']} (${weatherData['forecast']['forecastday'][0]['date']})',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                          Text('Temperature: ${weatherData['current']['temp_c']} °C', style: headlineStyle),
                                          Text('Wind Speed: ${weatherData['current']['wind_kph']} kph', style: headlineStyle),
                                          Text('Humidity: ${weatherData['current']['humidity']} %', style: headlineStyle),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10), 
                                      Column(
                                        children: [
                                          Image.network(
                                            'https:${weatherData['current']['condition']['icon']}',                              
                                            fit: BoxFit.cover,
                                          ),
                                          Text( '${weatherData['current']['condition']['text']}',style: headlineStyle,)
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                    '4-Day Forecast',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  for (var day in weatherData['forecast']['forecastday'].take(4))
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Container(
                                          width: 100,
                                          height: 230,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[500],
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '(${day['date']})',
                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),
                                              ),
                                              Image.network(
                                                'https:${day['day']['condition']['icon']}',
                                                height: 40, 
                                                width: 40,  
                                                fit: BoxFit.cover,
                                              ),
                                              Text('Max Temp: ${day['day']['maxtemp_c']} °C',style: headlineStyle,),
                                              Text('Min Temp: ${day['day']['mintemp_c']} °C',style: headlineStyle,),
                                              Text('Humidity: ${day['day']['avghumidity']} %',style: headlineStyle,),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Text('No data available');
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}
}