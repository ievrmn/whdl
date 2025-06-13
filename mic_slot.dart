import 'package:flutter/material.dart';

enum MicStatus { open, muted, locked }

class MicSlotWidget extends StatelessWidget {
  final String userName;
  final String userId;
  final MicStatus micStatus;
  final bool isAdmin; // هل هو مشرف؟
  final VoidCallback? onToggleMute;
  final VoidCallback? onKick;
  final VoidCallback? onMakeAdmin;

  const MicSlotWidget({
    Key? key,
    required this.userName,
    required this.userId,
    required this.micStatus,
    this.isAdmin = false,
    this.onToggleMute,
    this.onKick,
    this.onMakeAdmin,
  }) : super(key: key);

  Color _getMicColor() {
    switch (micStatus) {
      case MicStatus.open:
        return Colors.green;
      case MicStatus.muted:
        return Colors.red;
      case MicStatus.locked:
        return Colors.grey;
    }
  }

  IconData _getMicIcon() {
    switch (micStatus) {
      case MicStatus.open:
        return Icons.mic;
      case MicStatus.muted:
        return Icons.mic_off;
      case MicStatus.locked:
        return Icons.lock;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getMicColor(),
          child: Icon(
            _getMicIcon(),
            color: Colors.white,
          ),
        ),
        title: Text(userName),
        subtitle: Text('ID: $userId'),
        trailing: isAdmin
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'mute') {
                    onToggleMute?.call();
                  } else if (value == 'kick') {
                    onKick?.call();
                  } else if (value == 'admin') {
                    onMakeAdmin?.call();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'mute',
                    child: Text(micStatus == MicStatus.muted ? 'فتح المايك' : 'كتم المايك'),
                  ),
                  PopupMenuItem(
                    value: 'kick',
                    child: Text('طرد المستخدم'),
                  ),
                  PopupMenuItem(
                    value: 'admin',
                    child: Text('رفع/تنزيل مشرف'),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}