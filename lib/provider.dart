import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:own_king_notes/data/data.dart';
import 'package:http/http.dart' as http;

class ParameterProvider with ChangeNotifier {
  bool isPlaying = false;
  String password = '';
  List<int> scores = [0, 0, 0, 0];
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int attempt = 0;
  CurrentGame currentGame = CurrentGame(
    date: DateTime.now(),
    players: [
      PlayerInGame(
          player: Player(
              name: 'ACY',
              totalPoint: 0,
              totalKoz: 0,
              totalCeza: 0,
              description: '',
              imageUrl: ''),
          point: 0,
          koz: 0,
          ceza: 0,
          numberOfKozLeft: 2,
          numberOfCezaLeft: 3),
      PlayerInGame(
        player: Player(
            name: 'Hasağn',
            totalPoint: 0,
            totalKoz: 0,
            totalCeza: 0,
            description: '',
            imageUrl: ''),
        point: 0,
        koz: 0,
        ceza: 0,
        numberOfKozLeft: 2,
        numberOfCezaLeft: 3,
      ),
      PlayerInGame(
          player: Player(
              name: 'HiperAtik',
              totalPoint: 0,
              totalKoz: 0,
              totalCeza: 0,
              description: '',
              imageUrl: ''),
          point: 0,
          koz: 0,
          ceza: 0,
          numberOfKozLeft: 2,
          numberOfCezaLeft: 3),
      PlayerInGame(
          player: Player(
              name: 'Hüsoğ',
              totalPoint: 0,
              totalKoz: 0,
              totalCeza: 0,
              description: '',
              imageUrl: ''),
          point: 0,
          koz: 0,
          ceza: 0,
          numberOfKozLeft: 2,
          numberOfCezaLeft: 3),
    ],
    gamesLeft: [
      Game(
          type: GameType.el,
          name: 'El Almaz',
          point: -50,
          left: 2,
          numberOfItem: 13),
      Game(
          type: GameType.erkek,
          name: 'Erkek Almaz ',
          point: -60,
          left: 2,
          numberOfItem: 8),
      Game(
          type: GameType.kiz,
          name: 'Kız Almaz',
          point: -100,
          left: 2,
          numberOfItem: 4),
      Game(
          type: GameType.kupa,
          name: 'Kupa Almaz',
          point: -30,
          left: 2,
          numberOfItem: 13),
      Game(
          type: GameType.son2,
          name: 'Son 2',
          point: -180,
          left: 2,
          numberOfItem: 2),
      Game(
          type: GameType.rifki,
          name: 'Rıfkı',
          point: -320,
          left: 2,
          numberOfItem: 1),
      Game(
        type: GameType.koz,
        name: 'Koz',
        point: 50,
        left: 8,
        numberOfItem: 13,
      ),
    ],
    gamesPlayed: [],
  );

  League league = League(players: [
    Player(
        name: 'ACY',
        totalPoint: 0,
        totalKoz: 0,
        totalCeza: 0,
        description: '',
        imageUrl: ''),
    Player(
        name: 'Hasağn',
        totalPoint: 0,
        totalKoz: 0,
        totalCeza: 0,
        description: '',
        imageUrl: ''),
    Player(
        name: 'HiperAtik',
        totalPoint: 0,
        totalKoz: 0,
        totalCeza: 0,
        description: '',
        imageUrl: ''),
    Player(
        name: 'Hüsoğ',
        totalPoint: 0,
        totalKoz: 0,
        totalCeza: 0,
        description: '',
        imageUrl: ''),
    Player(
        name: 'Ozzy',
        totalPoint: 0,
        totalKoz: 0,
        totalCeza: 0,
        description: '',
        imageUrl: ''),
    Player(
        name: 'OÇ Kemal',
        totalPoint: 0,
        totalKoz: 0,
        totalCeza: 0,
        description: '',
        imageUrl: ''),
    Player(
        name: 'Sarp O\'Che',
        totalPoint: 0,
        totalKoz: 0,
        totalCeza: 0,
        description: '',
        imageUrl: ''),
    Player(
        name: 'Sipahiğ',
        totalPoint: 0,
        totalKoz: 0,
        totalCeza: 0,
        description: '',
        imageUrl: ''),
  ]);

  Future<void> getPlayers() async {
    final url = Uri.https(
      'los-pollos-kings-default-rtdb.europe-west1.firebasedatabase.app',
      'league.json',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch data');
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        league.players.clear();
        data.forEach((key, value) {
          league.players
              .add(Player.fromJson(value as Map<String, dynamic>, key));
        });
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
    notifyListeners();
  }

  Future<void> getHalfGame() async {
    final url = Uri.https(
      'los-pollos-kings-default-rtdb.europe-west1.firebasedatabase.app',
      'games/${DateFormat('yyyy-MM-dd HH:mm:ss')}.json',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch data');
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);

        currentGame.fromJson(data, league);
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
    notifyListeners();
  }

  void setScores(int index, int value) {
    scores[index] = value;
    notifyListeners();
  }

  bool verifyScores() {
    for (int i = 0; i < 4; i++) {
      scores[i] = scores[i] * currentGame.currentGame!.point;
    }

    return scores[0] + scores[1] + scores[2] + scores[3] ==
        currentGame.currentGame!.numberOfItem * currentGame.currentGame!.point;
  }

  void postScoresToCloud() async {
    currentGame = currentGame.addGame(scores);
    currentGame.nextPlayer();
    var body = json.encode({
      currentGame.players[0].player.name: scores[0],
      currentGame.players[1].player.name: scores[1],
      currentGame.players[2].player.name: scores[2],
      currentGame.players[3].player.name: scores[3],
    });
    scores = [0, 0, 0, 0];

    final today = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentGame.date);
    final url = Uri.https(
        'los-pollos-kings-default-rtdb.europe-west1.firebasedatabase.app',
        'games/$today/${currentGame.currentGame!.name}-${currentGame.currentGame!.type == GameType.koz ? 9 - currentGame.currentGame!.left : 3 - currentGame.currentGame!.left}.json');
    final response = await http.patch(
      url,
      headers: {'players': 'scores'},
      body: body,
    );
    print(response.statusCode);
    notifyListeners();
  }

