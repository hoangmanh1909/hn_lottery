import 'dart:convert';

import 'package:lottery_flutter_application/constants/command_code.dart';
import 'package:lottery_flutter_application/core/api_client.dart';
import 'package:lottery_flutter_application/models/request/base_request.dart';
import 'package:lottery_flutter_application/models/request/request_object.dart';
import 'package:lottery_flutter_application/models/request/together_ticket_request.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/request/together_ticket_add_item_request.dart';
import '../models/request/together_ticket_item_search_request.dart';
import '../models/response/response_object.dart';

class TogetherTicketController extends ControllerMVC {
  factory TogetherTicketController() => _this ??= TogetherTicketController._();
  TogetherTicketController._();

  static TogetherTicketController? _this;
  final ApiClient _apiClient = ApiClient();

  Future<ResponseObject> search(TogetherTicketSearchRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.TT_SEARCH, data: jsonEncode(req), signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> searchItem(TogetherTicketSearchItemRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.TT_GET_ITEM_BY_ID,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> addItem(TogetherTicketItemAddRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.TT_ADD_ITEM, data: jsonEncode(req), signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> getTogetherGroup(BaseRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.TT_GET_TOGETHER_GROUP,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> addItemGroup(TogetherTicketItemAddRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.TT_ADD_ITEM_GROUP,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> getTogetherGroupDetail(BaseRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.TT_GET_DETAIL, data: jsonEncode(req), signature: "");
    return await _apiClient.execute(baseRequest);
  }
}
