import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VoiceRoomScreen extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String currentUserId;
  final bool isCurrentUserAdmin;

  VoiceRoomScreen({
    required this.roomId,
    required this.roomName,
    required this.currentUserId,
    this.isCurrentUserAdmin = false,
  });

  @override
  _VoiceRoomScreenState createState() => _VoiceRoomScreenState();
}

class User {
  final String id;
  final String name;
  bool isMuted;
  bool isAdmin;
  bool micEnabled;

  User({
    required this.id,
    required this.name,
    this.isMuted = false,
    this.isAdmin = false,
    this.micEnabled = true,
  });
}

class _VoiceRoomScreenState extends State<VoiceRoomScreen> {
  List<User> users = [];
  bool roomMicLocked = false;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  @override
  void initState() {
    super.initState();
    initUsers();
    initWebRTC();
  }

  void initUsers() {
    users = List.generate(15, (index) {
      return User(
        id: 'user$index',
        name: 'مستخدم $index',
        isAdmin: index == 0,
      );
    });
  }

  Future<void> initWebRTC() async {
    final configuration = <String, dynamic>{
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'},
      ]
    };

    _peerConnection =
        await createPeerConnection(configuration, {});

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });

    _localStream?.getAudioTracks()[0].enabled = !roomMicLocked;

    _peerConnection?.addStream(_localStream!);

    // هنا يجب تكملة التواصل مع سيرفر الإشارات (signaling) لمزامنة الاتصالات
  }

  bool get isAdmin {
    return widget.isCurrentUserAdmin ||
        users.any((u) => u.id == widget.currentUserId && u.isAdmin);
  }

  void toggleMute(User user) {
    if (!isAdmin && user.id != widget.currentUserId) return;
    setState(() {
      user.isMuted = !user.isMuted;
      if (user.id == widget.currentUserId) {
        _localStream?.getAudioTracks()[0].enabled = !user.isMuted;
      }
    });
  }

  void toggleMicLock() {
    if (!isAdmin) return;
    setState(() {
      roomMicLocked = !roomMicLocked;
      if (roomMicLocked) {
        for (var user in users) {
          if (!user.isAdmin) user.micEnabled = false;
        }
        if (widget.currentUserId == users[0].id) {
          _localStream?.getAudioTracks()[0].enabled = !roomMicLocked;
        }
      } else {
        for (var user in users) {
          user.micEnabled = true;
          user.isMuted = false;
        }
        _localStream?.getAudioTracks()[0].enabled = true;
      }
    });
  }

  void toggleAdmin(User user) {
    if (!isAdmin) return;
    setState(() {
      user.isAdmin = !user.isAdmin;
      if (!user.isAdmin) {
        user.micEnabled = true;
        user.isMuted = false;
      }
    });
  }

  void kickUser(User user) {
    if (!isAdmin) return;
    if (user.id == widget.currentUserId) return;
    setState(() {
      users.removeWhere((u) => u.id == user.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${user.name} تم طرده من الغرفة')),
    );
  }

  void leaveRoom() {
    _localStream?.dispose();
    _peerConnection?.close();
    Navigator.pop(context);
  }

  Widget buildUserTile(User user) {
    bool canControl = isAdmin || user.id == widget.currentUserId;
    return ListTile(
      leading: CircleAvatar(child: Text(user.name.substring(0, 1))),
      title: Text(user.name),
      subtitle: Text(user.isAdmin ? 'مشرف' : 'عضو'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canControl)
            IconButton(
              icon: Icon(user.isMuted ? Icons.mic_off : Icons.mic,
                  color: user.isMuted ? Colors.red : Colors.green),
              tooltip: user.isMuted ? 'فك كتم' : 'كتم',
              onPressed: () => toggleMute(user),
            ),
          if (isAdmin && user.id != widget.currentUserId)
            IconButton(
              icon: Icon(
                  user.isAdmin ? Icons.star : Icons.star_border_outlined,
                  color: user.isAdmin ? Colors.amber : Colors.grey),
              tooltip: user.isAdmin ? 'تنزيل مشرف' : 'رفع مشرف',
              onPressed: () => toggleAdmin(user),
            ),
          if (isAdmin && user.id != widget.currentUserId)
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.red),
              tooltip: 'طرد من الغرفة',
              onPressed: () => kickUser(user),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('غرفة صوتية: ${widget.roomName}'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: Icon(
                roomMicLocked ? Icons.lock : Icons.lock_open,
                color: roomMicLocked ? Colors.red : Colors.white,
              ),
              tooltip: roomMicLocked ? 'فتح المايك للجميع' : 'قفل المايك للجميع',
              onPressed: toggleMicLock,
            ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'خروج من الغرفة',
            onPressed: leaveRoom,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return buildUserTile(users[index]);
        },
      ),
    );
  }
}