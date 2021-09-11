import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:face_project_app/core/services/http_service_base.dart';



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
    _dio = Dio();
  }

  @override
  Future<Response> encodeFaceImage(String url, File image) async {
    String encodeRequestKey = "encode_face_image";
    Response response;
    String filename = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      encodeRequestKey :  await MultipartFile.fromFile(image.path,
          filename : filename,
          contentType: MediaType('image', 'jpeg')
      )
    });
    try {
      response = await _dio.post(url,
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
  Future<Response> faceAugmentRequest(String url, String augmentType, List latent, Map attributes) async {
    var data =  {
      "type" : augmentType,
      "latent": latent,
      "attributes": attributes
    };

    Response response = await _dio.post(url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      data: jsonEncode(data),
    );

    return response;
  }
}