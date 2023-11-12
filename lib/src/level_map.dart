import 'package:flutter/material.dart';
import 'package:level_map/src/model/images_to_paint.dart';
import 'package:level_map/src/model/level_map_params.dart';
import 'package:level_map/src/paint/custom_info_window.dart';
import 'package:level_map/src/paint/level_map_painter.dart';
import 'package:level_map/src/utils/load_ui_image_to_draw.dart';
import 'package:level_map/src/utils/scroll_behaviour.dart';

typedef OnTapLevel = void Function(int level, Offset offset);
typedef WidgetBuilder = Widget Function(BuildContext context, int level);

class LevelMap extends StatelessWidget {
  final LevelMapParams levelMapParams;
  final Color backgroundColor;
  final OnTapLevel? onTapLevel;
  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  final WidgetBuilder previewBuilder;
  final double? previewHeight;
  final List<Offset> offsetList = [];
  final Offset previewOffset;

  /// If set to false, scroll starts from the bottom end (level 1).
  final bool scrollToCurrentLevel;
  LevelMap({
    Key? key,
    required this.levelMapParams,
    this.onTapLevel,
    this.backgroundColor = Colors.transparent,
    this.scrollToCurrentLevel = true,
    this.previewOffset = const Offset(0, 0),
    required this.previewBuilder,
    this.previewHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ScrollConfiguration(
        behavior: const MyBehavior(),
        child: SingleChildScrollView(
          controller: ScrollController(
              initialScrollOffset: (((scrollToCurrentLevel
                          ? (levelMapParams.levelCount -
                              levelMapParams.currentLevel +
                              2)
                          : levelMapParams.levelCount)) *
                      levelMapParams.levelHeight) -
                  constraints.maxHeight),
          // physics: FixedExtentScrollPhysics(),
          child: ColoredBox(
            color: backgroundColor,
            child: FutureBuilder<ImagesToPaint?>(
              future: loadImagesToPaint(
                levelMapParams,
                levelMapParams.levelCount,
                levelMapParams.levelHeight,
                constraints.maxWidth,
              ),
              builder: (context, snapshot) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTapUp: (details) {
                        final int _levelTapped = (details.localPosition.dy /
                                levelMapParams.levelHeight)
                            .floor();
                        onTapLevel?.call(
                            _levelTapped + 1, details.localPosition);
                        if (offsetList.length >= (_levelTapped + 1)) {
                          var offset = offsetList[_levelTapped];
                          customInfoWindowController.addInfoWindow!(
                              previewBuilder(context, _levelTapped),
                              Offset(offset.dx, -offset.dy));
                        }
                      },
                      child: CustomPaint(
                        size: Size(
                            constraints.maxWidth,
                            levelMapParams.levelCount *
                                levelMapParams.levelHeight),
                        painter: LevelMapPainter(
                          params: levelMapParams,
                          imagesToPaint: snapshot.data,
                          offsets: offsetList,
                        ),
                      ),
                    ),
                    CustomInfoWindow(
                      controller: customInfoWindowController,
                      height: previewHeight,
                      offset: previewOffset,
                      rightSide: levelMapParams.levelCount.isEven,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
