import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meepay_app/config/api.dart';
import 'package:meepay_app/models/request/base_request.dart';
import 'package:meepay_app/models/response/base_response.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<dynamic> execute(BaseRequest baseRequest) async {
    try {
      Response response = await _dio.post("${urlGateway}LKLGW/Service",
          data: baseRequest,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      return response.data;
      // ignore: deprecated_member_use
    } on DioError {
      BaseResponse baseResponse =
          BaseResponse(code: "98", message: "Không thể kết nối đến máy chủ");
      return baseResponse.toJson();
    }
  }

  Future<dynamic> login(BaseRequest baseRequest) async {
    try {
      Response response = await _dio.post("${urlGateway}Mobile/Login",
          data: baseRequest,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      return response.data;
      // ignore: deprecated_member_use
    } on DioError {
      BaseResponse baseResponse =
          BaseResponse(code: "98", message: "Không thể kết nối đến máy chủ");
      return baseResponse.toJson();
    }
  }
}
