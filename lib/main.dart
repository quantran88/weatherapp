
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:weatherapp/screens/weatherscreen.dart';



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


Future<void> sendEmail(String recipient, String subject, String body) async {
  final Email email = Email(
    body: body,
    subject: subject,
    recipients: [recipient],
    isHTML: false,  
  );

  try {
    await FlutterEmailSender.send(email);
  } catch (error) {
    print("Error sending email: $error");
  }
}

Future<void> sendConfirmationEmail(String userEmail) async {
  String subject = "Xác nhận đăng ký nhận dự báo thời tiết";
  String body = "Chào bạn, Cảm ơn bạn đã đăng ký nhận thông tin dự báo thời tiết qua email. Bạn sẽ nhận được thông báo vào mỗi ngày.";

  await sendEmail(userEmail, subject, body);
}



Future<void> saveEmailToFirestore(String email) async {
  FirebaseFirestore.instance.collection('subscribers').add({
    'email': email,
    'timestamp': FieldValue.serverTimestamp(),
  });
}


