import 'package:doers/features/upcoming/date_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NewBottomSheet extends StatefulWidget {
  DateTime selectedDate;
  final List tabList;
  final Function onCreateDate;
  final Function onDateTimeChanged;
  final TextEditingController controller;
  final Function resetSelectedDate;
  NewBottomSheet(
      {super.key,
      required this.selectedDate,
      required this.tabList,
      required this.onCreateDate,
      required this.onDateTimeChanged,
      required this.controller,
      required this.resetSelectedDate});

  @override
  State<NewBottomSheet> createState() => _NewBottomSheetState();
}

class _NewBottomSheetState extends State<NewBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: GestureDetector(
          onTap: () {
            if (FocusManager.instance.primaryFocus != null) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: DefaultTabController(
            length: widget.tabList.length,
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: TabBar(
                    splashFactory: NoSplash.splashFactory,
                    labelColor: Theme.of(context).primaryColor,
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: [
                      for (var tab in widget.tabList)
                        Text(
                          tab,
                          style: const TextStyle(fontSize: 17),
                        )
                    ],
                  ),
                ),
                SizedBox(
                  height: 350,
                  child: TabBarView(
                    children: [
                      // First Tab
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 180,
                            child: CupertinoDatePicker(
                              minimumDate: DateTime.now(),
                              onDateTimeChanged: (date) =>
                                  widget.onDateTimeChanged(date),
                              mode: CupertinoDatePickerMode.date,
                              showDayOfWeek: true,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: double.maxFinite,
                            height: 30,
                            color:
                                context.watch<DateListProvider>().isDeclinedDate
                                    ? Colors.red.shade500
                                    : Colors.transparent,
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  Text(
                                    "This date already exists",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<DateListProvider>()
                                      .setDeclinedDate(false);
                                  widget.resetSelectedDate();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => widget.onCreateDate(false,
                                    context1: context),
                                child: Text(
                                  "Create",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Second Tab
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 180,
                            child: CupertinoDatePicker(
                              minimumDate: DateTime.now(),
                              onDateTimeChanged: (date) =>
                                  widget.onDateTimeChanged(date),
                              mode: CupertinoDatePickerMode.dateAndTime,
                              showDayOfWeek: true,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextField(
                              controller: widget.controller,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                  hintText: "Your event goes here",
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor))),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  widget.controller.clear();
                                  context
                                      .read<DateListProvider>()
                                      .setDeclinedDate(false);
                                  widget.resetSelectedDate();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => widget.onCreateDate(true,
                                    context1: context),
                                child: Text(
                                  "Create",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
