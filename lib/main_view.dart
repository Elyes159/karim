// ignore_for_file: unused_field

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_app/core/bloc/base_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';

import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/features/home/pages/home_screen.dart';
import 'package:quran_app/features/home/widgets/custom_bottom_navigation_bar2.dart';
import 'package:quran_app/features/home/widgets/next_player.dart';
import 'package:quran_app/languages/languages_constants.dart';

import 'core/services/get_cash_data.dart';
import 'core/services/services_notification.dart';
import 'core/util/exit_alert.dialog.dart';
import 'features/prayer_time/cubit/prayer_time_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void setLastRead() async {
  await CashHelper.setData(
    key: 'lastPageRead',
    value: lastPageRead,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initNotification();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrayerTimeCubit()..initPrayerTime(),
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) => MaterialApp(
          builder: BotToastInit(), //1. call BotToastInit
          navigatorObservers: [BotToastNavigatorObserver()],
          home: const HomeScreenNew(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: _locale,
        ),
      ),
    );
  }

  void initNotification() async {
    notifyHelper = NotifyHelper();
    await notifyHelper.initializeNotification(context);
    await notifyHelper.initChannelAndroid();
    print("init Notification ");
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();
    // ControllerQuran.loadSurah();
    initCashValue();
    ToastServes.fToast = FToast();
    ToastServes.fToast!.init(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        showMyAlert(context: context);
        // await showDialog(
        //   context: context,
        //   builder: (context) => const MyAlertDialog(),
        // );
        return false;
      },
      // child: ,
      child: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseBloc, BaseState>(
      builder: (context, state) {
        return BaseHome(
          titleWidget: currentPage == 0 ? const NextTimePrayerRemain() : null,
          back: false,
          title: "",
          isScroll: currentPage == 2 ? false : true,
          bottomNavigationBar: const CustomBottomNavigationBar(),
          body: screens[currentPage],
        );
      },
    );
  }
}
