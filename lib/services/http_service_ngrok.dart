import 'package:dio/dio.dart';
import 'package:face_project_app/services/http_service_base.dart';

const BASE_URL = "http://6abe-34-78-52-237.ngrok.io";

class HttpServiceNgrok implements HttpService{
  late Dio _dio;

  @override
  Future<Response> getRequest(String url) async {
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
}