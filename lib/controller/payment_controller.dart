import 'dart:convert';

import 'package:lottery_flutter_application/models/request/get_fee_request.dart';
import 'package:lottery_flutter_application/models/request/order_add_request.dart';
import 'package:lottery_flutter_application/models/request/order_list_add_request.dart';
import 'package:lottery_flutter_application/models/request/trans_payment_request.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../constants/command_code.dart';
import '../core/api_client.dart';
import '../models/request/request_object.dart';
import '../models/request/together_payment.dart';
import '../models/response/response_object.dart';

class PaymentController extends ControllerMVC {
  factory PaymentController() => _this ??= PaymentController._();
  PaymentController._();
  static PaymentController? _this;
  final ApiClient _apiClient = ApiClient();

  Future<ResponseObject> addOrder(OrderAddNewRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.OD_ADD_NEW, data: jsonEncode(req), signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> getFee(GetFeeRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.TRANS_GET_FEE, data: jsonEncode(req), signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> payment(TransPaymentRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.TRANS_PAYMENT, data: jsonEncode(req), signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> paymentList(OrderListAddNewRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.OD_LIST_ADD, data: jsonEncode(req), signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> paymentTogetherTicket(
      TogetherTicketPaymentRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.TT_PAYMENT, data: jsonEncode(req), signature: "");
    return await _apiClient.execute(baseRequest);
  }
}
