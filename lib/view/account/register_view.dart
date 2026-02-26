// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/models/request/register_request.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/view/main/main_view.dart';
import 'package:lottery_flutter_application/widgets/app_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/account_controller.dart';
import '../../models/response/player_profile.dart';
import '../../utils/color_lot.dart';
import '../../utils/dialog_process.dart';
import '../../utils/scaffold_messger.dart';
import 'rule_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AccountController _con = AccountController();
  bool _showPassword = true;
  bool _showPasswordAgain = true;
  bool isChecked = true;
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordAgain = TextEditingController();
  register() async {
    if (mobileNumber.text == "") {
      showMessage(context, "Bạn chưa nhập số điện thoại", "99");
      return;
    }
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
    if (!isChecked) {
      showMessage(context, "Bạn chưa đồng ý điều khoản sử dụng", "99");
      return;
    }

    RegisterRequest request = RegisterRequest(
        mobileNumber: mobileNumber.text,
        password: password.text,
        oTP: "",
        sourceNumber: "");

    showProcess(context);
    ResponseObject res = await _con.register(request);
    if (context.mounted) Navigator.pop(context);
    if (res.code == "00") {
      PlayerProfile playerProfile =
          PlayerProfile.fromJson(jsonDecode(res.data!));
      SharedPreferences sharedUser = await SharedPreferences.getInstance();
      String user = jsonEncode(playerProfile);
      sharedUser.setString('user', user);
      sharedUser.setString('accessToken', res.accessToken!);
      sharedUser.setString('mobileNumber', playerProfile.mobileNumber ?? "");
      Future.delayed(Duration.zero, () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainView()));
      });
    } else {
      if (context.mounted) showMessage(context, res.message!, "99");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
              ),
              Center(
                child: Text(
                  "Đăng ký tài khoản",
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
              ),
              SizedBox(height: 12),
              AppTextField(
                label: "Mật khẩu",
                controller: password,
                obscureText: _showPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() => _showPassword = !_showPassword);
                  },
                ),
              ),
              SizedBox(height: 12),
              AppTextField(
                label: "Nhập lại mật khẩu",
                controller: passwordAgain,
                obscureText: _showPasswordAgain,
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPasswordAgain
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() => _showPasswordAgain = !_showPasswordAgain);
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() => isChecked = value ?? false);
                    },
                    shape: const CircleBorder(),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(
                            text: "Tôi đã đủ 18 tuổi, đã đọc và đồng ý với ",
                          ),
                          TextSpan(
                            text: "Điều khoản sử dụng",
                            style: TextStyle(
                              color: ColorLot.ColorPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RuleView(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: register,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ColorLot.ColorPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: Center(
                      child: Text(
                    "Đăng ký",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),
            ],
          ),
        )));
  }
}
