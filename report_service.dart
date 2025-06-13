import 'package:cloud_firestore/cloud_firestore.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String reportsCollection = 'reports';

  // إرسال بلاغ جديد
  Future<void> sendReport({
    required String reporterId,
    required String reportedUserId,
    required String description,
  }) async {
    await _firestore.collection(reportsCollection).add({
      'reporterId': reporterId,
      'reportedUserId': reportedUserId,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'resolved': false,
    });
  }

  // جلب جميع البلاغات (للمطور/المشرف)
  Stream<List<Report>> getReportsStream() {
    return _firestore
        .collection(reportsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Report.fromMap(doc.id, doc.data()))
            .toList());
  }

  // تحديث حالة البلاغ (مثلاً جعله محلول)
  Future<void> updateReportStatus(String reportId, bool resolved) async {
    await _firestore
        .collection(reportsCollection)
        .doc(reportId)
        .update({'resolved': resolved});
  }
}