import 'package:meepay_app/constants/command_code.dart';
import 'package:meepay_app/core/api_client.dart';
import 'package:meepay_app/models/request/base_request.dart';
import 'package:meepay_app/models/response/response_object.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class DictionaryController extends ControllerMVC {
  factory DictionaryController() => _this ??= DictionaryController._();
  DictionaryController._();

  static DictionaryController? _this;
  final ApiClient apiClient = ApiClient();

  Future<ResponseObject> getBank() async {
    RequestObject baseRequest =
        RequestObject(code: CommandCode.DIC_BANK, data: "", signature: "");
    return await apiClient.execute(baseRequest);
  }
}
