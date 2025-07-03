import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabary/domain/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _usersCollection => _firestore.collection('users');

  Future<void> saveUser(UserModel user) async {
    await _usersCollection
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true));
  }

  Future<UserModel?> getUserById(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<void> createUserDocIfNotExists(User user) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'email': user.email,
        'name': user.displayName ?? '',
        'id': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
