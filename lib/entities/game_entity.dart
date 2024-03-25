//TODO: complete this
class GameEntity {
  final String gameId;

  GameEntity({required this.gameId});

  factory GameEntity.fromMap(Map<String, dynamic> map) {
    return GameEntity(
      gameId: map['gameId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
    };
  }
}
