import 'dart:convert';

import 'package:meepay_app/constants/command_code.dart';
import 'package:meepay_app/core/api_client.dart';
import 'package:meepay_app/models/request/base_request.dart';
import 'package:meepay_app/models/request/notify_search_request.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class NotifyController extends ControllerMVC {
  factory NotifyController() => _this ??= NotifyController._();
  NotifyController._();

  static NotifyController? _this;
  final ApiClient apiClient = ApiClient();

  Future<dynamic> search(NotifySearchRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.NOTIFY_SEARCH, data: jsonEncode(req), signature: "");
    return await apiClient.execute(baseRequest);
  }

  Future<dynamic> general(NotifySearchRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.NOTIFY_GENERAL, data: jsonEncode(req), signature: "");
    return await apiClient.execute(baseRequest);
  }
}
