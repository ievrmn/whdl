import 'package:flutter/material.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/room.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'غرفة الدردشة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: const [
                      GiftItem(image: 'car.png', name: 'سيارة'),
                      GiftItem(image: 'kiker.png', name: 'كنغر'),
                      GiftItem(image: 'lion.png', name: 'أسد'),
                      GiftItem(image: 'werd.png', name: 'وردة'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GiftItem extends StatelessWidget {
  final String image;
  final String name;

  const GiftItem({
    super.key,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('🎁 أرسلت هدية: $name')),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 80,
        child: Column(
          children: [
            Expanded(
              child: Image.asset('assets/images/$image'),
            ),
            Text(name, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}