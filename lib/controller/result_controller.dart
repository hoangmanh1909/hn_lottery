import 'dart:convert';

import 'package:lottery_flutter_application/models/request/xskt_base_request.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../constants/command_code.dart';
import '../core/api_client.dart';
import '../models/request/request_object.dart';

class ResultController extends ControllerMVC {
  factory ResultController() => _this ??= ResultController._();
  ResultController._();
  static ResultController? _this;
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> getResultMega645() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_MEGA,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute1(baseRequest);
  }

  Future<dynamic> getResultLotto535() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_LOTTO535,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute1(baseRequest);
  }

  Future<dynamic> getResultPower() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_POWER,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute1(baseRequest);
  }

  Future<dynamic> getResultMax3D() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_MAX3D,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute1(baseRequest);
  }

  Future<dynamic> getResultMax3DPro() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_MAX3D_PRO,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute1(baseRequest);
  }

  Future<dynamic> getResultKeno() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_KENO,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute1(baseRequest);
  }

  Future<ResponseObject> getResultMienBac() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_LOTOMB,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute1(baseRequest);
  }

  Future<ResponseObject> getResult636() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_LOTO636,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute1(baseRequest);
  }

  Future<ResponseObject> getXSKT(XSKTBaseRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_RESULT_XSKT,
        data: jsonEncode(req),
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute1(baseRequest);
  }
}
