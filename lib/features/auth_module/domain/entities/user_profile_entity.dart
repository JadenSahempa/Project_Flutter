class UserProfileEntity {
  final String uid;
  final String email;
  final String? name;
  final String role;
  // 🔹 Tambahan field profil
  final String? photoUrl;
  final String? dob; // simpan string "dd/MM/yyyy" biar simpel
  final String? gender; // 'L' / 'P'
  final String? jobStatus; // 'pelajar', 'karyawan', dst.
  final String? address;

  const UserProfileEntity({
    required this.uid,
    required this.email,
    this.name,
    required this.role,
    this.photoUrl,
    this.dob,
    this.gender,
    this.jobStatus,
    this.address,
  });

  UserProfileEntity copyWith({
    String? name,
    String? photoUrl,
    String? dob,
    String? gender,
    String? jobStatus,
    String? address,
  }) {
    return UserProfileEntity(
      uid: uid,
      email: email,
      role: role,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      jobStatus: jobStatus ?? this.jobStatus,
      address: address ?? this.address,
    );
  }
}
