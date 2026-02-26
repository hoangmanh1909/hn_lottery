// ignore_for_file: public_member_api_docs, sort_constructors_first, await_only_futures, use_build_context_synchronously, prefer_interpolation_to_compose_strings, unused_field, unnecessary_brace_in_string_interps
// ignore_for_file: prefer_const_constructors, sort_child_properties_last, must_be_immutable, unnecessary_new, prefer_const_literals_to_create_immutables, unnecessary_this, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/controller/account_controller.dart';
import 'package:lottery_flutter_application/controller/dictionary_controller.dart';
import 'package:lottery_flutter_application/controller/history_controller.dart';
import 'package:lottery_flutter_application/controller/payment_controller.dart';
import 'package:lottery_flutter_application/models/request/get_fee_request.dart';
import 'package:lottery_flutter_application/models/response/draw_response.dart';
import 'package:lottery_flutter_application/models/response/get_item_response.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/dialog_update_info_player.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/utils/head_balance_view.dart';
import 'package:lottery_flutter_application/utils/widget_divider.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:lottery_flutter_application/view/payment_view.dart';
import 'package:lottery_flutter_application/widgets/custom_button.dart';
import 'package:lottery_flutter_application/widgets/ticket_line.dart';
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
import '../../../utils/box_shadow.dart';
import '../../../utils/dialog_qr.dart';

final key = new GlobalKey<_TicketLotoCapSoViewState>();

class TicketLotoCapSoView extends StatefulWidget {
  const TicketLotoCapSoView({Key? key, required this.type, this.code})
      : super(key: key);
  final int type;
  final String? code;
  @override
  State<TicketLotoCapSoView> createState() => _TicketLotoCapSoViewState();
}

class _TicketLotoCapSoViewState extends State<TicketLotoCapSoView> {
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

