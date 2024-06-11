import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:own_king_notes/general_theme.dart';
import 'package:own_king_notes/new_game.dart';
import 'package:own_king_notes/provider.dart';
import 'package:provider/provider.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParameterProvider>();
    return BackgroundTheme(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 47, 108),
          title: Text(
            provider.isPlaying ? 'İçerde bi oyun var' : 'Sayın defterdar...',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
          ),
          elevation: 15,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: provider.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  provider.isPlaying
                      ? 'İnsanlar ahlaki-teknolojik yıkım kapasiteleri ile bu dürtülerini kontrol etmelerini sağlayan ahlaki kapasiteleri arasındaki boşluğu kapatabilir mi?'
                      : 'Şimdi senden başkasının kaydetmesini engelleyecez. Bi şifre oluturcan diğer amcıklar yanlış veri kaydedemeyecek.',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: provider.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: provider.isPlaying
                          ? 'Seri cevap ver!'
                          : 'Kolay gele defterdar bey...'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Taşak mı geçiyon amın oğlu...';
                    } else if (!provider.isPlaying && value.length < 8) {
                      return '8 harf olmayan şifre olmaz aslan ...';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 64),
                InkWell(
                  onTap: () {
                    if (provider.formKey.currentState!.validate()) {
                      if (provider.validatePassword()) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const NewGameScreen()));
                      } else {
                        if (provider.attempt >= 4) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Yakalandın...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white),
                              ),
                              duration: const Duration(seconds: 2),
                              backgroundColor:
                                  const Color.fromARGB(157, 138, 22, 1),
                            ),
                          );
                          const Duration(seconds: 2);
                          if (Platform.isAndroid) {
                            SystemNavigator.pop();
                          } else if (Platform.isIOS || Platform.isWindows) {
                            exit(
                                0); // Note: Use with caution on iOS and Windows
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Sahtekar orospu çocuğu? ${4 - provider.attempt} hakkın kaldı...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white),
                              ),
                              duration: const Duration(seconds: 2),
                              backgroundColor:
                                  const Color.fromARGB(157, 138, 22, 1),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: const Icon(
                      Icons.lock_open,
                      size: 48,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
