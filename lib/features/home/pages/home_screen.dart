import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/FontSizeParam/settingFont.dart';
import 'package:quran_app/core/components/base_header.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/features/another_screen/widgets/another_featuers.dart';
import 'package:quran_app/features/prayer_time/widgets/item_prayer_home.dart';
import 'package:quran_app/features/quran_audio/ui/widgets/surah_audio_only.dart';
import 'package:quran_app/starting/signin.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({Key? key}) : super(key: key);

  @override
  State<HomeScreenNew> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenNew> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ajout des IconButton
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SettingsPage()),
                        );
                      },
                      icon: Icon(Icons.settings),
                      tooltip: 'Accueil',
                    ),
                    IconButton(
                      onPressed: () async {
                        try {
                          // Déconnexion de l'utilisateur
                          await FirebaseAuth.instance.signOut();
                          // Naviguer vers l'écran d'accueil et supprimer l'écran actuel de la pile
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        } catch (e) {
                          print("Erreur lors de la déconnexion : $e");
                          // Gérer les erreurs de déconnexion ici
                        }
                      },
                      icon: Icon(Icons.logout),
                      tooltip: 'Déconnexion',
                    ),
                  ],
                ),
              ),

              // Les autres éléments de votre écran
              ItemPrayerHome(),
              SurahAudioOnly(),
              BaseHeder(text: "المميزات"),
              AnotherFeatures(),
            ],
          ),
        ),
      ),
    );
  }
}
