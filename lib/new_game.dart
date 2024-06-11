import 'package:flutter/material.dart';
import 'package:own_king_notes/data/data.dart';
import 'package:own_king_notes/general_theme.dart';
import 'package:own_king_notes/provider.dart';
import 'package:own_king_notes/selection.dart';
import 'package:provider/provider.dart';

class NewGameScreen extends StatelessWidget {
  const NewGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParameterProvider>();

    return BackgroundTheme(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 15,
          backgroundColor: const Color.fromARGB(255, 0, 47, 108),
          title: const Text('Tamam da Hangi Oros....'),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 7,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 16.0),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    // print('index: $index');
                    // print(
                    //     'player: ${provider.currentGame.players[index].player.name}');
                    return Column(
                      children: [
                        ListTile(
                          title: Text('${index + 1}. Orrrospu Evladı:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: const Color.fromARGB(
                                          255, 211, 211, 211),
                                      fontSize: 24.0)),
                          trailing: DropdownButton<String>(
                            dropdownColor:
                                const Color.fromARGB(232, 138, 22, 1),
                            value:
                                provider.currentGame.players[index].player.name,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                print('newValue: $newValue');
                                Player newPlayer = provider.league.players
                                    .firstWhere(
                                        (player) => player.name == newValue);
                                provider.setCurrentGamePlayer(newPlayer, index);
                              }
                            },
                            items: provider.league.players.map((Player option) {
                              return DropdownMenuItem<String>(
                                value: option.name,
                                child: Text(
                                  option.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: const Color.fromARGB(
                                              255, 211, 211, 211),
                                          fontSize: 20.0),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 48.0)
                      ],
                    );
                  }),
            ),
            Flexible(
                child: InkWell(
                    onTap: () {
                      onPressed(context, provider);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(178, 138, 21, 1),
                          borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Masaya oturabildik miii?',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color.fromARGB(255, 211, 211, 211),
                            fontSize: 24),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}

void onPressed(BuildContext context, ParameterProvider provider) {
  provider.currentGame.ownerOfCurrentGame = provider.currentGame.players[0];
  Set<String> newSet =
      Set.from(provider.currentGame.players.map((e) => e.player.name).toList());
  if (newSet.length != 4) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: const Color.fromARGB(255, 138, 22, 1),
          title: Text(
            'Sizin ben...',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: const Color.fromARGB(255, 211, 211, 211),
                fontSize: 32,
                fontWeight: FontWeight.w500),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32),
              Text(
                '    Şimdi biriniz masada iki yerde mi oynayacak amk özürlüleri? Biraz az için şu mereti!!',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: const Color.fromARGB(255, 211, 211, 211),
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 32),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(118, 0, 47, 108),
                    borderRadius: BorderRadius.circular(16)),
                child: const Text(
                  'Bunu içelim bi süre sarmayız be abi.',
                  style: TextStyle(
                      color: Color.fromARGB(255, 211, 211, 211), fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
    return;
  }
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const SelectionScreen(),
  ));
}
