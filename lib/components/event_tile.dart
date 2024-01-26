// ignore_for_file: must_be_immutable
import 'package:animated_line_through/animated_line_through.dart';
import 'package:doers/models/date_tile_model.dart';
import 'package:doers/models/todo_tile_model.dart';
import 'package:doers/providers/date_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class EventTile extends StatefulWidget {
  final ValueNotifier<bool> isSelected;
  ToDoTileModel event;
  final Color tileColor;
  final int index;
  final DateTileModel dateTile;
  final TextEditingController controller;
  final Function onSubmitted;
  EventTile(
      {super.key,
      required this.isSelected,
      required this.event,
      required this.tileColor,
      required this.index,
      required this.dateTile,
      required this.controller,
      required this.onSubmitted});

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  Future<bool> onCheckTap(value, dateTileModel, event) async {
    return await context.read<DateListProvider>().onCheckTap(event);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.event.isEditing,
      builder: (context, value, child) => ValueListenableBuilder(
        valueListenable: widget.isSelected,
        builder: (context, value, child) => ListTile(
          dense: true,
          tileColor: widget.tileColor,
          horizontalTitleGap: BorderSide.strokeAlignCenter,
          leading: SizedBox(
            width: 40,
            height: 40,
            child: LikeButton(
              isLiked: widget.isSelected.value,
              onTap: (value) =>
                  onCheckTap(value, widget.dateTile, widget.event),
              animationDuration: const Duration(milliseconds: 700),
              likeBuilder: (isLiked) {
                return Icon(
                  isLiked ? Icons.check_box : Icons.check_box_outline_blank,
                  color: isLiked ? Theme.of(context).primaryColor : null,
                  size: 25,
                );
              },
            ),
          ),
          title: widget.event.isEditing.value
              ? TextField(
                  autocorrect: false,
                  controller: widget.controller,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                  onTapOutside: (event) {
                    widget.event.isEditing.value = false;
                    widget.controller.clear();
                  },
                  onSubmitted: (value) =>
                      widget.onSubmitted(value, widget.event, widget.index),
                )
              : AnimatedLineThrough(
                  strokeWidth: 1.0,
                  isCrossed: widget.isSelected.value,
                  duration: const Duration(milliseconds: 100),
                  child: Text(
                    widget.event.text,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
          subtitle: Text(DateFormat.jm().format(widget.event.date)),
          trailing: ReorderableDragStartListener(
            index: widget.index,
            child: const Icon(Icons.drag_handle),
          ),
        ),
      ),
    );
  }
}
