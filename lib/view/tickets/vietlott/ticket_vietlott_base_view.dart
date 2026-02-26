// ignore_for_file: public_member_api_docs, sort_constructors_first, await_only_futures, use_build_context_synchronously, prefer_interpolation_to_compose_strings, unused_field, unnecessary_brace_in_string_interps
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
import '../../../utils/dialog_qr.dart';
import '../../../utils/dialog_selected_radio.dart';

final key = new GlobalKey<_TicketLotoState>();

class TicketVietlottBaseView extends StatefulWidget {
  const TicketVietlottBaseView({Key? key, required this.productID, this.code})
      : super(key: key);
  final int productID;
  final String? code;
  @override
  State<TicketVietlottBaseView> createState() => _TicketLotoState();
}

class _TicketLotoState extends State<TicketVietlottBaseView> {
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
  int _price = 70000;
  int _system = 7;
  List<String>? ballss;
  List<String>? listBall;
  List<String>? listBallA;
  List<String>? listBallB;
  List<String>? listBallC;
  List<String>? listBallD;
  List<String>? listBallE;
  List<String>? listBallF;
  int totalBall = 45;
  String mode = "ON";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
    });
    initData();
  }

  getData() async {
    _prefs = await SharedPreferences.getInstance();
    mode = _prefs!.getString(Common.SHARE_MODE_UPLOAD)!;
    String? userMap = _prefs?.getString('user');
    if (userMap != null) {
      setState(() {
        playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      });
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
    if (widget.productID == Common.ID_MEGA) {
      totalBall = 45;
      ballss = List.generate(
          totalBall, (index) => (index + 1).toString().padLeft(2, '0'));
      setState(() {});
      await getDrawMega();
    }
    if (widget.productID == Common.ID_POWER) {
      totalBall = 55;
      ballss =
          List.generate(55, (index) => (index + 1).toString().padLeft(2, '0'));
      setState(() {});
      await getDrawPower();
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

  getItemByCode() async {
    ResponseObject res = await _his.getItemByCode(widget.code!);
    if (res.code == "00") {
      items = List<GetItemResponse>.from((jsonDecode(res.data!)
          .map((model) => GetItemResponse.fromJson(model))));
      GetItemResponse item = items![0];
      _price = item.priceA!;
      _system = item.systemA!;
      if (item.lineA!.isNotEmpty) {
        listBallA = item.lineA!.split(',');
      }
      if (item.lineB!.isNotEmpty) {
        listBallB = item.lineB!.split(',');
      }
      if (item.lineC!.isNotEmpty) {
        listBallC = item.lineC!.split(',');
      }
      if (item.lineD!.isNotEmpty) {
        listBallD = item.lineD!.split(',');
      }
      if (item.lineE!.isNotEmpty) {
        listBallE = item.lineE!.split(',');
      }
      if (item.lineF!.isNotEmpty) {
        listBallF = item.lineF!.split(',');
      }
      calculator();
    }
  }

  getDrawMega() async {
    if (context.mounted) showProcess(context);
    ResponseObject res = await _con.getDrawMega();
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

  getDrawPower() async {
    if (context.mounted) showProcess(context);
    ResponseObject res = await _con.getDrawPower();
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
    String s = (rng.nextInt(totalBall) + 1).toString().padLeft(2, '0');
    return _listBall.contains(s) ? this.random(_listBall) : s;
  }

  // randomNumber() {
  //   bool isCheck = true;
  //   if (listBallA?[0] == "") {
  //     for (var i = 0; i < listBallA!.length; i++) {
  //       listBallA?[i] = random(listBallA!);
  //     }
  //     listBallA?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
  //     isCheck = false;
  //   }
  //   if (listBallB?[0] == "" && isCheck) {
  //     for (var i = 0; i < listBallB!.length; i++) {
  //       listBallB?[i] = random(listBallB!);
  //     }
  //     listBallB?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
  //     isCheck = false;
  //   }
  //   if (listBallC?[0] == "" && isCheck) {
  //     for (var i = 0; i < listBallC!.length; i++) {
  //       listBallC?[i] = random(listBallC!);
  //     }
  //     listBallC?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
  //     isCheck = false;
  //   }
  //   if (listBallD?[0] == "" && isCheck) {
  //     for (var i = 0; i < listBallD!.length; i++) {
  //       listBallD?[i] = random(listBallD!);
  //     }
  //     listBallD?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
  //     isCheck = false;
  //   }
  //   if (listBallE?[0] == "" && isCheck) {
  //     for (var i = 0; i < listBallE!.length; i++) {
  //       listBallE?[i] = random(listBallE!);
  //     }
  //     isCheck = false;
  //   }
  //   if (listBallF?[0] == "" && isCheck) {
  //     for (var i = 0; i < listBallF!.length; i++) {
  //       listBallF?[i] = random(listBallF!);
  //     }
  //     isCheck = false;
  //   }
  //   setState(() {
  //     listBallA = listBallA;
  //     listBallB = listBallB;
  //     listBallC = listBallC;
  //     listBallD = listBallD;
  //     listBallE = listBallE;
  //     listBallF = listBallF;
  //   });
  //   calculator();
  // }

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
      price = price + _price;
    }
    if (listBallB?[0] != "") {
      price = price + _price;
    }
    if (listBallC?[0] != "") {
      price = price + _price;
    }
    if (listBallD?[0] != "") {
      price = price + _price;
    }
    if (listBallE?[0] != "") {
      price = price + _price;
    }
    if (listBallF?[0] != "") {
      price = price + _price;
    }
    setState(() {
      drafAmount = price * draws.length;
    });
  }

  selectedBall(String line, List<String> _balls) {
    _balls.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
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

    int productTypeID = 1;
    if (_system == 6) {
      productTypeID = 1;
    } else {
      productTypeID = 2;
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
    order.productTypeID = productTypeID;

    List<OrderAddItemRequest> items = [];
    for (int d = 0; d < draws.length; d++) {
      OrderAddItemRequest item = new OrderAddItemRequest();
      item.productID = widget.productID;
      item.productTypeID = productTypeID;
      item.drawCode = draws[d].drawCode!;
      item.drawDate = draws[d].drawDate!;
      if (productTypeID == 2) item.bag = _system;
      item.price = 0;
      for (int i = 0; i < _line.length; i++) {
        switch (i) {
          case 0:
            item.lineA = _line[i];
            item.systemA = _system;
            item.priceA = _price;
            item.price = _price;
            break;
          case 1:
            item.lineB = _line[i];
            item.systemB = _system;
            item.priceB = _price;
            item.price = item.price! + _price;
            break;
          case 2:
            item.lineC = _line[i];
            item.systemC = _system;
            item.priceC = _price;
            item.price = item.price! + _price;
            break;
          case 3:
            item.lineD = _line[i];
            item.systemD = _system;
            item.priceD = _price;
            item.price = item.price! + _price;
            break;
          case 4:
            item.lineE = _line[i];
            item.systemE = _system;
            item.priceE = _price;
            item.price = item.price! + _price;
            break;
          case 5:
            item.lineF = _line[i];
            item.systemF = _system;
            item.priceF = _price;
            item.price = item.price! + _price;
            break;
        }
      }

      items.add(item);
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
        title: Text(
            widget.productID == Common.ID_MEGA ? "Mega 6/45" : "Power 6/55"),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cách chơi",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: Dimen.fontSizeLable),
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
                                          contentHeight: 220,
                                          productID: widget.productID,
                                          title: "Chọn bậc",
                                          callback: (value) {
                                            setState(() {
                                              _system = int.parse(value);
                                              _price = widget.productID ==
                                                      Common.ID_MEGA
                                                  ? getPriceMega(
                                                      int.parse(value))
                                                  : getPricePower(
                                                      int.parse(value));
                                            });
                                            initData();
                                            calculator();
                                          });
                                    });
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                      left: Dimen.padingDefault),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(getBagName(_system),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: Dimen.fontSizeValue,
                                            color: Colors.black,
                                          )),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: Dimen.padingDefault),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Chọn kỳ quay",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: Dimen.fontSizeLable),
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
                                padding:
                                    EdgeInsets.only(left: Dimen.padingDefault),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      padding: EdgeInsets.only(
                                          right: Dimen.padingDefault),
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
                      ],
                    ),
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
                        child: Column(
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
                                    child: LineView(
                                        balss: ballss ?? [],
                                        system: _system,
                                        listBall: listBallA,
                                        selectedBall: selectedBall,
                                        line: "A")),
                                SizedBox(
                                  width: 10,
                                ),
                                listBallA?[0] == ""
                                    ? tcBall(listBallA!, "A")
                                    : clearBall("A"),
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
                                    child: LineView(
                                        balss: ballss ?? [],
                                        system: _system,
                                        listBall: listBallB,
                                        selectedBall: selectedBall,
                                        line: "B")),
                                SizedBox(
                                  width: 10,
                                ),
                                listBallB?[0] == ""
                                    ? tcBall(listBallB!, "B")
                                    : clearBall("B"),
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
                                    child: LineView(
                                        balss: ballss ?? [],
                                        system: _system,
                                        listBall: listBallC,
                                        selectedBall: selectedBall,
                                        line: "C")),
                                SizedBox(
                                  width: 10,
                                ),
                                listBallC?[0] == ""
                                    ? tcBall(listBallC!, "C")
                                    : clearBall("C"),
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
                                    child: LineView(
                                        balss: ballss ?? [],
                                        system: _system,
                                        listBall: listBallD,
                                        selectedBall: selectedBall,
                                        line: "D")),
                                SizedBox(
                                  width: 10,
                                ),
                                listBallD?[0] == ""
                                    ? tcBall(listBallD!, "D")
                                    : clearBall("D"),
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
                                    child: LineView(
                                        balss: ballss ?? [],
                                        system: _system,
                                        listBall: listBallE,
                                        selectedBall: selectedBall,
                                        line: "E")),
                                SizedBox(
                                  width: 10,
                                ),
                                listBallE?[0] == ""
                                    ? tcBall(listBallE!, "E")
                                    : clearBall("E"),
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
                                    child: LineView(
                                        balss: ballss ?? [],
                                        system: _system,
                                        listBall: listBallF,
                                        selectedBall: selectedBall,
                                        line: "F")),
                                SizedBox(
                                  width: 10,
                                ),
                                listBallF?[0] == ""
                                    ? tcBall(listBallF!, "F")
                                    : clearBall("F"),
                              ],
                            ),
                          ],
                        )),
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

  Widget buildPayment() {
    if (mode != Common.ANDROID_MODE_UPLOAD) {
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

class LineView extends StatefulWidget {
  LineView({
    super.key,
    required this.system,
    required this.listBall,
    required this.line,
    required this.selectedBall,
    required this.balss,
  });

  final int system;
  final List<String> balss;
  List<String>? listBall;
  final String line;
  final Function selectedBall;

  @override
  State<LineView> createState() => _LineView();
}

class _LineView extends State<LineView> {
  StateSetter? _setState;
  final List<String> _balls = [];

  onTapBall(value) {
    if (_balls.contains(value)) {
      _setState!(() {
        _balls.remove(value);
      });
    } else {
      if (_balls.length < widget.system) {
        _setState!(() {
          _balls.add(value);
        });
      }
    }
  }

  onSelectedBall() {
    if (widget.system == _balls.length) {
      widget.selectedBall(widget.line, _balls);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  onClear() {
    _setState!(() {
      _balls.clear();
    });
  }

  showDialogBall() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          actionsAlignment: MainAxisAlignment.center,
          titlePadding: EdgeInsets.all(10),
          contentPadding: EdgeInsets.all(10),
          actionsPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  _setState = setState;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Chọn số",
                              style: TextStyle(fontSize: Dimen.fontSizeTitle),
                            ),
                            InkWell(
                              onTap: () => {Navigator.pop(context)},
                              child: Container(
                                alignment: Alignment.center,
                                height: Dimen.buttonHeight,
                                child: Text(
                                  "Đóng",
                                  style: TextStyle(
                                      color: ColorLot.ColorPrimary,
                                      fontSize: Dimen.fontSizeTitle),
                                ),
                              ),
                            )
                          ]),
                      Wrap(
                        alignment: WrapAlignment.center,
                        direction: Axis.horizontal,
                        children: widget.balss.map((item) {
                          return _balls.contains(item)
                              ? ballSelected(item)
                              : ballNormal(item);
                        }).toList(),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text("Bạn đã chọn : ${_balls.length}"),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: onClear,
                              child: Container(
                                alignment: Alignment.center,
                                height: Dimen.buttonHeight,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Dimen.radiusBorderButton)),
                                    border: Border.all(
                                        color: ColorLot.ColorPrimary,
                                        width: 1)),
                                child: Text(
                                  "Chọn lại",
                                  style:
                                      TextStyle(color: ColorLot.ColorPrimary),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: InkWell(
                            onTap: onSelectedBall,
                            child: Container(
                              alignment: Alignment.center,
                              height: Dimen.buttonHeight,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Dimen.radiusBorderButton)),
                                  border: Border.all(
                                      color: ColorLot.ColorSuccess, width: 1)),
                              child: Text(
                                "Đồng ý",
                                style: TextStyle(color: ColorLot.ColorSuccess),
                              ),
                            ),
                          ))
                        ],
                      )
                    ],
                  );
                },
              )),
        );
      },
    );
  }

  Widget ballNormal(item) {
    return InkWell(
      onTap: () => onTapBall(item),
      child: Container(
        alignment: Alignment.center,
        width: Dimen.sizeBallDialog,
        height: Dimen.sizeBallDialog,
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
        child: Text(item,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.0,
                color: Colors.black)),
      ),
    );
  }

  Widget ballSelected(item) {
    return InkWell(
      onTap: () => onTapBall(item),
      child: Container(
        alignment: Alignment.center,
        width: Dimen.sizeBallDialog,
        height: Dimen.sizeBallDialog,
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorLot.ColorPrimary,
            border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
        child: Text(item,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.0,
                color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width - 180,
      child: Wrap(
        direction: Axis.horizontal,
        children: widget.listBall!.map((item) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: showDialogBall,
                child: Container(
                  width: Dimen.sizeBall,
                  height: Dimen.sizeBall,
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border:
                          Border.all(color: ColorLot.ColorPrimary, width: 1)),
                  child: Center(
                    child: Text(item,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.0,
                            color: Colors.black)),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
