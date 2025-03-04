import 'dart:convert';

import 'package:meepay_app/constants/command_code.dart';
import 'package:meepay_app/core/api_client.dart';
import 'package:meepay_app/models/request/account_add_request.dart';
import 'package:meepay_app/models/request/account_search_request.dart';
import 'package:meepay_app/models/request/request_object.dart';
import 'package:meepay_app/models/request/change_link_request.dart';
import 'package:meepay_app/models/request/verify_otp_request.dart';
import 'package:meepay_app/models/response/response_object.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class AccountController extends ControllerMVC {
  factory AccountController() => _this ??= AccountController._();
  AccountController._();

  static AccountController? _this;
  final ApiClient apiClient = ApiClient();

  Future<ResponseObject> search(AccountSearchRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.ACCOUNT_BANK_SEARCH,
        data: jsonEncode(req),
        signature: "");
    return await apiClient.execute(baseRequest);
  }

  Future<ResponseObject> changeLink(ChangeLinkRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DEVICE_CHANGE_LINK,
        data: jsonEncode(req),
        signature: "");
    return await apiClient.execute(baseRequest);
  }

  Future<ResponseObject> addLink(AccountAddNewRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.ACCOUNT_BANK_ADD_NEW,
        data: jsonEncode(req),
        signature: "");
    return await apiClient.execute(baseRequest);
  }

  Future<ResponseObject> verifyOtp(VerifyOTPRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.ACCOUNT_VERIFY, data: jsonEncode(req), signature: "");
    return await apiClient.execute(baseRequest);
  }
}
