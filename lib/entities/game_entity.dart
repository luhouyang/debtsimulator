//TODO: complete this
import 'package:debtsimulator/entities/player_entity.dart';

class GameEntity {
  int maxPlayer = 4;

  final String gameId;
  bool gameStatus;
  int numPlayer;
  List<PlayerEntity> playerList;

  GameEntity(
      {required this.gameId,
      required this.gameStatus,
      required this.numPlayer,
      required this.playerList});

  factory GameEntity.fromMap(Map<String, dynamic> gMap) {
    return GameEntity(
      gameId: gMap['gameId'] as String,
      gameStatus: gMap['gameStatus'] as bool,
      numPlayer: gMap['numPlayer'] as int,
      playerList: List.from(
          (gMap['playerList'] as List<Map<String, dynamic>>).map((playerData) {
        PlayerEntity.fromMap(playerData);
      })),
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
