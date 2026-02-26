// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/constants/common.dart';
import 'package:lottery_flutter_application/controller/account_controller.dart';
import 'package:lottery_flutter_application/controller/dictionary_controller.dart';
import 'package:lottery_flutter_application/controller/reward_controller.dart';
import 'package:lottery_flutter_application/models/request/edit_profile_request.dart';
import 'package:lottery_flutter_application/models/request/reward_exchange_request.dart';
import 'package:lottery_flutter_application/models/response/bank_response.dart';
import 'package:lottery_flutter_application/models/response/dictionary_response.dart';
import 'package:lottery_flutter_application/models/terminal_view_model.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/utils/dialog_process.dart';
import 'package:lottery_flutter_application/utils/widget_divider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/request/player_base_request.dart';
import '../../models/response/get_balance_response.dart';
import '../../models/response/player_profile.dart';
import '../../models/response/response_object.dart';
import '../../utils/color_lot.dart';
import '../../utils/dialog_notify_sucess.dart';
import '../../utils/dimen.dart';
import '../../utils/scaffold_messger.dart';

class PlayerInfoView extends StatefulWidget {
  const PlayerInfoView({Key? key}) : super(key: key);

  @override
  State<PlayerInfoView> createState() => _PlayerInfoViewState();
}

class _PlayerInfoViewState extends State<PlayerInfoView> {
  final AccountController _con = AccountController();
  final DictionaryController _dic = DictionaryController();
  SharedPreferences? prefs;
  PlayerProfile? playerProfile;

  final TextEditingController mobile = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController pidNumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController province = TextEditingController();
  final TextEditingController terminal = TextEditingController();

