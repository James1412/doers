import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NewBottomSheet extends StatefulWidget {
  DateTime selectedDate;
  final List tabList;
  final Function onCreateDate;
  final Function onDateTimeChanged;
  final TextEditingController controller;
  NewBottomSheet(
      {super.key,
      required this.selectedDate,
      required this.tabList,
      required this.onCreateDate,
      required this.onDateTimeChanged,
      required this.controller});

  @override
  State<NewBottomSheet> createState() => _NewBottomSheetState();
}

class _NewBottomSheetState extends State<NewBottomSheet> {
  //TODO: Add not just date, but also time and notification time where user can decide
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusManager.instance.primaryFocus != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DefaultTabController(
          length: widget.tabList.length,
          child: Column(
            children: [
              SizedBox(
                height: 80,
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
              Expanded(
                child: TabBarView(
                  children: [
                    // First Tab
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  widget.onCreateDate(false, context1: context),
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            controller: widget.controller,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                                hintText: "Your event goes here",
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor)),
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
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  widget.onCreateDate(true, context1: context),
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
    );
  }
}
