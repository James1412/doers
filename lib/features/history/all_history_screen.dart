import 'package:doers/features/history/history_date_tile.dart';
import 'package:doers/models/date_tile_model.dart';
import 'package:doers/models/todo_tile_model.dart';
import 'package:doers/providers/date_list_provider.dart';
import 'package:doers/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllHistoryScreen extends StatefulWidget {
  const AllHistoryScreen({super.key});

  @override
  State<AllHistoryScreen> createState() => _AllHistoryScreenState();
}

class _AllHistoryScreenState extends State<AllHistoryScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.white,
            pinned: true,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "History",
                style: TextStyle(
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
                  itemCount: context.watch<DateListProvider>().dateList.length,
                  itemBuilder: (context, index) {
                    return HistoryDateTile(
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
      )),
    );
  }
}
