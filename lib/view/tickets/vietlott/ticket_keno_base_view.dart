// ignore_for_file: public_member_api_docs, sort_constructors_first, await_only_futures, use_build_context_synchronously, prefer_interpolation_to_compose_strings, unused_field, unnecessary_brace_in_string_interps
// ignore_for_file: prefer_const_constructors, sort_child_properties_last, must_be_immutable, unnecessary_new, prefer_const_literals_to_create_immutables, unnecessary_this, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/controller/account_controller.dart';
import 'package:lottery_flutter_application/controller/dictionary_controller.dart';
import 'package:lottery_flutter_application/controller/history_controller.dart';
import 'package:lottery_flutter_application/controller/payment_controller.dart';
import 'package:lottery_flutter_application/models/request/get_fee_request.dart';
import 'package:lottery_flutter_application/models/response/get_item_response.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/dialog_qr.dart';
import 'package:lottery_flutter_application/utils/dialog_update_info_player.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/utils/widget_divider.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:lottery_flutter_application/view/payment_view.dart';
import 'package:lottery_flutter_application/widgets/custom_button.dart';
import 'package:lottery_flutter_application/widgets/ticket_line.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/common.dart';
import '../../../models/request/order_add_request.dart';
import '../../../models/request/order_item_add_request.dart';
import '../../../models/response/get_draw_keno_response.dart';
import '../../../models/response/player_profile.dart';
import '../../../utils/box_shadow.dart';
import '../../../utils/color_lot.dart';
import '../../../utils/common.dart';
import '../../../utils/dialog_payment.dart';
import '../../../utils/dialog_process.dart';
import '../../../utils/dialog_selected_radio.dart';
import '../../../utils/scaffold_messger.dart';

final key = new GlobalKey<_TicketLotoState>();

class TicketBaseKenoView extends StatefulWidget {
  const TicketBaseKenoView(
      {Key? key, this.drawKeno, this.code, required this.balance})
      : super(key: key);
  final GetDrawKenoResponse? drawKeno;
  final String? code;
  final int balance;

  @override
  State<TicketBaseKenoView> createState() => _TicketLotoState();
}

class _TicketLotoState extends State<TicketBaseKenoView> {
  final DictionaryController _con = DictionaryController();
  final AccountController _conAcc = AccountController();
  final PaymentController _conPay = PaymentController();
  final HistoryController _his = HistoryController();

  List<GetItemResponse>? items;

  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;
  bool isSelectionMode = false;

  int drafAmount = 0;

  String? drawCode;
  int? drawTime;
  String? draw = "1";
  int system = 2;
  Timer? _timer;

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

    Future.delayed(Duration.zero, () {
      getData();
    });
    initData();

