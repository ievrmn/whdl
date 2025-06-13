import 'package:flutter/material.dart';
import 'chat_room_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/klf.png', width: 150),
            const SizedBox(height: 40),
            const TextField(
              decoration: InputDecoration(
                hintText: 'البريد الإلكتروني',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'كلمة المرور',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatRoomScreen()),
                );
              },
              child: const Text('تسجيل الدخول'),
            ),

            const SizedBox(height: 16),

            // زر إنشاء حساب جديد
            TextButton(
              onPressed: () {
                // هنا ممكن تضيف التنقل إلى صفحة إنشاء حساب
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الانتقال إلى صفحة إنشاء حساب')),
                );
              },
              child: const Text(
                'إنشاء حساب جديد',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}