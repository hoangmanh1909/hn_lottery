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
import 'package:lottery_flutter_application/utils/dialog_update_info_player.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/utils/head_balance_view.dart';
import 'package:lottery_flutter_application/utils/widget_divider.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/common.dart';
import '../../../models/request/order_add_request.dart';
import '../../../models/request/order_item_add_request.dart';
import '../../../models/request/player_base_request.dart';
import '../../../models/response/get_balance_response.dart';
import '../../../models/response/player_profile.dart';
import '../../../utils/box_shadow.dart';
import '../../../utils/color_lot.dart';
import '../../../utils/common.dart';
import '../../../utils/dialog_draw_checkbox.dart';
import '../../../utils/dialog_payment.dart';
import '../../../utils/dialog_process.dart';
import '../../../utils/dialog_qr.dart';
import '../../../utils/scaffold_messger.dart';

final key = new GlobalKey<_TicketLotoState>();

class Ticket3DBaseView extends StatefulWidget {
  const Ticket3DBaseView({Key? key, required this.type, this.code})
      : super(key: key);
  final int type;
  final String? code;
  @override
  State<Ticket3DBaseView> createState() => _TicketLotoState();
}

class _TicketLotoState extends State<Ticket3DBaseView> {
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

  List<bool>? valueSystem;
  List<int>? listAmount = [10000, 20000, 50000, 100000, 200000, 500000];
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
    await getMax3d();
    await getBalance();

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