  List<bool>? valueSystem;
  List<int>? listAmount = [10000, 20000, 50000];
  List<String>? listBall;
  List<String>? listBallA;
  List<String>? listBallB;
  List<String>? listBallC;
  List<String>? listBallD;
  List<String>? listBallE;
  int amountA = 20000;
  int amountB = 20000;
  int amountC = 20000;
  int amountD = 20000;
  int amountE = 20000;
  int amountF = 20000;
  String mode = "ON";
  @override
  void initState() {
    super.initState();
    valueSystem = List<bool>.generate(10, (index) => false);
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
    await getLotoDraw();
    await getBalance();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  getLotoDraw() async {
    if (context.mounted) showProcess(context);
    ResponseObject res = await _con.getDrawLoto();
    if (context.mounted) Navigator.pop(context);
    if (res.code == "00") {
      setState(() {
        drawResponse = List<DrawResponse>.from((jsonDecode(res.data!)
            .map((model) => DrawResponse.fromJson(model))));
      });
      if (widget.code != null) {
        getItemByCode();
      }
    } else {
      if (context.mounted) showMessage(context, res.message!, "99");
    }
  }

  getItemByCode() async {
    ResponseObject res = await _his.getItemByCode(widget.code!);
    if (res.code == "00") {
      items = List<GetItemResponse>.from((jsonDecode(res.data!)
          .map((model) => GetItemResponse.fromJson(model))));
      GetItemResponse item = items![0];
      initData();
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

      calculator();
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
    listBall = List<String>.generate(widget.type, (index) => "");
    listBallA = List<String>.generate(widget.type, (index) => "");
    listBallB = List<String>.generate(widget.type, (index) => "");
    listBallC = List<String>.generate(widget.type, (index) => "");
    listBallD = List<String>.generate(widget.type, (index) => "");
    listBallE = List<String>.generate(widget.type, (index) => "");
  }

  String random(List<String> _listBall) {
    var rng = Random();
    String s = (rng.nextInt(99)).toString().padLeft(2, '0');
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

    setState(() {
      listBallA = listBallA;
      listBallB = listBallB;
      listBallC = listBallC;
      listBallD = listBallD;
      listBallE = listBallE;
    });
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

    listBallA?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    listBallB?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    listBallC?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    listBallD?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    listBallE?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    setState(() {
      listBallA = listBallA;
      listBallB = listBallB;
      listBallC = listBallC;
      listBallD = listBallD;
      listBallE = listBallE;
    });
    calculator();
  }

  selectAmount(int index, String line) {
    switch (line) {
      case "A":
        setState(() {
          amountA = listAmount![index];
        });
        break;
      case "B":
        setState(() {
          amountB = listAmount![index];
        });
        break;
      case "C":
        setState(() {
          amountC = listAmount![index];
        });
        break;
      case "D":
        setState(() {
          amountD = listAmount![index];
        });
        break;
      case "E":
        setState(() {
          amountE = listAmount![index];
        });
        break;
      case "F":
        setState(() {
          amountF = listAmount![index];
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
                    itemCount: listAmount?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => selectAmount(index, line),
                        child: Container(
                            alignment: Alignment.center,
                            height: 42,
                            color: Colors.white,
                            child: Text(formatAmount(listAmount?[index]))),
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
          color: ColorLot.ColorBaoChung,
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
          listBallA = List<String>.generate(widget.type, (index) => "");
        });
        break;
      case "B":
        setState(() {
          listBallB = List<String>.generate(widget.type, (index) => "");
        });
        break;
      case "C":
        setState(() {
          listBallC = List<String>.generate(widget.type, (index) => "");
        });
        break;
      case "D":
        setState(() {
          listBallD = List<String>.generate(widget.type, (index) => "");
        });
        break;
      case "E":
        setState(() {
          listBallE = List<String>.generate(widget.type, (index) => "");
        });
        break;
    }
    calculator();
  }

  calculator() {
    int price = 0;
    if (listBallA?[0] != "") {
      price = price + amountA;
    }
    if (listBallB?[0] != "") {
      price = price + amountB;
    }
    if (listBallC?[0] != "") {
      price = price + amountC;
    }
    if (listBallD?[0] != "") {
      price = price + amountD;
    }
    if (listBallE?[0] != "") {
      price = price + amountE;
    }
    setState(() {
      drafAmount = price;
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
    }
    calculator();
  }

  next() async {
    if (drafAmount == 0) {
      showMessage(context, "Bạn chưa chọn bộ số dự thưởng", "01");
      return;
    }
    if (drawResponse == null) {
      showMessage(context, "Không có thông tin kỳ quay số mở thưởng", "01");
      return;
    }
    List<String> _line = [];
    if (listBallA![0] != "") {
      _line.add(listBallA!.join(',') + "|" + amountA.toString());
    }
    if (listBallB![0] != "") {
      _line.add(listBallB!.join(',') + "|" + amountB.toString());
    }
    if (listBallC![0] != "") {
      _line.add(listBallC!.join(',') + "|" + amountC.toString());
    }
    if (listBallD![0] != "") {
      _line.add(listBallD!.join(',') + "|" + amountD.toString());
    }
    if (listBallE![0] != "") {
      _line.add(listBallE!.join(',') + "|" + amountE.toString());
    }

    if (mode != Common.ANDROID_MODE_UPLOAD ||
        playerProfile!.mobileNumber == Common.MOBILE_OFF) {
      return dialogQR(context,
          "${_line.join("|")}|$drafAmount|${getProductName(Common.ID_LOTO234)}");
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
    order.productID = Common.ID_LOTO234;
    order.quantity = 1;
    order.mobileNumber = playerProfile!.mobileNumber;
    order.fullName = playerProfile!.name;
    order.pIDNumber = playerProfile!.pIDNumber;
    order.emailAddress = playerProfile!.emailAddress;
    order.amount = drafAmount;
    order.fee = 0;
    order.channel = Common.CHANNEL;
    order.desc = "Đặt vé";
    order.productTypeID = 1;
    order.productDT = widget.type;

    OrderAddItemRequest item = new OrderAddItemRequest();
    item.productID = Common.ID_LOTO234;
    item.productTypeID = 1;
    item.drawCode = drawResponse![0].drawCode!;
    item.drawDate = drawResponse![0].drawDate!;
    item.bag = 0;
    item.price = 0;
    for (int i = 0; i < _line.length; i++) {
      String line = _line[i].split('|')[0];
      int amount = int.parse(_line[i].split('|')[1]);
      switch (i) {
        case 0:
          item.lineA = line;
          item.systemA = widget.type;
          item.priceA = amount;
          item.price = amount;
          break;
        case 1:
          item.lineB = line;
          item.systemB = widget.type;
          item.priceB = amount;
          item.price = item.price! + amount;
          break;
        case 2:
          item.lineC = line;
          item.systemC = widget.type;
          item.priceC = amount;
          item.price = item.price! + amount;
          break;
        case 3:
          item.lineD = line;
          item.systemD = widget.type;
          item.priceD = amount;
          item.price = item.price! + amount;
          break;
        case 4:
          item.lineE = line;
          item.systemE = widget.type;
          item.priceE = amount;
          item.price = item.price! + amount;
          break;
      }
    }
    List<OrderAddItemRequest> items = [];
    items.add(item);
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentView(
                profile: playerProfile!,
                order: order,
                code: jsonDecode(res.data!)["Code"],
                preferences: _prefs,
                balance: balance,
                mode: mode,
              ),
            ),
          );
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
        title: Text("Lô tô ${widget.type.toString()} cặp số"),
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
                            Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  EdgeInsets.only(left: Dimen.padingDefault),
                              width: size.width / 2 - 14,
                              height: 40,
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[boxShadow()],
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                              ),
                              child:
                                  Text("Lô tô ${widget.type.toString()} cặp số",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: Dimen.fontSizeValue,
                                        color: Colors.black,
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
                              "Kỳ quay",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: Dimen.fontSizeLable),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  EdgeInsets.only(left: Dimen.padingDefault),
                              width: size.width / 2 - 14,
                              height: 40,
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[boxShadow()],
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                              ),
                              child: Text(
                                  drawResponse != null
                                      ? drawResponse![0].drawDate!
                                      : "",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimen.fontSizeValue,
                                    color: Colors.black,
                                  )),
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
                            buildTicketRow("A", listBallA, amountA),
                            dividerLot(),
                            buildTicketRow("B", listBallB, amountB),
                            dividerLot(),
                            buildTicketRow("C", listBallC, amountC),
                            dividerLot(),
                            buildTicketRow("D", listBallD, amountD),
                            dividerLot(),
                            buildTicketRow("E", listBallE, amountE),
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
                            Text("Giá vé tạm tính"),
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

