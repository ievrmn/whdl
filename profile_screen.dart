import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userBio;
  final String userAvatarUrl;
  final int userCoins;

  UserProfileScreen({
    required this.userId,
    required this.userName,
    required this.userBio,
    required this.userAvatarUrl,
    required this.userCoins,
  });

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late String avatarUrl;
  late int coins;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _bioController = TextEditingController(text: widget.userBio);
    avatarUrl = widget.userAvatarUrl;
    coins = widget.userCoins;
  }

  // محاكاة تغيير الصورة (عادة تفتح المعرض أو الكاميرا)
  void changeAvatar() {
    // هنا تضع كود اختيار صورة من الجهاز أو تحميلها
    setState(() {
      avatarUrl = 'https://via.placeholder.com/150'; // رابط صورة جديدة مؤقتة
    });
  }

  // حفظ التعديلات (اسم و نبذة)
  void saveProfile() {
    // ارسل البيانات للسيرفر هنا
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم حفظ التعديلات')),
    );
  }

  // إرسال هدية لمستخدم آخر
  void sendGift(String giftName) {
    // تأكد أن لديك عملات كافية ثم ارسل الهدية
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إرسال $giftName كهدية')),
    );
  }

  // إرسال طلب صداقة
  void sendFriendRequest() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إرسال طلب صداقة')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ملف المستخدم'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveProfile,
            tooltip: 'حفظ التعديلات',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: changeAvatar,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(avatarUrl),
              ),
            ),
            SizedBox(height: 12),
            Text('ID المستخدم: ${widget.userId}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'اسم المستخدم',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'نبذة تعريفية',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('رصيد العملات: $coins عملة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 20),

            // زر ارسال طلب صداقة
            ElevatedButton.icon(
              icon: Icon(Icons.person_add),
              label: Text('إرسال طلب صداقة'),
              onPressed: sendFriendRequest,
            ),

            SizedBox(height: 20),
            Text('إرسال هدية:', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => sendGift('وردة 🌹'),
                  child: Text('وردة 🌹'),
                ),
                ElevatedButton(
                  onPressed: () => sendGift('أسد 🦁'),
                  child: Text('أسد 🦁'),
                ),
                ElevatedButton(
                  onPressed: () => sendGift('كنغر 🦘'),
                  child: Text('كنغر 🦘'),
                ),
                ElevatedButton(
                  onPressed: () => sendGift('سيارة 🚗'),
                  child: Text('سيارة 🚗'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}