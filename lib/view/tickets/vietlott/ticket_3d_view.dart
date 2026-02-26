// ignore_for_file: public_member_api_docs, sort_constructors_first, await_only_futures, use_build_context_synchronously, prefer_interpolation_to_compose_strings, unused_field, unnecessary_brace_in_string_interps, prefer_final_fields
// ignore_for_file: prefer_const_constructors, sort_child_properties_last, must_be_immutable, unnecessary_new, prefer_const_literals_to_create_immutables, unnecessary_this, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/controller/account_controller.dart';
import 'package:lottery_flutter_application/controller/dictionary_controller.dart';
import 'package:lottery_flutter_application/controller/history_controller.dart';
import 'package:lottery_flutter_application/controller/payment_controller.dart';
import 'package:lottery_flutter_application/models/request/get_fee_request.dart';
import 'package:lottery_flutter_application/models/response/draw_response.dart';
import 'package:lottery_flutter_application/models/response/get_item_response.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/box_shadow.dart';
import 'package:lottery_flutter_application/utils/dialog_draw_checkbox.dart';
import 'package:lottery_flutter_application/utils/dialog_selected_radio.dart';
import 'package:lottery_flutter_application/utils/dialog_update_info_player.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/utils/head_balance_view.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/common.dart';
import '../../../../models/request/order_add_request.dart';
import '../../../../models/request/order_item_add_request.dart';
import '../../../../models/request/player_base_request.dart';
import '../../../../models/response/get_balance_response.dart';
import '../../../../models/response/player_profile.dart';
import '../../../../utils/color_lot.dart';
import '../../../../utils/common.dart';
import '../../../../utils/dialog_payment.dart';
import '../../../../utils/dialog_process.dart';
import '../../../../utils/scaffold_messger.dart';
import '../../../utils/dialog_number_3d.dart';
import '../../../utils/dialog_qr.dart';
import '../../../utils/widget_divider.dart';

final key = new GlobalKey<_Ticket3DState>();

class Ticket3DView extends StatefulWidget {
  const Ticket3DView({Key? key, required this.productID, this.code})
      : super(key: key);
  final int productID;
  final String? code;
  @override
  State<Ticket3DView> createState() => _Ticket3DState();
}

class _Ticket3DState extends State<Ticket3DView> {
  final DictionaryController _con = DictionaryController();
  final AccountController _conAcc = AccountController();
  final PaymentController _conPay = PaymentController();
  final HistoryController _his = HistoryController();

  List<GetItemResponse>? items;

  List<GetBalanceResponse>? balanceResponse;
  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;
  bool isSelectionMode = false;