  Widget buildTicketRow(String label, List<String>? balls, dynamic amount) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(label,
              style: TextStyle(
                  color: ColorLot.ColorPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ),
        Expanded(
          child: TicketLineView(
              system: widget.type,
              listBall: balls,
              selectedBall: selectedBall,
              line: label),
        ),
        // Logic hiển thị nút chọn nhanh hoặc xóa
        balls?[0] == "" ? tcBall(balls!, label) : clearBall(label),
        const SizedBox(width: 10),
        // Nút hiển thị số tiền
        OutlinedButton(
          onPressed: () => showAmount(label),
          style: OutlinedButton.styleFrom(
            // Cố định chiều cao là 32, chiều ngang tối thiểu 80 (tự giãn nếu tiền dài)
            minimumSize: const Size(80, 30),
            fixedSize: const Size.fromHeight(30), // Ép cứng chiều cao 32

            // Thu nhỏ vùng đệm thừa của hệ thống xung quanh nút
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,

            // Padding hẹp lại để chữ nằm gọn bên trong
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0)),
            side: BorderSide(width: 1, color: ColorLot.ColorPrimary),
          ),
          child: Text(
            formatAmount(amount),
            style: const TextStyle(
              fontWeight: FontWeight.w500, // Tăng lên 500 cho dễ đọc
              fontSize: 13, // Size 13 là cực chuẩn cho độ cao 32
              color: ColorLot.ColorPrimary,
            ),
          ),
        )
      ],
    );
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
              CustomButton(
                label: "Chọn nhanh",
                backgroundColor: ColorLot.ColorBaoChung,
                onPressed: randomNumberAllLine,
              ),
              const SizedBox(width: 8),
              CustomButton(
                label: "Đặt vé",
                backgroundColor: ColorLot.ColorPrimary,
                onPressed: next,
              ),
            ],
          ),
        ],
      );
    }
  }
}
