import 'package:doers/components/drag_tile.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

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

  String getDate(int x) {
    return "${DateTime.now().year} ${months[DateTime.now().month]} ${DateTime.now().day + x} ${weekdays[DateTime.now().weekday + x]}";
  }

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
              initiallyExpanded: true,
              iconColor: Colors.transparent,
              shape: const BeveledRectangleBorder(),
              title: Text(
                getDate(0),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              children: [
                for (var i in items)
                  Dismissible(
                    key: UniqueKey(),
                    onDismissed: (value) {
                      items.remove(i);
                      setState(() {});
                    },
                    child: LongPressDraggable(
                      data: i,
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
                  ),
                InkWell(
                  onTap: () {
                    setState(() {
                      items.add("");
                    });
                  },
                  child: const ListTile(
                    dense: true,
                    title: Icon(Icons.add),
                    subtitle: Text(
                      "Add new task or event",
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                  title: Text(
                    getDate(1),
                    style: const TextStyle(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        ],
      ),
    );
  }
}
