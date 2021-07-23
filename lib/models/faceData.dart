import 'dart:io';
import 'package:matrix2d/matrix2d.dart';

class FaceData{
  late final File original;
  late final File augmented;
  late final Map<String, String> attributes;
  late final Matrix2d latentEncoded;
  late final Matrix2d latentAugmented;

  FaceData({
    required this.original,
    required this.augmented,
    required this.attributes,
    required this.latentEncoded
    }) {
    this.latentAugmented = this.latentEncoded;
  }
}