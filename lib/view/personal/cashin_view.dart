// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/models/request/change_password_request.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/account_controller.dart';
import '../../models/response/player_profile.dart';
import '../../utils/box_shadow.dart';
import '../../utils/color_lot.dart';
import '../../utils/dialog_notify_sucess.dart';
import '../../utils/dialog_process.dart';
import '../../utils/dimen.dart';
import '../../utils/scaffold_messger.dart';

class CashinView extends StatefulWidget {
  const CashinView({Key? key}) : super(key: key);
  @override
  State<CashinView> createState() => _CashinViewState();
}

class _CashinViewState extends State<CashinView> {
  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;

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
          title: const Text('Nạp tiền'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Scaffold(
            backgroundColor: ColorLot.ColorBackground,
            body: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(Dimen.padingDefault),
                    margin: EdgeInsets.only(
                        left: Dimen.marginDefault,
                        right: Dimen.marginDefault,
                        top: Dimen.marginDefault),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[boxShadow()],
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimen.radiusBorder)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "HappyLott hỗ trợ nạp số dư qua hình thức chuyển khoản ngân hàng (nạp tối thiểu 50.000đ) với nội dung như sau:",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: Dimen.fontSizeDefault),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "NAP${playerProfile != null ? playerProfile!.mobileNumber! : ""}",
                              style: TextStyle(
                                  color: ColorLot.ColorPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                copyClipboard(
                                    "NAP${playerProfile != null ? playerProfile!.mobileNumber! : ""}",
                                    context);
                              },
                              child: Icon(
                                Ionicons.copy_outline,
                                color: ColorLot.ColorBaoChung,
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                Container(
                    padding: EdgeInsets.all(Dimen.padingDefault),
                    margin: EdgeInsets.only(
                        left: Dimen.marginDefault,
                        right: Dimen.marginDefault,
                        top: Dimen.marginDefault),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[boxShadow()],
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimen.radiusBorder)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 70,
                              child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/img/vietinkbank.png'),
                                    width: 50,
                                    height: 50,
                                  )),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    textValue(
                                        "CÔNG TY TNHH TM DICH VU HAPPYLOTT")
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    textLable("Ngân hàng: "),
                                    textValue("Vietinbank")
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),

                                Row(
                                  children: [
                                    textLable("Số tài khoản: "),
                                    textValue("110603712688"),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        copyClipboard("110603712688", context);
                                      },
                                      child: Icon(
                                        Ionicons.copy_outline,
                                        color: ColorLot.ColorBaoChung,
                                      ),
                                    )
                                  ],
                                ),
                                // SizedBox(
                                //   height: 8,
                                // ),
                                // Row(
                                //   children: [
                                //     textValue(
                                //         "CÔNG TY CỔ PHẦN PHÁT TRIỂN GIẢI PHÁP CÔNG NGHỆ SỐ MYLOTT")
                                //   ],
                                // ),
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          width: size.width,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Image(
                                image: AssetImage('assets/img/mylottqr.png'),
                                width: size.width,
                              )),
                        )
                      ],
                    ))
              ],
            ))));
  }

  Widget textLable(text) {
    return Text(
      text,
      style: TextStyle(fontSize: Dimen.fontSizeLable, color: Colors.black54),
    );
  }

  Widget textValue(String lable) {
    return Flexible(
        child: Text(
      lable,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Colors.black,
          fontSize: Dimen.fontSizeValue,
          fontWeight: FontWeight.w600),
    ));
  }
}
