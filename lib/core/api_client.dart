// ignore_for_file: deprecated_member_use, unused_import, prefer_interpolation_to_compose_strings, unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lottery_flutter_application/models/request/request_object.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<ResponseObject> login(RequestObject baseRequest) async {
    try {
      Response response = await _dio.post(urlGateway + "Mobile/Login",
          data: baseRequest,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      return ResponseObject.fromJson(response.data);
    } on DioError {
      ResponseObject responseObject =
          ResponseObject(code: "98", message: "Không thể kết nối đến máy chủ");
      return responseObject;
    }
  }

  Future<ResponseObject> register(RequestObject baseRequest) async {
    try {
      Response response = await _dio.post(urlGateway + "Mobile/Register",
          data: baseRequest,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      return ResponseObject.fromJson(response.data);
    } on DioError {
      ResponseObject responseObject =
          ResponseObject(code: "98", message: "Không thể kết nối đến máy chủ");
      return responseObject;
    }
  }

  Future<ResponseObject> getPrams() async {
    try {
      Response response = await _dio.get(urlGateway + "Mobile/GetPrams",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      return ResponseObject.fromJson(response.data);
    } on DioError {
      ResponseObject responseObject =
          ResponseObject(code: "98", message: "Không thể kết nối đến máy chủ");
      return responseObject;
    }
  }

  Future<ResponseObject> execute(RequestObject baseRequest) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? mobileNumber = prefs.getString('mobileNumber');
    try {
      Response response = await _dio.post(urlGateway + "Mobile/Execute",
          data: baseRequest,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "AccessToken": accessToken,
            "MobileNumber": mobileNumber
          }));

      return ResponseObject.fromJson(response.data);
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          ResponseObject responseObject = ResponseObject(
              code: e.response!.statusCode.toString(),
              message: "Không thể kết nối đến máy chủ");
          return responseObject;
        } else {
          ResponseObject responseObject = ResponseObject(
              code: "98", message: "Không thể kết nối đến máy chủ");
          return responseObject;
        }
        //handle DioError here by error type or by error code
      } else {
        ResponseObject responseObject = ResponseObject(
            code: "98", message: "Không thể kết nối đến máy chủ");
        return responseObject;
      }
    }
  }

  Future<ResponseObject> execute1(RequestObject baseRequest) async {
    try {
      Response response = await _dio.post(urlGateway + "Gateway/ExecuteV1",
          data: baseRequest,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      return ResponseObject.fromJson(response.data);
    } on DioError {
      ResponseObject responseObject =
          ResponseObject(code: "98", message: "Không thể kết nối đến máy chủ");
      return responseObject;
    }
  }

  Future<ResponseObject> executeSomo() async {
    try {
      Response response = await _dio.get(urlGateway + "Gateway/GetSomo");

      return ResponseObject.fromJson(response.data);
    } on DioError {
      ResponseObject responseObject =
          ResponseObject(code: "98", message: "Không thể kết nối đến máy chủ");
      return responseObject;
    }
  }

//
// DioException (DioException [bad response]: This exception was thrown because the response has a status code of 404 and RequestOptions.validateStatus was configured to throw for this status code.
// The status code of 404 has the following meaning: "Client error - the request contains bad syntax or cannot be fulfilled"
// Read more about status codes at https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
// In order to resolve this exception you typically have either to verify and fix your request code or you have to fix the server code.
// )
}
