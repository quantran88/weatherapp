
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:weatherapp/screens/weather_screen.dart';




void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb) {
    await Firebase.initializeApp(options: const 
    FirebaseOptions(apiKey: "AIzaSyAy3cGNYBLjntS0QWJF453sZcGsvHVde88",
    authDomain: "weather-72160.firebaseapp.com",
    projectId: "weather-72160",
    storageBucket: "weather-72160.firebasestorage.app",
    messagingSenderId: "326715297447",
    appId: "1:326715297447:web:b1d6d1c713d900b6311582"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ẩn banner debug
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tùy chỉnh màu chủ đạo của ứng dụng
      ),
      home: WeatherScreen(), // Màn hình chính là WeatherScreen
    );
  }
}






