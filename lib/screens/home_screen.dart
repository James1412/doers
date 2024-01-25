import 'package:animated_line_through/animated_line_through.dart';
import 'package:doers/components/drag_tile.dart';
import 'package:doers/components/proxy_decoration.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List items = [
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
  ];
  Map<int, String> weekdays = {
    1: "Mon",
    2: "Tue",
    3: "Wed",
    4: "Thu",
    5: "Fri",
    6: "Sat",
    7: "Sun",
  };
  late Map<int, String> months = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "June",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec",
  };
  bool showItems = false;

  ValueNotifier<bool> isSelected = ValueNotifier(false);
  late String todayDate =
      "${DateTime.now().year} ${months[DateTime.now().month]} ${DateTime.now().day} ${weekdays[DateTime.now().weekday]}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            ExpansionTile(
              shape: const BeveledRectangleBorder(),
              title: Text(
                todayDate,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              children: [
                for (var i in items)
                  LongPressDraggable(
                    data: i,
                    key: UniqueKey(),
                    feedback: Opacity(
                      opacity: 0.8,
                      child: Container(
                        color: Colors.grey,
                        width: double.maxFinite,
                        height: 70,
                        child: Material(
                          child: dragTile(isSelected, i),
                        ),
                      ),
                    ),
                    child: dragTile(isSelected, i),
                  ),
              ],
            ),
            DragTarget(
              onAcceptWithDetails: (data) {
                items.add('akdf');
                setState(() {});
              },
              builder: (context, candidateData, rejectedData) {
                return ExpansionTile(
                  shape: const BeveledRectangleBorder(),
                  title: const Text(
                    "tmr",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  children: [
                    for (var i in items)
                      candidateData.isNotEmpty
                          ? Opacity(
                              opacity: 0.5,
                              child: dragTile(isSelected, i),
                            )
                          : dragTile(isSelected, i),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
