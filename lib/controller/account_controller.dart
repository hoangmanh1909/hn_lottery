import 'dart:convert';

import 'package:lottery_flutter_application/core/api_client.dart';
import 'package:lottery_flutter_application/models/request/edit_profile_request.dart';
import 'package:lottery_flutter_application/models/request/register_request.dart';
import 'package:lottery_flutter_application/models/request/request_object.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../constants/command_code.dart';
import '../models/request/change_password_request.dart';
import '../models/request/login_request.dart';
import '../models/request/player_base_request.dart';

class AccountController extends ControllerMVC {
  factory AccountController() => _this ??= AccountController._();
  AccountController._();

  static AccountController? _this;
  final ApiClient _apiClient = ApiClient();

  Future<ResponseObject> login(LoginRequest loginRequest) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.ACC_LOGIN,
        data: jsonEncode(loginRequest),
        signature: "");
    return await _apiClient.login(baseRequest);
  }

  Future<ResponseObject> register(RegisterRequest registerRequest) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.ACC_REGISTER,
        data: jsonEncode(registerRequest),
        signature: "");
    return await _apiClient.register(baseRequest);
  }

  Future<ResponseObject> getBalance(PlayerBaseRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.TRANS_GET_BALANCE,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> editProfile(EditProfileRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.ACC_EDIT_PROFILE,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> changePassword(ChangePasswordRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.ACC_CHANGE_PASSWORD,
        data: jsonEncode(req),
        signature: "");
    return await _apiClient.execute(baseRequest);
  }

  Future<ResponseObject> lockUser(PlayerBaseRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.ACC_LOCK, data: jsonEncode(req), signature: "");
    return await _apiClient.execute(baseRequest);
  }
}
