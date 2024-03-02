import 'package:doers/box_name.dart';
import 'package:doers/features/settings/color_provider.dart';
import 'package:doers/features/upcoming/date_list_provider.dart';
import 'package:doers/features/notification/notification_provider.dart';
import 'package:doers/features/navigation/navigation_screen.dart';
import 'package:doers/features/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(dateListBox);
  await Hive.openBox(colorBoxName);
  await Hive.openBox(notiBoxName);
  await NotificationService().initNotification();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DateListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ColorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(),
        ),
      ],
      child: const DoersApp(),
    ),
  );
}

class DoersApp extends StatefulWidget {
  const DoersApp({super.key});

  @override
  State<DoersApp> createState() => _DoersAppState();
}

class _DoersAppState extends State<DoersApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textButtonTheme: const TextButtonThemeData(
            style: ButtonStyle(
                surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                splashFactory: NoSplash.splashFactory,
                foregroundColor: MaterialStatePropertyAll(Colors.black))),
        dialogTheme: const DialogTheme(
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white),
        primaryColor: Color(context.watch<ColorProvider>().colorhex),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const NavigationScreen(),
    );
  }
}
