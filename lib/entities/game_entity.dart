//TODO: complete this
class GameEntity {
  int maxPlayer = 4;

  final String gameId;
  bool gameStatus;  // 0 (not yet), 1 (started)
  int numPlayer;
  List<Map<String, dynamic>> playerList;

  GameEntity(
      {required this.gameId,
      required this.gameStatus,
      required this.numPlayer,
      required this.playerList});

  factory GameEntity.fromMap(Map<String, dynamic> map) {
    return GameEntity(
      gameId: map['gameId'] as String,
      gameStatus: map['gameStatus'] as bool,
      numPlayer: map['numPlayer'] as int,
      playerList: map['playerList']
      /*List.from(
          (gMap['playerList'] as List<Map<String, dynamic>>).map((playerData) {
        PlayerEntity.fromMap(playerData);
      })),*/
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'gameStatus': gameStatus,
      'numPlayer': numPlayer,
      'playerList': playerList,
    };
  }
}
