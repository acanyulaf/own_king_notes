import 'package:flutter/material.dart';
import 'package:own_king_notes/data/data.dart';
import 'package:own_king_notes/general_theme.dart';
import 'package:own_king_notes/king.dart';
import 'package:own_king_notes/provider.dart';
import 'package:own_king_notes/score_table.dart';
import 'package:provider/provider.dart';

class WinnerScreen extends StatelessWidget {
  const WinnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ParameterProvider>();
    return BackgroundTheme(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 15,
          backgroundColor: const Color.fromARGB(255, 0, 47, 108),
          title: const Text('Evveeeetttt...'),
          leading: const Text(''),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 6,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    vertical: 40.0, horizontal: 16.0),
                children: [
                  SortedList(
                    title: 'Oyunun Kazananları',
                    listOfPlayers: provider.currentGame.sortedPointPlayers,
                  ),
                  SortedList(
                    title: 'Oyunun Ceza Sıralaması',
                    listOfPlayers: provider.currentGame.sortedCezaPlayers,
                  ),
                  SortedList(
                    title: 'Oyunun Koz Sıralaması',
                    listOfPlayers: provider.currentGame.sortedKozPlayers,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ScoreTableScreen(
                              isComingFromSelection: true,
                            ),
                          ),
                        );
                      },
                      child: const Text('Skor Tablosuna Dön'),
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () async {
                        provider.pastScoresToLeague();
                        provider.postTotalGameToCloud();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const KingHomePage(),
                          ),
                        );
                      },
                      child: const Text('Ana Menüye Dön'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SortedList extends StatelessWidget {
  final String title;
  final List<PlayerInGame> listOfPlayers;
  const SortedList(
      {super.key, required this.title, required this.listOfPlayers});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24),
      ),
      children: listOfPlayers.map((playerInGame) {
        return ListTile(
          title: Text(
            playerInGame.player.name,
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24),
          ),
          trailing: Text(
            '${title.contains('Ceza') ? playerInGame.ceza : title.contains('Koz') ? playerInGame.koz : playerInGame.point}',
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
    );
  }
}
