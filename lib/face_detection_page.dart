

import 'package:flutter/foundation.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';

class FaceDetectionPage extends StatefulWidget {
  final File imageFile;
  final faceDetector = FirebaseVision.instance.faceDetector(
    FaceDetectorOptions(
      mode: FaceDetectorMode.accurate,
    )
  );
  FaceDetectionPage({@required this.imageFile});

  @override
  _FaceDetectionPage createState() => _FaceDetectionPage();
}

class _FaceDetectionPage extends State<FaceDetectionPage> {
  List<Face> detectedFaces;
  @override
  Widget build(BuildContext context){
    detectFaces();
    return Scaffold(
      body: Container(
        child: Image.file(widget.imageFile),
      ),
    );
  }

  detectFaces() async {
    final FirebaseVisionImage firebaseImage = FirebaseVisionImage.fromFile(widget.imageFile);
    detectedFaces = await widget.faceDetector.processImage(firebaseImage);

    for (Face face in detectedFaces) {
      final Rect boundingBox = face.boundingBox;
      print(boundingBox);

/*
      final double rotY = face.headEulerAngleY; // Head is rotated to the right rotY degrees
      final double rotZ = face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

      // If landmark detection was enabled with FaceDetectorOptions (mouth, ears, eyes, cheeks, and nose available):
      final FaceLandmark leftEar = face.getLandmark(FaceLandmarkType.leftEar);
      if (leftEar != null) {
        final Point<double> leftEarPos = leftEar.position;
      }

      // If classification was enabled with FaceDetectorOptions:
      if (face.smilingProbability != null) {
        final double smileProb = face.smilingProbability;
      }
      // If face tracking was enabled with FaceDetectorOptions:
      if (face.trackingId != null) {
        final int id = face.trackingId;
      }
*/
    }
    widget.faceDetector.close();
  }

}


class FacePainter extends CustomPainter {
  final ui.Image image;
  // final List<Face> faces;
  final List<Rect> rectangles = [];

  FacePainter(this.image, faces) {
    for (var i = 0; i < faces.length; i++) {
      rectangles.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0
      ..color = Colors.blue;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < rectangles.length; i++) {
      canvas.drawRect(rectangles[i], paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) => false;
}