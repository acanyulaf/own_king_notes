class League {
  final List<Player> players;
  League({required this.players});
  League addPlayer(Player player) {
    return League(players: [...players, player]);
  }

  League pointSort() {
    List<Player> newPlayers = List<Player>.from(players);
    newPlayers.sort((a, b) => b.totalPoint.compareTo(a.totalPoint));
    return League(players: newPlayers);
  }

  League cezaSort() {
    List<Player> newPlayers = List<Player>.from(players);
    newPlayers.sort((a, b) => b.totalCeza.compareTo(a.totalCeza));
    return League(players: newPlayers);
  }

  League kozSort() {
    List<Player> newPlayers = List<Player>.from(players);
    newPlayers.sort((a, b) => b.totalKoz.compareTo(a.totalKoz));
    return League(players: newPlayers);
  }
}

class Player {
  final String name;
  final int totalPoint;
  final int totalKoz;
  final int totalCeza;
  final String imageUrl;
  final String description;
  Player({
    required this.name,
    required this.totalPoint,
    required this.totalKoz,
    required this.totalCeza,
    required this.imageUrl,
    required this.description,
  });
  static Player fromJson(Map<String, dynamic> json, String key) {
    return Player(
        name: key,
        totalPoint: json['Puan'],
        totalKoz: json['Koz'],
        totalCeza: json['Ceza'],
        description: '',
        imageUrl: '');
  }

  Player addPoint(PlayerInGame playerInGame) {
    return Player(
        name: name,
        totalPoint: totalPoint + playerInGame.point,
        totalKoz: totalKoz + playerInGame.koz,
        totalCeza: totalCeza + playerInGame.ceza,
        description: description,
        imageUrl: imageUrl);
  }
}

class PlayerInGame {
  final Player player;
  final int point;
  final int koz;
  final int ceza;
  final int numberOfKozLeft;
  final int numberOfCezaLeft;
  PlayerInGame(
      {required this.player,
      required this.point,
      required this.koz,
      required this.ceza,
      required this.numberOfKozLeft,
      required this.numberOfCezaLeft});
  PlayerInGame addPoint(int point, int koz, int ceza) {
    return PlayerInGame(
        player: player,
        point: this.point + point,
        koz: this.koz + koz,
        ceza: this.ceza + ceza,
        numberOfKozLeft: numberOfKozLeft,
        numberOfCezaLeft: numberOfCezaLeft);
  }

  PlayerInGame reduceKozLeft() {
    return PlayerInGame(
        player: player,
        point: point,
        koz: koz,
        ceza: ceza,
        numberOfKozLeft: numberOfKozLeft - 1,
        numberOfCezaLeft: numberOfCezaLeft);
  }

  PlayerInGame reduceCezaLeft() {
    return PlayerInGame(
        player: player,
        point: point,
        koz: koz,
        ceza: ceza,
        numberOfKozLeft: numberOfKozLeft,
        numberOfCezaLeft: numberOfCezaLeft - 1);
  }

  PlayerInGame wrongKozSelection() {
    return PlayerInGame(
        player: player,
        point: point,
        koz: koz,
        ceza: ceza,
        numberOfKozLeft: numberOfKozLeft + 1,
        numberOfCezaLeft: numberOfCezaLeft);
  }

  PlayerInGame wrongCezaSelection() {
    return PlayerInGame(
        player: player,
        point: point,
        koz: koz,
        ceza: ceza,
        numberOfKozLeft: numberOfKozLeft,
        numberOfCezaLeft: numberOfCezaLeft + 1);
  }
}

class CurrentGame {
  DateTime date;
  final List<PlayerInGame> players;
  PlayerInGame? starter;
  List<Game> gamesLeft;
  final List<List<int>> gamesPlayed;
  Game? currentGame;
  PlayerInGame? ownerOfCurrentGame;
  CurrentGame({
    required this.date,
    required this.players,
    required this.gamesLeft,
    this.starter,
    required this.gamesPlayed,
    this.currentGame,
    this.ownerOfCurrentGame,
  });
  // add game: reduces from gamesleft and nothing else
  CurrentGame addGame(List<int> scores) {
    List<PlayerInGame> newPlayers = [];
    for (int i = 0; i < 4; i++) {
      newPlayers.add(players[i].addPoint(
          scores[i],
          currentGame!.type == GameType.koz ? scores[i] : 0,
          currentGame!.type == GameType.koz ? 0 : scores[i]));
    }
    List<List<int>> newGamesPlayed = gamesPlayed;
    newGamesPlayed.add(scores);

    List<Game> newGamesLeft = gamesLeft.map((e) {
      if (e.name == currentGame!.name) {
        return e.reduceLeft();
      } else {
        return e;
      }
    }).toList();

    return CurrentGame(
      date: date,
      players: newPlayers,
      gamesPlayed: newGamesPlayed,
      gamesLeft: newGamesLeft,
      starter: starter,
      ownerOfCurrentGame: ownerOfCurrentGame,
      currentGame: currentGame,
    );
  }

// WRONG SELECTİON CORRECTS THE GAME AND THE PLAYER
  CurrentGame wrongSelection() {
    if (currentGame!.type == GameType.koz) {
      players[players.indexWhere((element) =>
          element.player.name == ownerOfCurrentGame!.player.name)] = players[
              players.indexWhere((element) =>
                  element.player.name == ownerOfCurrentGame!.player.name)]
          .wrongKozSelection();
    } else {
      players[players.indexWhere((element) =>
          element.player.name == ownerOfCurrentGame!.player.name)] = players[
              players.indexWhere((element) =>
                  element.player.name == ownerOfCurrentGame!.player.name)]
          .wrongCezaSelection();
    }
    return CurrentGame(
        date: date,
        players: players,
        gamesPlayed: gamesPlayed,
        gamesLeft: gamesLeft,
        starter: starter,
        currentGame: null,
        ownerOfCurrentGame: ownerOfCurrentGame);
  }