    if (widget.code != null) {
      getItemByCode();
    }
  }

  getItemByCode() async {
    ResponseObject res = await _his.getItemByCode(widget.code!);
    if (res.code == "00") {
      items = List<GetItemResponse>.from((jsonDecode(res.data!)
          .map((model) => GetItemResponse.fromJson(model))));
      GetItemResponse item = items![0];
      system = item.systemA!;
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
      setState(() {
        playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      });
    } else {
      if (mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginView()));
      }
    }
  }

  initData() {
    listBall = List<String>.generate(system, (index) => "");
    listBallA = List<String>.generate(system, (index) => "");
    listBallB = List<String>.generate(system, (index) => "");
    listBallC = List<String>.generate(system, (index) => "");
    listBallD = List<String>.generate(system, (index) => "");
    listBallE = List<String>.generate(system, (index) => "");
    listBallF = List<String>.generate(system, (index) => "");
  }

  String random(List<String> _listBall) {
    var rng = Random();
    String s = (rng.nextInt(79) + 1).toString().padLeft(2, '0');
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
      listBallF?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    }
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
          listBallA = List<String>.generate(system, (index) => "");
        });
        break;
      case "B":
        setState(() {
          listBallB = List<String>.generate(system, (index) => "");
        });
        break;
      case "C":
        setState(() {
          listBallC = List<String>.generate(system, (index) => "");
        });
        break;
      case "D":
        setState(() {
          listBallD = List<String>.generate(system, (index) => "");
        });
        break;
      case "E":
        setState(() {
          listBallE = List<String>.generate(system, (index) => "");
        });
        break;
      case "F":
        setState(() {
          listBallF = List<String>.generate(system, (index) => "");
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
    drafAmount = price * int.parse(draw!);
    setState(() {});
  }

  selectDraw(String _draw) {
    draw = _draw.split(' ')[0];
    calculator();
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
    if (widget.drawKeno == null) {
      showMessage(context, "Không có thông tin kỳ quay thưởng", "01");
      return;
    }
    if (drafAmount == 0) {
      showMessage(context, "Bạn chưa chọn bộ số dự thưởng", "01");
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
    if (listBallF![0] != "") {
      _line.add(listBallF!.join(',') + "|" + amountF.toString());
    }
    if (mode != Common.ANDROID_MODE_UPLOAD ||
        playerProfile!.mobileNumber == Common.MOBILE_OFF) {
      return dialogQR(context,
          "${_line.join("|")}|$drafAmount|${getProductName(Common.ID_KENO)}");
    }
    if (playerProfile!.name == null || playerProfile!.pIDNumber == null) {
      if (mounted) {
        dialogBuilderUpdateInfo(context, "Thông báo",
            "Vui lòng cập nhật thông tin cá nhân trước khi đặt vé");
        return;
      }
    }

    final DateTime now = DateTime.now();
    final DateFormat formatterDrawDate = DateFormat('dd/MM/yyyy');

    OrderAddNewRequest order = new OrderAddNewRequest();
    order.price = drafAmount;
    order.productID = Common.ID_KENO;
    order.quantity = int.parse(draw!);
    order.mobileNumber = playerProfile!.mobileNumber;
    order.fullName = playerProfile!.name;
    order.pIDNumber = playerProfile!.pIDNumber;
    order.emailAddress = playerProfile!.emailAddress;
    order.amount = drafAmount;
    order.fee = 0;
    order.channel = Common.CHANNEL;
    order.desc = "Đặt vé";
    order.productTypeID = 1;

    List<OrderAddItemRequest> items = [];
    int drawCode = int.parse(widget.drawKeno!.drawCode!);
    for (int k = 0; k < order.quantity!; k++) {
      OrderAddItemRequest item = new OrderAddItemRequest();
      item.productID = Common.ID_KENO;
      item.productTypeID = 1;
      item.drawCode = drawCode.toString().padLeft(7, '0');
      item.drawDate = formatterDrawDate.format(now);
      item.bag = 0;
      item.price = 0;

      for (int i = 0; i < _line.length; i++) {
        String line = _line[i].split('|')[0];
        int amount = int.parse(_line[i].split('|')[1]);
        switch (i) {
          case 0:
            item.lineA = line;
            item.systemA = system;
            item.priceA = amount;
            item.price = amount;
            break;
          case 1:
            item.lineB = line;
            item.systemB = system;
            item.priceB = amount;
            item.price = item.price! + amount;
            break;
          case 2:
            item.lineC = line;
            item.systemC = system;
            item.priceC = amount;
            item.price = item.price! + amount;
            break;
          case 3:
            item.lineD = line;
            item.systemD = system;
            item.priceD = amount;
            item.price = item.price! + amount;
            break;
          case 4:
            item.lineE = line;
            item.systemE = system;
            item.priceE = amount;
            item.price = item.price! + amount;
            break;
          case 5:
            item.lineF = line;
            item.systemF = system;
            item.priceF = amount;
            item.price = item.price! + amount;
            break;
        }
      }
      drawCode++;
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentView(
                profile: playerProfile!,
                order: order,
                code: jsonDecode(res.data!)["Code"],
                preferences: _prefs,
                balance: widget.balance,
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
        backgroundColor: ColorLot.ColorBackground,
        body: Container(
            height: size.height,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: EdgeInsets.only(bottom: 2),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chọn bậc",
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
                                        contentHeight: 200,
                                        productID: 3,
                                        title: "Chọn bậc",
                                        value: system.toString(),
                                        callback: (value) {
                                          setState(() {
                                            system = int.parse(value);
                                          });
                                          initData();
                                          calculator();
                                        });
                                  });
                            },
                            child: Container(
                                alignment: Alignment.center,
                                padding:
                                    EdgeInsets.only(left: Dimen.padingDefault),
                                width: size.width - 16,
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
                                    Text("Bậc ${system.toString()}",
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
                          buildTicketRow("A", listBallA, amountA, system),
                          dividerLot(),
                          buildTicketRow("B", listBallB, amountB, system),
                          dividerLot(),
                          buildTicketRow("C", listBallC, amountC, system),
                          dividerLot(),
                          buildTicketRow("D", listBallD, amountD, system),
                          dividerLot(),
                          buildTicketRow("E", listBallE, amountE, system),
                          dividerLot(),
                          buildTicketRow("F", listBallF, amountF, system),
                        ],
                      )),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    alignment: AlignmentDirectional.topStart,
                    child: DrawView(
                      selectDraw: selectDraw,
                      draw: draw,
                    ),
                  ),
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
            )));
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

  Widget buildTicketRow(
      String label, List<String>? balls, dynamic amount, int system) {
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
          child: LineView(
              system: system,
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
  List<String> balss =
      List.generate(80, (index) => (index + 1).toString().padLeft(2, '0'));

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
                        children: balss.map((item) {
                          return _balls.contains(item)
                              ? ballSelected(item)
                              : ballNormal(item);
                        }).toList(),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text("Bạn đã chọn : ${_balls.length}/${widget.system}"),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          CustomButton(
                              label: "Chọn lại",
                              backgroundColor: ColorLot.ColorPrimary,
                              onPressed: onClear),
                          SizedBox(
                            width: 10,
                          ),
                          CustomButton(
                              label: "Đồng ý",
                              backgroundColor: ColorLot.ColorBaoChung,
                              onPressed: onSelectedBall)
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
                            fontSize: 14,
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

class DrawView extends StatefulWidget {
  const DrawView({super.key, required this.selectDraw, required this.draw});
  final Function selectDraw;
  final String? draw;
  @override
  State<DrawView> createState() => _DrawView();
}

class _DrawView extends State<DrawView> {
  String _d = "1";
  List<String> listDraw = [
    '1 kỳ',
    '3 kỳ',
    '5 kỳ',
    '10 kỳ',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: listDraw.map((item) {
        if (_d == item.split(' ')[0]) {
          return _drawSelect(item);
        } else {
          return _drawNormal(item);
        }
      }).toList(),
    );
  }

  Widget _drawNormal(item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              widget.selectDraw(item);
              _d = item.split(' ')[0];
            });
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 4 - 8,
            height: 32,
            child: Center(
              child: Text(
                item,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _drawSelect(item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 4 - 8,
          height: 32,
          decoration: BoxDecoration(
              color: ColorLot.ColorPrimary,
              borderRadius: const BorderRadius.all(
                Radius.circular(6.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                )
              ]),
          child: Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  _d = item.split(' ')[0];
                  widget.selectDraw(item);
                });
              },
              child: Text(
                item,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
