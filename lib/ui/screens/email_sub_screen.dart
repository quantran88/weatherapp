import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailSubscriptionWidget extends StatefulWidget {
  @override
  _EmailSubscriptionWidgetState createState() =>
      _EmailSubscriptionWidgetState();
}

class _EmailSubscriptionWidgetState extends State<EmailSubscriptionWidget> {
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;

  void _subscribeEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Email không được để trống';
      });
      return;
    }
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _errorMessage = 'Email không hợp lệ';
      });
      return;
    }
    setState(() {
      _errorMessage = null;
    });
    sendConfirmationEmail(email).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Đã gửi yêu cầu xác nhận tới email của bạn!'),
      ));
    }).catchError((e) {
      // Nếu có lỗi khi gửi email
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gửi email thất bại: $e'),
      ));
    });
  }

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
                    onPressed: _subscribeEmail,
                  ),
                  errorText: _errorMessage,
                ),
              ),
            ],
          ),
        ),
      ),
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
  String body =
      "Chào bạn, Cảm ơn bạn đã đăng ký nhận thông tin dự báo thời tiết qua email. Bạn sẽ nhận được thông báo vào mỗi ngày.";

  await sendEmail(userEmail, subject, body);
}

Future<void> saveEmailToFirestore(String email) async {
  FirebaseFirestore.instance.collection('subscribers').add({
    'email': email,
    'timestamp': FieldValue.serverTimestamp(),
  });
}
