import 'package:flexi_box/src/models/flexi_state.dart';

class FlexiInfoOpt {
  final FlexiAlignment scaleDirection;
  final double x;
  final double y;
  final double rotateAngle;

  const FlexiInfoOpt({
    required this.scaleDirection,
    required this.x,
    required this.y,
    required this.rotateAngle,
  });
}

class FlexiInfo {
  final double width;
  final double height;
  final double x;
  final double y;

  const FlexiInfo({
    required this.width,
    required this.height,
    required this.x,
    required this.y,
  });

  FlexiInfo copyWith({
    double? width,
    double? height,
    double? x,
    double? y,
  }) {
    return FlexiInfo(
      width: width ?? this.width,
      height: height ?? this.height,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['width'] = width;
    map['height'] = height;
    map['x'] = x;
    map['y'] = y;
    return map;
  }
}
