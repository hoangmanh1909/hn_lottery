import 'dart:convert';

import 'package:lottery_flutter_application/constants/command_code.dart';
import 'package:lottery_flutter_application/core/api_client.dart';
import 'package:lottery_flutter_application/models/request/request_object.dart';
import 'package:lottery_flutter_application/models/request/xskt_base_request.dart';
import 'package:lottery_flutter_application/models/request/xskt_search_ticket_request.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class XSKTController extends ControllerMVC {
  factory XSKTController() => _this ??= XSKTController._();
  XSKTController._();

  static XSKTController? _this;
  final ApiClient apiClient = ApiClient();

  Future<ResponseObject> searchTicket(XSKTSearchTicketRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.XSKT_SEARCH_TICKET,
        data: jsonEncode(req),
        signature: "");
    return await apiClient.execute(baseRequest);
  }

  Future<ResponseObject> getAmountPrize(XSKTBaseRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.XSKT_CONFIG_PRIZE,
        data: jsonEncode(req),
        signature: "");
    return await apiClient.execute(baseRequest);
  }
}
