import 'dart:math';

import 'package:flexi_box/src/models/flexi_data.dart';
import 'package:flexi_box/src/models/flexi_snap.dart';
import 'package:flexi_box/src/models/flexi_state.dart';
import 'package:flutter/material.dart';

/// A helper that handles scaling stuff
class FlexiHelper {
  ///
  /// Get new size and position based on [options].
  /// - [current]: The size, position before scaling.
  ///
  /// Scale widget from corners calculation
  ///
  /// ref: https://stackoverflow.com/a/60964980
  /// Author: @Kherel
  ///
  static FlexiInfo getScaleInfo({
    required FlexiInfo current,
    required FlexiInfoOpt options,
    required bool fixedAspectRatio,
  }) {
    final double dx = options.x;
    final double dy = options.y;
    final double rotateAngle = options.rotateAngle;
    final aspectRatio = current.width / current.height;

    double updatedWidth = current.width;
    double updatedHeight = current.height;
    double updatedXPosition = current.x;
    double updatedYPosition = current.y;

    ///
    /// Rotational offset
    /// - Fix x, y position after scaling if rotated
    ///
    /// https://stackoverflow.com/a/73930511
    /// Author: @Steve
    ///
    switch (options.scaleDirection) {
      case FlexiAlignment.centerLeft:
        // left
        var rotationalOffset = Offset(
              cos(rotateAngle) + 1, // x
              sin(rotateAngle), // y
            ) *
            dx /
            2;
        updatedXPosition += rotationalOffset.dx;
        updatedYPosition += rotationalOffset.dy;

        if (fixedAspectRatio) {
          double newHeight = updatedHeight - dx;
          updatedHeight = newHeight > 0 ? newHeight : 0;
          updatedWidth = updatedHeight * aspectRatio;
        } else {
          double newWidth = updatedWidth - dx;
          updatedWidth = newWidth > 0 ? newWidth : 0;
        }
        break;

      case FlexiAlignment.centerRight:
        // right
        var rotationalOffset = Offset(
              cos(rotateAngle) - 1, // x
              sin(rotateAngle), // y
            ) *
            dx /
            2;

        if (fixedAspectRatio) {
          double newHeight = updatedHeight + dx;
          updatedHeight = newHeight > 0 ? newHeight : 0;
          updatedWidth = updatedHeight * aspectRatio;
        } else {
          updatedXPosition += rotationalOffset.dx;
          updatedYPosition += rotationalOffset.dy;
        }
        break;
      case FlexiAlignment.topLeft:
        // region topLeft
        if (fixedAspectRatio) {
          // Calculate the bottom-right corner before resizing
          final bottomRightX = updatedXPosition + updatedWidth;
          final bottomRightY = updatedYPosition + updatedHeight;

          // Update width and height while maintaining aspect ratio
          if (fixedAspectRatio) {
            final newWidth = updatedWidth - dx;
            updatedWidth = newWidth > 0 ? newWidth : 0;
            updatedHeight = updatedWidth / aspectRatio;
          } else {
            final newWidth = updatedWidth - dx;
            final newHeight = updatedHeight - dy;
            updatedWidth = newWidth > 0 ? newWidth : 0;
            updatedHeight = newHeight > 0 ? newHeight : 0;
          }

          // Recalculate the top-left position to keep the bottom-right corner fixed
          updatedXPosition = bottomRightX - updatedWidth;
          updatedYPosition = bottomRightY - updatedHeight;
        } else {
          // left
          var rotationalOffset = Offset(cos(rotateAngle) + 1, sin(rotateAngle)) * dx / 2;
          // top
          var rotationalOffset2 = Offset(-sin(rotateAngle), cos(rotateAngle) + 1) * dy / 2;

          updatedXPosition += rotationalOffset.dx + rotationalOffset2.dx;
          updatedYPosition += rotationalOffset.dy + rotationalOffset2.dy;

          double newHeight = updatedHeight -= dy;
          updatedHeight = newHeight > 0 ? newHeight : 0;
          double newWidth = updatedWidth - dx;
          updatedWidth = newWidth > 0 ? newWidth : 0;
        }
        // endregion
        break;
      case FlexiAlignment.topCenter:
        // region topCenter
        // top
        var rotationalOffset = Offset(-sin(rotateAngle), cos(rotateAngle) + 1) * dy / 2;

        updatedXPosition += rotationalOffset.dx;
        updatedYPosition += rotationalOffset.dy;

        if (fixedAspectRatio) {
          double newHeight = updatedHeight - dy;
          updatedHeight = newHeight > 0 ? newHeight : 0;
          updatedWidth = updatedHeight * aspectRatio;
        } else {
          double newHeight = updatedHeight -= dy;
          updatedHeight = newHeight > 0 ? newHeight : 0;
        }
        // endregion
        break;
      case FlexiAlignment.topRight:
        // region topRight
        // right
        var rotationalOffset = Offset(cos(rotateAngle) - 1, sin(rotateAngle)) * dx / 2;
        // top
        var rotationalOffset2 = Offset(-sin(rotateAngle), cos(rotateAngle) + 1) * dy / 2;

        updatedXPosition += rotationalOffset.dx + rotationalOffset2.dx;
        updatedYPosition += rotationalOffset.dy + rotationalOffset2.dy;

        if (fixedAspectRatio) {
          double newHeight = updatedHeight - dy;
          updatedHeight = newHeight > 0 ? newHeight : 0;
          updatedWidth = updatedHeight * aspectRatio;
        } else {
          double newHeight = updatedHeight -= dy;
          double newWidth = updatedWidth + dx;
          updatedHeight = newHeight > 0 ? newHeight : 0;
          updatedWidth = newWidth > 0 ? newWidth : 0;
        }
        // endregion
        break;
      case FlexiAlignment.bottomLeft:
        // region bottomLeft
        // left
        var rotationalOffset = Offset(cos(rotateAngle) + 1, sin(rotateAngle)) * dx / 2;
        // bottom
        var rotationalOffset2 = Offset(-sin(rotateAngle), cos(rotateAngle) - 1) * dy / 2;

        if (fixedAspectRatio) {
          double newWidth = updatedWidth - dx;
          updatedWidth = newWidth > 0 ? newWidth : 0;
          updatedHeight = updatedWidth / aspectRatio;

          updatedXPosition += rotationalOffset.dx + rotationalOffset2.dx;
          updatedYPosition += rotationalOffset.dy + rotationalOffset2.dy;
        } else {
          double newHeight = updatedHeight + dy;
          double newWidth = updatedWidth - dx;
          updatedWidth = newWidth > 0 ? newWidth : 0;
          updatedHeight = newHeight > 0 ? newHeight : 0;

          updatedXPosition += rotationalOffset.dx + rotationalOffset2.dx;
          updatedYPosition += rotationalOffset.dy + rotationalOffset2.dy;
        }
        // endregion
        break;
      case FlexiAlignment.bottomCenter:
        // region bottomCenter
        // bottom
        var rotationalOffset = Offset(-sin(rotateAngle), cos(rotateAngle) - 1) * dy / 2;

        updatedXPosition += rotationalOffset.dx;
        updatedYPosition += rotationalOffset.dy;

        if (fixedAspectRatio) {
          double newHeight = updatedHeight + dy;
          updatedHeight = newHeight > 0 ? newHeight : 0;
          updatedWidth = updatedHeight * aspectRatio;
        } else {
          double newHeight = updatedHeight + dy;
          updatedHeight = newHeight > 0 ? newHeight : 0;
        }
        // endregion
        break;
      case FlexiAlignment.bottomRight:
        // region bottomRight
        // right
        var rotationalOffset = Offset(cos(rotateAngle) - 1, sin(rotateAngle)) * dx / 2;
        // bottom
        var rotationalOffset2 = Offset(-sin(rotateAngle), cos(rotateAngle) - 1) * dy / 2;

        updatedXPosition += rotationalOffset.dx + rotationalOffset2.dx;
        updatedYPosition += rotationalOffset.dy + rotationalOffset2.dy;

        if (fixedAspectRatio) {
          double newHeight = updatedHeight + dy;
          updatedHeight = newHeight > 0 ? newHeight : 0;
          updatedWidth = updatedHeight * aspectRatio;
        } else {
          double newHeight = updatedHeight + dy;
          double newWidth = updatedWidth + dx;
          updatedWidth = newWidth > 0 ? newWidth : 0;
          updatedHeight = newHeight > 0 ? newHeight : 0;
        }
        // endregion
        break;
      default:
    }

    return FlexiInfo(
      width: updatedWidth,
      height: updatedHeight,
      x: updatedXPosition,
      y: updatedYPosition,
    );
  }

