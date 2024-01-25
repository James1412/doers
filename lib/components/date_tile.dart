import 'package:doers/components/event_tile.dart';
import 'package:doers/components/proxy_decoration.dart';
import 'package:doers/models/date_tile_model.dart';
import 'package:doers/models/todo_tile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DateTile extends StatefulWidget {
  final List<DateTileModel> dateList;
  final DateTileModel dateTile;
  final Function onAccept;
  final Function getDate;
  final Function onDragComplete;
  final Function isDateToday;
  final Function removeDate;
  const DateTile(
      {super.key,
      required this.dateTile,
      required this.onAccept,
      required this.getDate,
      required this.onDragComplete,
      required this.dateList,
      required this.isDateToday,
      required this.removeDate});

  @override
  State<DateTile> createState() => _DateTileState();
}

class _DateTileState extends State<DateTile> {
  final TextEditingController _controller = TextEditingController();
  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = widget.dateTile.events.removeAt(oldIndex);
      widget.dateTile.events.insert(newIndex, item);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSubmitted(String value, ValueNotifier<bool> isEditing, int index) {
    isEditing.value = false;
    setState(() {
      widget.dateTile.events[index].text = value;
    });
    _controller.clear();
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
                  onReorder: onReorder,
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
                            height: 50,
                            child: Material(
                              shadowColor: Colors.black,
                              child: EventTile(
                                  onSubmitted: onSubmitted,
                                  controller: _controller,
                                  dateTile: widget.dateTile,
                                  isSelected: event.isChecked,
                                  text: event.text,
                                  tileColor: Colors.grey.withOpacity(0.5),
                                  index: widget.dateTile.events.indexOf(event),
                                  isEditing: event.isEditing),
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
                                  onPressed: (value) {},
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
                                text: event.text,
                                tileColor: Colors.white,
                                index: widget.dateTile.events.indexOf(event),
                                isEditing: event.isEditing),
                          ),
                        ),
                      ),
                  ],
                ),
                // Add List Tile
                InkWell(
                  key: UniqueKey(),
                  onTap: () {
                    setState(() {
                      widget.dateTile.events.add(ToDoTileModel(
                          isEditing: ValueNotifier(true),
                          date: DateTime.now(),
                          text: '',
                          isChecked: ValueNotifier(false)));
                    });
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
