import 'package:flutter/material.dart';
import 'package:own_king_notes/general_theme.dart';
import 'package:own_king_notes/league.dart';
import 'package:own_king_notes/new_game.dart';
import 'package:own_king_notes/password.dart';
import 'package:own_king_notes/players.dart';
import 'package:own_king_notes/provider.dart';
import 'package:provider/provider.dart';

class KingHomePage extends StatelessWidget {
  const KingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParameterProvider>();
    provider.getPlayers();

    // provider.learnIsPlayingCloud();
    return BackgroundTheme(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 15,
            backgroundColor: const Color.fromARGB(255, 0, 47, 108),
            title: const Text('King of los pollos hermanos'),
          ),
          body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Column(
              children: [
                MenuItem(
                    title: 'Yeni Maç Var',
                    subtitle:
                        'Demek 4 kişi oldunuz. O zaman yapılacak belli...',
                    destination: NewGameScreen()),
                SizedBox(height: 16.0),
                MenuItem(
                    title: 'Eski Oyuna Devam',
                    subtitle: '(Henüz aktif değil)',
                    destination: PasswordScreen()),
                SizedBox(height: 16.0),
                MenuItem(
                    title: 'Lig Puan Durumu',
                    subtitle: 'Onlarla asla sikişemezsin...',
                    destination: LeagueScreen()),
                SizedBox(height: 16.0),
                MenuItem(
                    title: 'Diğer orospu evlatları',
                    subtitle: 'Kimin annesi daha güzel...',
                    destination: PlayersScreen()),
              ],
            ),
          )),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget destination;
  const MenuItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
          onTap: title.contains('Eski')
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => destination),
                  );
                },
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                  157, 138, 22, 1), // Dark Grey Box Background
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(66, 147, 48, 185),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
            child: Stack(
              children: [
                Positioned(
                  top: 32,
                  left: 24,
                  child: Text(title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: const Color.fromARGB(255, 211, 211, 211),
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600,
                          )),
                ),
                Positioned(
                  bottom: 32,
                  left: 40,
                  child: SizedBox(
                    width: 284,
                    child: Text(
                      subtitle,
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color.fromARGB(255, 211, 211, 211),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
