class GameEntity {
  int maxPlayer = 4;
  double moveCountdownLimit = 20000; // miliseconds

  final String roomName;
  final String gameId;
  bool gameStatus; // 0 (not yet), 1 (started)
  double moveCountdown; // in miliseconds
  int currentMove;
  int numPlayer;
  List<Map<String, dynamic>> chatLog;
  List<Map<String, dynamic>> playerList;

  GameEntity(
      {required this.roomName,
      required this.gameId,
      required this.moveCountdown,
      required this.currentMove,
      required this.gameStatus,
      required this.numPlayer,
      required this.chatLog,
      required this.playerList});

  factory GameEntity.fromMap(Map<String, dynamic> map) {
    return GameEntity(
      roomName: map['roomName'] as String,
      gameId: map['gameId'] as String,
      moveCountdown: double.tryParse(map['moveCountdown'].toString())!,
      currentMove: map['currentMove'] as int,
      gameStatus: map['gameStatus'] as bool,
      numPlayer: map['numPlayer'] as int,
      chatLog: List<Map<String, dynamic>>.from(map['chatLog'] ?? []),
      playerList: List<Map<String, dynamic>>.from(map['playerList']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomName': roomName,
      'gameId': gameId,
      'moveCountdown': moveCountdown,
      'currentMove': currentMove,
      'gameStatus': gameStatus,
      'numPlayer': numPlayer,
      'chatLog': chatLog,
      'playerList': playerList,
    };
  }
}
