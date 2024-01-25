import 'package:animated_line_through/animated_line_through.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

Widget dragTile(ValueNotifier<bool> isSelected, String i) {
  return ValueListenableBuilder(
    valueListenable: isSelected,
    builder: (context, value, child) => ListTile(
      dense: true,
      tileColor: Colors.white,
      horizontalTitleGap: BorderSide.strokeAlignCenter,
      leading: SizedBox(
        width: 40,
        height: 40,
        child: LikeButton(
          isLiked: isSelected.value,
          onTap: (value) async {
            isSelected.value = !isSelected.value;
            return isSelected.value;
          },
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
            fontSize: 17,
          ),
        ),
      ),
    ),
  );
}
