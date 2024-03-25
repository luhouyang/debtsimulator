//TODO: complete this
class PlayerEntity {
  final String username;

  PlayerEntity({required this.username});

  factory PlayerEntity.fromMap(Map<String, dynamic> map) {
    return PlayerEntity(
      username: map['username'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
    };
  }
}
