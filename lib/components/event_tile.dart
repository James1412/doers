// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:animated_line_through/animated_line_through.dart';
import 'package:doers/models/date_tile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:vibration/vibration.dart';

class EventTile extends StatefulWidget {
  final ValueNotifier<bool> isSelected;
  String text;
  final Color tileColor;
  final int index;
  final ValueNotifier<bool> isEditing;
  final DateTileModel dateTile;
  final TextEditingController controller;
  final Function onSubmitted;
  EventTile(
      {super.key,
      required this.isSelected,
      required this.text,
      required this.tileColor,
      required this.index,
      required this.isEditing,
      required this.dateTile,
      required this.controller,
      required this.onSubmitted});

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  Future<bool> onCheckTap(value, isSelected) async {
    //Vibration
    if (Platform.isAndroid) {
      if (await Vibration.hasVibrator() != null &&
          await Vibration.hasVibrator() == true) {
        Vibration.vibrate(duration: 100);
      }
    } else if (Platform.isIOS) {
      HapticFeedback.mediumImpact();
    }
    isSelected.value = !isSelected.value;
    return isSelected.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.isEditing,
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
              onTap: (value) => onCheckTap(value, widget.isSelected),
              animationDuration: const Duration(milliseconds: 700),
              likeBuilder: (isLiked) {
                return Icon(
                  isLiked ? Icons.check_box : Icons.check_box_outline_blank,
                  color: isLiked ? Colors.blue : null,
                  size: 25,
                );
              },
            ),
          ),
          title: widget.isEditing.value
              ? TextField(
                  autocorrect: false,
                  controller: widget.controller,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                  onTapOutside: (event) {
                    widget.isEditing.value = false;
                    widget.controller.clear();
                  },
                  onSubmitted: (value) =>
                      widget.onSubmitted(value, widget.isEditing, widget.index),
                )
              : AnimatedLineThrough(
                  strokeWidth: 1.0,
                  isCrossed: widget.isSelected.value,
                  duration: const Duration(milliseconds: 100),
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
          trailing: ReorderableDragStartListener(
            index: widget.index,
            child: const Icon(Icons.drag_handle),
          ),
        ),
      ),
    );
  }
}
