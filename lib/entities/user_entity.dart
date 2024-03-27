class UserEntity {
  String userId;
  String username;
  String ongoingGame;
  int profileIndex;
  List<dynamic> achievements; // int

  UserEntity(
      {required this.userId,
      required this.username,
      required this.ongoingGame,
      required this.profileIndex,
      required this.achievements});

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      userId: map['userId'] as String,
      username: map['username'] as String,
      ongoingGame: map['ongoingGame'],
      profileIndex: map['profileIndex'] as int,
      achievements: map['achievements'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'ongoingGame': ongoingGame,
      'profileIndex': profileIndex,
      'achievements': achievements,
    };
  }
}
