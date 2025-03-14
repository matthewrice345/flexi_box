import 'package:flexi_box/src/models/flexi_state.dart';
import 'package:flutter/material.dart';

class FlexiController extends ChangeNotifier {
  FlexiController({
    required Size initialSize,
    required Offset initialOffset,
    required double initialRotation,
    FlexiState? state,
    bool fixedAspectRatio = false,
    bool initialMoveEnabled = true,
    bool initialScaleEnabled = true,
    Size? minSize,
    double distanceThreshold = 0.05,
  })  : _fixedAspectRatio = fixedAspectRatio,
        _moveEnabled = initialMoveEnabled,
        _scaleEnabled = initialScaleEnabled,
        _minSize = minSize ?? const Size(100, 100),
        _distanceThreshold = distanceThreshold,
        _state = state ??
            FlexiState(
              offset: initialOffset,
              size: initialSize,
              rotation: initialRotation,
            ), assert(distanceThreshold >= 0 && distanceThreshold <= 0.5);

  late FlexiState _state;

  double get rotation => _state.rotation;

  Offset get offset => _state.offset;

  Size get size => _state.size;

  bool get scaleEnabled => _scaleEnabled;
  bool _scaleEnabled = true;

  set scaleEnabled(bool value) {
    _scaleEnabled = value;
    notifyListeners();
  }

  bool get moveEnabled => _moveEnabled;
  bool _moveEnabled = true;

  set moveEnabled(bool value) {
    _moveEnabled = value;
    notifyListeners();
  }

  double get distanceThreshold => _distanceThreshold;
  double _distanceThreshold = 0.05;

  set distanceThreshold(double value) {
    _distanceThreshold = value;
    notifyListeners();
  }

  void updateData({Offset? offset, Size? size, Degree? rotation, bool notify = true}) {
    _state = _state.copyWith(
      offset: offset ?? _state.offset,
      size: _clampMinSize(size ?? _state.size),
      rotation: rotation ?? _state.rotation,
    );
    if (notify) {
      notifyListeners();
    }
  }

  bool get fixedAspectRatio => _fixedAspectRatio;
  final bool _fixedAspectRatio;

  Size get minSize => _minSize;
  late final Size _minSize;

  Size _clampMinSize(Size size) {
    if(fixedAspectRatio) {
      // limit the size from going below the minSize while maintaining the aspect ratio of currentSize
      final currentSize = _state.size;
      final aspectRatio = currentSize.aspectRatio;
      final minSize = _minSize;
      return Size(
        size.width.clamp(minSize.width, double.infinity),
        size.width / aspectRatio,
      );
    } else {
      return Size(
        size.width.clamp(_minSize.width, double.infinity),
        size.height.clamp(_minSize.height, double.infinity),
      );
    }
  }
}
