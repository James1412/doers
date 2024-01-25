import 'package:doers/components/drag_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  String getDate(DateTime dateTime) {
    if (DateTime(dateTime.year, dateTime.month, dateTime.day) ==
        DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
      return "${months[dateTime.month]} ${dateTime.day} (${weekdays[dateTime.weekday]}) • Today";
    }
    return "${months[dateTime.month]} ${dateTime.day} (${weekdays[dateTime.weekday]})";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            // TODO: Make this sliver app bar and change year based on current index
            ListTile(
              dense: true,
              title: Text(
                DateTime.now().year.toString(),
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            // Each day expansion tile
            DragTarget(
              onAcceptWithDetails: (data) {
                // TODO: if item is already in the day, don't add again
                items.add('added');
                setState(() {});
              },
              builder: (context, candidateData, rejectedData) {
                return Opacity(
                  opacity: candidateData.isNotEmpty ? 0.5 : 1,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    iconColor: Colors.transparent,
                    shape: const BeveledRectangleBorder(),
                    title: Text(
                      getDate(DateTime.now()),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    children: [
                      for (var i in items)
                        LongPressDraggable(
                          axis: Axis.vertical,
                          data: i,
                          // feedback shows widget when dragging
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
                          child: Slidable(
                            key: UniqueKey(),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  onPressed: (value) {},
                                  icon: Icons.edit,
                                ),
                                SlidableAction(
                                  backgroundColor: Colors.red,
                                  onPressed: (value) {},
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            child: dragTile(isSelected, i),
                          ),
                        ),
                      // Add List Tile
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
                );
              },
            ),
            DragTarget(
              onAcceptWithDetails: (data) {
                items.add('akdf');
                setState(() {});
              },
              builder: (context, candidateData, rejectedData) {
                return Opacity(
                  opacity: candidateData.isNotEmpty ? 0.5 : 1,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    shape: const BeveledRectangleBorder(),
                    title: Text(
                      getDate(DateTime.now().add(const Duration(days: 1))),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    children: [
                      for (var i in items) dragTile(isSelected, i),
                    ],
                  ),
                );
              },
            ),
            // Add new date tile
            InkWell(
              onTap: () {},
              child: const ListTile(
                title: Icon(Icons.add),
                subtitle: Text(
                  "Add new date",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}