  void pastScoresToLeague() {
    currentGame.players;
    for (var i = 0; i < currentGame.players.length; i++) {
      league.players[league.players.indexOf(currentGame.players[i].player)] =
          league.players[league.players.indexOf(currentGame.players[i].player)]
              .addPoint(currentGame.players[i]);
    }
    notifyListeners();
  }

  void postTotalGameToCloud() async {
    final url = Uri.https(
        'los-pollos-kings-default-rtdb.europe-west1.firebasedatabase.app',
        'league.json');
    try {
      final response = await http.patch(url,
          headers: {'players': 'scores'},
          body: json.encode({
            currentGame.players[0].player.name: {
              'Puan': league.players[0].totalPoint,
              'Ceza': league.players[0].totalCeza,
              'Koz': league.players[0].totalKoz,
            },
            currentGame.players[1].player.name: {
              'Puan': league.players[1].totalPoint,
              'Ceza': league.players[1].totalCeza,
              'Koz': league.players[1].totalKoz,
            },
            currentGame.players[2].player.name: {
              'Puan': league.players[2].totalPoint,
              'Ceza': league.players[2].totalCeza,
              'Koz': league.players[2].totalKoz,
            },
            currentGame.players[3].player.name: {
              'Puan': league.players[3].totalPoint,
              'Ceza': league.players[3].totalCeza,
              'Koz': league.players[3].totalKoz,
            },
          }));
      if (response.statusCode == 200) {
        print('Total game posted to cloud');
      } else {
        print('Failed to post total game to cloud');
      }
    } catch (e) {
      print('Failed to post total game to cloud: $e');
    }
  }

  void setStarter(String player) {
    currentGame.starter = currentGame.players
        .firstWhere((element) => element.player.name == player);
    currentGame.ownerOfCurrentGame = currentGame.starter;
    notifyListeners();
  }

  void setCurrentGamePlayer(Player player, int index) {
    currentGame.players[index] = PlayerInGame(
        player: player,
        point: 0,
        koz: 0,
        ceza: 0,
        numberOfKozLeft: 2,
        numberOfCezaLeft: 3);
    notifyListeners();
  }

  void chooseGame(Game game) {
    currentGame.currentGame = game;
    currentGame.nextGame(currentGame.currentGame!);
    notifyListeners();
  }

  void notifyIsPlayingCloud() async {
    isPlaying = true;
    final url = Uri.https(
        'los-pollos-kings-default-rtdb.europe-west1.firebasedatabase.app',
        'isPlaying.json');

    try {
      final response = await http.patch(
        url,
        headers: {'status': 'value'},
        body: json.encode(
          {
            'isPlaying': true.toString(),
            'writer': password,
            'key': DateFormat('yyyy-MM-dd HH:mm:ss').format(currentGame.date),
            'starter': currentGame.starter!.player.name,
          },
        ),
      );
      if (response.statusCode == 200) {
        print('isPlaying is set to true');
      } else {
        print('Failed to set isPlaying to true');
      }
    } catch (e) {
      print('Failed to set isPlaying to true: $e');
    }
  }

  void learnIsPlayingCloud() async {
    final url = Uri.https(
        'los-pollos-kings-default-rtdb.europe-west1.firebasedatabase.app',
        'isPlaying.json');
    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch data');
      } else {
        print(response.body);
        Map<String, dynamic> data =
            response.body == 'null' ? {} : jsonDecode(response.body);
        data.forEach((key, value) {
          if (key == 'isPlaying') {
            if (value == 'true') {
              isPlaying = true;
              password = data['writer'];
              currentGame.date = DateTime.parse(data['key']);
              currentGame.starter = currentGame.players.firstWhere(
                  (element) => element.player.name == data['starter']);
            }
          }
        });
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
    notifyListeners();
  }

  void deleteIsPlayingCloud() async {
    final url = Uri.https(
        'los-pollos-kings-default-rtdb.europe-west1.firebasedatabase.app',
        'isPlaying.json');
    try {
      final response = await http.delete(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to delete data');
      } else {
        print(response.body);
        isPlaying = false;
        password = '';
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
    notifyListeners();
  }

  bool validatePassword() {
    if (isPlaying) {
      if (passwordController.text == password) {
        passwordController.clear();
      }
      return passwordController.text == password;
    } else {
      notifyIsPlayingCloud();
      password = passwordController.text;
      passwordController.clear();
      return true;
    }
  }
}
