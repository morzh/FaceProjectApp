import 'dart:io';
import 'package:dio/dio.dart';

abstract class HttpService{
  void init();

  Future<Response> imageRequest(String url, String key, File image);
  Future<Response> latentFaceAttributesRequest(String url, String key, List latent, Map attributes);
  Future<Response> request(String url);
}