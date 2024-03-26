class GameEntity {
  int maxPlayer = 4;

  final String roomName;
  final String gameId;
  bool gameStatus; // 0 (not yet), 1 (started)
  double moveCountdown; // in miliseconds
  int numPlayer;
  List<Map<String, dynamic>> playerList;

  GameEntity(
      {required this.roomName,
      required this.gameId,
      required this.moveCountdown,
      required this.gameStatus,
      required this.numPlayer,
      required this.playerList});

  factory GameEntity.fromMap(Map<String, dynamic> map) {
    return GameEntity(
        roomName: map['roomName'] as String,
        gameId: map['gameId'] as String,
        moveCountdown: double.tryParse(map['moveCountdown'].toString())!,
        gameStatus: map['gameStatus'] as bool,
        numPlayer: map['numPlayer'] as int,
        playerList: List<Map<String, dynamic>>.from(map['playerList']),
        /*List.from(
          (gMap['playerList'] as List<Map<String, dynamic>>).map((playerData) {
        PlayerEntity.fromMap(playerData);
      })),*/
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomName': roomName,
      'gameId': gameId,
      'moveCountdown': moveCountdown,
      'gameStatus': gameStatus,
      'numPlayer': numPlayer,
      'playerList': playerList,
    };
  }
}
