import 'dart:ui';

import 'package:equatable/equatable.dart';

typedef Degree = double;

enum FlexiAlignment {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

class FlexiState extends Equatable {
  const FlexiState({
    required this.offset,
    required this.size,
    required this.rotation,
  });

  final Offset offset;
  final Size size;
  final Degree rotation;

  FlexiState copyWith({
    Offset? offset,
    Size? size,
    Degree? rotation,
  }) {
    return FlexiState(
      offset: offset ?? this.offset,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  List<Object> get props => [offset, size, rotation];
}
