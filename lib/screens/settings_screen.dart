import 'package:doers/providers/color_provider.dart';
import 'package:doers/services/notification_service.dart';
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
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Settings",
        ),
      ),
      body: Column(
        children: [
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
