import 'package:cloud_firestore/cloud_firestore.dart';

class RoomController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // مسار الغرفة في Firestore
  final String roomId;

  RoomController({required this.roomId});

  // جلب بيانات المستخدمين في الغرفة (Realtime)
  Stream<List<RoomUser>> getUsersStream() {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RoomUser.fromMap(doc.data()))
            .toList());
  }

  // تفعيل/تعطيل المايك للمستخدم (بواسطة المشرف)
  Future<void> toggleMicForUser(String userId, bool enable) async {
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('users')
        .doc(userId)
        .update({'micEnabled': enable});
  }

  // كتم المستخدم (يتم تعطيل المايك ويمنع التحدث)
  Future<void> muteUser(String userId, bool mute) async {
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('users')
        .doc(userId)
        .update({'isMutedByAdmin': mute, 'micEnabled': !mute});
  }

  // رفع مستخدم إلى مشرف
  Future<void> promoteToAdmin(String userId) async {
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('users')
        .doc(userId)
        .update({'isAdmin': true});
  }

  // تنزيل مشرف إلى مستخدم عادي
  Future<void> demoteAdmin(String userId) async {
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('users')
        .doc(userId)
        .update({'isAdmin': false});
  }

  // طرد مستخدم من الغرفة (حذف مستند المستخدم)
  Future<void> kickUser(String userId) async {
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('users')
        .doc(userId)
        .delete();
  }

  // المشرف يمكنه فتح/قفل المايك لجميع الأعضاء
  Future<void> toggleMicForAll(bool enable) async {
    final usersSnapshot = await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('users')
        .get();

    for (var doc in usersSnapshot.docs) {
      await doc.reference.update({'micEnabled': enable});
    }
  }
}