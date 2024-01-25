import 'package:doers/components/drag_tile.dart';
import 'package:doers/models/todo_tile_model.dart';
import 'package:doers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ToDoTileModel> todoList = [
    ToDoTileModel(
        date: DateTime.now(), text: 'hi', isChecked: ValueNotifier(false)),
    ToDoTileModel(
        date: DateTime.now(), text: 'hi', isChecked: ValueNotifier(false)),
    ToDoTileModel(
        date: DateTime.now(), text: 'hi', isChecked: ValueNotifier(false)),
    ToDoTileModel(
        date: DateTime.now(), text: 'hi', isChecked: ValueNotifier(false)),
  ];

  bool showItems = false;

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
                todoList.add(ToDoTileModel(
                    date: DateTime.now(),
                    text: 'added',
                    isChecked: ValueNotifier(false)));
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
                      for (var todoItem in todoList)
                        LongPressDraggable(
                          axis: Axis.vertical,
                          data: todoItem,
                          // feedback shows widget when dragging
                          feedback: SizedBox(
                            width: double.maxFinite,
                            height: 50,
                            child: Material(
                              elevation: 5,
                              shadowColor: Colors.black,
                              child: dragTile(todoItem.isChecked, todoItem.text,
                                  Colors.grey.withOpacity(0.5)),
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
                            child: dragTile(todoItem.isChecked, todoItem.text,
                                Colors.white),
                          ),
                        ),
                      // Add List Tile
                      InkWell(
                        onTap: () {
                          setState(() {
                            todoList.add(ToDoTileModel(
                                date: DateTime.now(),
                                text: '',
                                isChecked: ValueNotifier(false)));
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
              onAcceptWithDetails: (data) {},
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
                      for (var todoItem in todoList)
                        dragTile(
                            todoItem.isChecked, todoItem.text, Colors.white),
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
