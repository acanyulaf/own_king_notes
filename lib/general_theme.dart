import 'package:flutter/material.dart';

class BackgroundTheme extends StatelessWidget {
  final Widget child;
  const BackgroundTheme({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color.fromARGB(255, 184, 134, 11), // Dark Goldenrod
            Color.fromARGB(255, 0, 47, 108), // Dark Royal Blue
          ],
          radius: 2,
          center: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
