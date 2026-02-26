// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/models/request/change_password_request.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/account_controller.dart';
import '../../models/response/player_profile.dart';
import '../../utils/color_lot.dart';
import '../../utils/dialog_notify_sucess.dart';
import '../../utils/dialog_process.dart';
import '../../utils/dimen.dart';
import '../../utils/scaffold_messger.dart';

class ChangePasswrodView extends StatefulWidget {
  const ChangePasswrodView({Key? key}) : super(key: key);
  @override
  State<ChangePasswrodView> createState() => _ChangePasswrodViewState();
}

class _ChangePasswrodViewState extends State<ChangePasswrodView> {
  final AccountController _con = AccountController();

  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;
  bool _showPassword = true;
  bool _showPasswordAgain = true;
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordAgain = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      initPref();
    });
  }

  initPref() async {
    _prefs = await SharedPreferences.getInstance();
    String? userMap = _prefs?.getString('user');
    if (userMap != null) {
      setState(() {
        playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      });
    }
  }

  onOk() async {
    if (password.text == "") {
      showMessage(context, "Bạn chưa nhập mật khẩu", "99");
      return;
    }
    if (passwordAgain.text == "") {
      showMessage(context, "Bạn chưa nhập lại mật khẩu", "99");
      return;
    }
    if (password.text != passwordAgain.text) {
      showMessage(context, "Mật khẩu không khớp", "99");
      return;
    }
    ChangePasswordRequest request = ChangePasswordRequest(
        password: password.text, mobileNumber: playerProfile!.mobileNumber!);

    showProcess(context);
    ResponseObject res = await _con.changePassword(request);
    if (context.mounted) Navigator.pop(context);
    if (res.code == "00") {
      if (context.mounted) {
        dialogBuilderSucess(context, "Thay đổi mật khẩu thành công", "");
      }
    } else {
      if (context.mounted) showMessage(context, res.message!, "99");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorLot.ColorPrimary,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          title: const Text('Thay đổi mật khẩu'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Scaffold(
            backgroundColor: ColorLot.ColorBackground,
            body: Container(
                height: size.height,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(children: [
                  Container(
                      padding: EdgeInsets.all(Dimen.padingDefault),
                      margin: EdgeInsets.only(
                          left: Dimen.marginDefault,
                          right: Dimen.marginDefault,
                          top: Dimen.marginDefault),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimen.radiusBorder)),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            obscureText: _showPassword,
                            controller: password,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(
                                      () => _showPassword = !_showPassword);
                                },
                                child: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color.fromARGB(255, 80, 44, 44),
                                ),
                              ),
                              labelText: "Mật khẩu mới",
                              floatingLabelStyle:
                                  TextStyle(color: ColorLot.ColorPrimary),
                              hintText: "Nhập mật khẩu mới",
                              counterText: "",
                              isDense: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorLot.ColorPrimary),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorLot.ColorPrimary),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          TextFormField(
                            obscureText: _showPasswordAgain,
                            controller: passwordAgain,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() =>
                                      _showPasswordAgain = !_showPasswordAgain);
                                },
                                child: Icon(
                                  _showPasswordAgain
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color.fromARGB(255, 80, 44, 44),
                                ),
                              ),
                              labelText: "Nhập lại mật khẩu mới",
                              floatingLabelStyle:
                                  TextStyle(color: ColorLot.ColorPrimary),
                              hintText: "Nhập lại mật khẩu mới",
                              counterText: "",
                              isDense: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorLot.ColorPrimary),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorLot.ColorPrimary),
                              ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: onOk,
                    child: Container(
                      height: 40,
                      width: size.width - 32,
                      decoration: BoxDecoration(
                          color: ColorLot.ColorPrimary,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                          child: Text(
                        "Cập nhật",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                ]))));
  }
}
