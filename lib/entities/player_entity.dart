class PlayerEntity {
  final String username;
  double money;
  double debt;
  bool ready; // 0 (not ready), 1 (ready)
  int state; // -1 (lost), 0 (not turn), 1 (your turn)
  int afkCounter; // if (afkCounter == 3) state = -1
  int boardIndex;
  List<dynamic> assets; // String
  List<dynamic> moveHistory;  // int

  PlayerEntity({
    required this.username,
    required this.money,
    required this.debt,
    required this.ready,
    required this.state,
    required this.afkCounter,
    required this.boardIndex,
    required this.assets,
    required this.moveHistory,
  });

  factory PlayerEntity.fromMap(Map<String, dynamic> map) {
    return PlayerEntity(
      username: map['username'] as String,
      money: map['money'] as double,
      debt: map['debt'] as double,
      ready: map['ready'] as bool,
      state: map['state'] as int,
      afkCounter: map['afkCounter'] as int,
      boardIndex: map['boardIndex'] as int,
      assets: map['assets'],
      moveHistory: map['moveHistory'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'money': money,
      'debt': debt,
      'ready': ready,
      'state': state,
      'afkCounter': afkCounter,
      'boardIndex': boardIndex,
      'assets': assets,
      'moveHistory': moveHistory,
    };
  }
}
