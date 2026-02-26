import 'dart:convert';

import 'package:lottery_flutter_application/models/request/reward_exchage_search_request.dart';
import 'package:lottery_flutter_application/models/request/reward_exchange_request.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../constants/command_code.dart';
import '../core/api_client.dart';
import '../models/request/player_base_request.dart';
import '../models/request/request_object.dart';
import '../models/response/response_object.dart';

class RewardController extends ControllerMVC {
  factory RewardController() => _this ??= RewardController._();
  RewardController._();
  static RewardController? _this;
  final ApiClient _apiClient = ApiClient();

  Future<ResponseObject> getBalance(PlayerBaseRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.TRANS_GET_BALANCE,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> getBank() async {
    RequestObject baseRequest =
        RequestObject(code: CommandCode.DIC_GET_BANK, data: "", signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> rewardExchangeAdd(RewardExchangeAddRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.TRANS_REWARD_EXCHANGE_ADD,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> getRewardHistory(
      RewardExchangeSearchRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.TRANS_REWARD_EXCHANGE_SEARCH,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }
}
