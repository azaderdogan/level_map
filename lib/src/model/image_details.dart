import 'package:flutter/material.dart';

///Used to paint in the canvas
class ImageDetails {
  final ImageInfo imageInfo;
  final Size size;
  final Offset? offset;

  ImageDetails({required this.imageInfo, required this.size, this.offset});
}