      if (item.lineA!.isNotEmpty) {
        listBallA = item.lineA!.split('');
        amountA = item.priceA!;
      }
      if (item.lineB!.isNotEmpty) {
        listBallB = item.lineB!.split('');
        amountB = item.priceB!;
      }
      if (item.lineC!.isNotEmpty) {
        listBallC = item.lineC!.split('');
        amountC = item.priceC!;
      }
      if (item.lineD!.isNotEmpty) {
        listBallD = item.lineD!.split('');
        amountD = item.priceD!;
      }
      if (item.lineE!.isNotEmpty) {
        listBallE = item.lineE!.split('');
        amountE = item.priceE!;
      }
      if (item.lineF!.isNotEmpty) {
        listBallF = item.lineF!.split('');
        amountF = item.priceF!;
      }
      calculator();
    }
  }

  getMax3d() async {
    if (context.mounted) showProcess(context);
    ResponseObject res = await _con.getDrawMax3D();
    if (context.mounted) Navigator.pop(context);
    if (res.code == "00") {
      setState(() {
        drawResponse = List<DrawResponse>.from((jsonDecode(res.data!)
            .map((model) => DrawResponse.fromJson(model))));
      });

      draws.add(drawResponse![0]);
      if (widget.code != null) {
        getItemByCode();
      }
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
    listBall = List<String>.generate(widget.type, (index) => "");
    listBallA = List<String>.generate(widget.type, (index) => "");
    listBallB = List<String>.generate(widget.type, (index) => "");
    listBallC = List<String>.generate(widget.type, (index) => "");
    listBallD = List<String>.generate(widget.type, (index) => "");
    listBallE = List<String>.generate(widget.type, (index) => "");
    listBallF = List<String>.generate(widget.type, (index) => "");
  }

  String random(List<String> _listBall) {
    var rng = Random();
    String s = (rng.nextInt(9)).toString();
    return _listBall.contains(s) ? this.random(_listBall) : s;
  }

  randomNumber() {
    bool isCheck = true;
    if (listBallA?[0] == "") {
      for (var i = 0; i < listBallA!.length; i++) {
        listBallA?[i] = random(listBallA!);
      }
      // listBallA?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      isCheck = false;
    }
    if (listBallB?[0] == "" && isCheck) {
      for (var i = 0; i < listBallB!.length; i++) {
        listBallB?[i] = random(listBallB!);
      }
      // listBallB?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      isCheck = false;
    }
    if (listBallC?[0] == "" && isCheck) {
      for (var i = 0; i < listBallC!.length; i++) {
        listBallC?[i] = random(listBallC!);
      }
      // listBallC?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      isCheck = false;
    }
    if (listBallD?[0] == "" && isCheck) {
      for (var i = 0; i < listBallD!.length; i++) {
        listBallD?[i] = random(listBallD!);
      }
      // listBallD?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
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
    setState(() {});
    calculator();
  }

  randomNumberLine(List<String> _listBall, String _line) {
    for (var i = 0; i < _listBall.length; i++) {
      _listBall[i] = random(_listBall);
    }
    // _listBall.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
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

    // listBallA?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    // listBallB?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    // listBallC?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    // listBallD?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    // listBallE?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    // listBallF?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    setState(() {});
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
      case "F":
        setState(() {
          listBallF = List<String>.generate(widget.type, (index) => "");
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
    if (listBallF?[0] != "") {
      price = price + amountF;
    }
    setState(() {
      drafAmount = price * draws.length;
    });
  }

  selectedBall(String line, List<String> _balls) {
    // _balls.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
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
    if (draws.isEmpty) {
      showMessage(context, "Không có thông tin kỳ quay thưởng", "01");
      return;
    }
    if (drafAmount == 0) {
      showMessage(context, "Bạn chưa chọn bộ số dự thưởng", "01");
      return;
    }
    List<String> _line = [];
    if (listBallA![0] != "") {
      _line.add(listBallA!.join('') + "|" + amountA.toString());
    }
    if (listBallB![0] != "") {
      _line.add(listBallB!.join('') + "|" + amountB.toString());
    }
    if (listBallC![0] != "") {
      _line.add(listBallC!.join('') + "|" + amountC.toString());
    }
    if (listBallD![0] != "") {
      _line.add(listBallD!.join('') + "|" + amountD.toString());
    }
    if (listBallE![0] != "") {
      _line.add(listBallE!.join('') + "|" + amountE.toString());
    }
    if (listBallF![0] != "") {
      _line.add(listBallF!.join('') + "|" + amountF.toString());
    }
    if (mode != Common.ANDROID_MODE_UPLOAD ||
        playerProfile!.mobileNumber == Common.MOBILE_OFF) {
      return dialogQR(context,
          "${_line.join("|")}|$drafAmount|${getProductName(Common.ID_MAX3D)}");
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
    order.productID = Common.ID_MAX3D;
    order.quantity = draws.length;
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

    List<OrderAddItemRequest> items = [];

    for (int d = 0; d < draws.length; d++) {
      OrderAddItemRequest item = new OrderAddItemRequest();
      item.productID = Common.ID_MAX3D;
      item.productTypeID = 1;
      item.drawCode = draws[d].drawCode!;
      item.drawDate = draws[d].drawDate!;
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
          case 5:
            item.lineF = line;
            item.systemF = widget.type;
            item.priceF = amount;
            item.price = item.price! + amount;
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
        title: Text("Max 3D"),
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
                        Expanded(
                          child: Column(
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
                                  padding: EdgeInsets.only(
                                      left: Dimen.padingDefault),
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
                        )
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
                                        system: widget.type,
                                        listBall: listBallA,
                                        selectedBall: selectedBall,
                                        line: "A")),
                                listBallA?[0] == ""
                                    ? tcBall(listBallA!, "A")
                                    : clearBall("A"),
                                SizedBox(
                                  width: 10,
                                ),
                                OutlinedButton(
                                  onPressed: () => showAmount("A"),
                                  child: Text(
                                    formatAmount(amountA),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                      minimumSize: Size(80, 30),
                                      padding: EdgeInsets.all(4),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      side: BorderSide(
                                          width: 1,
                                          color: ColorLot.ColorPrimary)),
                                ),
                              ],
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
                                        system: widget.type,
                                        listBall: listBallB,
                                        selectedBall: selectedBall,
                                        line: "B")),
                                listBallB?[0] == ""
                                    ? tcBall(listBallB!, "B")
                                    : clearBall("B"),
                                SizedBox(
                                  width: 10,
                                ),
                                OutlinedButton(
                                  onPressed: () => showAmount("B"),
                                  child: Text(formatAmount(amountB),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400)),
                                  style: OutlinedButton.styleFrom(
                                      minimumSize: Size(80, 30),
                                      padding: EdgeInsets.all(4),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      side: BorderSide(
                                          width: 1,
                                          color: ColorLot.ColorPrimary)),
                                ),
                              ],
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
                                        system: widget.type,
                                        listBall: listBallC,
                                        selectedBall: selectedBall,
                                        line: "C")),
                                listBallC?[0] == ""
                                    ? tcBall(listBallC!, "C")
                                    : clearBall("C"),
                                SizedBox(
                                  width: 10,
                                ),
                                OutlinedButton(
                                  onPressed: () => showAmount("C"),
                                  child: Text(formatAmount(amountC),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400)),
                                  style: OutlinedButton.styleFrom(
                                      minimumSize: Size(80, 30),
                                      padding: EdgeInsets.all(4),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      side: BorderSide(
                                          width: 1,
                                          color: ColorLot.ColorPrimary)),
                                ),
                              ],
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
                                        system: widget.type,
                                        listBall: listBallD,
                                        selectedBall: selectedBall,
                                        line: "D")),
                                listBallD?[0] == ""
                                    ? tcBall(listBallD!, "D")
                                    : clearBall("D"),
                                SizedBox(
                                  width: 10,
                                ),
                                OutlinedButton(
                                  onPressed: () => showAmount("D"),
                                  child: Text(formatAmount(amountD),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400)),
                                  style: OutlinedButton.styleFrom(
                                      minimumSize: Size(80, 30),
                                      padding: EdgeInsets.all(4),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0)),
                                      side: BorderSide(
                                          width: 1,
                                          color: ColorLot.ColorPrimary)),
                                ),
                              ],
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
                                        system: widget.type,
                                        listBall: listBallE,
                                        selectedBall: selectedBall,
                                        line: "E")),
                                listBallE?[0] == ""
                                    ? tcBall(listBallE!, "E")
                                    : clearBall("E"),
                                SizedBox(
                                  width: 10,
                                ),
                                OutlinedButton(
                                  onPressed: () => showAmount("E"),
                                  child: Text(formatAmount(amountE),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400)),
                                  style: OutlinedButton.styleFrom(
                                      minimumSize: Size(80, 30),
                                      padding: EdgeInsets.all(4),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0)),
                                      side: BorderSide(
                                          width: 1,
                                          color: ColorLot.ColorPrimary)),
                                ),
                              ],
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
                                        system: widget.type,
                                        listBall: listBallF,
                                        selectedBall: selectedBall,
                                        line: "F")),
                                listBallF?[0] == ""
                                    ? tcBall(listBallF!, "F")
                                    : clearBall("F"),
                                SizedBox(
                                  width: 10,
                                ),
                                OutlinedButton(
                                  onPressed: () => showAmount("F"),
                                  child: Text(formatAmount(amountF),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400)),
                                  style: OutlinedButton.styleFrom(
                                      minimumSize: Size(80, 30),
                                      padding: EdgeInsets.all(4),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0)),
                                      side: BorderSide(
                                          width: 1,
                                          color: ColorLot.ColorPrimary)),
                                ),
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
  LineView(
      {super.key,
      required this.system,
      required this.listBall,
      required this.line,
      required this.selectedBall});

  final int system;
  List<String>? listBall;
  final String line;
  final Function selectedBall;

  @override
  State<LineView> createState() => _LineView();
}

