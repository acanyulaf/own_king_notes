import 'package:flutter/material.dart';
import 'package:own_king_notes/general_theme.dart';
import 'package:own_king_notes/provider.dart';
import 'package:own_king_notes/selection.dart';
import 'package:own_king_notes/winner.dart';
import 'package:provider/provider.dart';

class ScoresScreen extends StatelessWidget {
  const ScoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParameterProvider>();
    return BackgroundTheme(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 15,
          backgroundColor: const Color.fromARGB(255, 0, 47, 108),
          //leading: const Text(''),
          title: const Text('Skorlar'),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 8,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 80.0, horizontal: 16.0),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16),
                      child: ListTile(
                          // contentPadding: const EdgeInsets.symmetric(
                          //     vertical: 16.0, horizontal: 16.0),
                          title: Text(
                            provider.currentGame.players[index].player.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.w400),
                          ),
                          trailing: DropdownButton<int>(
                            dropdownColor:
                                const Color.fromARGB(157, 138, 22, 1),
                            value: provider.scores[index],
                            onChanged: (int? newValue) {
                              provider.setScores(index, newValue!);
                            },
                            items: List.generate(
                                    provider.currentGame.currentGame!
                                            .numberOfItem +
                                        1,
                                    (index) => index)
                                .map((int option) => DropdownMenuItem<int>(
                                      value: option,
                                      child: Text(
                                        option.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(fontSize: 24),
                                      ),
                                    ))
                                .toList(),
                          )),
                    );
                  }),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (!(provider.verifyScores())) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor:
                              const Color.fromARGB(255, 138, 22, 1),
                          title: Text(
                            'Ne desek az...',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: 32, fontWeight: FontWeight.w500),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                'Siktir git şu skor tablosunu iyi bak amına koduum çocuğu seni. Bi de skor tutuyo annesini siktiğim',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
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
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(171, 0, 47, 108),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: const Text(
                                  'Kafamız taşak olmuş abi ya',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
                  provider.postScoresToCloud();
                  if (provider.currentGame.gamesPlayed.length >= 20) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const WinnerScreen()));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SelectionScreen()));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(157, 138, 22, 1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(
                    'Tamam mıyız abi',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 24,
                          // color: Theme.of(context).dialogBackgroundColor,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 160,
            )
          ],
        ),
      ),
    );
  }
}
