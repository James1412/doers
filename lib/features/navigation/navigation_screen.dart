import 'package:doers/features/history/all_history_screen.dart';
import 'package:doers/features/settings/settings_screen.dart';
import 'package:doers/features/upcoming/screens/home_screen.dart';
import 'package:doers/features/chart/chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> screens = [
    const HomeScreen(),
    const AllHistoryScreen(),
    const ChartScreen(),
    const SettingsScreen(),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: GNav(
          backgroundColor: Colors.white,
          color: Colors.grey,
          activeColor: Theme.of(context).primaryColor,
          tabBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          onTabChange: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          padding: const EdgeInsets.all(16),
          gap: 5,
          tabs: const [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.history, text: "History"),
            GButton(icon: Icons.bar_chart, text: "Chart"),
            GButton(icon: Icons.settings, text: "Settings"),
          ],
        ),
      ),
    );
  }
}
