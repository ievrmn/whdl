import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> rooms = [
    {'name': 'روم النجوم', 'image': 'assets/images/star_room.png'},
    {'name': 'الدردشة العامة', 'image': 'assets/images/chat_room.png'},
  ];

  final List<String> privateChats = [
    'أحمد',
    'سارة',
    'محمد',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KitKat Live'),
      ),
      body: _currentIndex == 0 ? _buildRoomsList() : _buildPrivateChatsList(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'الرومات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'الدردشة الخاصة',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _showCreateRoomDialog(context);
              },
              tooltip: 'إنشاء روم جديد',
            )
          : null,
    );
  }

  Widget _buildRoomsList() {
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.asset(rooms[index]['image']!),
          title: Text(rooms[index]['name']!),
          onTap: () {
            Navigator.pushNamed(context, '/room');
          },
        );
      },
    );
  }

  Widget _buildPrivateChatsList() {
    return ListView.builder(
      itemCount: privateChats.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Text(privateChats[index][0])),
          title: Text(privateChats[index]),
          onTap: () {
            // افتح المحادثة الخاصة مع هذا الصديق
          },
        );
      },
    );
  }

  void _showCreateRoomDialog(BuildContext context) {
    final TextEditingController _roomNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('إنشاء روم جديد'),
        content: TextField(
          controller: _roomNameController,
          decoration: InputDecoration(hintText: 'أدخل اسم الغرفة'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final newRoomName = _roomNameController.text.trim();
              if (newRoomName.isNotEmpty) {
                setState(() {
                  rooms.add({'name': newRoomName, 'image': 'assets/images/default_room.png'});
                });
                Navigator.pop(context);
              }
            },
            child: Text('إنشاء'),
          ),
        ],
      ),
    );
  }
}