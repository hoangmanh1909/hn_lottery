// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/controller/dictionary_controller.dart';
import 'package:lottery_flutter_application/controller/payment_controller.dart';
import 'package:lottery_flutter_application/models/request/order_add_request.dart';
import 'package:lottery_flutter_application/models/request/order_item_add_request.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dialog_update_info_player.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/utils/head_balance_view.dart';
import 'package:lottery_flutter_application/utils/scaffold_messger.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:lottery_flutter_application/view/payment_view.dart';
import 'package:lottery_flutter_application/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/common.dart';
import '../../../controller/account_controller.dart';
import '../../../models/request/get_fee_request.dart';
import '../../../models/request/player_base_request.dart';
import '../../../models/response/get_balance_response.dart';
import '../../../models/response/get_draw_keno_response.dart';
import '../../../models/response/player_profile.dart';
import '../../../utils/box_shadow.dart';
import '../../../utils/common.dart';
import '../../../utils/dialog_payment.dart';
import '../../../utils/dialog_process.dart';
import '../../../utils/dialog_qr.dart';
import '../../../utils/dialog_selected_radio.dart';
import '../../../utils/widget_divider.dart';

class TicketKenoBagView extends StatefulWidget {
  const TicketKenoBagView({Key? key}) : super(key: key);

  @override
  State<TicketKenoBagView> createState() => _TicketKenoBagViewState();
}

