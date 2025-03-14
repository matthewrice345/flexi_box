import 'package:flexi_box/src/flexi_controller.dart';
import 'package:flexi_box/src/models/flexi_helper.dart';
import 'package:flexi_box/src/models/flexi_state.dart';
import 'package:flutter/material.dart';

typedef HandleBuilder = Widget Function(BuildContext, FlexiAlignment);

class FlexiBox extends StatefulWidget {
  const FlexiBox({
    super.key,
    required this.child,
    required this.handleBuilder,
    this.initialSize,
    this.controller,
    this.initialOffset = Offset.zero,
    this.initialRotation = 0,
    this.clip = Clip.none,
  }) : assert(initialSize != null || controller != null, 'initialSize or controller must be provided');

  final Widget child;
  final HandleBuilder handleBuilder;

  final Size? initialSize;
  final Offset initialOffset;
  final Degree initialRotation;
  final Clip clip;
  final FlexiController? controller;

  @override
  State<FlexiBox> createState() => _FlexiBoxState();
}

class _FlexiBoxState extends State<FlexiBox> {
  late FlexiController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        FlexiController(
          initialSize: widget.initialSize!,
          initialOffset: widget.initialOffset,
          initialRotation: widget.initialRotation,
        );
  }

  @override
  Widget build(BuildContext context) {
    // GestureItem > PositionedItem > RotationItem > ScalableItem

    return ClipRRect(
      clipBehavior: widget.clip,
      child: GestureItem(
        onPanUpdate: (details) {
          if (controller.moveEnabled) {
            final updatedOffset = FlexiHelper.calculateNewOffset(details, controller.offset);
            // Prevents small movements from being registered as a drag
            if(updatedOffset.dx < 2 || updatedOffset.dy < 2) return;
            controller.updateData(offset: updatedOffset);
          }
        },
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            return PositionedItem(
              controller: controller,
              child: RotationItem(
                controller: controller,
                child: ScalableItem(
                  onBottomRightDrag: (details) => _handleDragChanges(details, FlexiAlignment.bottomRight),
                  onTopRightDrag: (details) => _handleDragChanges(details, FlexiAlignment.topRight),
                  onTopLeftDrag: (details) => _handleDragChanges(details, FlexiAlignment.topLeft),
                  onBottomLeftDrag: (details) => _handleDragChanges(details, FlexiAlignment.bottomLeft),
                  handleBuilder: widget.handleBuilder,
                  controller: controller,
                  child: child!,
                ),
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }

  void _handleDragChanges(DragUpdateDetails details, FlexiAlignment alignment) {
    final changes = FlexiHelper.calculateNewSize(
      details,
      alignment,
      offset: controller.offset,
      size: controller.size,
      rotation: controller.rotation,
      fixedAspectRatio: controller.fixedAspectRatio,
      minSize: controller.minSize,
      snap: controller.snap,
    );

    if (changes != null) {
      controller.updateData(
        offset: Offset(changes.x, changes.y),
        size: Size(changes.width, changes.height),
      );
    }
  }
}

class GestureItem extends StatelessWidget {
  const GestureItem({
    super.key,
    required this.child,
    required this.onPanUpdate,
  });

  final Widget child;
  final void Function(DragUpdateDetails) onPanUpdate;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox.expand(
        child: GestureDetector(
          onPanUpdate: onPanUpdate,
          child: child,
        ),
      ),
    );
  }
}

class PositionedItem extends StatelessWidget {
  const PositionedItem({
    super.key,
    required this.child,
    required this.controller,
  });

  final Widget child;
  final FlexiController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: controller.offset.dx,
          top: controller.offset.dy,
          height: controller.size.height,
          width: controller.size.width,
          child: child,
        ),
      ],
    );
  }
}

class RotationItem extends StatelessWidget {
  const RotationItem({
    super.key,
    required this.child,
    required this.controller,
  });

  final Widget child;
  final FlexiController controller;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      alignment: Alignment.center,
      angle: FlexiHelper.degreeToRadians(controller.rotation),
      child: child,
    );
  }
}

class ScalableItem extends StatelessWidget {
  const ScalableItem({
    super.key,
    required this.child,
    required this.handleBuilder,
    required this.controller,
    this.onBottomRightDrag,
    this.onTopRightDrag,
    this.onTopLeftDrag,
    this.onBottomLeftDrag,
  });

  final Widget child;
  final FlexiController controller;
  final Function(DragUpdateDetails)? onBottomRightDrag;
  final Function(DragUpdateDetails)? onTopRightDrag;
  final Function(DragUpdateDetails)? onTopLeftDrag;
  final Function(DragUpdateDetails)? onBottomLeftDrag;
  final HandleBuilder handleBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned.fill(
          child: child,
        ),
        if (onBottomRightDrag != null && controller.scaleEnabled)
          GestureDetector(
            onPanUpdate: (details) => onBottomRightDrag!(details),
            child: Container(
              alignment: Alignment.bottomRight,
              child: handleBuilder(context, FlexiAlignment.bottomRight),
            ),
          ),
        if (onTopRightDrag != null && controller.scaleEnabled)
          GestureDetector(
            onPanUpdate: (details) => onTopRightDrag!(details),
            child: Container(
              alignment: Alignment.topRight,
              child: handleBuilder(context, FlexiAlignment.topRight),
            ),
          ),
        if (onBottomLeftDrag != null && controller.scaleEnabled)
          GestureDetector(
            onPanUpdate: (details) => onBottomLeftDrag!(details),
            child: Container(
              alignment: Alignment.bottomLeft,
              child: handleBuilder(context, FlexiAlignment.bottomLeft),
            ),
          ),
        if (onTopLeftDrag != null && controller.scaleEnabled)
          GestureDetector(
            onPanUpdate: (details) => onTopLeftDrag!(details),
            child: Container(
              alignment: Alignment.topLeft,
              child: handleBuilder(context, FlexiAlignment.topLeft),
            ),
          ),
      ],
    );
  }
}
