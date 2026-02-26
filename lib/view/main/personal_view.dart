// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/models/request/player_base_request.dart';
import 'package:lottery_flutter_application/models/response/get_balance_response.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/utils/dialog_confirm.dart';
import 'package:lottery_flutter_application/utils/dialog_process.dart';
import 'package:lottery_flutter_application/view/account/rule_view.dart';
import 'package:lottery_flutter_application/view/personal/cashin_view.dart';
import 'package:lottery_flutter_application/view/personal/change_password_view.dart';
import 'package:lottery_flutter_application/view/personal/player_info_view.dart';
import 'package:lottery_flutter_application/view/personal/reward_cate_view.dart';
import 'package:lottery_flutter_application/widgets/icon_with_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/common.dart';
import '../../controller/account_controller.dart';
import '../../models/response/player_profile.dart';
import '../../utils/box_shadow.dart';
import '../../utils/dimen.dart';
import '../../utils/scaffold_messger.dart';
import '../account/login_view.dart';

class PersonalView extends StatefulWidget {
  const PersonalView({super.key});

  @override
  State<StatefulWidget> createState() => _PersonalView();
}

class _PersonalView extends State<PersonalView> {
  final AccountController _con = AccountController();
  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;
  List<GetBalanceResponse>? balanceResponse;
  int balanceWin = 0;
  String mode = "ON";
  @override
  void initState() {
    super.initState();
    initPref();
  }