class _TicketKenoBagViewState extends State<TicketKenoBagView>
    with TickerProviderStateMixin {
  final DictionaryController _con = DictionaryController();
  final AccountController _conAcc = AccountController();
  final PaymentController _conPay = PaymentController();

  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;

  GetDrawKenoResponse? drawKenoResponse;
  List<GetBalanceResponse>? balanceResponse;
  int balance = 0;

  int secondCountdown = 0;
  Timer? timer;

  List<int>? listAmount = [10000, 20000, 50000, 100000, 200000, 500000];
  List<String>? listBall;
  List<String>? listBallA;
  int amountA = 20000;
  int bag = 3;
  int system = 2;
  int drafAmount = 0;
  String? draw = "1";

  List<String> _arrPrint = [];
  List<int> _a = [];
  List<int> _s = [];
  String mode = "ON";
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getData();
    });
    initData();
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    super.dispose();
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
    if (mounted) {
      showProcess(context);
    }

    await getDrawKeno();
    await getBalance();
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

  initData() {
    listBall = List<String>.generate(bag, (index) => "");
    listBallA = List<String>.generate(bag, (index) => "");
    if (_arrPrint.isNotEmpty) {
      _arrPrint.clear();
    }
    setState(() {});
  }

  getDrawKeno() async {
    if (mounted) {
      showProcess(context);
    }
    ResponseObject res = await _con.getDrawKeno();
    if (mounted) {
      Navigator.pop(context);
    }
    if (res.code == "00") {
      setState(() {
        drawKenoResponse = GetDrawKenoResponse.fromJson(jsonDecode(res.data!));
        secondCountdown = drawKenoResponse!.closeTime!;
      });
      if (drawKenoResponse != null) {
        startTimer();
      }
    }
  }

  startTimer() {
    Duration oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (secondCountdown == 0) {
          setState(() {
            secondCountdown = 480;
          });
        } else {
          setState(() {
            secondCountdown--;
          });
        }
      },
    );
  }

  String random(List<String> _listBall) {
    var rng = Random();
    String s = (rng.nextInt(79) + 1).toString().padLeft(2, '0');
    return _listBall.contains(s) ? random(_listBall) : s;
  }

  randomNumber() {
    if (listBallA?[0] == "") {
      for (var i = 0; i < listBallA!.length; i++) {
        listBallA?[i] = random(listBallA!);
      }
      listBallA?.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    }
    setState(() {
      listBallA = listBallA;
    });
    calculator();
  }

  randomNumberLine(List<String> _listBall, String _line) {
    for (var i = 0; i < _listBall.length; i++) {
      _listBall[i] = random(_listBall);
    }
    _listBall.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    listBallA = _listBall;
    processBag();
    calculator();
  }

  processBag() {
    _arrPrint = [];
    _a = List<int>.generate(bag + 1, (index) => 0);
    _s = List<int>.generate(bag + 1, (index) => 0);
    for (var i = 0; i < bag + 1; i++) {
      _s[i] = 0;
    }
    _a[0] = 1;
    recursion(1);
  }

  print() {
    var item = "";
    for (var j = 1; j <= system; j++) {
      if (item == "") {
        item = listBallA![_a[j] - 1];
      } else {
        item += " ${listBallA![_a[j] - 1]}";
      }
    }
    _arrPrint.add(item);
  }

  recursion(i) {
    if (i > system) {
      print();
    } else {
      int j;
      for (j = _a[i - 1]; j <= bag; j++) {
        if (_s[j] == 0) {
          _a[i] = j;
          _s[j] = 1;
          recursion(i + 1);
          _s[j] = 0;
        }
      }
    }
  }

  selectAmount(int index, String line) {
    setState(() {
      amountA = listAmount![index];
    });
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
    setState(() {
      _arrPrint = [];
      listBallA = List<String>.generate(bag, (index) => "");
    });
    calculator();
  }

  calculator() {
    int price = 0;
    if (listBallA?[0] != "") {
      price = price + amountA;
    }

    setState(() {
      drafAmount = price * _arrPrint.length * int.parse(draw!);
    });
  }

  selectDraw(String _draw) {
    draw = _draw.split(' ')[0];
    calculator();
  }

  selectedBall(String line, List<String> _balls) {
    _balls.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    setState(() {
      listBallA = _balls;
    });
    processBag();
    calculator();
  }

  Future<ResponseObject> getFee(int productID) async {
    GetFeeRequest feeRequest =
        GetFeeRequest(amount: drafAmount, productID: productID);
    return await _conPay.getFee(feeRequest);
  }

  next() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyMMddHHmmssmmm');
    final DateFormat formatterDrawDate = DateFormat('dd/MM/yyyy');
    final String codePayment = formatter.format(now);

    if (drafAmount == 0 || _arrPrint.isEmpty) {
      if (mounted) {
        showMessage(context, "Bạn chưa chọn bộ số dự thưởng", "01");
        return;
      }
    }
    if (drawKenoResponse == null) {
      if (mounted) {
        showMessage(context, "Không có thông tin kỳ quay thưởng", "01");
        return;
      }
    }
    if (mode != Common.ANDROID_MODE_UPLOAD ||
        playerProfile!.mobileNumber == Common.MOBILE_OFF) {
      return dialogQR(context,
          "${playerProfile!.mobileNumber}|$drafAmount|${getProductName(Common.ID_KENO)}");
    }
    if (playerProfile!.name == null || playerProfile!.pIDNumber == null) {
      if (mounted) {
        dialogBuilderUpdateInfo(context, "Thông báo",
            "Vui lòng cập nhật thông tin cá nhân trước khi đặt vé");
        return;
      }
    }
    bool isCheck = true;
    int drawCode = int.parse(drawKenoResponse!.drawCode!);
    if (context.mounted) showProcess(context);
    for (int k = 0; k < int.parse(draw!); k++) {
      List<OrderAddItemRequest> items = [];

      OrderAddItemRequest item = OrderAddItemRequest();
      item.drawCode = drawCode.toString().padLeft(7, '0');
      item.drawDate = formatterDrawDate.format(now);
      item.productID = Common.ID_KENO;
      item.productTypeID = 2;
      item.bag = bag;

      int countLine = 0;
      int price = 0;
      for (int i = 0; i < _arrPrint.length; i++) {
        countLine++;
        switch (countLine) {
          case 1:
            item.lineA = _arrPrint[i].replaceAll(" ", ",");
            item.priceA = amountA;
            item.systemA = system;
            price += amountA;
            break;
          case 2:
            item.lineB = _arrPrint[i].replaceAll(" ", ",");
            item.priceB = amountA;
            item.systemB = system;
            price += amountA;
            break;
          case 3:
            item.lineC = _arrPrint[i].replaceAll(" ", ",");
            item.priceC = amountA;
            item.systemC = system;
            price += amountA;
            break;
          case 4:
            item.lineD = _arrPrint[i].replaceAll(" ", ",");
            item.priceD = amountA;
            item.systemD = system;
            price += amountA;
            break;
          case 5:
            item.lineE = _arrPrint[i].replaceAll(" ", ",");
            item.priceE = amountA;
            item.systemE = system;
            price += amountA;
            break;
          case 6:
            item.lineF = _arrPrint[i].replaceAll(" ", ",");
            item.priceF = amountA;
            item.systemF = system;
            price += amountA;
            break;
        }

        if (countLine == 6 ||
            countLine == _arrPrint.length ||
            i == _arrPrint.length - 1) {
          item.price = price;
          items.add(item);

          if (i != _arrPrint.length - 1) {
            item = OrderAddItemRequest();
            item.drawCode = drawCode.toString().padLeft(7, '0');
            item.productID = Common.ID_KENO;
            item.productTypeID = 2;
            item.bag = bag;
            item.drawDate = formatterDrawDate.format(now);
            countLine = 0;
            price = 0;
          }
        }
      }
      OrderAddNewRequest order = OrderAddNewRequest();
      order.price = drafAmount ~/ int.parse(draw!);
      order.productID = Common.ID_KENO;
      order.quantity = items.length;
      order.mobileNumber = playerProfile!.mobileNumber;
      order.fullName = playerProfile!.name;
      order.pIDNumber = playerProfile!.pIDNumber;
      order.emailAddress = playerProfile!.emailAddress;
      order.amount = drafAmount ~/ int.parse(draw!);
      order.fee = 0;
      order.channel = Common.CHANNEL;
      order.desc = "Đặt vé bao Keno";
      order.bag = bag;
      order.bagBalls = listBallA!.join(",");
      order.productTypeID = 2;
      order.terminalID = playerProfile!.terminalID!;
      order.codePayment = codePayment;
      order.items = items;

      ResponseObject res = await _conPay.addOrder(order);
      if (res.code != "00") {
        isCheck = false;
        break;
      }
      drawCode++;
    }
    if (context.mounted) Navigator.pop(context);
    if (isCheck) {
      OrderAddNewRequest order = OrderAddNewRequest();
      order.price = drafAmount;
      order.productID = Common.ID_KENO;
      order.mobileNumber = playerProfile!.mobileNumber;
      order.fullName = playerProfile!.name;
      order.pIDNumber = playerProfile!.pIDNumber;
      order.emailAddress = playerProfile!.emailAddress;
      order.amount = drafAmount;
      order.fee = 0;
      order.codePayment = codePayment;
      if (mounted) {
        dialogPayment(context, playerProfile!, order, codePayment, _prefs);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentView(
              profile: playerProfile!,
              order: order,
              code: codePayment,
              preferences: _prefs,
              balance: balance,
              mode: mode,
            ),
          ),
        );
      }
    } else {
      if (context.mounted) showMessage(context, "Lỗi cập nhật dữ liệu!", "98");
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
          title: Text("Bao Keno"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                color: ColorLot.ColorBackground,
                padding: EdgeInsets.all(Dimen.padingDefault),
                child: Column(
                  children: [
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Kỳ #${drawKenoResponse != null ? drawKenoResponse!.drawCode : ""}",
                          style: TextStyle(
                              color: ColorLot.ColorPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                        _countDownKeno()
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildHead(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[boxShadow()],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      alignment: AlignmentDirectional.topStart,
                      child: Row(
                        children: [
                          Expanded(
                              child: LineView(
                                  system: bag,
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
                            style: OutlinedButton.styleFrom(
                              // Cố định chiều cao là 32, chiều ngang tối thiểu 80 (tự giãn nếu tiền dài)
                              minimumSize: const Size(80, 30),
                              fixedSize: const Size.fromHeight(
                                  30), // Ép cứng chiều cao 32

                              // Thu nhỏ vùng đệm thừa của hệ thống xung quanh nút
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,

                              // Padding hẹp lại để chữ nằm gọn bên trong
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 0),

                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                              side: BorderSide(
                                  width: 1, color: ColorLot.ColorPrimary),
                            ),
                            child: Text(
                              formatAmount(amountA),
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.w500, // Tăng lên 500 cho dễ đọc
                                fontSize:
                                    13, // Size 13 là cực chuẩn cho độ cao 32
                                color: ColorLot.ColorPrimary,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      alignment: AlignmentDirectional.topStart,
                      child: DrawView(
                        selectDraw: selectDraw,
                        draw: draw,
                      ),
                    ),
                    Container(
                      width: size.width - 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[boxShadow()],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Danh sách bộ số",
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "(${_arrPrint.length})",
                                style: TextStyle(
                                    color: ColorLot.ColorPrimary,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          buildListBall(_arrPrint)
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[boxShadow()],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(top: 10),
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
                ))));
  }

  Widget buildPayment() {
    if (mode != Common.ANDROID_MODE_UPLOAD) {
      return SizedBox.shrink();
    } else {
      return Column(children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            CustomButton(
              label: "Chọn nhanh",
              backgroundColor: ColorLot.ColorBaoChung,
              onPressed: () => _clearBall("A"),
            ),
            const SizedBox(width: 8),
            CustomButton(
              label: "Đặt vé",
              backgroundColor: ColorLot.ColorPrimary,
              onPressed: next,
            ),
          ],
        ),
      ]);
    }
  }

  Widget buildListBall(List<String> balls) {
    return Wrap(
        alignment: WrapAlignment.center,
        children: balls.map((e) {
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    width: 1,
                    color: ColorLot.ColorPrimary,
                    style: BorderStyle.solid),
              ),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: EdgeInsets.all(2),
              child: Text(
                e,
                style: TextStyle(color: Colors.black),
              ));
        }).toList());
  }

  Widget buildHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chọn bao",
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
                          contentHeight: 200,
                          productID: Common.ID_KENO_TYPE_BAG,
                          title: "Chọn bao",
                          value: bag.toString(),
                          callback: (value) {
                            bag = int.parse(value);
                            if (bag == 12) {
                              system = 10;
                            } else {
                              system = bag - 1;
                            }

                            initData();
                            calculator();
                          });
                    });
              },
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: Dimen.padingDefault),
                  width: double.infinity,
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
                      Flexible(
                          child: Text("Bao $bag",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Dimen.fontSizeValue,
                                color: Colors.black,
                              ))),
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
        )),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chọn bậc",
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
                            contentHeight: 120,
                            productID: Common.ID_KENO_TYPE_BAG_OP,
                            title: "Chọn bậc",
                            condition: bag,
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
                    padding: EdgeInsets.only(left: Dimen.padingDefault),
                    width: double.infinity,
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
                        Text("Bậc ${system.toString()}",
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
        ),
      ],
    );
  }

  Widget _countDownKeno() {
    if (secondCountdown > 0) {
      Duration duration = Duration(seconds: secondCountdown);
      return Text(
        " thời gian còn ${padLeftTwo(duration.inMinutes.remainder(60))}:${padLeftTwo(duration.inSeconds.remainder(60))}",
        style: TextStyle(
            color: ColorLot.ColorPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16),
      );
    } else {
      return Text(" thời gian còn 00:00",
          style: TextStyle(
              color: ColorLot.ColorPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16));
    }
  }
}

class LineView extends StatefulWidget {
  const LineView(
      {super.key,
      required this.system,
      required this.listBall,
      required this.line,
      required this.selectedBall});

  final int system;
  final List<String>? listBall;
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