  int drafAmount = 0;
  int balance = 0;
  List<DrawResponse>? drawResponse;
  List<DrawResponse> draws = [];
  List<int> listAmount = [];
  int _price = 20000;
  int _system = 2;
  bool isBag = true;
  List<String>? listBall;
  List<String>? listBallA;
  List<String>? listBallB;
  List<String>? listBallC;
  List<String>? listBallD;
  List<String>? listBallE;
  List<String>? listBallF;
  int amountA = 20000;
  int amountB = 20000;
  int amountC = 20000;
  int amountD = 20000;
  int amountE = 20000;
  int amountF = 20000;
  int systemA = 0;
  int systemB = 0;
  int systemC = 0;
  int systemD = 0;
  int systemE = 0;
  int systemF = 0;
  String mode = "ON";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
    });
    if (widget.productID == Common.ID_MAX3D_PLUS) {
      listAmount = [10000, 20000, 50000, 100000, 200000];
      isBag = false;
    } else {
      listAmount = [10000, 20000, 50000, 100000];
    }
    initData();
  }

  getItemByCode() async {
    ResponseObject res = await _his.getItemByCode(widget.code!);
    if (res.code == "00") {
      items = List<GetItemResponse>.from((jsonDecode(res.data!)
          .map((model) => GetItemResponse.fromJson(model))));
      GetItemResponse item = items![0];

      if (item.lineA!.isNotEmpty) {
        listBallA = item.lineA!.split(',');
        amountA = item.priceA!;
      }
      if (item.lineB!.isNotEmpty) {
        listBallB = item.lineB!.split(',');
        amountB = item.priceB!;
      }
      if (item.lineC!.isNotEmpty) {
        listBallC = item.lineC!.split(',');
        amountC = item.priceC!;
      }
      if (item.lineD!.isNotEmpty) {
        listBallD = item.lineD!.split(',');
        amountD = item.priceD!;
      }
      if (item.lineE!.isNotEmpty) {
        listBallE = item.lineE!.split(',');
        amountE = item.priceE!;
      }
      if (item.lineF!.isNotEmpty) {
        listBallF = item.lineF!.split(',');
        amountF = item.priceF!;
      }
      calculator();
    }
  }

  getData() async {
    _prefs = await SharedPreferences.getInstance();
    mode = _prefs!.getString(Common.SHARE_MODE_UPLOAD)!;
    String? userMap = _prefs?.getString('user');
    if (userMap != null) {
      playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
    } else {
      if (mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginView()));
      }
      return;
    }

    if (mounted) {
      showProcess(context);
    }
    if (widget.productID == Common.ID_MAX3D_PRO) {
      await getDrawMax3DPro();
    } else {
      await getDrawMax3D();
    }
    await getBalance();
    if (drawResponse != null) {
      draws.add(drawResponse![0]);

      if (widget.code != null) {
        getItemByCode();
      }
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  getDrawMax3D() async {
    if (context.mounted) showProcess(context);
    ResponseObject res = await _con.getDrawMax3D();
    if (context.mounted) Navigator.pop(context);
    if (res.code == "00") {
      setState(() {
        drawResponse = List<DrawResponse>.from((jsonDecode(res.data!)
            .map((model) => DrawResponse.fromJson(model))));
      });
    } else {
      if (context.mounted) showMessage(context, res.message!, "99");
    }
  }

  getDrawMax3DPro() async {
    if (context.mounted) showProcess(context);
    ResponseObject res = await _con.getDrawMax3DPro();
    if (context.mounted) Navigator.pop(context);
    if (res.code == "00") {
      setState(() {
        drawResponse = List<DrawResponse>.from((jsonDecode(res.data!)
            .map((model) => DrawResponse.fromJson(model))));
      });
    } else {
      if (context.mounted) showMessage(context, res.message!, "99");
    }
  }

  getBalance() async {
    if (playerProfile != null) {
      PlayerBaseRequest request =
          PlayerBaseRequest(mobileNumber: playerProfile!.mobileNumber!);
      ResponseObject res = await _conAcc.getBalance(request);
      if (res.code == "00") {
        if (mounted) {
          balanceResponse = List<GetBalanceResponse>.from((jsonDecode(res.data!)
              .map((model) => GetBalanceResponse.fromJson(model))));
          GetBalanceResponse bl = balanceResponse!
              .where((element) => element.accountType == "P")
              .first;
          setState(() {
            balance = bl.amount!;
          });
        }
      }
    }
  }

  initData() {
    listBall = List<String>.generate(_system, (index) => "");
    listBallA = List<String>.generate(_system, (index) => "");
    listBallB = List<String>.generate(_system, (index) => "");
    listBallC = List<String>.generate(_system, (index) => "");
    listBallD = List<String>.generate(_system, (index) => "");
    listBallE = List<String>.generate(_system, (index) => "");
    listBallF = List<String>.generate(_system, (index) => "");
  }

  String random(List<String> _listBall) {
    var rng = Random();
    String s = (rng.nextInt(999) + 1).toString().padLeft(3, '0');
    return _listBall.contains(s) ? this.random(_listBall) : s;
  }

  randomNumber() {
    bool isCheck = true;
    if (listBallA?[0] == "") {
      for (var i = 0; i < listBallA!.length; i++) {
        listBallA?[i] = random(listBallA!);
      }
      listBallA?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      isCheck = false;
    }
    if (listBallB?[0] == "" && isCheck) {
      for (var i = 0; i < listBallB!.length; i++) {
        listBallB?[i] = random(listBallB!);
      }
      listBallB?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      isCheck = false;
    }
    if (listBallC?[0] == "" && isCheck) {
      for (var i = 0; i < listBallC!.length; i++) {
        listBallC?[i] = random(listBallC!);
      }
      listBallC?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      isCheck = false;
    }
    if (listBallD?[0] == "" && isCheck) {
      for (var i = 0; i < listBallD!.length; i++) {
        listBallD?[i] = random(listBallD!);
      }
      listBallD?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      isCheck = false;
    }
    if (listBallE?[0] == "" && isCheck) {
      for (var i = 0; i < listBallE!.length; i++) {
        listBallE?[i] = random(listBallE!);
      }
      isCheck = false;
    }
    if (listBallF?[0] == "" && isCheck) {
      for (var i = 0; i < listBallF!.length; i++) {
        listBallF?[i] = random(listBallF!);
      }
      isCheck = false;
    }

    calculator();
  }

  randomNumberLine(List<String> _listBall, String _line) {
    for (var i = 0; i < _listBall.length; i++) {
      _listBall[i] = random(_listBall);
    }
    _listBall.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    switch (_line) {
      case "A":
        setState(() {
          listBallA = _listBall;
        });
        break;
      case "B":
        setState(() {
          listBallB = _listBall;
        });
        break;
      case "C":
        setState(() {
          listBallC = _listBall;
        });
        break;
      case "D":
        setState(() {
          listBallD = _listBall;
        });
        break;
      case "E":
        setState(() {
          listBallE = _listBall;
        });
        break;
      case "F":
        setState(() {
          listBallF = _listBall;
        });
        break;
    }
    calculator();
  }

  randomNumberAllLine() {
    for (var i = 0; i < listBallA!.length; i++) {
      listBallA?[i] = random(listBallA!);
    }
    for (var i = 0; i < listBallB!.length; i++) {
      listBallB?[i] = random(listBallB!);
    }
    for (var i = 0; i < listBallC!.length; i++) {
      listBallC?[i] = random(listBallC!);
    }
    for (var i = 0; i < listBallD!.length; i++) {
      listBallD?[i] = random(listBallD!);
    }
    for (var i = 0; i < listBallE!.length; i++) {
      listBallE?[i] = random(listBallE!);
    }
    for (var i = 0; i < listBallF!.length; i++) {
      listBallF?[i] = random(listBallF!);
    }

    listBallA?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    listBallB?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    listBallC?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    listBallD?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    listBallE?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    listBallF?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    setState(() {
      listBallA = listBallA;
      listBallB = listBallB;
      listBallC = listBallC;
      listBallD = listBallD;
      listBallE = listBallE;
      listBallF = listBallF;
    });
    calculator();
  }

  selectAmount(int index, String line) {
    switch (line) {
      case "A":
        setState(() {
          amountA = listAmount[index];
        });
        break;
      case "B":
        setState(() {
          amountB = listAmount[index];
        });
        break;
      case "C":
        setState(() {
          amountC = listAmount[index];
        });
        break;
      case "D":
        setState(() {
          amountD = listAmount[index];
        });
        break;
      case "E":
        setState(() {
          amountE = listAmount[index];
        });
        break;
      case "F":
        setState(() {
          amountF = listAmount[index];
        });
        break;
    }
    Navigator.pop(context);
    calculator();
  }

  showAmount(String line) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      // set this when inner content overflows, making RoundedRectangleBorder not working as expected
      clipBehavior: Clip.antiAlias,
      // set shape to make top corners rounded
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
              color: Colors.white,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Chọn mệnh giá",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                dividerLot(),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: listAmount.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => selectAmount(index, line),
                        child: Container(
                            alignment: Alignment.center,
                            height: 42,
                            color: Colors.white,
                            child: Text(formatAmount(listAmount[index]))),
                      );
                    }),
                InkWell(
                  onTap: () => {Navigator.pop(context)},
                  child: Container(
                      alignment: Alignment.center,
                      height: 46,
                      color: Colors.white,
                      child: Text("Đóng",
                          style: TextStyle(color: ColorLot.ColorPrimary))),
                )
              ])),
        );
      },
    );
  }

  Widget tcBall(List<String> balls, String line) {
    return InkWell(
      onTap: () => randomNumberLine(balls, line),
      child: Container(
        alignment: Alignment.center,
        width: Dimen.sizeBall,
        height: Dimen.sizeBall,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorLot.ColorSuccess,
        ),
        child: Text(
          "TC",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget clearBall(String line) {
    return InkWell(
      onTap: () => _clearBall(line),
      child: Container(
        alignment: Alignment.center,
        width: Dimen.sizeBall,
        height: Dimen.sizeBall,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: ColorLot.ColorPrimary),
        child: Icon(Icons.delete, color: Colors.white),
      ),
    );
  }

  _clearBall(String line) {
    switch (line) {
      case "A":
        setState(() {
          listBallA = List<String>.generate(_system, (index) => "");
        });
        break;
      case "B":
        setState(() {
          listBallB = List<String>.generate(_system, (index) => "");
        });
        break;
      case "C":
        setState(() {
          listBallC = List<String>.generate(_system, (index) => "");
        });
        break;
      case "D":
        setState(() {
          listBallD = List<String>.generate(_system, (index) => "");
        });
        break;
      case "E":
        setState(() {
          listBallE = List<String>.generate(_system, (index) => "");
        });
        break;
      case "F":
        setState(() {
          listBallF = List<String>.generate(_system, (index) => "");
        });
        break;
    }
    calculator();
  }

  calculator() {
    int price = 0;
    if (listBallA?[0] != "") {
      if (isBag) {
        if (_system > 2) {
          price = price + amountA * getPriceMax3DBag(_system) ~/ 10000;
        } else if (_system == 2) {
          systemA = getSystem(listBallA!);
          price = price + amountA * systemA;
        } else {
          price = price + amountA;
        }
      } else {
        price = price + amountA;
      }
    }
    if (listBallB?[0] != "") {
      if (isBag) {
        if (_system > 2) {
          price = price + amountB * getPriceMax3DBag(_system) ~/ 10000;
        } else if (_system == 2) {
          systemB = getSystem(listBallB!);
          price = price + amountB * systemB;
        } else {
          price = price + amountB;
        }
      } else {
        price = price + amountB;
      }
    }
    if (listBallC?[0] != "") {
      if (isBag) {
        if (_system > 2) {
          price = price + amountC * getPriceMax3DBag(_system) ~/ 10000;
        } else if (_system == 2) {
          systemC = getSystem(listBallC!);
          price = price + amountC * systemC;
        } else {
          price = price + amountC;
        }
      } else {
        price = price + amountC;
      }
    }
    if (listBallD?[0] != "") {
      if (isBag) {
        if (_system > 2) {
          price = price + amountD * getPriceMax3DBag(_system) ~/ 10000;
        } else if (_system == 2) {
          systemD = getSystem(listBallD!);
          price = price + amountD * systemD;
        } else {
          price = price + amountD;
        }
      } else {
        price = price + amountD;
      }
    }
    if (listBallE?[0] != "") {
      if (isBag) {
        if (_system > 2) {
          price = price + amountE * getPriceMax3DBag(_system) ~/ 10000;
        } else if (_system == 2) {
          systemE = getSystem(listBallE!);
          price = price + amountE * systemE;
        } else {
          price = price + amountE;
        }
      } else {
        price = price + amountE;
      }
    }
    if (listBallF?[0] != "") {
      if (isBag) {
        if (_system > 2) {
          price = price + amountF * getPriceMax3DBag(_system) ~/ 10000;
        } else if (_system == 2) {
          systemF = getSystem(listBallF!);
          price = price + amountF * systemF;
        } else {
          price = price + amountF;
        }
      } else {
        price = price + amountF;
      }
    }
    drafAmount = price * draws.length;
    setState(() {});
  }

  getSystem(List<String> arrBall) {
    List<String> balls1 = arrBall[0].split('');
    int maxball1;
    int ball11find = balls1.where((x) => x == balls1[0]).length;
    int ball12find = balls1.where((x) => x == balls1[1]).length;
    if (ball11find > ball12find) {
      maxball1 = ball11find;
    } else {
      maxball1 = ball12find;
    }

    List<String> balls2 = arrBall[1].split('');
    int maxball2;
    int ball21find = balls2.where((x) => x == balls2[0]).length;
    int ball22find = balls2.where((x) => x == balls2[1]).length;
    if (ball21find > ball22find) {
      maxball2 = ball21find;
    } else {
      maxball2 = ball22find;
    }
    if (maxball1 == 1 && maxball2 == 1) {
      return 36;
    } else if (maxball1 == 1 && maxball2 == 2) {
      return 18;
    } else if (maxball1 == 2 && maxball2 == 1) {
      return 18;
    } else if (maxball1 == 2 && maxball2 == 2) {
      return 9;
    } else if (maxball1 == 3 && maxball2 == 1) {
      return 6;
    } else if (maxball1 == 1 && maxball2 == 3) {
      return 6;
    } else if (maxball1 == 3 && maxball2 == 2) {
      return 3;
    } else if (maxball1 == 2 && maxball2 == 3) {
      return 3;
    } else {
      return 0;
    }
  }

  selectedBall(String line, List<String> _balls) {
    switch (line) {
      case "A":
        setState(() {
          listBallA = _balls;
        });
        break;
      case "B":
        setState(() {
          listBallB = _balls;
        });
        break;
      case "C":
        setState(() {
          listBallC = _balls;
        });
        break;
      case "D":
        setState(() {
          listBallD = _balls;
        });
        break;
      case "E":
        setState(() {
          listBallE = _balls;
        });
        break;
      case "F":
        setState(() {
          listBallF = _balls;
        });
        break;
    }
    calculator();
  }

  next() async {
    if (drafAmount == 0) {
      showMessage(context, "Bạn chưa chọn bộ số dự thưởng", "01");
      return;
    }
    if (draws.isEmpty) {
      showMessage(context, "Không có thông tin kỳ quay số mở thưởng", "01");
      return;
    }
    List<String> _line = [];
    if (listBallA![0] != "") {
      _line.add(listBallA!.join(','));
    }
    if (listBallB![0] != "") {
      _line.add(listBallB!.join(','));
    }
    if (listBallC![0] != "") {
      _line.add(listBallC!.join(','));
    }
    if (listBallD![0] != "") {
      _line.add(listBallD!.join(','));
    }
    if (listBallE![0] != "") {
      _line.add(listBallE!.join(','));
    }
    if (listBallF![0] != "") {
      _line.add(listBallF!.join(','));
    }
    if (mode != Common.ANDROID_MODE_UPLOAD ||
        playerProfile!.mobileNumber == Common.MOBILE_OFF) {
      return dialogQR(context,
          "${_line.join("|")}|$drafAmount|${getProductName(widget.productID)}");
    }
    if (playerProfile!.name == null || playerProfile!.pIDNumber == null) {
      if (mounted) {
        dialogBuilderUpdateInfo(context, "Thông báo",
            "Vui lòng cập nhật thông tin cá nhân trước khi đặt vé");
        return;
      }
    }

    OrderAddNewRequest order = new OrderAddNewRequest();
    order.price = drafAmount;
    order.productID = widget.productID;
    order.quantity = draws.length;
    order.mobileNumber = playerProfile!.mobileNumber;
    order.fullName = playerProfile!.name;
    order.pIDNumber = playerProfile!.pIDNumber;
    order.emailAddress = playerProfile!.emailAddress;
    order.amount = drafAmount;
    order.fee = 0;
    order.channel = Common.CHANNEL;
    order.desc = "Đặt vé";
    order.productTypeID = isBag ? 2 : 1;
    order.bag = isBag ? _system : 0;
    List<OrderAddItemRequest> items = [];
    if (widget.productID == Common.ID_MAX3D_PRO && isBag) {
      for (int d = 0; d < draws.length; d++) {
        OrderAddItemRequest item = new OrderAddItemRequest();
        item.productID = widget.productID;
        item.productTypeID = isBag ? 2 : 1;
        item.drawCode = draws[d].drawCode!;
        item.drawDate = draws[d].drawDate!;
        item.bag = isBag ? _system : 0;
        item.price = 0;
        for (int i = 0; i < _line.length; i++) {
          switch (i) {
            case 0:
              if (_system > 2) {
                systemA = _system;
                item.priceA = amountA * getPriceMax3DBag(systemA) ~/ 10000;
                item.price = amountA * getPriceMax3DBag(systemA) ~/ 10000;
              } else {
                item.priceA = systemA * amountA;
                item.price = systemA * amountA;
              }
              item.lineA = _line[i];
              item.systemA = systemA;

              break;
            case 1:
              item.lineB = _line[i];
              item.systemB = systemB;
              item.priceB = systemB * amountB;
              item.price = item.price! + systemB * amountB;
              break;
            case 2:
              item.lineC = _line[i];
              item.systemC = systemC;
              item.priceC = systemC * amountC;
              item.price = item.price! + systemC * amountC;
              break;
            case 3:
              item.lineD = _line[i];
              item.systemD = systemD;
              item.priceD = systemD * amountD;
              item.price = item.price! + systemD * amountD;
              break;
            case 4:
              item.lineE = _line[i];
              item.systemE = systemE;
              item.priceE = systemE * amountE;
              item.price = item.price! + systemE * amountE;
              break;
            case 5:
              item.lineF = _line[i];
              item.systemF = systemF;
              item.priceF = systemF * amountF;
              item.price = item.price! + systemF * amountF;
              break;
          }
        }

        items.add(item);
      }
    } else {
      for (int d = 0; d < draws.length; d++) {
        OrderAddItemRequest item = new OrderAddItemRequest();
        item.productID = widget.productID;
        item.productTypeID = isBag ? 2 : 1;
        item.drawCode = draws[d].drawCode!;
        item.drawDate = draws[d].drawDate!;
        item.bag = 0;
        item.price = 0;
        for (int i = 0; i < _line.length; i++) {
          switch (i) {
            case 0:
              item.lineA = _line[i];
              item.systemA = _system;
              item.priceA = amountA;
              item.price = amountA;
              break;
            case 1:
              item.lineB = _line[i];
              item.systemB = _system;
              item.priceB = amountB;
              item.price = item.price! + amountB;
              break;
            case 2:
              item.lineC = _line[i];
              item.systemC = _system;
              item.priceC = amountC;
              item.price = item.price! + amountC;
              break;
            case 3:
              item.lineD = _line[i];
              item.systemD = _system;
              item.priceD = amountD;
              item.price = item.price! + amountD;
              break;
            case 4:
              item.lineE = _line[i];
              item.systemE = _system;
              item.priceE = amountE;
              item.price = item.price! + amountE;
              break;
            case 5:
              item.lineF = _line[i];
              item.systemF = _system;
              item.priceF = amountF;
              item.price = item.price! + amountF;
              break;
          }
        }

        items.add(item);
      }
    }

    order.items = items;

    if (context.mounted) showProcess(context);
    ResponseObject res = await _conPay.addOrder(order);

    if (res.code == "00") {
      if (context.mounted) {
        ResponseObject resFee = await getFee(order.productID!);
        if (context.mounted) Navigator.pop(context);
        if (resFee.code == "00") {
          double fee = jsonDecode(resFee.data!)["Fee"];
          order.fee = fee.round();
          dialogPayment(context, playerProfile!, order,
              jsonDecode(res.data!)["Code"], _prefs);
        } else {
          if (context.mounted) showMessage(context, res.message!, "98");
        }
      }
    } else {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) showMessage(context, res.message!, "98");
    }
  }

  Future<ResponseObject> getFee(int productID) async {
    GetFeeRequest feeRequest =
        GetFeeRequest(amount: drafAmount, productID: productID);
    return await _conPay.getFee(feeRequest);
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
        title: Text(getProductName(widget.productID)),
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    headBalance(
                        balance,
                        mode,
                        playerProfile != null
                            ? playerProfile!.mobileNumber!
                            : ""),
                    SizedBox(
                      height: 8,
                    ),
                    buildSpot(),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: <BoxShadow>[boxShadow()],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        alignment: AlignmentDirectional.topStart,
                        child: buildRow()),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[boxShadow()],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(top: 8),
                      alignment: AlignmentDirectional.topStart,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tạm tính"),
                            Text(formatAmountD(drafAmount),
                                style: TextStyle(
                                    color: ColorLot.ColorPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))
                          ]),
                    ),
                    buildPayment()
                  ],
                ),
              ))),
    );
  }

  Widget buildRow() {
    if (widget.productID == Common.ID_MAX3D_PLUS || _system < 3) {
      return Column(
        children: [
          Row(
            children: [
              SizedBox(
                  width: 20,
                  child: Text("A",
                      style: TextStyle(
                          color: ColorLot.ColorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))),
              Expanded(
                  child: Line3DView(
                      product: widget.productID,
                      listBall: listBallA,
                      selectedBall: selectedBall,
                      line: "A")),
              SizedBox(
                width: 10,
              ),
              listBallA?[0] == "" ? tcBall(listBallA!, "A") : clearBall("A"),
              SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () => showAmount("A"),
                child: Text(
                  formatAmount(amountA),
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(80, 30),
                    padding: EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    side: BorderSide(width: 1, color: ColorLot.ColorPrimary)),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                  width: 20,
                  child: Text("B",
                      style: TextStyle(
                          color: ColorLot.ColorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))),
              Expanded(
                  child: Line3DView(
                      product: widget.productID,
                      listBall: listBallB,
                      selectedBall: selectedBall,
                      line: "B")),
              SizedBox(
                width: 10,
              ),
              listBallB?[0] == "" ? tcBall(listBallB!, "B") : clearBall("B"),
              SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () => showAmount("B"),
                child: Text(formatAmount(amountB),
                    style: TextStyle(fontWeight: FontWeight.w400)),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(80, 30),
                    padding: EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    side: BorderSide(width: 1, color: ColorLot.ColorPrimary)),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                  width: 20,
                  child: Text("C",
                      style: TextStyle(
                          color: ColorLot.ColorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))),
              Expanded(
                  child: Line3DView(
                      product: widget.productID,
                      listBall: listBallC,
                      selectedBall: selectedBall,
                      line: "C")),
              SizedBox(
                width: 10,
              ),
              listBallC?[0] == "" ? tcBall(listBallC!, "C") : clearBall("C"),
              SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () => showAmount("C"),
                child: Text(formatAmount(amountC),
                    style: TextStyle(fontWeight: FontWeight.w400)),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(80, 30),
                    padding: EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    side: BorderSide(width: 1, color: ColorLot.ColorPrimary)),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                  width: 20,
                  child: Text("D",
                      style: TextStyle(
                          color: ColorLot.ColorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))),
              Expanded(
                  child: Line3DView(
                      product: widget.productID,
                      listBall: listBallD,
                      selectedBall: selectedBall,
                      line: "D")),
              SizedBox(
                width: 10,
              ),
              listBallD?[0] == "" ? tcBall(listBallD!, "D") : clearBall("D"),
              SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () => showAmount("D"),
                child: Text(formatAmount(amountD),
                    style: TextStyle(fontWeight: FontWeight.w400)),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(80, 30),
                    padding: EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                    side: BorderSide(width: 1, color: ColorLot.ColorPrimary)),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                  width: 20,
                  child: Text("E",
                      style: TextStyle(
                          color: ColorLot.ColorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))),
              Expanded(
                  child: Line3DView(
                      product: widget.productID,
                      listBall: listBallE,
                      selectedBall: selectedBall,
                      line: "E")),
              SizedBox(
                width: 10,
              ),
              listBallE?[0] == "" ? tcBall(listBallE!, "E") : clearBall("E"),
              SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () => showAmount("E"),
                child: Text(formatAmount(amountE),
                    style: TextStyle(fontWeight: FontWeight.w400)),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(80, 30),
                    padding: EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                    side: BorderSide(width: 1, color: ColorLot.ColorPrimary)),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                  width: 20,
                  child: Text("F",
                      style: TextStyle(
                          color: ColorLot.ColorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))),
              Expanded(
                  child: Line3DView(
                      product: widget.productID,
                      listBall: listBallF,
                      selectedBall: selectedBall,
                      line: "F")),
              SizedBox(
                width: 10,
              ),
              listBallF?[0] == "" ? tcBall(listBallF!, "F") : clearBall("F"),
              SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () => showAmount("F"),
                child: Text(formatAmount(amountF),
                    style: TextStyle(fontWeight: FontWeight.w400)),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(80, 30),
                    padding: EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                    side: BorderSide(width: 1, color: ColorLot.ColorPrimary)),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          SizedBox(
              width: 20,
              child: Text("A",
                  style: TextStyle(
                      color: ColorLot.ColorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16))),
          Expanded(
              child: Line3DView(
                  product: widget.productID,
                  listBall: listBallA,
                  selectedBall: selectedBall,
                  line: "A")),
          SizedBox(
            width: 10,
          ),
          listBallA?[0] == "" ? tcBall(listBallA!, "A") : clearBall("A"),
          SizedBox(
            width: 10,
          ),
          OutlinedButton(
            onPressed: () => showAmount("A"),
            child: Text(
              formatAmount(amountA),
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            style: OutlinedButton.styleFrom(
                minimumSize: Size(80, 30),
                padding: EdgeInsets.all(4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                side: BorderSide(width: 1, color: ColorLot.ColorPrimary)),
          ),
        ],
      );
    }
  }

  Widget buildSpot() {
    var size = MediaQuery.of(context).size;
    if (widget.productID == Common.ID_MAX3D_PRO) {
      return Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cách chơi",
                style: TextStyle(
                    color: Colors.black54, fontSize: Dimen.fontSizeLable),
              ),
              SizedBox(
                height: 4,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogSelectedRadio(
                            contentHeight: 380,
                            productID: widget.productID,
                            title: "Chọn cách chơi",
                            value: isBag ? _system.toString() : "1",
                            callback: (value) {
                              if (value == "1") {
                                isBag = false;
                              } else {
                                _system = int.parse(value);
                                isBag = true;
                              }

                              initData();
                              calculator();
                            });
                      });
                },
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: Dimen.padingDefault),
                    width: size.width / 2 - 14,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[boxShadow()],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(getBagName3DPro(isBag ? _system : 1),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Dimen.fontSizeValue,
                              color: Colors.black,
                            )),
                        Padding(
                          padding: EdgeInsets.only(right: Dimen.padingDefault),
                          child: Icon(
                            Ionicons.chevron_down_outline,
                            size: 16,
                            color: Colors.black54,
                          ),
                        )
                      ],
                    )),
              ),
            ],
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chọn kỳ quay",
                  style: TextStyle(
                      color: Colors.black54, fontSize: Dimen.fontSizeLable),
                ),
                SizedBox(
                  height: 4,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogDrawCheckbox(
                              title: "Chọn kỳ quay",
                              draws: drawResponse ?? [],
                              drawsSeleted: draws,
                              callback: (value) {
                                setState(() {
                                  draws = value;
                                });
                                calculator();
                              });
                        });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: Dimen.padingDefault),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[boxShadow()],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            draws.isNotEmpty
                                ? (draws.length > 1
                                    ? "..."
                                    : draws[0].drawDate!)
                                : "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Dimen.fontSizeValue,
                              color: Colors.black,
                            )),
                        Padding(
                          padding: EdgeInsets.only(right: Dimen.padingDefault),
                          child: Icon(
                            Ionicons.chevron_down_outline,
                            size: 16,
                            color: Colors.black54,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chọn kỳ quay",
            style:
                TextStyle(color: Colors.black54, fontSize: Dimen.fontSizeLable),
          ),
          SizedBox(
            height: 4,
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return DialogDrawCheckbox(
                        title: "Chọn kỳ quay",
                        draws: drawResponse ?? [],
                        drawsSeleted: draws,
                        callback: (value) {
                          setState(() {
                            draws = value;
                          });
                          calculator();
                        });
                  });
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: Dimen.padingDefault),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[boxShadow()],
                borderRadius: const BorderRadius.all(
                  Radius.circular(6.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      draws.isNotEmpty
                          ? (draws.length > 1 ? "..." : draws[0].drawDate!)
                          : "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimen.fontSizeValue,
                        color: Colors.black,
                      )),
                  Padding(
                    padding: EdgeInsets.only(right: Dimen.padingDefault),
                    child: Icon(
                      Ionicons.chevron_down_outline,
                      size: 16,
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget buildPayment() {
    if (mode != Common.ANDROID_MODE_UPLOAD ||
        playerProfile!.mobileNumber == Common.MOBILE_OFF) {
      return SizedBox.shrink();
    } else {
      return Column(
        children: [
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: OutlinedButton(
                onPressed: randomNumberAllLine,
                child: Text("Chọn nhanh",
                    style: TextStyle(color: ColorLot.ColorRandomFast)),
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(6),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    side:
                        BorderSide(width: 1, color: ColorLot.ColorRandomFast)),
              )),
              SizedBox(width: 8),
              Expanded(
                  child: OutlinedButton(
                onPressed: next,
                child: Text(
                  "Đặt vé",
                  style: TextStyle(color: ColorLot.ColorSuccess),
                ),
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(6),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    side: BorderSide(width: 1, color: ColorLot.ColorSuccess)),
              )),
            ],
          ),
        ],
      );
    }
  }
}
