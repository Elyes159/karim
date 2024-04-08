import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:quran_app/core/Home/state.dart';
import 'package:quran_app/core/bloc/base_bloc.dart';
import 'package:quran_app/core/helper/db/sqflite.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/services/permission_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';

import 'package:quran_app/core/BlocObserver/BlocObserver.dart';
import 'package:quran_app/core/Home/cubit.dart';
import 'package:quran_app/features/read_quran/data/data_source/data_client.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/starting/signin.dart';
import 'package:sqflite/sqflite.dart';
import 'features/my_adia/core/db/db_helper_note.dart';
import 'main_view.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Logger logger = Logger();
//flutter build appbundle --release --no-sound-null-safety

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FlutterDownloader.initialize();

  Bloc.observer = MyBlocObserver();
  await DBHelperDou.initDb();
  await DioHelper.init();
  DBHelper.initDb();
  await CashHelper.init();
  lastPageRead = CashHelper.getInt(key: 'lastPageRead') ?? 0;
  currentThemeType = CashHelper.getInt(key: 'currentThemeType') ?? 0;
  setupServiceLocator();
  serviceEnabled = await PermissionService.locationEnabled();

  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }

  await PermissionService.handelNotification();

  // Ajouter la condition ici
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      // Rediriger l'utilisateur vers la page de connexion
      runApp(
        MaterialApp(
          home: Login(),
        ),
      );
    } else {
      // Rediriger l'utilisateur vers la page existante
      // Par exemple, vous pouvez utiliser Navigator.pushReplacementNamed()
      // pour rediriger l'utilisateur vers la page existante
      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AudioCubit()..initAudioPlayer(),
            ),

            //Home Cubit
            BlocProvider(create: (context) => HomeCubit()..checkConnection()),

            // BlocProvider(create: (context) => QuranCubit()),

            BlocProvider(create: (context) => BaseBloc()),
            BlocProvider(create: (context) => BookmarkBloc()),
            BlocProvider(
                lazy: false,
                create: (context) => ReadQuranBloc()..add(LoadQuranEvent())),

            //
          ],
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return const MyApp();
            },
          ),
        ),
      );
    }
  });
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
