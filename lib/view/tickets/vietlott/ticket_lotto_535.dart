// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/constants/common.dart';
import 'package:lottery_flutter_application/controller/account_controller.dart';
import 'package:lottery_flutter_application/controller/dictionary_controller.dart';
import 'package:lottery_flutter_application/controller/history_controller.dart';
import 'package:lottery_flutter_application/controller/payment_controller.dart';
import 'package:lottery_flutter_application/models/request/get_fee_request.dart';
import 'package:lottery_flutter_application/models/request/order_add_request.dart';
import 'package:lottery_flutter_application/models/request/order_item_add_request.dart';
import 'package:lottery_flutter_application/models/request/player_base_request.dart';
import 'package:lottery_flutter_application/models/response/draw_response.dart';
import 'package:lottery_flutter_application/models/response/get_balance_response.dart';
import 'package:lottery_flutter_application/models/response/get_item_response.dart';
import 'package:lottery_flutter_application/models/response/player_profile.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/box_shadow.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/utils/dialog_draw_checkbox.dart';
import 'package:lottery_flutter_application/utils/dialog_payment.dart';
import 'package:lottery_flutter_application/utils/dialog_process.dart';
import 'package:lottery_flutter_application/utils/dialog_qr.dart';
import 'package:lottery_flutter_application/utils/dialog_selected_radio.dart';
import 'package:lottery_flutter_application/utils/dialog_update_info_player.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/utils/head_balance_view.dart';
import 'package:lottery_flutter_application/utils/scaffold_messger.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/line_view.dart';

final key = new GlobalKey<_TicketLotoState>();

class TicketLotto535View extends StatefulWidget {
  const TicketLotto535View({Key? key, this.code}) : super(key: key);
  final String? code;
  @override
  State<TicketLotto535View> createState() => _TicketLotoState();
}

class _TicketLotoState extends State<TicketLotto535View> {
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
  int _price = 10000;
  int _numberMain = 5;
  int _numberSpecial = 1;

  List<String>? ballss;
  List<String>? listBall;
  List<String>? listBallA;
  List<String>? listBallB;
  List<String>? listBallC;
  List<String>? listBallD;
  List<String>? listBallE;
  List<String>? listBallF;

  List<String>? specialBallss;
  List<String>? listspA;
  List<String>? listspB;
  List<String>? listspC;
  List<String>? listspD;
  List<String>? listspE;
  List<String>? listspF;

  List<String> rows = ['A', 'B', 'C', 'D', 'E', 'F'];

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

    await getDraw();
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

  getDraw() async {
    if (context.mounted) showProcess(context);
    ResponseObject res = await _con.getDrawLotto535();
    if (mounted) Navigator.pop(context);
    if (res.code == "00") {
      setState(() {
        drawResponse = List<DrawResponse>.from((jsonDecode(res.data!)
            .map((model) => DrawResponse.fromJson(model))));
      });
    } else {
      if (mounted) showMessage(context, res.message!, "99");
    }
  }

