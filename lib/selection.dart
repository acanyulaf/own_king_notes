import 'package:flutter/material.dart';
import 'package:own_king_notes/data/data.dart';
import 'package:own_king_notes/general_theme.dart';
import 'package:own_king_notes/provider.dart';
import 'package:own_king_notes/score_table.dart';
import 'package:provider/provider.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParameterProvider>();
    print('${provider.currentGame.gamesPlayed.length} games oynandı');
    return BackgroundTheme(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 15,
            backgroundColor: const Color.fromARGB(255, 0, 47, 108),
            leading: const Text(''),
            title: Text(provider.currentGame.gamesPlayed.isEmpty
                ? 'Haydiii'
                : 'Seçen Orospu Evladı: ${provider.currentGame.ownerOfCurrentGame!.player.name}'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                provider.currentGame.gamesPlayed.isEmpty
                    ? Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          alignment: Alignment.center,
                          child: ListTile(
                            title: Text(
                              'Sinek 2 şunda',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: 24.0),
                            ),
                            trailing: DropdownButton<String>(
                              dropdownColor:
                                  const Color.fromARGB(232, 138, 22, 1),
                              value: provider.currentGame.starter == null
                                  ? provider.currentGame.players[0].player.name
                                  : provider.currentGame.starter!.player.name,
                              onChanged: (String? newValue) {
                                provider.setStarter(newValue!);
                              },
                              items: provider.currentGame.players
                                  .map((PlayerInGame option) {
                                return DropdownMenuItem<String>(
                                  value: option.player.name,
                                  child: Text(
                                    option.player.name,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontSize: 24),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      )
                    : const Text(''),
                Expanded(
                  flex: 10,
                  child: GridView(
                    padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 16, horizontal: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.25,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 16,
                    ),
                    children: [
                      for (final item in provider.currentGame.gamesLeft)
                        ((item.left > 0 &&
                                        provider.currentGame.gamesPlayed
                                                .length >=
                                            4) ||
                                    (item.left > 0 &&
                                        provider.currentGame.gamesPlayed
                                                .length <
                                            4 &&
                                        item.type != GameType.koz)) &&
                                ((provider.currentGame.ownerOfCurrentGame!
                                                .numberOfCezaLeft >
                                            0 &&
                                        item.type != GameType.koz) ||
                                    (provider.currentGame.ownerOfCurrentGame!
                                                .numberOfKozLeft >
                                            0 &&
                                        item.type == GameType.koz))
                            ? InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(167, 138, 22, 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.name,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(fontSize: 24),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Puan: ${item.point.toString()}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Kalan: ${item.left.toString()}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  provider.chooseGame(item);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ScoreTableScreen(
                                      isComingFromSelection: false,
                                    ),
                                  ));
                                },
                              )
                            : const Text(''),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                provider.currentGame.gamesPlayed.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ScoreTableScreen(
                              isComingFromSelection: true,
                            ),
                          ));
                        },
                        child: Container(
                          width: 250,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 47, 108),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                          child: Text(
                            'Tabloyu bi göriyim',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontSize: 24,
                                      // color: Theme.of(context).dialogBackgroundColor,
                                    ),
                          ),
                        ),
                      )
                    : const Text(''),
                const SizedBox(height: 16),
              ],
            ),
          )),
    );
  }
}