  initPref() async {
    _prefs = await SharedPreferences.getInstance();
    mode = _prefs!.getString(Common.SHARE_MODE_UPLOAD)!;
    String? userMap = _prefs?.getString('user');
    if (userMap != null) {
      setState(() {
        playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      });
      getBalance();
    } else {
      if (mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginView()));
      }
    }
  }

  getBalance() async {
    if (playerProfile != null) {
      PlayerBaseRequest request =
          PlayerBaseRequest(mobileNumber: playerProfile!.mobileNumber!);
      ResponseObject res = await _con.getBalance(request);
      if (res.code == "00") {
        if (mounted) {
          setState(() {
            balanceResponse = List<GetBalanceResponse>.from(
                (jsonDecode(res.data!)
                    .map((model) => GetBalanceResponse.fromJson(model))));
            List<GetBalanceResponse>? balances = balanceResponse!
                .where((element) => element.accountType == "W")
                .toList();
            if (balances.isNotEmpty) {
              balanceWin = balances[0].amount!;
            }
          });
        }
      }
    }
  }

  logout() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    if (context.mounted) {
      sharedUser.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
        (Route<dynamic> route) => false,
      );
    }
  }

  lockUser() async {
    bool isAccept = await dialogConfirm(context, "Xác nhận xóa tài khoản",
        "Bạn có chắc chắn muốn xóa tài khoản?");
    if (isAccept) {
      if (mounted) {
        showProcess(context);
      }
      PlayerBaseRequest req =
          PlayerBaseRequest(mobileNumber: playerProfile!.mobileNumber);
      ResponseObject res = await _con.lockUser(req);
      if (mounted) Navigator.of(context).pop();
      if (res.code == "00") {
        if (mounted) {
          showMessage(context, "Tài khoản của bạn đã được xóa bỏ", "00");
        }
        Future.delayed(Duration(seconds: 3), () {
          logout();
        });
      } else {
        if (mounted) {
          showMessage(context, res.message!, "99");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (playerProfile == null) {
      return SizedBox.shrink();
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: ColorLot.ColorBackground,
            body: SingleChildScrollView(
                child: Column(
              children: [
                buildBalance(),
                Container(
                    padding: EdgeInsets.all(Dimen.padingDefault),
                    margin: EdgeInsets.only(
                        left: Dimen.padingDefault, right: Dimen.padingDefault),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[boxShadow()],
                        borderRadius:
                            BorderRadius.circular(Dimen.radiusBorder)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () => {
                            Future.delayed(Duration.zero, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlayerInfoView()));
                            })
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconWithBackground(
                                icon: Ionicons.person,
                                size: 20,
                                padding: 4,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Thông tin cá nhân",
                                  ),
                                  Icon(
                                    Ionicons.chevron_forward_outline,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                        buildChangePass(),
                        buildPolicy(),
                        // buildTutorial(),
                        buildContact(),
                        buildLogout()
                      ],
                    )),
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.all(Dimen.marginDefault),
                  child: Text(
                    "Phiên bản ${Common.VERSION}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorLot.ColorPrimary,
                        fontSize: Dimen.fontSizeDefault),
                  ),
                ),

                // SizedBox(
                //   height: 12,
                // ),
                buildDelete()
              ],
            ))));
  }

  Widget buildDelete() {
    if (Common.CHANNEL == "IOS") {
      return InkWell(
        onTap: lockUser,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              left: Dimen.padingDefault, right: Dimen.padingDefault),
          padding: EdgeInsets.all(Dimen.padingDefault),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[boxShadow()],
              borderRadius: BorderRadius.circular(Dimen.radiusBorder)),
          child: Text(
            "Xóa tài khoản",
            style: TextStyle(color: ColorLot.ColorPrimary, fontSize: 16),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildBalance() {
    if (playerProfile != null) {
      if (mode == Common.ANDROID_MODE_UPLOAD &&
          playerProfile!.mobileNumber != Common.MOBILE_OFF) {
        return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(Dimen.padingDefault),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[boxShadow()],
                borderRadius: BorderRadius.circular(Dimen.radiusBorder)),
            child: Column(
              children: [
                InkWell(
                    onTap: () => {
                          Future.delayed(Duration.zero, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CashinView()));
                          })
                        },
                    child: Row(
                      children: [
                        IconWithBackground(
                          icon: Ionicons.wallet,
                          size: 25,
                          iconColor: ColorLot.ColorPrimary,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tài khoản đặt vé",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      balanceResponse != null
                                          ? formatAmountD(balanceResponse!
                                              .where((element) =>
                                                  element.accountType == "P")
                                              .first
                                              .amount!)
                                          : "0đ",
                                      style: TextStyle(
                                          color: ColorLot.ColorPrimary,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: ColorLot.ColorPrimary),
                                  child: Text(
                                    "Nạp tiền",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Dimen.fontSizeDefault),
                                  ),
                                ),
                                Icon(
                                  Ionicons.chevron_forward_outline,
                                  size: 16,
                                  color: ColorLot.ColorPrimary,
                                )
                              ],
                            ),
                          ],
                        ))
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () => {
                    Future.delayed(Duration.zero, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RewardCateView()));
                    })
                  },
                  child: Row(
                    children: [
                      IconWithBackground(
                        icon: Ionicons.trophy,
                        iconColor: ColorLot.ColorPrimary,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tài khoản trúng thưởng",
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                formatAmountD(balanceWin),
                                style: TextStyle(
                                    color: ColorLot.ColorPrimary,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: ColorLot.ColorPrimary),
                                child: Text(
                                  "Đổi thưởng",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimen.fontSizeDefault),
                                ),
                              ),
                              Icon(
                                Ionicons.chevron_forward_outline,
                                size: 16,
                                color: ColorLot.ColorPrimary,
                              )
                            ],
                          ),
                        ],
                      ))
                    ],
                  ),
                )
              ],
            ));
      } else {
        return SizedBox.shrink();
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildPolicy() {
    if (mode == Common.ANDROID_MODE_UPLOAD &&
        playerProfile!.mobileNumber != Common.MOBILE_OFF) {
      return Column(
        children: [
          SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () {
              // Future.delayed(Duration.zero, () {
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => RuleView()));
              // });
            },
            child: Row(
              children: [
                IconWithBackground(
                    icon: Ionicons.shield_checkmark, size: 20, padding: 4),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Điều khoản chính sách"),
                    Icon(
                      Ionicons.chevron_forward_outline,
                      size: 16,
                      color: Colors.black54,
                    ),
                  ],
                ))
              ],
            ),
          )
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildTutorial() {
    if (mode == Common.ANDROID_MODE_UPLOAD &&
        playerProfile!.mobileNumber != Common.MOBILE_OFF) {
      return Column(
        children: [
          SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () {
              // Future.delayed(Duration.zero, () {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => RuleView(
              //                 url: "https://vesomb.vn/Tutorial",
              //                 title: "Hướng dẫn",
              //               )));
              // });
            },
            child: Row(
              children: [
                Icon(
                  Ionicons.newspaper_outline,
                  color: Colors.black54,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Hướng dẫn"),
                    Icon(
                      Ionicons.chevron_forward_outline,
                      size: 16,
                      color: Colors.black54,
                    ),
                  ],
                ))
              ],
            ),
          )
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildContact() {
    if (mode == Common.ANDROID_MODE_UPLOAD &&
        playerProfile!.mobileNumber != Common.MOBILE_OFF) {
      return Column(
        children: [
          SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () {
              // Future.delayed(Duration.zero, () {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => RuleView(
              //                 url: "https://vesomb.vn/Tutorial/Contact",
              //                 title: "Liên hệ",
              //               )));
              // });
            },
            child: Row(
              children: [
                IconWithBackground(icon: Ionicons.call, size: 20, padding: 4),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Liên hệ"),
                    Icon(
                      Ionicons.chevron_forward_outline,
                      size: 16,
                      color: Colors.black54,
                    ),
                  ],
                ))
              ],
            ),
          )
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildChangePass() {
    return Column(
      children: [
        SizedBox(
          height: 24,
        ),
        InkWell(
          onTap: () => {
            Future.delayed(Duration.zero, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswrodView()));
            })
          },
          child: Row(
            children: [
              IconWithBackground(
                icon: Ionicons.lock_open,
                size: 20,
                padding: 4,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Đổi mật khẩu"),
                  Icon(
                    Ionicons.chevron_forward_outline,
                    size: 16,
                    color: Colors.black54,
                  ),
                ],
              ))
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLogout() {
    return Column(
      children: [
        SizedBox(
          height: 24,
        ),
        InkWell(
          onTap: logout,
          child: Row(
            children: [
              IconWithBackground(
                icon: Ionicons.log_out,
                size: 20,
                padding: 4,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Đăng xuất"),
                  Icon(
                    Ionicons.chevron_forward_outline,
                    size: 16,
                    color: Colors.black54,
                  ),
                ],
              ))
            ],
          ),
        ),
      ],
    );
  }
}
