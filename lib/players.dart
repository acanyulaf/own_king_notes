import 'package:flutter/material.dart';
import 'package:own_king_notes/general_theme.dart';
import 'package:own_king_notes/provider.dart';
import 'package:provider/provider.dart';

import 'player_page.dart';

class PlayersScreen extends StatelessWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ParameterProvider>();
    return BackgroundTheme(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 15,
            backgroundColor: const Color.fromARGB(255, 0, 47, 108),
            title: const Text('Rakiplerini Tanı'),
          ),
          body: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
              itemCount: provider.league.players.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(provider.league.players[index].name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 24.0)),
                      trailing: const CircleAvatar(
                          // backgroundImage: AssetImage('assets/images/${index + 1}.jpg'),
                          ),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PlayerProfile(
                              player: provider.league.players[index]);
                        }));
                      },
                    ),
                    const SizedBox(height: 32.0)
                  ],
                );
              })),
    );
  }
}
