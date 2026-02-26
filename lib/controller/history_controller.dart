import 'dart:convert';

import 'package:lottery_flutter_application/models/request/search_order_history_request.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../constants/command_code.dart';
import '../core/api_client.dart';
import '../models/request/request_object.dart';
import '../models/response/response_object.dart';

class HistoryController extends ControllerMVC {
  factory HistoryController() => _this ??= HistoryController._();
  HistoryController._();
  static HistoryController? _this;
  final ApiClient _apiClient = ApiClient();

  Future<ResponseObject> getDataHistory(String mobile) async {
    final Map<String, String> req = <String, String>{};
    req["MobileNumber"] = mobile;
    RequestObject baseRequest = RequestObject(
        code: CommandCode.OD_SEARCH_FOR_WEBAPP,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> getItemByCode(String code) async {
    final Map<String, String> req = <String, String>{};
    req["Code"] = code;
    RequestObject baseRequest = RequestObject(
        code: CommandCode.OD_GET_ITEM_BY_CODE,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> getDataListHistory(String mobile) async {
    final Map<String, String> req = <String, String>{};
    req["MobileNumber"] = mobile;
    RequestObject baseRequest = RequestObject(
        code: CommandCode.OD_LIST_GET_BY_MOBILE_NUMBER,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> searchHistory(SearchOrderHistoryRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.OD_SEARCH_FOR_WEBAPP,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }
}
