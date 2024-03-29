import 'dart:ui';

import 'package:flutter/material.dart';

Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final double curve = Curves.easeInOut.transform(animation.value);
      final double opacity = lerpDouble(1, 0.5, curve)!;
      final double elevation = lerpDouble(0, 2, curve)!;
      return Opacity(
        opacity: opacity,
        child: Material(
          elevation: elevation,
          child: child,
        ),
      );
    },
    child: child,
  );
}
