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
  void onAccept(
      DragTargetDetails<ToDoTileModel> receivedData, DateTileModel dateTile) {
    context.read<DateListProvider>().onAccept(receivedData, dateTile);
  }

  void onDragComplete(dateTile, event) {
    context.read<DateListProvider>().onDragComplete(dateTile, event);
  }

  void removeDate(DateTileModel dateTile) {
    context.read<DateListProvider>().removeDate(dateTile);
  }

  List tabList = ["New Date", "New Event"];
  DateTime selectedDate = DateTime.now();

  void onCreateDate(bool isEvent, {required BuildContext context1}) {
    if (isEvent) {
      // If date matches with existing date
      context.read<DateListProvider>().addEvent(ToDoTileModel(
          date: selectedDate,
          text: _newEventController.text,
          isChecked: ValueNotifier(false),
          isEditing: ValueNotifier(false)));
      selectedDate = DateTime.now();
      _newEventController.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("New event has been created!")));
    } else {
      for (DateTileModel date
          in Provider.of<DateListProvider>(context, listen: false).dateList) {
        if (getDate(date.date) == getDate(selectedDate)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("This date already exists!"),
          ));
          return;
        }
      }
      context
          .read<DateListProvider>()
          .addDate(DateTileModel(date: selectedDate, events: []));
      selectedDate = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator.adaptive(
        color: Theme.of(context).primaryColor,
        onRefresh: context.read<DateListProvider>().refreshHomeScreen,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              shadowColor: Colors.white,
              elevation: 0,
              surfaceTintColor: Colors.white,
              pinned: true,
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  currentYear.toString(),
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        context.watch<DateListProvider>().dateList.length,
                    itemBuilder: (context, index) {
                      return DateTile(
                        dateTile:
                            context.watch<DateListProvider>().dateList[index],
                        onAccept: onAccept,
                        getDate: getDate,
                        onDragComplete: onDragComplete,
                        isDateToday: isDateToday,
                        removeDate: removeDate,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: onNewEventTap,
        child: const Icon(Icons.add),
      ),
    );
  }
}
