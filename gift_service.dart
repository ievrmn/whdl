import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class GiftService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userCollection = 'users';
  final String giftsCollection = 'gifts';

  final Uuid uuid = Uuid();

  // إرسال هدية من المستخدم senderId إلى receiverId (مستخدم أو روم)
  Future<bool> sendGift({
    required String senderId,
    required String receiverId,
    required String giftType,
    required int giftValue,
  }) async {
    try {
      final senderRef = _firestore.collection(userCollection).doc(senderId);
      final receiverRef = _firestore.collection(userCollection).doc(receiverId);

      // تحقق من رصيد المرسل أولاً
      final senderSnapshot = await senderRef.get();
      int senderBalance = senderSnapshot.data()?['balance'] ?? 0;

      if (senderBalance < giftValue) {
        print('رصيد غير كافٍ لإرسال الهدية');
        return false;
      }

      // تحديث رصيد المرسل (خصم قيمة الهدية)
      await senderRef.update({'balance': senderBalance - giftValue});

      // إضافة سجل الهدية
      final giftId = uuid.v4();
      await _firestore.collection(giftsCollection).doc(giftId).set({
        'giftId': giftId,
        'senderId': senderId,
        'receiverId': receiverId,
        'giftType': giftType,
        'giftValue': giftValue,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // يمكن إضافة منطق إرسال إشعار للمتلقي هنا

      return true;
    } catch (e) {
      print('Error sending gift: $e');
      return false;
    }
  }

  // جلب الهدايا المستلمة لمستخدم معين
  Stream<List<Gift>> getReceivedGifts(String receiverId) {
    return _firestore
        .collection(giftsCollection)
        .where('receiverId', isEqualTo: receiverId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Gift.fromMap(doc.data())).toList());
  }
}