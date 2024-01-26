import 'package:doers/components/event_tile.dart';
import 'package:doers/components/proxy_decoration.dart';
import 'package:doers/models/date_tile_model.dart';
import 'package:doers/models/todo_tile_model.dart';
import 'package:doers/providers/date_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class DateTile extends StatefulWidget {
  final DateTileModel dateTile;
  final Function onAccept;
  final Function getDate;
  final Function onDragComplete;
  final Function isDateToday;
  final Function removeDate;
  const DateTile({
    super.key,
    required this.dateTile,
    required this.onAccept,
    required this.getDate,
    required this.onDragComplete,
    required this.isDateToday,
    required this.removeDate,
  });

  @override
  State<DateTile> createState() => _DateTileState();
}

class _DateTileState extends State<DateTile> {
  final TextEditingController _controller = TextEditingController();

  void onReorder(int oldIndex, int newIndex, DateTileModel dateTile) {
    context.read<DateListProvider>().onReorder(oldIndex, newIndex, dateTile);
  }

  @override
  void dispose() {
    _controller.dispose();
    _editingController.dispose();
    super.dispose();
  }

  void onSubmitted(String value, ToDoTileModel event, int index) {
    context
        .read<DateListProvider>()
        .onSubmittedTap(event, value, widget.dateTile, index);
    _controller.clear();
  }

  final TextEditingController _editingController = TextEditingController();

  void onEditTap(value, ToDoTileModel event) {
    DateTime selectedDate = event.date;
    _editingController.text = event.text;
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            if (FocusManager.instance.primaryFocus != null) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: Dialog(
            insetPadding:
                const EdgeInsets.symmetric(vertical: 250, horizontal: 30),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _editingController,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        )),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 130,
                  child: CupertinoDatePicker(
                    initialDateTime: event.date,
                    onDateTimeChanged: (value) {
                      setState(() {
                        selectedDate = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<DateListProvider>().removeEvent(event);
                        event.date = selectedDate;
                        event.text = _editingController.text;
                        context.read<DateListProvider>().addEvent(event);
                        _editingController.clear();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Apply",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onAcceptWithDetails: (DragTargetDetails<ToDoTileModel> details) =>
          widget.onAccept(details, widget.dateTile),
      builder: (context, candidateData, rejectedData) {
        return Opacity(
          opacity: candidateData.isNotEmpty ? 0.5 : 1,
          child: Slidable(
            key: UniqueKey(),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  backgroundColor: Colors.red,
                  onPressed: (value) => widget.removeDate(widget.dateTile),
                  icon: Icons.delete,
                ),
              ],
            ),
            child: ExpansionTile(
              dense: true,
              initiallyExpanded: true,
              iconColor: widget.isDateToday(widget.dateTile.date)
                  ? Colors.transparent
                  : null,
              shape: const BeveledRectangleBorder(),
              title: Text(
                widget.getDate(widget.dateTile.date),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              children: [
                ReorderableListView(
                  proxyDecorator: proxyDecorator,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  onReorder: (oldIndex, newIndex) =>
                      onReorder(oldIndex, newIndex, widget.dateTile),
                  children: [
                    for (ToDoTileModel event in widget.dateTile.events)
                      InkWell(
                        key: UniqueKey(),
                        onTap: () {
                          event.isEditing.value = !event.isEditing.value;
                          _controller.text = event.text;
                        },
                        child: LongPressDraggable(
                          onDragCompleted: () =>
                              widget.onDragComplete(widget.dateTile, event),
                          axis: Axis.vertical,
                          data: event,
                          // feedback shows widget when dragging
                          feedback: SizedBox(
                            width: double.maxFinite,
                            height: 60,
                            child: Material(
                              shadowColor: Colors.black,
                              child: EventTile(
                                onSubmitted: onSubmitted,
                                controller: _controller,
                                dateTile: widget.dateTile,
                                isSelected: event.isChecked,
                                event: event,
                                tileColor: Colors.grey.withOpacity(0.5),
                                index: widget.dateTile.events.indexOf(event),
                              ),
                            ),
                          ),
                          // regular child when not dragged
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  onPressed: (value) => onEditTap(value, event),
                                  icon: Icons.edit,
                                ),
                                SlidableAction(
                                  backgroundColor: Colors.red,
                                  onPressed: (value) {
                                    setState(() {
                                      widget.dateTile.events.remove(event);
                                    });
                                  },
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            child: EventTile(
                              onSubmitted: onSubmitted,
                              controller: _controller,
                              dateTile: widget.dateTile,
                              isSelected: event.isChecked,
                              event: event,
                              tileColor: Colors.white,
                              index: widget.dateTile.events.indexOf(event),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                // Add List Tile
                InkWell(
                  key: UniqueKey(),
                  onTap: () {
                    context.read<DateListProvider>().addEvent(ToDoTileModel(
                        isEditing: ValueNotifier(true),
                        date: widget.dateTile.date,
                        text: '',
                        isChecked: ValueNotifier(false)));
                  },
                  child: const ListTile(
                    dense: true,
                    title: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
