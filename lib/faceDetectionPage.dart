import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'dart:core';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:face_project_app/editChoicePage.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'package:face_project_app/models/faceData.dart';


class ImageStruct {
  Uint8List imageData;
  double imageWidth;
  double imageHeight;
  double scale;
  Offset offset;

  ImageStruct({
    required this.imageData,
    required this.imageWidth,
    required this.imageHeight,
    required this.scale,
    required this.offset,
  });
}

class FaceDetectionPage extends StatefulWidget {
  final File imageFile;
  FaceDetectionPage({required this.imageFile});

  @override
  _FaceDetectionPage createState() => _FaceDetectionPage();
}

class _FaceDetectionPage extends State<FaceDetectionPage> {
  final faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(mode: FaceDetectorMode.fast));
  final _rng = Random();
  late final imageSize;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: Future.wait([_loadData(context), detectFaces()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData ? new Scaffold(
            body: snapshot.data[1].length == 0
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
            :InteractiveViewer(
                  minScale: 0.15,
                  maxScale: 5.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.memory(
                            snapshot.data[0].imageData,
                          // alignment: Alignment.topLeft,
                        ),
                        for (var face in snapshot.data[1])
                          Positioned(
                            top: snapshot.data[0].scale * face.boundingBox.top + snapshot.data[0].offset.dy,
                            left: snapshot.data[0].scale * face.boundingBox.left + snapshot.data[0].offset.dx,
                            width: snapshot.data[0].scale * face.boundingBox.width,
                            height: snapshot.data[0].scale * face.boundingBox.height,
                            child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _isLoading = !_isLoading;
                                  });
                                  final String random = (_rng.nextInt(1000000)).toString();
                                  final Uint8List data = await _cropImage(snapshot.data[0], face.boundingBox);
                                  final String tempPath = (await getTemporaryDirectory()).path;
                                  final String filePathSource = tempPath + '/' + random+'.jpg';
                                  final String filePathEncoded = tempPath + '/' + random + '_encoded.jpg';
                                  print(filePathSource);
                                  final File dataFile = File(filePathSource);
                                  if (dataFile.existsSync()) { dataFile.deleteSync(); }
                                  dataFile.writeAsBytesSync(data);
                                  // print(dataFile.path);
                                  // print( await dataFile.length());
                                  final File dataFileEncoded = await _uploadImageToServer(dataFile, filePathEncoded);
                                  Get.off(() => EditChoicePage(imageFile: dataFileEncoded));
                                },
                              child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0.015*MediaQuery.of(context).size.longestSide),
                                border: Border.all(
                                    width: 0.006*MediaQuery.of(context).size.longestSide,
                                    color: Colors.blueAccent),
                              ),
                            ),
                          ),
                          ),
                        Visibility(
                          visible: _isLoading,
                            child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 7,
                                )
                            )
                        )
                      ],
                    ),
                  ),
                // ),
          )
            :
          new Center(
              child: CircularProgressIndicator()
          );
        }
    );
  }

  Future _cropImage(imageStructData, Rect rect) async {
    final editorOption = ImageEditorOption();
    var imageRect = Rect.fromLTRB(0, 0, imageStructData.imageWidth - 1, imageStructData.imageHeight - 1);
    rect = rect.inflate(rect.longestSide);
    rect = rect.intersect(imageRect);
    editorOption.addOption(ClipOption(x: rect.left, y: rect.top, width: rect.width, height : rect.height));
    return ImageEditor.editImage(
        image: imageStructData.imageData,
        imageEditorOption: editorOption);
  }

  Future detectFaces() async {
    print('face detector started');
    final InputImage mlKitImage = InputImage.fromFile(widget.imageFile);
    final List<Face> detectedFaces = await faceDetector.processImage(mlKitImage);
    print('face detector ended');
    // faceDetector.close();
    final List<Face> filteredFaces = [];
    for (var face in detectedFaces) {
      if (face.boundingBox.longestSide / face.boundingBox.shortestSide > 2) {
        continue;
      }
      filteredFaces.add(face);
    }
  return filteredFaces;
  }

  Future _loadData(BuildContext context) async {
    final imageData = await widget.imageFile.readAsBytes();
    final decodedImage = await decodeImageFromList(imageData);

    double imageWidth = decodedImage.width.toDouble();
    double imageHeight = decodedImage.height.toDouble();

    double screenWidth = MediaQuery.of(context).size.width.toDouble();
    double screenHeight = MediaQuery.of(context).size.height.toDouble();

    double scaleWidth = screenWidth / imageWidth;
    double scaleHeight = screenHeight / imageHeight;
    double scale = min(scaleWidth, scaleHeight).clamp(0.01, 1.0);

    Offset offset = Offset(
      0.5 * (screenWidth - scale * imageWidth),
      0.5 * (screenHeight - scale * imageHeight),
    );

    return ImageStruct(
      imageData: imageData,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      scale : scale,
      offset : offset,
    );
  }

  _uploadImageToServer(File imageFile, String filePath) async   {
    var uri = Uri.parse('http://1c6199407cfb.ngrok.io');
    var request =  http.MultipartRequest("POST", uri);
    request.files.add(
        http.MultipartFile.fromBytes(
            'file', await imageFile.readAsBytes(),
            filename: basename(imageFile.path),
            contentType: MediaType('image','jpeg')
        )
    );

    final response = await request.send();
    print('response:');
    print(response.statusCode);
    print(response.headers);
    final jsonResponse = json.decode(await response.stream.bytesToString());
    final imageAlignedDecoded = base64.decode(base64.normalize(jsonResponse["ImageAligned"]));
    final imageEncodedDecoded = base64.decode(base64.normalize(jsonResponse["ImageEncoded"]));
    final latentDecoded = base64.decode(base64.normalize(jsonResponse["latent"]));
    final faceAttributestDecoded = base64.decode(base64.normalize(jsonResponse["faceAttributes"]));
    final File alignedImage = File(filePath);
    final File encodedImage = File(filePath);
    alignedImage.writeAsBytesSync(imageAlignedDecoded.toList());
    encodedImage.writeAsBytesSync(imageEncodedDecoded.toList());
    setState(() {
      _isLoading = !_isLoading;
    });
    FaceData(alignedImage, encodedImage, );
    return alignedImage;
  }
}


