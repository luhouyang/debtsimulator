class GameEntity {
  int maxPlayer = 4;
  double moveCountdownLimit = 30000; // miliseconds

  final String roomName;
  final String gameId;
  bool gameStatus; // 0 (not yet), 1 (started)
  bool afked;
  int currentMove;
  int numPlayer;
  List<Map<String, dynamic>> chatLog;
  List<Map<String, dynamic>> playerList;

  GameEntity(
      {required this.roomName,
      required this.gameId,
      required this.currentMove,
      required this.gameStatus,
      required this.afked,
      required this.numPlayer,
      required this.chatLog,
      required this.playerList});

  factory GameEntity.fromMap(Map<String, dynamic> map) {
    return GameEntity(
      roomName: map['roomName'] as String,
      gameId: map['gameId'] as String,
      currentMove: map['currentMove'] as int,
      gameStatus: map['gameStatus'] as bool,
      afked: map['afked'] as bool,
      numPlayer: map['numPlayer'] as int,
      chatLog: List<Map<String, dynamic>>.from(map['chatLog'] ?? []),
      playerList: List<Map<String, dynamic>>.from(map['playerList']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomName': roomName,
      'gameId': gameId,
      'currentMove': currentMove,
      'gameStatus': gameStatus,
      'afked': afked,
      'numPlayer': numPlayer,
      'chatLog': chatLog,
      'playerList': playerList,
    };
  }
}
