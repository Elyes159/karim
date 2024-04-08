// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_header.dart';
import 'package:quran_app/features/another_screen/widgets/another_featuers.dart';
import 'package:quran_app/features/prayer_time/widgets/item_prayer_home.dart';
import 'package:quran_app/features/quran_audio/ui/widgets/surah_audio_only.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemPrayerHome(),
          SurahAudioOnly(),
          BaseHeder(text: "المميزات"),
          AnotherFeatures(),
        ],
      ),
    );
  }
}
