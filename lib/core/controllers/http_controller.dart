import 'dart:io';
import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import 'package:face_project_app/core/services/http_service_ngrok.dart';

const BASE_URL = "http://6abe-34-78-52-237.ngrok.io";

class HttpController extends GetxController {
  get httpService => Get.put(HttpServiceNgrok());

  encodeRequest(File image) async {
    httpService.encodeFaceImage(BASE_URL, image);
  }
}