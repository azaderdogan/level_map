import 'package:flutter/material.dart';

/// Controller to add, update and control the custom info window.
class CustomInfoWindowController {
  Function(Widget, Offset)? addInfoWindow;

  /// Notifies [CustomInfoWindow] to redraw as per change in position.
  VoidCallback? onCameraMove;

  /// Hides [CustomInfoWindow].
  VoidCallback? hideInfoWindow;

  void dispose() {
    addInfoWindow = null;
    onCameraMove = null;
    hideInfoWindow = null;
  }
}

/// A stateful widget responsible to create widget based custom info window.
class CustomInfoWindow extends StatefulWidget {
  /// A [CustomInfoWindowController] to manipulate [CustomInfoWindow] state.
  final CustomInfoWindowController controller;
  //if true all offset count is odd, if false all offset count is even
  final bool rightSide;

  /// Height of [CustomInfoWindow].
  final double? height;
  final Offset offset;
  const CustomInfoWindow({
    required this.controller,
    this.offset = Offset.zero,
    this.rightSide = true,
    this.height,
  });

  @override
  _CustomInfoWindowState createState() => _CustomInfoWindowState();
}

class _CustomInfoWindowState extends State<CustomInfoWindow> {
  bool _showNow = false;
  Offset _offset = Offset.zero;
  Widget? _child;

  @override
  void initState() {
    super.initState();
    widget.controller.addInfoWindow = _addInfoWindow;
    widget.controller.onCameraMove = _onCameraMove;
    widget.controller.hideInfoWindow = _hideInfoWindow;
  }

  @override
  void didUpdateWidget(covariant CustomInfoWindow oldWidget) {
    widget.controller.addInfoWindow = _addInfoWindow;
    widget.controller.onCameraMove = _onCameraMove;
    widget.controller.hideInfoWindow = _hideInfoWindow;
    super.didUpdateWidget(oldWidget);
  }

  void _updateInfoWindow(Offset offset) async {
    if (_child == null || mounted == false) {
      return;
    }

    setState(() {
      _showNow = true;
      _offset = offset;
    });
  }

  void _addInfoWindow(Widget child, Offset offset) {
    _child = child;

    //ignore necessary to avoid context null exception
    try {
      _updateInfoWindow(offset);
      // ignore: empty_catches
    } catch (e) {}
  }

  void _onCameraMove() {
    /*  if (!_showNow) return;
    //ignore necessary to avoid context null exception
    try {
      _updateInfoWindow();
      // ignore: empty_catches
    } catch (e) {} */
  }

  /// Disables [CustomInfoWindow] visibility.
  void _hideInfoWindow() {
    if (_showNow) {
      setState(() {
        _showNow = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: (_offset.dy - widget.offset.dy),
      right: widget.rightSide ? _offset.dx + widget.offset.dx : null,
      left: !widget.rightSide ? _offset.dx + widget.offset.dx : null,
      duration: Duration(milliseconds: 200),
      child: Visibility(
        visible: (_showNow == false || _child == null) ? false : true,
        child: Container(
          alignment: Alignment.center,
          height: widget.height,
          child: _child,
        ),
      ),
    );
  }
}
