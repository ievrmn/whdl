import 'package:cloud_firestore/cloud_firestore.dart';
import 'room.dart';

class RoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String roomsCollection = 'rooms';

  // إنشاء غرفة جديدة
  Future<String> createRoom({required String name, required String creatorId}) async {
    DocumentReference docRef = await _firestore.collection(roomsCollection).add({
      'name': name,
      'members': [creatorId],
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;  // إرجاع الـ ID الخاص بالغرفة
  }

  // الانضمام لغرفة بواسطة الـ ID
  Future<bool> joinRoom({required String roomId, required String userId}) async {
    DocumentReference docRef = _firestore.collection(roomsCollection).doc(roomId);
    DocumentSnapshot snapshot = await docRef.get();
    if (!snapshot.exists) {
      return false; // الغرفة غير موجودة
    }
    List<dynamic> members = snapshot.get('members');
    if (!members.contains(userId)) {
      members.add(userId);
      await docRef.update({'members': members});
    }
    return true;
  }

  // الحصول على بيانات الغرفة مع تحديثات الأعضاء realtime
  Stream<Room> roomStream(String roomId) {
    return _firestore.collection(roomsCollection).doc(roomId).snapshots().map((snapshot) {
      return Room.fromMap(snapshot.id, snapshot.data()!);
    });
  }
}