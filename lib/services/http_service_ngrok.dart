import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:face_project_app/services/http_service_base.dart';

const BASE_URL = "http://6abe-34-78-52-237.ngrok.io";

class HttpServiceNgrok implements HttpService{
  late Dio _dio;

  @override
  Future<Response> request(String url) async {
    Response response;
    try {
      response = await _dio.get(url);
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
    return response;
  }

  @override
  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: BASE_URL,
    ));
  }

  @override
  Future<Response> imageRequest(String url, String key, File image) async {
    Response response;
    String filename = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      key :  await MultipartFile.fromFile(image.path,
          filename : filename,
          contentType: MediaType('image', 'jpeg')
      )
    });
    try {
      response = await _dio.post(BASE_URL,
          data: formData,
          options: Options(
              headers: {"Content-Type": "multipart/form-data"}
          ));
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
    return response;
  }

  @override
  Future<Response> latentFaceAttributesRequest(String url, String key, File image) {
    // TODO: implement latentFaceAttributesRequest
    throw UnimplementedError();
  }
}