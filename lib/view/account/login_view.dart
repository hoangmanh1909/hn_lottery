// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unnecessary_brace_in_string_interps, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/controller/account_controller.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/box_shadow.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dialog_notify.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/view/account/register_view.dart';
import 'package:lottery_flutter_application/view/main/main_view.dart';
import 'package:lottery_flutter_application/widgets/app_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/common.dart';
import '../../models/request/login_request.dart';
import '../../models/response/player_profile.dart';
import '../../utils/dialog_process.dart';
import '../../utils/scaffold_messger.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginView();
}

class _LoginView extends State<LoginView> {
  final AccountController _con = AccountController();

  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool _showPassword = true;
  String deviceCode = "";
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    initPref();
  }

  void initPref() async {
    prefs = await SharedPreferences.getInstance();
    String? userMap = prefs!.getString('user');
    if (userMap != null) {
      setState(() {
        PlayerProfile playerProfile =
            PlayerProfile.fromJson(jsonDecode(userMap));
        mobileNumber.text = playerProfile.mobileNumber!;
      });
    }
    // await getParams();
    // await FirebaseMessaging.instance.subscribeToTopic("marketing");

    // FirebaseMessaging.instance.getToken().then((token) {
    //   if (token != null) deviceCode = token;
    // });
    // FirebaseMessaging.instance.getInitialMessage().then(
    //       (value) => setState(
    //         () {
    //           print(
    //               'Handling a background message getInitialMessage ${value?.data.toString()}');
    //         },
    //       ),
    //     );
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Handling a background message listen${message.messageId}');
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!${message}');
    // });
  }

  login() async {
    mobileNumber.text = "0936062990";
    password.text = "1";
    if (mobileNumber.text == "") {
      showMessage(context, "Vui lòng nhập số điện thoại", "99");
      return;
    }

    if (password.text == "") {
      showMessage(context, "Vui lòng nhập mật khẩu", "99");
      return;
    }
    LoginRequest loginRequest = LoginRequest();
    loginRequest.mobileNumber = mobileNumber.text;
    loginRequest.password = password.text;
    loginRequest.fCMToken = deviceCode;
    loginRequest.channel = Common.CHANNEL;
    if (mounted) showProcess(context);
    // await FirebaseMessaging.instance.subscribeToTopic("marketing");
    ResponseObject res = await _con.login(loginRequest);
    if (context.mounted) Navigator.pop(context);
    if (res.code == "00") {
      PlayerProfile playerProfile =
          PlayerProfile.fromJson(jsonDecode(res.data!));

      String user = jsonEncode(playerProfile);
      prefs!.setString('user', user);
      prefs!.setString('accessToken', res.accessToken!);
      prefs!.setString('mobileNumber', playerProfile.mobileNumber ?? "");
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MainView()),
            (Route<dynamic> route) => false);
      }
    } else {
      if (context.mounted) showMessage(context, res.message!, "99");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                    margin: EdgeInsets.all(30),
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Đăng nhập",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        AppTextField(
                          label: "Số điện thoại",
                          controller: mobileNumber,
                          keyboardType: TextInputType.phone,
                          suffixIcon: mobileNumber.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    setState(() {
                                      mobileNumber.clear();
                                    });
                                  },
                                )
                              : null,
                        ),
                        SizedBox(height: 12),
                        AppTextField(
                          label: "Mật khẩu",
                          controller: password,
                          obscureText: _showPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() => _showPassword = !_showPassword);
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: login,
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: ColorLot.ColorPrimary,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Center(
                                child: Text(
                              "Đăng nhập",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ),
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: InkWell(
                            onTap: () {
                              dialogNotify(context, "Quên mật khẩu",
                                  "Để lấy lại mật khẩu quý khách vui lòng nhắn tin về số điện thoại 0971896985");
                            },
                            child: Text("Quên mật khẩu?"),
                          ),
                        ),
                        SizedBox(height: 12),
                        buidRegister()
                      ],
                    ))),
              ),
              SizedBox(
                  height: 30,
                  child: Text(
                    "Phiên bản ${Common.VERSION}",
                    style: TextStyle(
                        color: ColorLot.ColorPrimary,
                        fontSize: Dimen.fontSizeDefault),
                  ))
            ],
          )),
    );
  }

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      hintText: "Nhập $label",
      floatingLabelStyle: TextStyle(color: ColorLot.ColorPrimary),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorLot.ColorPrimary, width: 1.5),
      ),
    );
  }

  Widget buidRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Bạn chưa có tài khoản?"),
        SizedBox(
          width: 4,
        ),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterView()));
          },
          child: Text(
            "Đăng ký",
            style: TextStyle(color: ColorLot.ColorPrimary),
          ),
        )
      ],
    );
  }
}