  static FlexiInfo? calculateNewSize(
    DragUpdateDetails details,
    FlexiAlignment alignment, {
    required Size size,
    required Offset offset,
    required Degree rotation,
    required bool fixedAspectRatio,
    required Size minSize,
    required FlexiSnap snap,
  }) {
    final scaleInfoAfterCalculation = FlexiHelper.getScaleInfo(
      current: FlexiInfo(
        width: size.width,
        height: size.height,
        x: offset.dx,
        y: offset.dy,
      ),
      options: FlexiInfoOpt(
        scaleDirection: alignment,
        x: details.delta.dx,
        y: details.delta.dy,
        rotateAngle: degreeToRadians(rotation),
      ),
      fixedAspectRatio: fixedAspectRatio,
    );

    return FlexiInfo(
      width: max(minSize.width, scaleInfoAfterCalculation.width),
      height: max(minSize.height, scaleInfoAfterCalculation.height),
      x: scaleInfoAfterCalculation.x,
      y: scaleInfoAfterCalculation.y,
    );
  }

  static Offset calculateNewOffset(DragUpdateDetails details, Offset offset) {
    // Handles moving the widget
    double updatedXPosition = offset.dx;
    double updatedYPosition = offset.dy;

    updatedXPosition += (details.delta.dx);
    updatedYPosition += (details.delta.dy);

    return Offset(updatedXPosition, updatedYPosition);
  }

  static double degreeToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
