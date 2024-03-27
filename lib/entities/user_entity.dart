class UserEntity {
  String username;
  int profileIndex;
  List<dynamic> achievements; // int

  UserEntity(
      {required this.username,
      required this.profileIndex,
      required this.achievements});

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      username: map['username'] as String,
      profileIndex: map['profileIndex'] as int,
      achievements: map['achievements'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'profileIndex': profileIndex,
      'achievements': achievements,
    };
  }
}
