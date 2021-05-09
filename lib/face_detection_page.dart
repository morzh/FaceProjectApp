import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';

class FaceDetectionPage extends StatefulWidget {
  final File imageFile;

  FaceDetectionPage({required this.imageFile});

  @override
  _FaceDetectionPage createState() => _FaceDetectionPage();
}

class _FaceDetectionPage extends State<FaceDetectionPage> {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: Future.wait([detectFaces(), loadUiImage()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData ? new Scaffold(
            body: snapshot.data[0].length == 0
            ?Center(child: Text(
                'No faces found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                )
              )
            )
            :Center(
              child: FittedBox(
                child: SizedBox(
                  width: snapshot.data[1].width.toDouble(),
                  height:snapshot.data[1].height.toDouble(),
                  child: CustomPaint(
                    painter: FacePainter(snapshot.data[1], snapshot.data[0]),
                  ),
              ),
            ),
          )
          )
              :
          new Center(
              child: CircularProgressIndicator()
          );
        }
    );
  }

  Future detectFaces() async {
    final FirebaseVisionImage firebaseImage = FirebaseVisionImage.fromFile(
        widget.imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
        FaceDetectorOptions(mode: FaceDetectorMode.accurate));
    final List<Face> detectedFaces = await faceDetector.processImage(
        firebaseImage);
    faceDetector.close();
    return detectedFaces;
  }

  Future loadUiImage() async {
    final data = await widget.imageFile.readAsBytes();
    ui.Image image = await decodeImageFromList(data);
    return image;
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rectangles = [];

  FacePainter(this.image, this.faces) {
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
  bool shouldRepaint(FacePainter oldDelegate)  => false;
}