import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:flexi_box/flexi_box.dart';

void main() {
  test('adds one to input values', () {
    final state = FlexiState(
      offset: Offset.zero,
      size: Size.zero,
      rotation: 0,
    );
    expect(state.rotation, 0);
    expect(state.offset.dx, 0);
    expect(state.offset.dy, 0);
    expect(state.size.width, 0);
    expect(state.size.height, 0);
  });
}