class _LineView extends State<LineView> {
  StateSetter? _setState;
  List<String> balss = List.generate(10, (index) => (index).toString());
  List<String> balss1 = List.generate(10, (index) => (index).toString());
  List<String> balss2 = List.generate(10, (index) => (index).toString());
  List<String> balss3 = List.generate(10, (index) => (index).toString());
  List<String> balss4 = List.generate(10, (index) => (index).toString());

  final List<String> _balls = [];
  final List<String> _balls1 = [];
  final List<String> _balls2 = [];
  final List<String> _balls3 = [];
  final List<String> _balls4 = [];
  onTapBall(value, type) {
    if (type == 0) {
      _balls.clear();
      _setState!(() {
        _balls.add(value);
      });
    } else if (type == 1) {
      _balls1.clear();
      _setState!(() {
        _balls1.add(value);
      });
    } else if (type == 2) {
      _balls2.clear();
      _setState!(() {
        _balls2.add(value);
      });
    } else if (type == 3) {
      _balls3.clear();
      _setState!(() {
        _balls3.add(value);
      });
    } else if (type == 4) {
      _balls4.clear();
      _setState!(() {
        _balls4.add(value);
      });
    }
  }

  onClear() {
    _setState!(() {
      _balls.clear();
      _balls1.clear();
      _balls2.clear();
      _balls3.clear();
      _balls4.clear();
    });
  }

