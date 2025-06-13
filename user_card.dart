import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String userId;
  final String userName;
  final String userImage; // رابط صورة المستخدم أو من assets
  final bool isMuted;
  final bool isModerator;
  final bool canControl; // هل يمكنني التحكم في هذا المستخدم (كتم/طرد)
  final VoidCallback? onMuteToggle;
  final VoidCallback? onKick;

  const UserCard({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userImage,
    this.isMuted = false,
    this.isModerator = false,
    this.canControl = false,
    this.onMuteToggle,
    this.onKick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(userImage),
        ),
        title: Row(
          children: [
            Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
            if (isModerator)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Icon(Icons.shield, color: Colors.blue, size: 18),
              ),
          ],
        ),
        subtitle: Text(isMuted ? 'الميكروفون مكتوم' : 'الميكروفون مفتوح'),
        trailing: canControl
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isMuted ? Icons.mic_off : Icons.mic,
                      color: isMuted ? Colors.red : Colors.green,
                    ),
                    onPressed: onMuteToggle,
                    tooltip: isMuted ? 'تشغيل الميكروفون' : 'كتم الميكروفون',
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: onKick,
                    tooltip: 'طرد المستخدم',
                  ),
                ],
              )
            : null,
      ),
    );
  }
}