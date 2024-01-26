import 'package:doers/box_name.dart';
import 'package:doers/providers/color_provider.dart';
import 'package:doers/providers/date_list_provider.dart';
import 'package:doers/screens/navigation_screen.dart';
import 'package:doers/services/notification_service.dart';
import 'package:doers/utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(dateListBox);
  await Hive.openBox(colorBoxName);
  await NotificationService().initNotification();
  await NotificationService().scheduleNotification(
      scheduledNotificationDateTime: currentDay.add(const Duration(hours: 10)),
      title: "Check your to do list!",
      body: "or create one!",
      id: 1);
  await NotificationService().scheduleNotification(
      scheduledNotificationDateTime: currentDay.add(const Duration(hours: 21)),
      title: "Check your to do list!",
      body: "or create one!",
      id: 2);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DateListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ColorProvider(),
        )
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
