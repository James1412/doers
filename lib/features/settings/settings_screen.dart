import 'package:doers/features/settings/instruction_screen.dart';
import 'package:doers/features/settings/color_provider.dart';
import 'package:doers/features/notification/notification_provider.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> onColorChangeTap() async {
    var selectedColor = Theme.of(context).primaryColor;
    selectedColor = await showColorPickerDialog(
      context,
      Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
    );
    if (!mounted) return;
    context
        .read<ColorProvider>()
        .setColor(int.parse("0xff${selectedColor.hex}"));
  }

  @override
  Widget build(BuildContext context) {
    bool isNotificationOn =
        context.watch<NotificationProvider>().isNotificationOn;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: false,
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const InstructionsScreen(),
                ),
              );
            },
            child: const ListTile(
              dense: true,
              title: Text(
                "How to use?",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          InkWell(
            child: ListTile(
              dense: true,
              trailing: Transform.translate(
                offset: const Offset(13, 0),
                child: Switch(
                  splashRadius: 0,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.shade100,
                  activeColor: Theme.of(context).primaryColor,
                  value: isNotificationOn,
                  onChanged: (val) => context
                      .read<NotificationProvider>()
                      .toggleNotifications(val),
                ),
              ),
              title: const Text(
                "Notifications",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          InkWell(
            onTap: onColorChangeTap,
            child: ListTile(
              dense: true,
              title: const Text(
                "Change theme color",
                style: TextStyle(fontSize: 17),
              ),
              trailing: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          const AboutListTile(
            applicationName: "Doers",
          ),
        ],
      ),
    );
  }
}
