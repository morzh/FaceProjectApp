import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:face_project_app/core/services/http_service_base.dart';

class HttpServiceNgrok implements HttpService{
  late final _dio;

  HttpServiceNgrok() {
    init();
  }

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
    final String requestKey = "file";
    // String requestKey = "encode_face_image";
    final Response response;
    final filename = image.path.split('/').last;
    final formData = FormData.fromMap({
      requestKey :  await MultipartFile.fromFile(image.path,
          filename : filename,
          contentType: MediaType('image', 'jpeg')
      )
    });
    try {
      print(url);
      response = await _dio.post(url,
          data: formData,
          options: Options(
              headers: {"Content-Type": "multipart/form-data"}
          ));
      return response;
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
  }

  @override
  Future<Response> faceAugmentRequest(String url, String augmentType, List latent, Map attributes) async {
    final data = {
      "augment_type" : augmentType,
      "latent": latent,
      "attributes": attributes
    };
    final formData = FormData.fromMap({
      augmentType :  jsonEncode(data),
    });

    Response response = await _dio.post(url,
      data: data,
      // data: FormData.fromMap(data),
    );
    return response;
  }
}