  onSelectedBall() {
    if (widget.system == 2) {
      if (_balls.isNotEmpty && _balls1.isNotEmpty) {
        List<String> _b = [_balls[0], _balls1[0]];
        widget.selectedBall(widget.line, _b);
        Navigator.of(context, rootNavigator: true).pop();
      }
    } else if (widget.system == 3) {
      if (_balls.isNotEmpty && _balls1.isNotEmpty && _balls2.isNotEmpty) {
        List<String> _b = [_balls[0], _balls1[0], _balls2[0]];
        widget.selectedBall(widget.line, _b);
        Navigator.of(context, rootNavigator: true).pop();
      }
    } else if (widget.system == 5) {
      if (_balls.isNotEmpty &&
          _balls1.isNotEmpty &&
          _balls2.isNotEmpty &&
          _balls3.isNotEmpty &&
          _balls4.isNotEmpty) {
        List<String> _b = [
          _balls[0],
          _balls1[0],
          _balls2[0],
          _balls3[0],
          _balls4[0]
        ];
        widget.selectedBall(widget.line, _b);
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
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
            content: StatefulBuilder(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          direction: Axis.vertical,
                          children: balss.map((item) {
                            return _balls.contains(item)
                                ? ballSelected(item, 0)
                                : ballNormal(item, 0);
                          }).toList(),
                        ),
                        Container(
                          margin: EdgeInsets.all(6),
                          width: 1,
                          height: 360,
                          color: Colors.grey,
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          children: balss1.map((item) {
                            return _balls1.contains(item)
                                ? ballSelected(item, 1)
                                : ballNormal(item, 1);
                          }).toList(),
                        ),
                        buildBySystem()
                      ],
                    ),
                    SizedBox(
                      height: 8,
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
                                      color: ColorLot.ColorPrimary, width: 1)),
                              child: Text(
                                "Chọn lại",
                                style: TextStyle(color: ColorLot.ColorPrimary),
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
                                    Radius.circular(Dimen.radiusBorderButton)),
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
            ));
      },
    );
  }

  Widget buildBySystem() {
    if (widget.system == 3) {
      return Row(
        children: [
          Container(
            margin: EdgeInsets.all(6),
            width: 1,
            height: 360,
            color: Colors.grey,
          ),
          Wrap(
            direction: Axis.vertical,
            children: balss2.map((item) {
              return _balls2.contains(item)
                  ? ballSelected(item, 2)
                  : ballNormal(item, 2);
            }).toList(),
          ),
        ],
      );
    } else if (widget.system == 5) {
      return Row(
        children: [
          Container(
            margin: EdgeInsets.all(6),
            width: 1,
            height: 360,
            color: Colors.grey,
          ),
          Wrap(
            direction: Axis.vertical,
            children: balss2.map((item) {
              return _balls2.contains(item)
                  ? ballSelected(item, 2)
                  : ballNormal(item, 2);
            }).toList(),
          ),
          Container(
            margin: EdgeInsets.all(6),
            width: 1,
            height: 360,
            color: Colors.grey,
          ),
          Wrap(
            direction: Axis.vertical,
            children: balss3.map((item) {
              return _balls3.contains(item)
                  ? ballSelected(item, 3)
                  : ballNormal(item, 3);
            }).toList(),
          ),
          Container(
            margin: EdgeInsets.all(6),
            width: 1,
            height: 360,
            color: Colors.grey,
          ),
          Wrap(
            direction: Axis.vertical,
            children: balss4.map((item) {
              return _balls4.contains(item)
                  ? ballSelected(item, 4)
                  : ballNormal(item, 4);
            }).toList(),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget ballNormal(item, type) {
    return InkWell(
      onTap: () => onTapBall(item, type),
      child: Container(
        alignment: Alignment.center,
        width: Dimen.sizeBall,
        height: Dimen.sizeBall,
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

  Widget ballSelected(item, type) {
    return InkWell(
      onTap: () => onTapBall(item, type),
      child: Container(
        alignment: Alignment.center,
        width: Dimen.sizeBall,
        height: Dimen.sizeBall,
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
