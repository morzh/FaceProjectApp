import 'dart:io';
import 'dart:async';

import 'package:face_project_app/edit_choice_page.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

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
        future: Future.wait([detectFaces(), loadImage()]),
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
              fit: BoxFit.fitWidth,
                child: Stack(
                  children: <Widget>[
                    Image.memory(snapshot.data[1]),
                    for (var face in snapshot.data[0] )
                      Positioned(
                        top: face.boundingBox.top,
                        left: face.boundingBox.left,
                        width: face.boundingBox.width,
                        height: face.boundingBox.height,
                        child: GestureDetector(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      EditChoicePage(
                                          selectedImage: Image.memory(snapshot.data[1])
                                      )
                              )
                              );
                            },
                          child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 8,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      )
                  ],
                ),
              ),
            ),
          )
            :
          new Center(
              child: CircularProgressIndicator()
          );
        }
    );
  }

  Future detectFaces() async {
    List<Widget> objects = [];
    final FirebaseVisionImage firebaseImage = FirebaseVisionImage.fromFile(
        widget.imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
        FaceDetectorOptions(mode: FaceDetectorMode.accurate));
    final List<Face> detectedFaces = await faceDetector.processImage(
        firebaseImage);
    faceDetector.close();

  return detectedFaces;
  }

  Future loadImage() async {
    final data = await widget.imageFile.readAsBytes();
    // Image image = Image.memory(data);
    // return image;
    return data;
  }

  /*  Uint8List getFaceFromImage(Image image)  {
      final decodedImage = Img.decodeImage(image.);

      final rectangle = this.boundingBox;

      final face = Img.copyCrop(
        decodedImage,
        rectangle.topLeft.dx.toInt(),
        rectangle.topLeft.dy.toInt(),
        rectangle.width.toInt(),
        rectangle.height.toInt(),
      );

      return Uint8List.fromList(encodePng(face));
    }*/
}


