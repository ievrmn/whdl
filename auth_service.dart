import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // تسجيل حساب جديد مع تخزين بيانات إضافية
  Future<User?> signUp({
    required String email,
    required String password,
    required String username,
    required String userCode,
  }) async {
    try {
      // إنشاء حساب في Firebase Authentication
      UserCredential result =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // حفظ بيانات إضافية في Firestore تحت مجموعة "users"
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'userCode': userCode,
          'email': email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      print('Error in signUp: $e');
      return null;
    }
  }

  // تسجيل الدخول
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print('Error in signIn: $e');
      return null;
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // جلب بيانات المستخدم من Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // مراقبة تغير حالة المستخدم (تسجيل دخول/خروج)
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}