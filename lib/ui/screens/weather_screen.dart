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
      backgroundColor: Colors.blue[600],
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
                          backgroundColor: Colors.blue[600],
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
                          backgroundColor: Colors.grey[600],
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
                                    print(snapshot.data);
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
                                      color: Colors.blue[600],
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
                                          SizedBox(height: 10),
                                          Text('Temperature: ${weatherData.current?.tempC} °C', style: headlineStyle),
                                          SizedBox(height: 10),
                                          Text('Wind Speed: ${weatherData.current?.windKph} kph', style: headlineStyle),
                                          SizedBox(height: 10),
                                          Text('Humidity: ${weatherData.current?.humidity} %', style: headlineStyle),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10), 
                                      Column(
                                        children: [
                                          Image.network(
                                            'https:${weatherData.current?.condition?.icon}', 
                                            height: 80,
                                            width: 80,                             
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
                              Container(
                              height: 230, 
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal, 
                                itemCount: weatherData.forecast?.forecastday?.take(4).length ?? 0, // Số lượng phần tử
                                itemBuilder: (context, index) {
                                  var forecastDay = weatherData.forecast?.forecastday?[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                      width: 173,                                
                                      decoration: BoxDecoration(
                                        color: Colors.grey[600],
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
                                          Text('(${forecastDay?.date ?? 'No Date'})',style: headlineStyle,),
                                          SizedBox(height: 10),
                                          if (forecastDay?.day?.condition?.icon != null)
                                            Image.network(
                                              'https:${forecastDay?.day?.condition?.icon}',
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          SizedBox(height: 10),
                                          Text('Max Temp: ${forecastDay?.day?.maxtempC ?? 'N/A'} °C',style: headlineStyle,),
                                          SizedBox(height: 10),
                                          Text('Min Temp: ${forecastDay?.day?.mintempC ?? 'N/A'} °C',style: headlineStyle,),
                                          SizedBox(height: 10),
                                          Text('Humidity: ${forecastDay?.day?.avghumidity ?? 'N/A'} %',style: headlineStyle,),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
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
