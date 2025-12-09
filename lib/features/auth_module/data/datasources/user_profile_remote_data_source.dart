import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/entities/user_profile_entity.dart';

abstract class UserProfileRemoteDataSource {
  Future<void> createUserProfile(UserProfileEntity user);
  Future<UserProfileEntity> getUserProfile(String uid);
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  UserProfileRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> createUserProfile(UserProfileEntity user) async {
    await firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'name': user.name,
      'role': user.role,
      // 🔹 field tambahan
      'photoUrl': user.photoUrl,
      'dob': user.dob,
      'gender': user.gender,
      'jobStatus': user.jobStatus,
      'address': user.address,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // merge = bisa dipakai sebagai "update"
  }

  @override
  Future<UserProfileEntity> getUserProfile(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception('User profile not found for uid: $uid');
    }

    final data = doc.data()!;
    return UserProfileEntity(
      uid: data['uid'] as String,
      email: data['email'] as String,
      name: data['name'] as String?,
      role: (data['role'] as String?) ?? 'student',
      // 🔹 baca field tambahan (boleh null)
      photoUrl: data['photoUrl'] as String?,
      dob: data['dob'] as String?,
      gender: data['gender'] as String?,
      jobStatus: data['jobStatus'] as String?,
      address: data['address'] as String?,
    );
  }
}
