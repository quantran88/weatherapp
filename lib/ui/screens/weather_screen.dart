import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/data/weather/day.dart';
import 'package:weatherapp/data/weather/weather.dart';
import 'package:weatherapp/ui/provider/weather_provider.dart';
import 'package:weatherapp/ui/screens/email_sub_screen.dart';


class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}
const TextStyle headlineStyle = TextStyle(color: Colors.white);
class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  Future<Weather>? _futureWeatherData; 

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
                            final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
                            setState(() {
                            _futureWeatherData = weatherProvider.fetchWeather(_controller.text);
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
                      child: ElevatedButton (
                        onPressed: () async {
                          final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
                            String location = await weatherProvider.getCurrentLocation(); // Gọi hàm từ Provider
                            setState(() {
                              _futureWeatherData = weatherProvider.fetchWeather(location);
                            });
                        },
                        child: Text('Use Current Location'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.grey[500],
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
                  : FutureBuilder<Weather>(
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
                                            '${weatherData.location?.name} (${weatherData.forecast?.forecastday?[0].date})',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                          Text('Temperature: ${weatherData.current?.tempC} °C', style: headlineStyle),
                                          Text('Wind Speed: ${weatherData.current?.windKph} kph', style: headlineStyle),
                                          Text('Humidity: ${weatherData.current?.humidity} %', style: headlineStyle),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10), 
                                      Column(
                                        children: [
                                          Image.network(
                                            'https:${weatherData.current?.condition?.icon}',                              
                                            fit: BoxFit.cover,
                                          ),
                                          Text( '${weatherData.current?.condition?.text}',style: headlineStyle,)
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
                                  for (var day in weatherData.forecast?.forecastday?.take(4) ?? [])
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
                                                '(${day.date ?? 'No Date'})',
                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),
                                              ),
                                              Image.network(
                                                'https:${day.day?.condition?.icon}',
                                                height: 40, 
                                                width: 40,  
                                                fit: BoxFit.cover,
                                              ),
                                              Text('Max Temp: ${day.day?.maxtempC} °C',style: headlineStyle,),
                                              Text('Min Temp: ${day.day?.mintempC} °C',style: headlineStyle,),
                                              Text('Humidity: ${day.day?.avghumidity} %',style: headlineStyle,),
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
