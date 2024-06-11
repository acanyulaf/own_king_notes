import 'package:flutter/material.dart';
import 'package:own_king_notes/data/data.dart';
import 'package:own_king_notes/general_theme.dart';
import 'package:own_king_notes/provider.dart';
import 'package:own_king_notes/scores.dart';
import 'package:own_king_notes/selection.dart';
import 'package:provider/provider.dart';

class ScoreTableScreen extends StatelessWidget {
  final bool isComingFromSelection;
  const ScoreTableScreen({super.key, required this.isComingFromSelection});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParameterProvider>();

    return BackgroundTheme(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 15,
          backgroundColor: const Color.fromARGB(255, 0, 47, 108),
          leading: const Text(''),
          title: Text(
              'Skorlar:   ${provider.currentGame.gamesPlayed.length}. El Sonu'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Row(
                  children: [
                    const SizedBox(width: 32.0),
                    UserCard(
                      playerInGame: provider.currentGame.players[0],
                    ),
                    UserCard(
                      playerInGame: provider.currentGame.players[1],
                    ),
                    UserCard(
                      playerInGame: provider.currentGame.players[2],
                    ),
                    UserCard(
                      playerInGame: provider.currentGame.players[3],
                    ),
                    const SizedBox(width: 8.0)
                  ],
                ),
              ),
              const Divider(
                color: Color.fromARGB(157, 138, 22, 1), // Line color
                thickness: 2, // Line thickness
                height: 15, // Space above and below the line
              ),
              Flexible(
                flex: 7,
                child: provider.currentGame.gamesPlayed.isEmpty
                    ? const Center(
                        child: Text(
                        'Başlıyorr...',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 211, 211, 211),
                        ),
                      ))
                    : ListView.builder(
                        itemCount: provider.currentGame.gamesPlayed.length,
                        itemBuilder: (context, index) {
                          return ScoreCard(
                            score: provider.currentGame.gamesPlayed[index],
                            numberOfTurns: index,
                          );
                        }),
              ),
              const Divider(
                color: Color.fromARGB(157, 138, 22, 1), // Line color
                thickness: 2, // Line thickness
                height: 15, // Space above and below the line
              ),
              Flexible(
                flex: 3,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  children: [
                    TotalScoreCard(
                        icon: Icons.calculate_rounded,
                        players: provider.currentGame.players),
                    TotalScoreCard(
                        players: provider.currentGame.players,
                        icon: Icons.text_increase_rounded),
                    TotalScoreCard(
                        players: provider.currentGame.players,
                        icon: Icons.accessible_forward_rounded),
                  ],
                ),
              ),
              isComingFromSelection
                  ? Text('')
                  : Flexible(
                      flex: 1,
                      child: ListTile(
                        title: Text(
                          '${provider.currentGame.currentGame!.name} oynanıyor.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 20),
                        ),
                        subtitle: Text(
                          '${provider.currentGame.ownerOfCurrentGame!.player.name} seçti.',
                        ),
                        trailing: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ScoresScreen(),
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(157, 138, 22, 1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'Bittiii!',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 20,
                                    color: const Color.fromARGB(
                                        255, 211, 211, 211),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: isComingFromSelection
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SelectionScreen(),
                          ));
                        }
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SelectionScreen(),
                          ));
                          provider.currentGame =
                              provider.currentGame.wrongSelection();
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 47, 108),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Text(
                      '${isComingFromSelection ? 'Tamam hazırım!' : 'Beynim olmadığı için hatalı seçtim.'} ',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: isComingFromSelection ? 24 : 16,
                            color: const Color.fromARGB(255, 211, 211, 211),
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final PlayerInGame playerInGame;
  const UserCard({
    super.key,
    required this.playerInGame,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12),
        color: const Color.fromARGB(255, 184, 134, 11),
        elevation: 4.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              playerInGame.player.name,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 16.0,
                    color: const Color.fromARGB(255, 0, 47, 108),
                  ),
              textAlign: TextAlign.center,
            ), // Spacing between title and icon row
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.accessible_forward_rounded,
                  color: playerInGame.numberOfCezaLeft == 3
                      ? Colors.white
                      : Colors.red,
                ),
                Icon(
                  Icons.accessible_forward_rounded,
                  color: playerInGame.numberOfCezaLeft < 2
                      ? Colors.red
                      : Colors.white,
                ), // Spacing between icons
                Icon(
                  Icons.accessible_forward_rounded,
                  color: playerInGame.numberOfCezaLeft < 1
                      ? Colors.red
                      : Colors.white,
                ),
              ],
            ), // Spacing between rows of icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.text_increase,
                    color: playerInGame.numberOfKozLeft == 2
                        ? Colors.white
                        : Colors.green),
                Icon(Icons.text_increase,
                    color: playerInGame.numberOfKozLeft < 1
                        ? Colors.blue
                        : Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  final List<int> score;
  final int numberOfTurns;

  const ScoreCard({
    super.key,
    required this.score,
    required this.numberOfTurns,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        SizedBox(
          width: 16.0,
          child: Text('${numberOfTurns + 1}'),
        ),
        for (var i = 0; i < score.length; i++)
          Flexible(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                '${score[i]}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 24),
              ),
            ),
          ),
      ],
    );
  }
}

class TotalScoreCard extends StatelessWidget {
  final List<PlayerInGame> players;
  final IconData icon;
  const TotalScoreCard({
    super.key,
    required this.players,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Icon(
            icon,
            size: 32,
            color: icon == Icons.accessible_forward_rounded
                ? Colors.red
                : icon == Icons.text_increase_rounded
                    ? Colors.green
                    : Colors.blue,
          ),
        ),
        for (var i = 0; i < players.length; i++)
          Flexible(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '${icon == Icons.accessible_forward_rounded ? players[i].ceza : icon == Icons.text_increase_rounded ? players[i].koz : players[i].point}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 28),
              ),
            ),
          ),
      ],
    );
  }
}
