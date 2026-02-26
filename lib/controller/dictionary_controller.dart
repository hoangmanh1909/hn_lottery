import 'dart:convert';

import 'package:lottery_flutter_application/core/api_client.dart';
import 'package:lottery_flutter_application/models/request/notification_update_request.dart';
import 'package:lottery_flutter_application/models/request/request_object.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../constants/command_code.dart';

class DictionaryController extends ControllerMVC {
  factory DictionaryController() => _this ??= DictionaryController._();
  DictionaryController._();

  static DictionaryController? _this;
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> getJackpotHome() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_JACKPOT_HOME, data: "", signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getDrawKeno() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_DRAW_KENO,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute1(baseRequest);
  }

  Future<dynamic> getDrawLoto() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_DRAW_LOTO, data: "", signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getDrawPower() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_DRAW_POWER, data: "", signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getDrawMega() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_DRAW_MEGA, data: "", signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getDrawLotto535() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_DRAW_LOTTO_535, data: "", signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getDrawKenoByDay() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_DRAW_KENO_BY_DAY1, data: "", signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getDrawMax3D() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_DRAW_MAX3D, data: "", signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getDrawMax3DPro() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_DRAW_MAX3D_PRO, data: "", signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getDrawLoto636() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_DRAW_LOTO636, data: "", signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getNotification(String mobileNumber) async {
    final Map<String, String> req = <String, String>{};
    req["MobileNumber"] = mobileNumber;
    RequestObject baseRequest = RequestObject(
        code: CommandCode.NOTIFICATION_SEARCH,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> countNotification(String mobileNumber) async {
    final Map<String, String> req = <String, String>{};
    req["MobileNumber"] = mobileNumber;
    RequestObject baseRequest = RequestObject(
        code: CommandCode.NOTIFICATION_COUNT_READ,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> updateNotification(NotificationUpdateReadRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.NOTIFICATION_UPDATE_READ,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getProvince() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_PROVINCE, data: "", signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getTerminal(int provinceID) async {
    final Map<String, String> req = <String, String>{};
    req["ProvinceID"] = provinceID.toString();
    req["IsLock"] = "N";
    RequestObject baseRequest = RequestObject(
        code: CommandCode.POS_SEARCH, data: jsonEncode(req), signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getPrams() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_PARAMS,
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
}