  getItemByCode() async {
    ResponseObject res = await _his.getItemByCode(widget.code!);
    if (res.code == "00") {
      items = List<GetItemResponse>.from((jsonDecode(res.data!)
          .map((model) => GetItemResponse.fromJson(model))));
      GetItemResponse item = items![0];
      _price = item.priceA!;
      _numberMain = item.systemA!;
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

  initData() {
    listBall = List<String>.filled(_numberMain, "");
    listBallA = List<String>.filled(_numberMain, "");
    listBallB = List<String>.filled(_numberMain, "");
    listBallC = List<String>.filled(_numberMain, "");
    listBallD = List<String>.filled(_numberMain, "");
    listBallE = List<String>.filled(_numberMain, "");
    listBallF = List<String>.filled(_numberMain, "");

    ballss =
        List.generate(35, (index) => (index + 1).toString().padLeft(2, '0'));
    specialBallss =
        List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
    listspA = List<String>.filled(_numberSpecial, "");
    listspB = List<String>.filled(_numberSpecial, "");
    listspC = List<String>.filled(_numberSpecial, "");
    listspD = List<String>.filled(_numberSpecial, "");
    listspE = List<String>.filled(_numberSpecial, "");
    listspF = List<String>.filled(_numberSpecial, "");
  }

  String random(int totalNumber, List<String> _listBall) {
    var rng = Random();
    String s = (rng.nextInt(totalNumber) + 1).toString().padLeft(2, '0');
    return _listBall.contains(s) ? random(totalNumber, _listBall) : s;
  }

  void randomNumberLine(
      List<String> listBall, List<String> listSpecial, String line) {
    // Fill main numbers
    for (int i = 0; i < listBall.length; i++) {
      listBall[i] = random(35, listBall);
    }
    listBall.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    // Fill special numbers
    for (int i = 0; i < listSpecial.length; i++) {
      listSpecial[i] = random(12, listSpecial);
    }
    listSpecial.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    // Update theo line
    _updateListByLine(line, listBall, listSpecial);
    calculator();
  }

  void _updateListByLine(
      String line, List<String> ballList, List<String> specialList) {
    switch (line) {
      case "A":
        listBallA = ballList;
        listspA = specialList;
        break;
      case "B":
        listBallB = ballList;
        listspB = specialList;
        break;
      case "C":
        listBallC = ballList;
        listspC = specialList;
        break;
      case "D":
        listBallD = ballList;
        listspD = specialList;
        break;
      case "E":
        listBallE = ballList;
        listspE = specialList;
        break;
      case "F":
        listBallF = ballList;
        listspF = specialList;
        break;
    }
    setState(() {});
  }

// Method 2: Random tất cả lines
  void randomNumberAllLine() {
    final ballLists = [
      listBallA,
      listBallB,
      listBallC,
      listBallD,
      listBallE,
      listBallF
    ];
    final specialLists = [listspA, listspB, listspC, listspD, listspE, listspF];

    // Process ball lists
    for (var list in ballLists) {
      if (list != null) {
        for (int i = 0; i < list.length; i++) {
          list[i] = random(35, list);
        }
        list.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      }
    }

    // Process special lists
    for (var list in specialLists) {
      if (list != null) {
        for (int i = 0; i < list.length; i++) {
          list[i] = random(12, list);
        }
        list.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      }
    }

    setState(() {});
    calculator();
  }

  Widget tcBall(List<String> balls, List<String> ballsp, String line) {
    return InkWell(
      onTap: () => randomNumberLine(balls, ballsp, line),
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

  void _clearBall(String line) {
    switch (line) {
      case "A":
        setState(() {
          listBallA = List<String>.generate(_numberMain, (index) => "");
          listspA = List<String>.generate(_numberSpecial, (index) => "");
        });
        break;
      case "B":
        setState(() {
          listBallB = List<String>.generate(_numberMain, (index) => "");
          listspB = List<String>.generate(_numberSpecial, (index) => "");
        });
        break;
      case "C":
        setState(() {
          listBallC = List<String>.generate(_numberMain, (index) => "");
          listspC = List<String>.generate(_numberSpecial, (index) => "");
        });
        break;
      case "D":
        setState(() {
          listBallD = List<String>.generate(_numberMain, (index) => "");
          listspD = List<String>.generate(_numberSpecial, (index) => "");
        });
        break;
      case "E":
        setState(() {
          listBallE = List<String>.generate(_numberMain, (index) => "");
          listspE = List<String>.generate(_numberSpecial, (index) => "");
        });
        break;
      case "F":
        setState(() {
          listBallF = List<String>.generate(_numberMain, (index) => "");
          listspF = List<String>.generate(_numberSpecial, (index) => "");
        });
        break;
    }
    calculator();
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

  calculator() {
    int price = 0;
    if (listBallA?[0] != "") {
      price = price + _price * _numberSpecial;
    }
    if (listBallB?[0] != "") {
      price = price + _price * _numberSpecial;
    }
    if (listBallC?[0] != "") {
      price = price + _price * _numberSpecial;
    }
    if (listBallD?[0] != "") {
      price = price + _price * _numberSpecial;
    }
    if (listBallE?[0] != "") {
      price = price + _price * _numberSpecial;
    }
    if (listBallF?[0] != "") {
      price = price + _price * _numberSpecial;
    }
    setState(() {
      drafAmount = price * draws.length;
    });
  }

  selectedBall(String line, List<String> mainBalls, List<String> specialBalls) {
    setState(() {
      switch (line) {
        case "A":
          listBallA = [...mainBalls];
          listspA = [...specialBalls];
          break;
        case "B":
          listBallB = [...mainBalls];
          listspB = [...specialBalls];
          break;
        case "C":
          listBallC = [...mainBalls];
          listspC = [...specialBalls];
          break;
        case "D":
          listBallD = [...mainBalls];
          listspD = [...specialBalls];
          break;
        case "E":
          listBallE = [...mainBalls];
          listspE = [...specialBalls];
          break;
        case "F":
          listBallF = [...mainBalls];
          listspF = [...specialBalls];
          break;
      }
    });
    calculator(); // Tính toán lại
  }

  Future<ResponseObject> getFee(int productID) async {
    GetFeeRequest feeRequest =
        GetFeeRequest(amount: drafAmount, productID: productID);
    return await _conPay.getFee(feeRequest);
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

    // Kiểm tra và lấy các hàng có đủ dữ liệu (cả main và special)
    List<String> _line = [];
    List<String> _symbolLine = []; // Cho special numbers
    List<Map<String, dynamic>> validLines = [];

    // Hàm helper kiểm tra hàng có đầy đủ dữ liệu
    bool isLineComplete(List<String>? mainList, List<String>? specialList) {
      if (mainList == null || specialList == null) return false;
      if (mainList.isEmpty || specialList.isEmpty) return false;
      if (mainList[0] == "" || specialList[0] == "") return false;

      // Kiểm tra số lượng đủ theo system
      int mainCount = mainList.where((item) => item.isNotEmpty).length;
      int specialCount = specialList.where((item) => item.isNotEmpty).length;

      return mainCount == _numberMain && specialCount == _numberSpecial;
    }

    // Thu thập tất cả hàng hợp lệ (không quan tâm thứ tự gốc)
    List<Map<String, dynamic>> allPossibleLines = [
      {'original': 'A', 'main': listBallA, 'special': listspA},
      {'original': 'B', 'main': listBallB, 'special': listspB},
      {'original': 'C', 'main': listBallC, 'special': listspC},
      {'original': 'D', 'main': listBallD, 'special': listspD},
      {'original': 'E', 'main': listBallE, 'special': listspE},
      {'original': 'F', 'main': listBallF, 'special': listspF},
    ];

    // Lọc và dồn các hàng hợp lệ theo thứ tự A, B, C, D, E, F
    int compactIndex = 0;
    for (var lineData in allPossibleLines) {
      if (isLineComplete(lineData['main'], lineData['special'])) {
        List<String> mainList = lineData['main'];
        List<String> specialList = lineData['special'];

        _line.add(mainList.where((item) => item.isNotEmpty).join(','));
        _symbolLine.add(specialList.where((item) => item.isNotEmpty).join(','));

        validLines.add({
          'compactIndex': compactIndex, // Vị trí sau khi dồn (0=A, 1=B, ...)
          'originalLine': lineData['original'], // Hàng gốc (A, B, C, D, E, F)
          'main': mainList,
          'special': specialList
        });

        compactIndex++;
      }
    }

    // Kiểm tra có ít nhất 1 hàng hợp lệ
    if (validLines.isEmpty) {
      showMessage(
          context,
          "Vui lòng chọn đầy đủ số chính và số đặc biệt cho ít nhất 1 hàng",
          "01");
      return;
    }

    if (mode != Common.ANDROID_MODE_UPLOAD ||
        playerProfile!.mobileNumber == Common.MOBILE_OFF) {
      // Bao gồm cả main và special numbers trong QR
      String qrData =
          "${_line.join("|")}#${_symbolLine.join("|")}|$drafAmount|${getProductName(16)}";
      return dialogQR(context, qrData);
    }

    if (playerProfile!.name == null || playerProfile!.pIDNumber == null) {
      if (mounted) {
        dialogBuilderUpdateInfo(context, "Thông báo",
            "Vui lòng cập nhật thông tin cá nhân trước khi đặt vé");
        return;
      }
    }

    int productTypeID = 1;
    if (_numberMain == 6) {
      productTypeID = 1;
    } else {
      productTypeID = 2;
    }

    OrderAddNewRequest order = OrderAddNewRequest();
    order.price = drafAmount;
    order.productID = 16;
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
      item.productID = 16;
      item.productTypeID = productTypeID;
      item.drawCode = draws[d].drawCode!;
      item.drawDate = draws[d].drawDate!;
      if (productTypeID == 2) {
        item.bag = _numberMain;
      }
      item.price = 0;

      // Dồn các hàng hợp lệ vào lineA, lineB, lineC, lineD, lineE, lineF theo thứ tự
      for (int i = 0; i < validLines.length; i++) {
        var lineData = validLines[i];
        int compactIndex = lineData['compactIndex']; // Vị trí sau khi dồn

        switch (compactIndex) {
          case 0: // Hàng đầu tiên hợp lệ → lineA
            item.lineA = _line[i];
            item.systemA = _numberMain;
            item.priceA = _price * _numberSpecial;
            item.symbolA = _symbolLine[i];
            item.drawlerA = _numberSpecial;
            item.price = _price * _numberSpecial;
            break;
          case 1: // Hàng thứ 2 hợp lệ → lineB
            item.lineB = _line[i];
            item.systemB = _numberMain;
            item.priceB = _price * _numberSpecial;
            item.symbolB = _symbolLine[i];
            item.drawlerB = _numberSpecial;
            item.price = item.price! + _price * _numberSpecial;
            break;
          case 2: // Hàng thứ 3 hợp lệ → lineC
            item.lineC = _line[i];
            item.systemC = _numberMain;
            item.priceC = _price * _numberSpecial;
            item.symbolC = _symbolLine[i];
            item.drawlerC = _numberSpecial;
            item.price = item.price! + _price * _numberSpecial;
            break;
          case 3: // Hàng thứ 4 hợp lệ → lineD
            item.lineD = _line[i];
            item.systemD = _numberMain;
            item.priceD = _price * _numberSpecial;
            item.symbolD = _symbolLine[i];
            item.drawlerD = _numberSpecial;
            item.price = item.price! + _price * _numberSpecial;
            break;
          case 4: // Hàng thứ 5 hợp lệ → lineE
            item.lineE = _line[i];
            item.systemE = _numberMain;
            item.priceE = _price * _numberSpecial;
            item.symbolE = _symbolLine[i];
            item.drawlerE = _numberSpecial;
            item.price = item.price! + _price * _numberSpecial;
            break;
          case 5: // Hàng thứ 6 hợp lệ → lineF
            item.lineF = _line[i];
            item.systemF = _numberMain;
            item.priceF = _price * _numberSpecial;
            item.symbolF = _symbolLine[i];
            item.drawlerF = _numberSpecial;
            item.price = item.price! + _price * _numberSpecial;
            break;
        }
      }

      items.add(item);
    }

    order.items = items;

    if (mounted) showProcess(context);

    try {
      ResponseObject res = await _conPay.addOrder(order);
      if (!mounted) return;

      if (res.code == "00") {
        ResponseObject resFee = await getFee(order.productID!);
        if (!mounted) return;

        Navigator.pop(context); // Hide loading

        if (resFee.code == "00") {
          double fee = jsonDecode(resFee.data!)["Fee"];
          order.fee = fee.round();

          if (mounted) {
            dialogPayment(context, playerProfile!, order,
                jsonDecode(res.data!)["Code"], _prefs);
          }
        } else {
          if (mounted) showMessage(context, resFee.message!, "98");
        }
      } else {
        Navigator.pop(context); // Hide loading
        if (mounted) showMessage(context, res.message!, "98");
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Hide loading
        showMessage(context, "Có lỗi xảy ra: $e", "98");
      }
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
        title: Text("Lotto 5/35"),
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
                              "Số chính",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: Dimen.fontSizeLable),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            InkWell(
                              onTap: () {
                                if (_numberSpecial != 1) return;
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DialogSelectedRadio(
                                          contentHeight: 240,
                                          productID: Common.ID_LOTTO_535,
                                          title: "Chọn số chính",
                                          callback: (value) {
                                            setState(() {
                                              _numberMain = int.parse(value);
                                              _price = getPriceByPlayTypeLoto(
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
                                    color: _numberSpecial == 1
                                        ? Colors.white
                                        : Colors.white70,
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
                                          getNumberMainNameLotto535(
                                              _numberMain),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: Dimen.fontSizeValue,
                                            color: _numberSpecial == 1
                                                ? Colors.black
                                                : Colors.grey,
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
                              "Số đặc biệt",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: Dimen.fontSizeLable),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            InkWell(
                              onTap: () {
                                if (_numberMain != 5) return;
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DialogSelectedRadio(
                                          contentHeight: 240,
                                          productID:
                                              Common.ID_LOTTO_535_SPECIAL,
                                          title: "Chọn số đặc biệt",
                                          callback: (value) {
                                            setState(() {
                                              _numberSpecial = int.parse(value);
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
                                    color: _numberMain == 5
                                        ? Colors.white
                                        : Colors.white70,
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
                                          getNumberSpecialNameLotto535(
                                              _numberSpecial),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: Dimen.fontSizeValue,
                                            color: _numberMain == 5
                                                ? Colors.black
                                                : Colors.grey,
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
                      ],
                    ),
                    SizedBox(
                      height: 8,
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
                            // Row A
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
                                        specialBalls: specialBallss ??
                                            [], // Danh sách số đặc biệt (1-12)
                                        system: _numberMain,
                                        systemSpecial:
                                            _numberSpecial, // Số lượng số đặc biệt
                                        listBall: listBallA,
                                        listsp: listspA, // Thêm listsp
                                        selectedBall: selectedBall,
                                        line: "A")),
                                SizedBox(width: 10),
                                // Kiểm tra cả main và special ball
                                (listBallA?[0] == "" || listspA?[0] == "")
                                    ? tcBall(listBallA!, listspA!, "A")
                                    : clearBall("A"),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Row B
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
                                        specialBalls: specialBallss ?? [],
                                        system: _numberMain,
                                        systemSpecial: _numberSpecial,
                                        listBall: listBallB,
                                        listsp: listspB,
                                        selectedBall: selectedBall,
                                        line: "B")),
                                SizedBox(width: 10),
                                (listBallB?[0] == "" || listspB?[0] == "")
                                    ? tcBall(listBallB!, listspB!, "B")
                                    : clearBall("B"),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Row C
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
                                        specialBalls: specialBallss ?? [],
                                        system: _numberMain,
                                        systemSpecial: _numberSpecial,
                                        listBall: listBallC,
                                        listsp: listspC,
                                        selectedBall: selectedBall,
                                        line: "C")),
                                SizedBox(width: 10),
                                (listBallC?[0] == "" || listspC?[0] == "")
                                    ? tcBall(listBallC!, listspC!, "C")
                                    : clearBall("C"),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Row D
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
                                        specialBalls: specialBallss ?? [],
                                        system: _numberMain,
                                        systemSpecial: _numberSpecial,
                                        listBall: listBallD,
                                        listsp: listspD,
                                        selectedBall: selectedBall,
                                        line: "D")),
                                SizedBox(width: 10),
                                (listBallD?[0] == "" || listspD?[0] == "")
                                    ? tcBall(listBallD!, listspD!, "D")
                                    : clearBall("D"),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Row E
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
                                        specialBalls: specialBallss ?? [],
                                        system: _numberMain,
                                        systemSpecial: _numberSpecial,
                                        listBall: listBallE,
                                        listsp: listspE,
                                        selectedBall: selectedBall,
                                        line: "E")),
                                SizedBox(width: 10),
                                (listBallE?[0] == "" || listspE?[0] == "")
                                    ? tcBall(listBallE!, listspE!, "E")
                                    : clearBall("E"),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Row F
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
                                        specialBalls: specialBallss ?? [],
                                        system: _numberMain,
                                        systemSpecial: _numberSpecial,
                                        listBall: listBallF,
                                        listsp: listspF,
                                        selectedBall: selectedBall,
                                        line: "F")),
                                SizedBox(width: 10),
                                (listBallF?[0] == "" || listspF?[0] == "")
                                    ? tcBall(listBallF!, listspF!, "F")
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
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(6),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    side:
                        BorderSide(width: 1, color: ColorLot.ColorRandomFast)),
                child: Text("Chọn nhanh",
                    style: TextStyle(color: ColorLot.ColorRandomFast)),
              )),
              SizedBox(width: 8),
              Expanded(
                  child: OutlinedButton(
                onPressed: next,
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(6),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    side: BorderSide(width: 1, color: ColorLot.ColorSuccess)),
                child: Text(
                  "Đặt vé",
                  style: TextStyle(color: ColorLot.ColorSuccess),
                ),
              )),
            ],
          ),
        ],
      );
    }
  }
}