  List<DictionaryResponse> provinces = [];
  DictionaryResponse? selectedProvince;
  TerminalViewModel? selectedTerminal;
  String mode = "ON";
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      initPref();
    });
  }

  initPref() async {
    prefs = await SharedPreferences.getInstance();
    mode = prefs!.getString(Common.SHARE_MODE_UPLOAD)!;
    String? userMap = prefs?.getString('user');
    if (mounted) showProcess(context);
    if (userMap != null) {
      setState(() {
        playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      });

      if (playerProfile != null) {
        mobile.text = playerProfile!.mobileNumber!;
        name.text = playerProfile!.name ?? "";
        pidNumber.text = playerProfile!.pIDNumber ?? "";
        email.text = playerProfile!.emailAddress ?? "";
        province.text = playerProfile!.provinceName ?? "";
        terminal.text = playerProfile!.terminalName ?? "";

        selectedProvince = DictionaryResponse();
        selectedProvince!.iD = playerProfile!.provinceID ?? 0;
        selectedProvince!.name = playerProfile!.provinceName ?? "";

        selectedTerminal = TerminalViewModel();
        selectedTerminal!.iD = playerProfile!.terminalID ?? 0;
        selectedTerminal!.name = playerProfile!.terminalName ?? "";
      }
    }
    await getProvince();
    if (context.mounted) Navigator.pop(context);
  }

  getProvince() async {
    ResponseObject res = await _dic.getProvince();

    if (res.code == "00") {
      if (context.mounted) {
        provinces = List<DictionaryResponse>.from((jsonDecode(res.data!)
            .map((model) => DictionaryResponse.fromJson(model))));
      }
    } else {
      if (context.mounted) showMessage(context, res.message!, "98");
    }
  }

  onOk() async {
    EditProfileRequest req = EditProfileRequest();

    if (name.text == '') {
      showMessage(context, "Bạn chưa nhập họ và tên", "100");
      return;
    }

    if (playerProfile != null) {
      if (mode == Common.ANDROID_MODE_UPLOAD &&
          playerProfile!.mobileNumber != Common.MOBILE_OFF) {
        if (pidNumber.text == '') {
          showMessage(context, "Bạn chưa nhập số giấy tờ tùy thân", "100");
          return;
        }
      }
    }
    req.iD = playerProfile!.iD!;
    req.emailAddress = email.text;
    req.name = name.text;
    req.pIDNumber = pidNumber.text;

    if (selectedProvince != null) {
      req.provinceID = selectedProvince!.iD;
    }
    if (selectedTerminal != null) {
      req.terminalID = selectedTerminal!.iD;
    }
    if (mounted) showProcess(context);
    ResponseObject res = await _con.editProfile(req);
    if (context.mounted) Navigator.pop(context);
    if (res.code == "00") {
      if (context.mounted) {
        PlayerProfile newProfile = PlayerProfile();
        newProfile = playerProfile!;
        newProfile.emailAddress = req.emailAddress;
        newProfile.name = req.name;
        newProfile.pIDNumber = req.pIDNumber;

        if (selectedProvince != null) {
          newProfile.provinceID = selectedProvince!.iD!;
          newProfile.provinceName = selectedProvince!.name!;
        }
        if (selectedTerminal != null) {
          newProfile.terminalID = req.terminalID;
          newProfile.terminalName = selectedTerminal!.name!;
        }
        String user = jsonEncode(playerProfile);
        prefs!.setString('user', user);
        dialogBuilderSucess(context, "Cập nhật thông tin thành công", "");
      }
    } else {
      if (context.mounted) showMessage(context, res.message!, "98");
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
          title: const Text('Thông tin cá nhân'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Scaffold(
            backgroundColor: ColorLot.ColorBackground,
            body: SingleChildScrollView(
                child: Container(
                    height: size.height,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                                controller: mobile,
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Số điện thoại",
                                  floatingLabelStyle:
                                      TextStyle(color: ColorLot.ColorPrimary),
                                  counterText: "",
                                  isDense: true,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorLot.ColorPrimary),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Dimen.marginDefault,
                              ),
                              TextFormField(
                                controller: name,
                                decoration: InputDecoration(
                                  hintText: "Nhập họ và tên",
                                  labelText: "Họ và tên",
                                  floatingLabelStyle:
                                      TextStyle(color: ColorLot.ColorPrimary),
                                  counterText: "",
                                  isDense: true,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorLot.ColorPrimary),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Dimen.marginDefault,
                              ),
                              buildProfile()
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
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
                    ])))));
  }

  Widget buildProfile() {
    if (playerProfile != null) {
      if (mode == Common.ANDROID_MODE_UPLOAD &&
          playerProfile!.mobileNumber != Common.MOBILE_OFF) {
        return Column(
          children: [
            TextFormField(
              controller: pidNumber,
              decoration: InputDecoration(
                hintText: "Nhập số giấy tờ tùy thân",
                labelText: "Số giấy tờ tùy thân",
                floatingLabelStyle: TextStyle(color: ColorLot.ColorPrimary),
                counterText: "",
                isDense: true,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorLot.ColorPrimary),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: Dimen.marginDefault,
            ),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                hintText: "Nhập email",
                labelText: "Email",
                floatingLabelStyle: TextStyle(color: ColorLot.ColorPrimary),
                counterText: "",
                isDense: true,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorLot.ColorPrimary),
                ),
              ),
            ),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    } else {
      return SizedBox.shrink();
    }
  }

  openDialogProvince() async {
    DictionaryResponse? provinceModel =
        await Navigator.of(context).push(MaterialPageRoute<DictionaryResponse>(
            builder: (BuildContext context) {
              return ProvinceDialog(
                provinces: provinces,
              );
            },
            fullscreenDialog: true));
    if (provinceModel != null) {
      setState(() {
        selectedProvince = provinceModel;
        province.text = selectedProvince!.name!;
      });
    }
  }

  openDialogTerminal() async {
    if (selectedProvince != null) {
      ResponseObject res = await _dic.getTerminal(selectedProvince!.iD!);

      if (res.code == "00") {
        if (context.mounted) {
          List<TerminalViewModel> terminals = List<TerminalViewModel>.from(
              (jsonDecode(res.data!)
                  .map((model) => TerminalViewModel.fromJson(model))));

          TerminalViewModel? terminalViewModel = await Navigator.of(context)
              .push(MaterialPageRoute<TerminalViewModel>(
                  builder: (BuildContext context) {
                    return TerminalDialog(
                      terminals: terminals,
                    );
                  },
                  fullscreenDialog: true));
          if (terminalViewModel != null) {
            setState(() {
              selectedTerminal = terminalViewModel;
              terminal.text = selectedTerminal!.address!;
            });
          }
        }
      } else {
        if (context.mounted) showMessage(context, res.message!, "98");
      }
    } else {
      if (context.mounted) {
        showMessage(context, "Vui lòng chọn Tỉnh/Thành phố in vé", "98");
      }
    }
  }
}

class ProvinceDialog extends StatelessWidget {
  const ProvinceDialog({super.key, required this.provinces});

  final List<DictionaryResponse> provinces;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorLot.ColorPrimary,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          title: const Text('Chọn Tỉnh/Thành phố in vé'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(color: Colors.white),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: provinces.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).pop(provinces[index]);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    provinces[index].name!.trim(),
                                  ),
                                  Icon(
                                    Ionicons.chevron_forward_outline,
                                    size: 18,
                                    color: Colors.black54,
                                  )
                                ],
                              )),
                          dividerLot()
                        ],
                      ));
                })));
  }
}

class TerminalDialog extends StatelessWidget {
  const TerminalDialog({super.key, required this.terminals});

  final List<TerminalViewModel> terminals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorLot.ColorPrimary,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          title: const Text('Chọn Điểm in vé'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(color: Colors.white),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: terminals.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).pop(terminals[index]);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    terminals[index].address!.trim(),
                                  )),
                                  Container(
                                    width: 30,
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Ionicons.chevron_forward_outline,
                                      size: 18,
                                      color: Colors.black54,
                                      textDirection: TextDirection.ltr,
                                    ),
                                  )
                                ],
                              )),
                          dividerLot()
                        ],
                      ));
                })));
  }
}
