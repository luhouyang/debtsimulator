class UserEntity {
  String username;
  int profileIndex;
  List<int> achievements;

  UserEntity({required this.username, required this.profileIndex, required this.achievements});

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      username: map['username'],
      profileIndex: map['profileIndex'],
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
