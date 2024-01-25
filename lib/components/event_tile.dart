import 'dart:io';

import 'package:animated_line_through/animated_line_through.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:vibration/vibration.dart';

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

Widget dragTile(
    ValueNotifier<bool> isSelected, String i, Color tileColor, index) {
  return ValueListenableBuilder(
    valueListenable: isSelected,
    builder: (context, value, child) => ListTile(
      dense: true,
      tileColor: tileColor,
      horizontalTitleGap: BorderSide.strokeAlignCenter,
      leading: SizedBox(
        width: 40,
        height: 40,
        child: LikeButton(
          isLiked: isSelected.value,
          onTap: (value) => onCheckTap(value, isSelected),
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
      title: AnimatedLineThrough(
        strokeWidth: 1.0,
        isCrossed: isSelected.value,
        duration: const Duration(milliseconds: 100),
        child: Text(
          i,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      trailing: ReorderableDragStartListener(
        index: index,
        child: const Icon(Icons.drag_handle),
      ),
    ),
  );
}
