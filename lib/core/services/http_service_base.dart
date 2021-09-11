import 'dart:io';
import 'package:dio/dio.dart';

abstract class HttpService{
  void init();
  Future<Response> encodeFaceImage(String url, File image);
  Future<Response> faceAugmentRequest(String url, String key, List latent, Map attributes);
  Future<Response> request(String url);
}