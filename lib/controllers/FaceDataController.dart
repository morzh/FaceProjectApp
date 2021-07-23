import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'dart:core';

import 'package:path/path.dart';
import 'package:get/state_manager.dart';
import 'package:face_project_app/models/faceData.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';

class FaceDataController extends GetxController {
  var faceData = FaceData().obs;

  void fetchProduct(File imageFile, String filePath) async {
    faceData.original = imageFile;
    var uri = Uri.parse('http://dc4e5826ee65.ngrok.io');
    var request =  http.MultipartRequest("POST", uri);
    // request.fields['user'] = 'blah';
    request.files.add(
        http.MultipartFile.fromBytes(
            'file', await imageFile.readAsBytes(),
            filename: basename(imageFile.path),
            contentType: new MediaType('image','jpeg')
        )
    );

    final response = await request.send();
    print('response:');
    print(response.statusCode);
    print(response.headers);
    // final imageResponse = Image.memory(await response.stream.toBytes()).image;
    final File iamgeRsponseaFile = File(filePath);
    faceDataFromJson(JsonFromStream()(response.stream));
    iamgeRsponseaFile.writeAsBytesSync(await response.stream.toBytes());
    return iamgeRsponseaFile;
  }
}