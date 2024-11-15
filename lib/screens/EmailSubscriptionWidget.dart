import 'package:flutter/material.dart';
import 'package:weatherapp/main.dart';

class EmailSubscriptionWidget extends StatefulWidget {
  @override
  _EmailSubscriptionWidgetState createState() => _EmailSubscriptionWidgetState();
}

class _EmailSubscriptionWidgetState extends State<EmailSubscriptionWidget> {
  final TextEditingController _emailController = TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký nhận thông tin thời tiết'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Nhập địa chỉ email',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _subscribe,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _subscribe() {
    String email = _emailController.text;

    if (email.isNotEmpty) {
      // Lưu email vào Firestore
      saveEmailToFirestore(email);
      // Gửi email xác nhận
      sendConfirmationEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã gửi email xác nhận!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập email!")),
      );
    }
  }
}
