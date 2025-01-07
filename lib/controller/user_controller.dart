import 'dart:convert';

import 'package:meepay_app/constants/command_code.dart';
import 'package:meepay_app/core/api_client.dart';
import 'package:meepay_app/models/request/base_request.dart';
import 'package:meepay_app/models/request/login_request.dart';
import 'package:meepay_app/models/response/response_object.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class UserController extends ControllerMVC {
  factory UserController() => _this ??= UserController._();
  UserController._();

  static UserController? _this;
  final ApiClient apiClient = ApiClient();

  Future<ResponseObject> login(LoginRequest loginRequest) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.USER_LOGIN,
        data: jsonEncode(loginRequest),
        signature: "");
    return await apiClient.login(baseRequest);
  }
}
