// ignore_for_file: unused_catch_clause

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meepay_app/config/api.dart';
import 'package:meepay_app/models/request/base_request.dart';
import 'package:meepay_app/models/response/response_object.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<ResponseObject> execute(RequestObject baseRequest) async {
    try {
      Response response = await _dio.post("${urlGateway}Gateway/Execute",
          data: baseRequest,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      return ResponseObject.fromJson(response.data);
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      ResponseObject responseObject =
          ResponseObject(code: "98", message: "Không thể kết nối đến máy chủ");
      return responseObject;
    }
  }

  Future<ResponseObject> login(RequestObject baseRequest) async {
    try {
      Response response = await _dio.post("${urlGateway}Gateway/Login",
          data: baseRequest,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      return ResponseObject.fromJson(response.data);
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      ResponseObject responseObject =
          ResponseObject(code: "98", message: "Không thể kết nối đến máy chủ");
      return responseObject;
    }
  }
}
