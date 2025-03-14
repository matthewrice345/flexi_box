import 'dart:ui';

import 'package:equatable/equatable.dart';

class FlexiSnap extends Equatable {
  const FlexiSnap({
    this.position = const FlexiSnapValue(),
    this.size = const FlexiSnapValue(),
  });

  final FlexiSnapValue position;
  final FlexiSnapValue size;

  @override
  List<Object?> get props => [
        position,
        size,
      ];

  Size calculateSnapSize({
    required double prevWidth,
    required double prevHeight,
    required double width,
    required double height,
  }) {
    if(size.snap) {
      // TODO:
      return Size(width, height);
    } else {
      return Size(width, height);
    }
  }

  Offset calculateSnapPosition({
    required double prevX,
    required double prevY,
    required double x,
    required double y,
  }) {
    if(position.snap) {
      // TODO:
      return Offset(x, y);
    } else {
      return Offset(x, y);
    }
  }
}

class FlexiSnapValue extends Equatable {
  const FlexiSnapValue({
    this.snap = false,
    this.value = 1,
  });

  final bool snap;
  final double value;

  @override
  List<Object?> get props => [snap, value];
}