  // next player only changes the owner of the game
  void nextPlayer() {
    ownerOfCurrentGame = players[(players.indexWhere((element) =>
                element.player.name == ownerOfCurrentGame!.player.name) +
            1) %
        4];
  }

  // next game reduces the left of the game
  CurrentGame nextGame(Game nextGame) {
    if (nextGame.type == GameType.koz) {
      players[players.indexWhere((element) =>
          element.player.name == ownerOfCurrentGame!.player.name)] = players[
              players.indexWhere((element) =>
                  element.player.name == ownerOfCurrentGame!.player.name)]
          .reduceKozLeft();
    } else {
      players[players.indexWhere((element) =>
          element.player.name == ownerOfCurrentGame!.player.name)] = players[
              players.indexWhere((element) =>
                  element.player.name == ownerOfCurrentGame!.player.name)]
          .reduceCezaLeft();
    }

    return CurrentGame(
        date: date,
        players: players,
        gamesPlayed: gamesPlayed,
        gamesLeft: gamesLeft,
        starter: starter,
        currentGame: nextGame,
        ownerOfCurrentGame: ownerOfCurrentGame);
  }

  List<PlayerInGame> get sortedPointPlayers {
    List<PlayerInGame> newPlayers = List<PlayerInGame>.from(players);
    newPlayers.sort((a, b) => b.point.compareTo(a.point));
    return newPlayers;
  }

  List<PlayerInGame> get sortedKozPlayers {
    List<PlayerInGame> newPlayers = List<PlayerInGame>.from(players);
    newPlayers.sort((a, b) => b.koz.compareTo(a.koz));
    return newPlayers;
  }

  List<PlayerInGame> get sortedCezaPlayers {
    List<PlayerInGame> newPlayers = List<PlayerInGame>.from(players);
    newPlayers.sort((a, b) => b.ceza.compareTo(a.ceza));
    return newPlayers;
  }

  CurrentGame fromJson(Map<String, dynamic> json, League league) {
    List<PlayerInGame> newPlayers = [];
    List<Game> newGamesLeft = gamesLeft;
    List<List<int>> newGamesPlayed = [];
    int innerIterator = 0;
    int outerIterator = 0;
    Game currentGame = gamesLeft[0];
    json.forEach(
      (key, value) {
        String substr1 = key.substring(0, 3);
        newGamesLeft = newGamesLeft.map((e) {
          String substr2 = e.name.substring(0, 3);
          if (substr2 == substr1) {
            currentGame = e;
            return e.reduceLeft();
          } else {
            return e;
          }
        }).toList();

        (value as Map<String, dynamic>).forEach(
          (key, value) {
            if (innerIterator < 4) {
              newPlayers.add(PlayerInGame(
                player: league.players[league.players
                    .indexWhere((element) => element.name == key)],
                point: 0,
                koz: 0,
                ceza: 0,
                numberOfKozLeft: 2,
                numberOfCezaLeft: 3,
              ).addPoint(value, value > 0 ? value : 0, value > 0 ? 0 : value));
              newGamesPlayed[outerIterator][innerIterator] = value;
            } else {
              newPlayers[newPlayers
                      .indexWhere((element) => element.player.name == key)] =
                  newPlayers[newPlayers
                          .indexWhere((element) => element.player.name == key)]
                      .addPoint(
                          value, value > 0 ? value : 0, value > 0 ? 0 : value);
            }

            innerIterator++;
          },
        );
        nextGame(currentGame);
        nextPlayer();
        outerIterator++;
      },
    );
    return CurrentGame(
      date: date,
      players: players,
      gamesPlayed: gamesPlayed,
      gamesLeft: gamesLeft,
      starter: starter,
      currentGame: currentGame,
      ownerOfCurrentGame: ownerOfCurrentGame,
    );
  }
}

enum GameType { el, erkek, kiz, kupa, son2, rifki, koz }

class Game {
  final GameType type;
  final String name;
  final int point;
  final int left;
  final int numberOfItem;
  Game(
      {required this.type,
      required this.name,
      required this.point,
      required this.left,
      required this.numberOfItem});
  Game reduceLeft() {
    return Game(
        type: type,
        name: name,
        point: point,
        left: left - 1,
        numberOfItem: numberOfItem);
  }

  Game wrongSelection() {
    return Game(
        type: type,
        name: name,
        point: point,
        left: left + 1,
        numberOfItem: numberOfItem);
  }
}
