import 'package:flutter/material.dart';
import 'package:quran_app/languages/languages.dart';
import 'package:quran_app/languages/languages_constants.dart';
import 'package:quran_app/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final double initialFontSize;

  SettingsPage({required this.initialFontSize});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double _fontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Language>(
              underline: const SizedBox(),
              icon: const Icon(
                Icons.language,
                color: Colors.black,
              ),
              onChanged: (Language? language) async {
                if (language != null) {
                  Locale _locale = await setLocale(language.languageCode);
                  // ignore: use_build_context_synchronously
                  MyApp.setLocale(context, _locale);
                }
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.name,
                            style: const TextStyle(fontSize: 30),
                          ),
                          Text(e.name)
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Taille de la police',
              style: Theme.of(context).textTheme.headline6,
            ),
            Slider(
              value: _fontSize,
              min: 12.0,
              max: 24.0,
              onChanged: (newValue) {
                setState(() {
                  _fontSize = newValue;
                });
              },
            ),
            Text(
              '$_fontSize',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                _saveFontSize(_fontSize);
                Navigator.pop(context, _fontSize);
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveFontSize(double fontSize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
  }
}
