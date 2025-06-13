import 'package:flutter/material.dart';

class RoomTile extends StatelessWidget {
  final String roomId;
  final String roomName;
  final String roomImage; // مسار الصورة داخل assets أو URL
  final int membersCount;
  final VoidCallback onJoin;

  const RoomTile({
    Key? key,
    required this.roomId,
    required this.roomName,
    required this.roomImage,
    this.membersCount = 0,
    required this.onJoin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            roomImage,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          roomName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$membersCount عضو'),
        trailing: ElevatedButton(
          onPressed: onJoin,
          child: Text('انضمام'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onTap: onJoin,
      ),
    );
  }
}