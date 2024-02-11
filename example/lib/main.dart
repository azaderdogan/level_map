import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:level_map/level_map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LevelMapPage(),
    );
  }
}

class LevelMapPage extends StatefulWidget {
  @override
  _LevelMapPageState createState() => _LevelMapPageState();
}

class _LevelMapPageState extends State<LevelMapPage> {
  final previewWidth = 150.0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LevelMap(
          backgroundColor: Colors.limeAccent,
          onTapLevel: (value, offset) {
            print(value);
          },
          previewOffset: Offset(-(previewWidth / 2), 110),
          previewBuilder: (context, level) => LevelMapPreview(
            previewWidth: previewWidth,
            child: Center(
              child: Row(
                children: [
                  Text(
                    "Preview $level",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
          levelMapParams: LevelMapParams(
            levelCount: 1,
            currentLevel: 1,
            maxVariationFactor: 1,
            minReferencePositionOffsetFactor: Offset(0.5, 0.5),
            maxReferencePositionOffsetFactor: Offset(0.8, 0.8),
            enableVariationBetweenCurves: false,
            levelHeight: 120,
            pathColor: Colors.black,
            currentLevelImage: ImageParams(
              path: "assets/images/current_black.png",
              size: Size(40, 47),
            ),
            lockedLevelImage: ImageParams(
              path: "assets/images/locked_black.png",
              size: Size(40, 42),
            ),
            completedLevelImage: ImageParams(
              path: "assets/images/completed_black.png",
              size: Size(40, 42),
            ),
            startLevelImage: ImageParams(
              path: "assets/images/Boy Study.png",
              size: Size(60, 60),
            ),
            pathEndImage: ImageParams(
              path: "assets/images/Boy Graduation.png",
              size: Size(60, 60),
            ),
            /*         bgImagesToBePaintedRandomly: [
              ImageParams(
                  path: "assets/images/Energy equivalency.png",
                  size: Size(80, 80),
                  repeatCountPerLevel: 0.5),
              ImageParams(
                  path: "assets/images/Astronomy.png",
                  size: Size(80, 80),
                  repeatCountPerLevel: 0.25),
              ImageParams(
                  path: "assets/images/Atom.png",
                  size: Size(80, 80),
                  repeatCountPerLevel: 0.25),
              ImageParams(
                  path: "assets/images/Certificate.png",
                  size: Size(80, 80),
                  repeatCountPerLevel: 0.25),
            ],
     */
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.bolt,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              //Just to visually see the change of path's curve.
            });
          },
        ),
      ),
    );
  }
}

class LevelMapPreview extends StatelessWidget {
  const LevelMapPreview({
    Key? key,
    required this.previewWidth,
    required this.child,
  }) : super(key: key);

  final double previewWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          "assets/images/currentlesson.svg",
          width: previewWidth,
        ),
        Container(
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.all(10),
            width: previewWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: child),
      ],
    );
  }
}
