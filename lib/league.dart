import 'package:flutter/material.dart';
import 'package:own_king_notes/data/data.dart';
import 'package:own_king_notes/general_theme.dart';
import 'package:own_king_notes/provider.dart';
import 'package:provider/provider.dart';

class LeagueScreen extends StatelessWidget {
  const LeagueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ParameterProvider>();
    return BackgroundTheme(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 15,
          backgroundColor: const Color.fromARGB(255, 0, 47, 108),
          title: const Text('League of Kings'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
          children: [
            LeagueConstructor(
              title: 'En Büyük Orospu Evlatları',
              players: provider.league.pointSort().players,
            ),
            LeagueConstructor(
                title: 'En Büyük Ceza Orospu Evatları',
                players: provider.league.cezaSort().players),
            LeagueConstructor(
              title: 'En Büyük Koz Orospu Evlatları',
              players: provider.league.kozSort().players,
            ),
          ],
        ),
      ),
    );
  }
}

class LeagueConstructor extends StatelessWidget {
  final String title;
  final List<Player> players;

  const LeagueConstructor(
      {super.key, required this.title, required this.players});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontSize: 24, fontWeight: FontWeight.w500),
      ),
      children: players
          .map((e) => ListTile(
                title: Text(e.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w400)),
                leading: const CircleAvatar(),
                trailing: Text(e.totalPoint.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w400)),
                onTap: () {},
              ))
          .toList(),
    );
  }
}
