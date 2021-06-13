import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'dart:core';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:face_project_app/edit_choice_page.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
// import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:cookie_jar/cookie_jar.dart';


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
                                    final String random = (_rng.nextInt(1000000)).toString();
                                    final Uint8List data = await _cropImage(snapshot.data[0].imageData, face.boundingBox);
                                    final String tempPath = (await getTemporaryDirectory()).path;
                                    final String filePathSource = tempPath + '/' + random;
                                    final String filePathEncoded = tempPath + '/' + random + '_encoded';
                                    print(filePathSource);
                                    final File dataFile = File(filePathSource);
                                    if (dataFile.existsSync()) { dataFile.deleteSync(); }
                                    dataFile.writeAsBytesSync(data);
                                    // print(dataFile.path);
                                    // print( await dataFile.length());
                                    final File dataFile2 = await _uploadImageToServer(dataFile, filePathEncoded);
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          EditChoicePage(
                                              imageFile: dataFile2
                                          )
                                  )
                                  );
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

  Future _cropImage(imageData, Rect rect) async {
    final editorOption = ImageEditorOption();
    editorOption.addOption(ClipOption(x: rect.left, y: rect.top, width: rect.width, height : rect.height));
    return ImageEditor.editImage(
        image: imageData,
        imageEditorOption: editorOption);
  }

  Future detectFaces() async {
    print('face detector started');
    final InputImage MlKitImage = InputImage.fromFile(widget.imageFile);
    final List<Face> detectedFaces = await faceDetector.processImage(MlKitImage);
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
    FormData formData = FormData.fromMap({
      "name": "wendux",
      "file": MultipartFile.fromFile(imageFile.path, filename:basename(imageFile.path))
    });

    var uri = Uri.parse('http://e0e1e71d4d7d.ngrok.io/');
    var dio = Dio();
    // var cookieJar=CookieJar();
    // dio.interceptors.add(CookieManager(cookieJar));
    // print(cookieJar.loadForRequest(uri));
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['accept'] = 'application/json';
    final response = await dio.postUri(uri,
        data: formData,
        options: Options(
          method: "POST",
          contentType: 'multipart/form-data',
          followRedirects: true,
          headers: {'accept': 'application/json'},
          validateStatus: (int? status) { return status! < 500; }
        )
    );

    print('response:');
    print(response.statusCode);
    print(response.headers);
    print(response.redirects);

    return imageFile;

    /*
    Map<String, String> headersMap = {
      'set-cookie' : 'session=eyJfZmxhc2hlcyI6W3siIHQiOlsibWVzc2FnZSIsIk5vIGZpbGUgcGFydCJdfV19.YMYCpQ.X-XZFS9Q7Dm7e-EUt49RNhzJSYA'
    };

    var uri = Uri.parse('http://9e325129b82b.ngrok.io');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('picture', imageFile
        .path));
    var response = await request.send();

    print('response:');
    print(response.statusCode);
    print(response.headers);

    // var responsebody = response.stream.transform(utf8.decoder);
    // final imageResponse = Image.memory(await response.stream.toBytes()).image;


    final Uint8List imageData = await response.stream.toBytes();
    final String pathImageResponse = (await getTemporaryDirectory()).path;
    final File newImage = File('$pathImageResponse/image1.png');
    newImage.writeAsBytesSync(imageData);
    */

    /*
    final File transferedImage = File(filePath); // must assign a File to _transferedImage
    IOSink sink = transferedImage.openWrite();
    await sink.addStream(response.stream); // this requires await as addStream is async
    await sink.close(); // so does this
    setState(() {});
    */
    // print(await transferedImage.length());
    // print(await transferedImage.stat());
    // return newImage;
  }
}


