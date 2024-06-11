import 'package:flutter/material.dart';
import 'package:own_king_notes/data/data.dart';
import 'package:own_king_notes/general_theme.dart';
// import 'package:own_king_notes/provider.dart';
// import 'package:provider/provider.dart';

class PlayerProfile extends StatelessWidget {
  final Player player;
  const PlayerProfile({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    // final provider = context.read<ParameterProvider>();
    return BackgroundTheme(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 15,
          backgroundColor: const Color.fromARGB(255, 0, 47, 108),
          title: Text(player.name),
        ),
        body: const Center(child: Text('Yakında...')),
      ),
    );
  }
}
