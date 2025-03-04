import 'dart:convert';

import 'package:meepay_app/constants/command_code.dart';
import 'package:meepay_app/core/api_client.dart';
import 'package:meepay_app/models/request/base_request.dart';
import 'package:meepay_app/models/request/change_password.dart';
import 'package:meepay_app/models/request/request_object.dart';
import 'package:meepay_app/models/request/login_request.dart';
import 'package:meepay_app/models/request/register_request.dart';
import 'package:meepay_app/models/request/verify_otp_request.dart';
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

  Future<ResponseObject> register(RegisterRequest loginRequest) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.USER_REGISTER,
        data: jsonEncode(loginRequest),
        signature: "");
    return await apiClient.register(baseRequest);
  }

  Future<ResponseObject> remove(BaseRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.USER_DELETE, data: jsonEncode(req), signature: "");
    return await apiClient.execute(baseRequest);
  }

  Future<ResponseObject> changePassword(ChangePasswordRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.USER_CHANGE_PASSWORD,
        data: jsonEncode(req),
        signature: "");
    return await apiClient.execute(baseRequest);
  }

  Future<ResponseObject> verifyOTP(VerifyOTPRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.USER_VERIFY_OTP,
        data: jsonEncode(req),
        signature: "");
    return await apiClient.execute(baseRequest);
  }

  Future<ResponseObject> addPassword(ChangePasswordRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.USER_ADD_PASSWORD,
        data: jsonEncode(req),
        signature: "");
    return await apiClient.execute(baseRequest);
  }

  Future<ResponseObject> missPassword(ChangePasswordRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.USER_MISS_PASSWORD,
        data: jsonEncode(req),
        signature: "");
    return await apiClient.execute(baseRequest);
  }
}
