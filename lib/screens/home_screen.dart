import 'package:doers/components/date_tile.dart';
import 'package:doers/components/new_bottom_sheet.dart';
import 'package:doers/models/date_tile_model.dart';
import 'package:doers/models/todo_tile_model.dart';
import 'package:doers/providers/date_list_provider.dart';
import 'package:doers/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDraggedToSameDate = false;

  void onAccept(
      DragTargetDetails<ToDoTileModel> receivedData, DateTileModel dateTile) {
    print(getDate(receivedData.data.date));
    print(getDate(dateTile.date));
    if (getDate(receivedData.data.date) == getDate(dateTile.date)) {
      isDraggedToSameDate = true;
      setState(() {});
      return;
    } else {
      setState(() {
        isDraggedToSameDate = false;
        receivedData.data.date = dateTile.date;
        dateTile.events.add(receivedData.data);
      });
    }
  }

  void onDragComplete(dateTile, event) {
    if (isDraggedToSameDate) return;
    setState(() {
      dateTile.events.remove(event);
    });
  }

  void removeDate(DateTileModel dateTile) {
    context.read<DateListProvider>().removeDate(dateTile);
  }

  List tabList = ["New Date", "New Event"];
  DateTime selectedDate = DateTime.now();

  void onCreateDate(bool isEvent, {required BuildContext context1}) {
    for (DateTileModel date
        in Provider.of<DateListProvider>(context, listen: false).dateList) {
      if (getDate(date.date) == getDate(selectedDate)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("This date already exists!"),
        ));
        return;
      }
    }
    if (isEvent) {
      final newEvent = _newEventController.text;
      setState(() {
        context.read<DateListProvider>().addDate(
              DateTileModel(date: selectedDate, events: [
                ToDoTileModel(
                    date: selectedDate,
                    text: newEvent,
                    isChecked: ValueNotifier(false),
                    isEditing: ValueNotifier(false))
              ]),
            );
        selectedDate = DateTime.now();
        _newEventController.clear();
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("New event has been created!")));
    } else {
      setState(() {
        context
            .read<DateListProvider>()
            .addDate(DateTileModel(date: selectedDate, events: []));
        selectedDate = DateTime.now();
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("New date has been created!")));
    }
  }

  final TextEditingController _newEventController = TextEditingController();
  void onNewEventTap() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        height: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.hardEdge,
        child: Scaffold(
          body: NewBottomSheet(
            controller: _newEventController,
            onDateTimeChanged: onDateTimeChanged,
            selectedDate: selectedDate,
            tabList: tabList,
            onCreateDate: onCreateDate,
          ),
        ),
      ),
    );
  }

  void onDateTimeChanged(value) {
    selectedDate = value;
    setState(() {});
  }

  @override
  void dispose() {
    _newEventController.dispose();
    super.dispose();
  }

  int currentYear = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              dense: true,
              title: Text(
                currentYear.toString(),
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: context.watch<DateListProvider>().dateList.length,
              itemBuilder: (context, index) {
                return DateTile(
                  dateTile: context.watch<DateListProvider>().dateList[index],
                  onAccept: onAccept,
                  getDate: getDate,
                  onDragComplete: onDragComplete,
                  isDateToday: isDateToday,
                  removeDate: removeDate,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorLight,
        splashColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: onNewEventTap,
        child: const Icon(Icons.add),
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
