// ignore_for_file: unused_field, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/constants/common.dart';
import 'package:lottery_flutter_application/controller/account_controller.dart';
import 'package:lottery_flutter_application/controller/dictionary_controller.dart';
import 'package:lottery_flutter_application/controller/payment_controller.dart';
import 'package:lottery_flutter_application/models/feedbody_view_model.dart';
import 'package:lottery_flutter_application/models/request/get_fee_request.dart';
import 'package:lottery_flutter_application/models/request/order_add_request.dart';
import 'package:lottery_flutter_application/models/request/order_item_add_request.dart';
import 'package:lottery_flutter_application/models/request/order_list_add_request.dart';
import 'package:lottery_flutter_application/models/request/player_base_request.dart';
import 'package:lottery_flutter_application/models/response/get_balance_response.dart';
import 'package:lottery_flutter_application/models/response/get_draw_keno_response.dart';
import 'package:lottery_flutter_application/models/response/player_profile.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/models/selected_item_model.dart';
import 'package:lottery_flutter_application/utils/box_shadow.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/utils/dialog_payment.dart';
import 'package:lottery_flutter_application/utils/dialog_process.dart';
import 'package:lottery_flutter_application/utils/dialog_selected_draw.dart';
import 'package:lottery_flutter_application/utils/dialog_selected_radio.dart';
import 'package:lottery_flutter_application/utils/dialog_update_info_player.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/utils/head_balance_view.dart';
import 'package:lottery_flutter_application/utils/scaffold_messger.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_keno_feed_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketKenoFeedODView extends StatefulWidget {
  const TicketKenoFeedODView({Key? key}) : super(key: key);

  @override
  State<TicketKenoFeedODView> createState() => _TicketKenoFeedODViewState();
}

class _TicketKenoFeedODViewState extends State<TicketKenoFeedODView>
    with TickerProviderStateMixin {
  final DictionaryController _con = DictionaryController();
  final AccountController _conAcc = AccountController();
  final PaymentController _conPay = PaymentController();

  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;

  List<GetDrawKenoResponse>? drawKenoResponses;
  GetDrawKenoResponse? drawKenoResponse;
  List<GetBalanceResponse>? balanceResponse;
  int balance = 0;

  int secondCountdown = 0;
  Timer? timer;

  List<FeedBodyViewModel> drawSeleted = [];

  int drafAmount = 0;
  bool iscancel = false;
  int spot = 1;
  int totalRow = 30;
  int totalSelectedDefault = 15;
  String mode = "ON";
  List<TextEditingController> pricesController = [];
  String lineA = "CHAN";
  String groupvalue = "1";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  void getData() async {
    _prefs = await SharedPreferences.getInstance();
    mode = _prefs!.getString(Common.SHARE_MODE_UPLOAD)!;
    String? userMap = _prefs?.getString('user');
    if (userMap != null) {
      playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
    } else {
      if (mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginView()));
      }
    }
    if (mounted) {
      showProcess(context);
    }

    await getDrawKenoByDay();
    await getBalance();
    if (mounted) {
      Navigator.pop(context);
    }
    setState(() {});
  }

  getDrawKenoByDay() async {
    if (mounted) {
      showProcess(context);
    }
    ResponseObject res = await _con.getDrawKenoByDay();
    if (mounted) {
      Navigator.pop(context);
    }
    if (res.code == "00") {
      drawKenoResponses = List<GetDrawKenoResponse>.from((jsonDecode(res.data!)
          .map((model) => GetDrawKenoResponse.fromJson(model))));
      if (drawKenoResponses != null && drawKenoResponses!.isNotEmpty) {
        drawKenoResponse = drawKenoResponses![0];
        initData();
      }
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

          balance = bl.amount!;
        }
      }
    }
  }

  initData() {
    if (mounted) {
      showProcess(context);
    }

    if (spot == 1) {
      if (drawKenoResponses != null && drawKenoResponses!.isNotEmpty) {
        drawSeleted.clear();
        pricesController.clear();
        totalRow =
            drawKenoResponses!.length > 15 ? 15 : drawKenoResponses!.length;
        totalSelectedDefault =
            drawKenoResponses!.length > 15 ? 15 : drawKenoResponses!.length;

        double totalAmount = 0;
        double priceBase = 0;
        switch (lineA) {
          case Common.HOA:
          case Common.C1112:
          case Common.L1112:
            if (totalRow > 8) {
              totalRow = 8;
            }
            for (int i = 0; i < totalRow; i++) {
              pricesController.add(TextEditingController());
              switch (i) {
                case 0:
                  priceBase = 10000;
                  break;
                case 1:
                  priceBase = 50000;
                  break;
                case 2:
                  priceBase = 200000;
                  break;
                case 3:
                  priceBase = 500000;
                  break;
                case 4:
                  priceBase = 1500000;
                  break;
                case 5:
                  priceBase = 4500000;
                  break;
                case 6:
                  priceBase = 9500000;
                  break;
                case 7:
                  priceBase = 21000000;
                  break;
                default:
                  priceBase = 0;
                  break;
              }
              totalAmount += priceBase;
              double prize =
                  getPrizeAdvance(lineA, priceBase.toInt(), groupvalue);

              drawSeleted.add(FeedBodyViewModel(
                  isSelected: i < totalSelectedDefault ? true : false,
                  numberDraw: i + 1,
                  price: priceBase,
                  prize: prize,
                  totalAmount: totalAmount,
                  profit: prize - totalAmount));
            }
            break;
          case Common.LON:
          case Common.HOA_LN:
          case Common.NHO:
            if (totalRow > 10) {
              totalRow = 10;
            }
            for (int i = 0; i < totalRow; i++) {
              pricesController.add(TextEditingController());
              switch (i) {
                case 0:
                  priceBase = 10000;
                  break;
                case 1:
                  priceBase = 20000;
                  break;
                case 2:
                  priceBase = 50000;
                  break;
                case 3:
                  priceBase = 100000;
                  break;
                case 4:
                  priceBase = 200000;
                  break;
                case 5:
                  priceBase = 500000;
                  break;
                case 6:
                  priceBase = 1000000;
                  break;
                case 7:
                  priceBase = 2500000;
                  break;
                case 8:
                  priceBase = 6000000;
                  break;
                case 9:
                  priceBase = 9000000;
                  break;
                default:
                  priceBase = 0;
                  break;
              }
              totalAmount += priceBase;
              double prize =
                  getPrizeAdvance(lineA, priceBase.toInt(), groupvalue);

              drawSeleted.add(FeedBodyViewModel(
                  isSelected: i < totalSelectedDefault ? true : false,
                  numberDraw: i + 1,
                  price: priceBase,
                  prize: prize,
                  totalAmount: totalAmount,
                  profit: prize - totalAmount));
            }
            break;
          case Common.CHAN:
          case Common.LE:
            for (int i = 0; i < totalRow; i++) {
              pricesController.add(TextEditingController());
              switch (i) {
                case 0:
                  priceBase = 10000;
                  break;
                case 1:
                  priceBase = 10000;
                  break;
                case 2:
                  priceBase = 20000;
                  break;
                case 3:
                  priceBase = 20000;
                  break;
                case 4:
                  priceBase = 50000;
                  break;
                case 5:
                  priceBase = 100000;
                  break;
                case 6:
                  priceBase = 200000;
                  break;
                case 7:
                  priceBase = 500000;
                  break;
                case 8:
                  priceBase = 1000000;
                  break;
                case 9:
                  priceBase = 2000000;
                  break;
                case 10:
                  priceBase = 2000000;
                  break;
                case 11:
                  priceBase = 3000000;
                  break;
                case 12:
                  priceBase = 4000000;
                  break;
                case 13:
                  priceBase = 6000000;
                  break;
                case 14:
                  priceBase = 9000000;
                  break;
                default:
                  priceBase = 0;
                  break;
              }
              totalAmount += priceBase;
              double prize =
                  getPrizeAdvance(lineA, priceBase.toInt(), groupvalue);

              drawSeleted.add(FeedBodyViewModel(
                  isSelected: i < totalSelectedDefault ? true : false,
                  numberDraw: i + 1,
                  price: priceBase,
                  prize: prize,
                  totalAmount: totalAmount,
                  profit: prize - totalAmount));
            }
            break;
        }

        calculator();
      }
    } else {
      if (drawKenoResponses != null && drawKenoResponses!.isNotEmpty) {
        drawSeleted.clear();
        pricesController.clear();
        totalRow =
            drawKenoResponses!.length > 30 ? 30 : drawKenoResponses!.length;
        totalSelectedDefault =
            drawKenoResponses!.length > 15 ? 15 : drawKenoResponses!.length;
        for (int i = 0; i < totalRow; i++) {
          pricesController.add(TextEditingController());

          drawSeleted.add(FeedBodyViewModel(
              isSelected: false,
              numberDraw: i + 1,
              price: 0,
              prize: 0,
              totalAmount: 0,
              profit: 0));
        }
      }
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void calculator() {
    List<FeedBodyViewModel> datas =
        drawSeleted.where((element) => element.isSelected!).toList();

    if (datas.isNotEmpty) {
      drafAmount = datas[datas.length - 1].totalAmount!.toInt();
    }

    setState(() {});
  }

  Future<ResponseObject> getFee(int productID) async {
    GetFeeRequest feeRequest =
        GetFeeRequest(amount: drafAmount, productID: productID);
    return await _conPay.getFee(feeRequest);
  }

  void selectedBall(SelectItemModel selected) {
    if (selected.isSelected!) {
      setState(() {
        lineA = selected.value!;
      });
    }
    initData();
    calculator();
  }

  void onChangeType(v) {
    groupvalue = v.toString();
    if (v == "1") {
      lineA = Common.CHAN;
    } else {
      lineA = Common.LON;
    }
    initData();
    calculator();
  }

  next() async {
    List<FeedBodyViewModel> datas =
        drawSeleted.where((element) => element.isSelected!).toList();

    if (datas.isEmpty || drafAmount == 0) {
      if (mounted) {
        showMessage(context, "Thông tin dự thưởng không hợp lệ", "01");
        return;
      }
    }

    if (playerProfile!.name == null || playerProfile!.pIDNumber == null) {
      if (mounted) {
        dialogBuilderUpdateInfo(context, "Thông báo",
            "Vui lòng cập nhật thông tin cá nhân trước khi đặt vé");
        return;
      }
    }
    for (int i = 0; i < datas.length; i++) {
      int price = datas[i].price!.toInt();
      if (price < 10 || price % 10 != 0) {
        if (mounted) {
          showMessage(context,
              "Tiền đặt của 1 kỳ tối thiểu là 10k và chia hết cho 10k.", "01");
          return;
        }
      }
    }
    if (mounted) {
      showProcess(context);
    }
    ResponseObject res = await _con.getDrawKeno();
    if (res.code == "00") {
      GetDrawKenoResponse dr =
          GetDrawKenoResponse.fromJson(jsonDecode(res.data!));
      if (int.parse(drawKenoResponse!.drawCode!) < int.parse(dr.drawCode!)) {
        if (mounted) {
          Navigator.of(context).pop();
          showMessage(
              context, "Kỳ bắt đầu đã quá kỳ mua, vui lòng chọn lại!", "01");
        }
        return;
      }
    } else {
      if (mounted) {
        Navigator.of(context).pop();
        showMessage(context, "Không có thông tin kỳ quay thưởng", "01");
        return;
      }
    }
    final DateTime now = DateTime.now();
    final DateFormat formatterDrawDate = DateFormat('dd/MM/yyyy');

    OrderListAddNewRequest req = OrderListAddNewRequest();
    req.quantity = datas.length;
    req.mobileNumber = playerProfile!.mobileNumber;
    req.fullName = playerProfile!.name;
    req.isCancel = iscancel ? "Y" : "N";
    req.type = spot;
    req.fee = 0;
    req.price = drafAmount;
    req.amount = drafAmount;

    int drawCode = int.parse(drawKenoResponse!.drawCode!);
    List<OrderAddNewRequest> orders = [];
    for (int i = 0; i < datas.length; i++) {
      List<OrderAddItemRequest> items = [];
      OrderAddItemRequest item = OrderAddItemRequest();
      item.productTypeID = 5;
      item.productID = Common.ID_KENO;
      item.drawCode = drawCode.toString().padLeft(7, '0');
      item.drawDate = formatterDrawDate.format(now);

      //datas.sort((a, b) => b.price!.compareTo(a.price!));

      List<int> newPrice = [];
      List<int> basePrices = listPriceKeno();
      basePrices.sort((a, b) => b.compareTo(a));

      int price = datas[i].price!.toInt();
      for (int i = 0; i < basePrices.length; i++) {
        int basePrice = basePrices[i];
        int phannguyen = price ~/ basePrice;
        int phanndu = price % basePrice;
        if (phannguyen >= 1) {
          for (int j = 0; j < phannguyen; j++) {
            newPrice.add(basePrice);
          }
          price = phanndu;
          if (price == 0) break;
        }
      }
      // newPrice.sort((a, b) => a.compareTo(b));

      int countLine = 0;
      int priceItem = 0;
      for (int i = 0; i < newPrice.length; i++) {
        countLine++;
        switch (countLine) {
          case 1:
            item.lineA = lineA;
            item.priceA = newPrice[i];
            priceItem += newPrice[i];
            break;
          case 2:
            item.lineB = lineA;
            item.priceB = newPrice[i];
            priceItem += newPrice[i];
            break;
          case 3:
            item.lineC = lineA;
            item.priceC = newPrice[i];
            priceItem += newPrice[i];
            break;
          case 4:
            item.lineD = lineA;
            item.priceD = newPrice[i];
            priceItem += newPrice[i];
            break;
          case 5:
            item.lineE = lineA;
            item.priceE = newPrice[i];
            priceItem += newPrice[i];
            break;
          case 6:
            item.lineF = lineA;
            item.priceF = newPrice[i];
            priceItem += newPrice[i];
            break;
        }

        if (countLine == 6 ||
            countLine == newPrice.length ||
            i == newPrice.length - 1) {
          item.price = priceItem;
          items.add(item);

          if (i != newPrice.length - 1) {
            item = OrderAddItemRequest();

            item.productTypeID = 5;
            item.productID = Common.ID_KENO;
            item.drawCode = drawCode.toString().padLeft(7, '0');
            item.drawDate = formatterDrawDate.format(now);

            countLine = 0;
            priceItem = 0;
          }
        }
      }
      drawCode++;
      OrderAddNewRequest order = OrderAddNewRequest();
      order.price = items.fold(0, (sum, item) => sum! + item.price!);
      order.productID = Common.ID_KENO;
      order.quantity = items.length;
      order.mobileNumber = playerProfile!.mobileNumber;
      order.fullName = playerProfile!.name;
      order.pIDNumber = playerProfile!.pIDNumber;
      order.emailAddress = playerProfile!.emailAddress;
      order.amount = items.fold(0, (sum, item) => sum! + item.price!);
      order.fee = 0;
      order.channel = Common.CHANNEL;
      order.desc = "Đặt vé nuôi Keno";
      order.bagBalls = lineA;
      order.productTypeID = 5;
      order.terminalID = playerProfile!.terminalID!;
      order.items = items;
      orders.add(order);
    }
    req.orders = orders;
    res = await _conPay.paymentList(req);
    if (res.code == "00") {
      if (context.mounted) {
        Navigator.pop(context);
        OrderAddNewRequest order = OrderAddNewRequest();
        order.price = drafAmount;
        order.productID = Common.ID_KENO;
        order.mobileNumber = playerProfile!.mobileNumber;
        order.fullName = playerProfile!.name;
        order.pIDNumber = playerProfile!.pIDNumber;
        order.emailAddress = playerProfile!.emailAddress;
        order.amount = drafAmount;
        order.fee = 0;
        dialogPayment(context, playerProfile!, order,
            jsonDecode(res.data!)["Code"], _prefs);
      }
    } else {
      if (context.mounted) {
        Navigator.pop(context);
        showMessage(context, res.message!, "98");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLot.ColorPrimary,
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        title: const Text("Nuôi Keno Chẵn Lẻ"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          InkWell(
            onTap: () {
              Future.delayed(Duration.zero, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const TicketKenoFeedHistoryView()));
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 4),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(4)),
              child: const Text(
                "Lịch sử nuôi Keno",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
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
                            height: 12,
                          ),
                          buildHead(),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    iscancel = !iscancel;
                                  });
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      child: Checkbox(
                                        value: iscancel,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            iscancel = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Tự động hủy các vé còn lại sau khi trúng thưởng",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                  onTap: dialogNotifyCancel,
                                  child: Icon(Ionicons.help_circle_outline,
                                      color: ColorLot.ColorPrimary))
                            ],
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: <BoxShadow>[boxShadow()],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.only(bottom: 6),
                              alignment: AlignmentDirectional.center,
                              child: Column(
                                children: [buildOptionType(), buildLine()],
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              border: TableBorder.all(
                                  width: 1,
                                  color: Colors.black12,
                                  style: BorderStyle.solid),
                              columnWidths: const <int, TableColumnWidth>{
                                0: FixedColumnWidth(40),
                                1: FixedColumnWidth(46),
                              },
                              children: buildRowKeno())
                        ],
                      )))),
          Container(
              alignment: Alignment.center,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[boxShadow()],
                borderRadius: const BorderRadius.all(
                  Radius.circular(Dimen.radiusBorder),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(Dimen.padingDefault),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tạm tính"),
                          Text(formatAmountD(drafAmount),
                              style: TextStyle(
                                  color: ColorLot.ColorPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))
                        ]),
                    buildPayment()
                  ],
                ),
              )),
        ],
      ),
    );
  }

  List<TableRow> buildRowKeno() {
    if (drawKenoResponses != null) {
      // List<TextEditingController> _controllers = [];
      List<TableRow> rows = [
        TableRow(
          decoration: BoxDecoration(
              color: ColorLot.ColorPrimary,
              border: Border.all(
                  color: Colors.red, width: 1, style: BorderStyle.solid)),
          children: [
            TextHead("Chọn"),
            TextHead("Số kỳ"),
            TextHead("Tiền đặt"),
            TextHead("Tổng tiền"),
            TextHead("Trúng"),
            TextHead("Lãi")
          ],
        )
      ];
      int idx = 0;
      rows.addAll(drawSeleted.map((e) {
        idx++;
        if (spot == 1) {
          pricesController[idx - 1].text = convertIntToString1(e.price!);
        }
        return TableRow(children: [
          SizedBox(
            width: 20,
            height: 30,
            child: Checkbox(
                value: e.isSelected,
                onChanged: (bool? value) {
                  for (int i = 0; i < drawSeleted.length; i++) {
                    if (drawSeleted[i].numberDraw! > e.numberDraw!) {
                      drawSeleted[i].isSelected = false;
                    } else {
                      drawSeleted[i].isSelected = true;
                    }
                  }
                  calculator();
                }),
          ),
          TextBody("${e.numberDraw} kỳ"),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 60,
                padding: EdgeInsets.all(2),
                child: TextFormField(
                  controller: pricesController[idx - 1],
                  onChanged: (string) {
                    string = (string != ''
                        ? formatAmount(int.parse(string.replaceAll(',', '')))
                        : '');
                    // pricesController[idx].value = TextEditingValue(
                    //   text: string,
                    //   selection: TextSelection.collapsed(offset: string.length),
                    // );
                    if (string.isNotEmpty) {
                      int price = int.parse(string.replaceAll(',', ''));
                      int amount = 0;
                      if (price >= 10 && price % 10 == 0) {
                        if (e.numberDraw! > 1) {
                          for (var i = e.numberDraw! - 1; i > 0; i--) {
                            amount = drawSeleted[i - 1].totalAmount!.toInt();
                            if (amount > 0) {
                              amount = (amount ~/ 1000) + price;
                              break;
                            }
                          }
                        } else {
                          amount = price;
                        }
                        e.price = price.toDouble() * 1000;
                        e.totalAmount = amount.toDouble() * 1000;
                        e.prize =
                            getPrizeAdvance(lineA, price * 1000, groupvalue);
                        e.profit = e.prize! - e.totalAmount!;
                        drafAmount = e.totalAmount!.toInt();

                        if (e.numberDraw! <= drawSeleted.length) {
                          for (var i = e.numberDraw!;
                              i < drawSeleted.length;
                              i++) {
                            int _price = drawSeleted[i].price!.toInt() ~/ 1000;
                            int _amount = 0;
                            if (_price > 0 && drawSeleted[i].isSelected!) {
                              for (var ii = i; ii > 0; ii--) {
                                int idxa = ii - 1;
                                _amount =
                                    drawSeleted[idxa].totalAmount!.toInt();
                                if (_amount > 0) {
                                  _amount = (_amount ~/ 1000) + _price;
                                  break;
                                }
                              }
                              drafAmount = _amount * 1000;
                              drawSeleted[i].totalAmount =
                                  _amount.toDouble() * 1000;
                              drawSeleted[i].prize =
                                  getPrizeAdvance(lineA, _price, groupvalue);
                              drawSeleted[i].profit = drawSeleted[i].prize! -
                                  drawSeleted[i].totalAmount!;
                            }
                          }
                        }

                        setState(() {});
                      } else {
                        e.price = amount.toDouble() * 1000;
                        e.totalAmount = 0;
                        e.prize = 0;
                        e.profit = 0;
                        setState(() {});
                      }
                      calculator();
                    }
                  },
                  readOnly: spot == 1 || e.isSelected == false ? true : false,
                  style: TextStyle(fontSize: Dimen.fontSizeDefault),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    isDense: true,
                    contentPadding: EdgeInsets.all(2),
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: ColorLot.ColorPrimary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: ColorLot.ColorPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
                child: TextBody("k"),
              )
            ],
          ),
          TextBody(convertIntToString(e.totalAmount!)),
          TextBody(convertIntToString(e.prize!)),
          TextBody(convertIntToString(e.profit!))
        ]);
      }).toList());

      return rows;
    }
    return [
      TableRow(
        decoration: BoxDecoration(
            color: ColorLot.ColorPrimary,
            border: Border.all(
                color: Colors.red, width: 1, style: BorderStyle.solid)),
        children: [
          TextHead("Chọn"),
          TextHead("Số kỳ"),
          TextHead("Tiền đặt"),
          TextHead("Tổng tiền"),
          TextHead("Trúng"),
          TextHead("Lãi")
        ],
      ),
    ];
  }

  Widget TextHead(String text) {
    return Padding(
        padding: EdgeInsets.all(1),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Colors.white, fontSize: Dimen.fontSizeDefault),
        ));
  }

  Widget TextBody(String text) {
    return Padding(
        padding: EdgeInsets.all(2),
        child: Text(
          text,
          textAlign: TextAlign.right,
          style:
              TextStyle(color: Colors.black87, fontSize: Dimen.fontSizeDefault),
        ));
  }

  Widget buildLine() {
    if (groupvalue == "1") {
      return LineView(selectedBall: selectedBall, line: "A");
    } else {
      return LineView1(selectedBall: selectedBall, line: "A");
    }
  }

  Widget buildOptionType() {
    var size = MediaQuery.of(context).size;
    var item = (size.width - 36) / 2;
    return Row(
      children: [
        SizedBox(
            width: item,
            child: RadioListTile(
              title: Text("Nuôi Chẵn Lẻ"),
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
              value: "1",
              dense: false,
              groupValue: groupvalue,
              onChanged: (value) {
                onChangeType(value);
              },
            )),
        SizedBox(
          width: item,
          child: RadioListTile(
              title: Text("Nuôi Lớn Nhỏ"),
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
              value: "2",
              dense: false,
              groupValue: groupvalue,
              onChanged: (value) {
                onChangeType(value);
              }),
        ),
      ],
    );
  }

  dialogNotifyCancel() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: ColorLot.ColorBackground,
          surfaceTintColor: Colors.transparent,
          titlePadding: EdgeInsets.all(10),
          contentPadding: EdgeInsets.all(10),
          actionsPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(
            "Cơ chế hủy vé tự động",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
                "- Trong trường hợp Quý khách lựa chọn cơ chế ${"\"Tự động hủy các vé còn lại sau khi trúng thưởng\""}, thì ngay khi vé của Quý khách trúng thưởng, thì vé đặt ở các kì tiếp theo sẽ được hủy và hoàn trả lại tiền cho Quý khách."),
            Text(
                "- Trường hợp ngược lại, Quý khách không chọn cơ chế này, thì trong trường hợp vé của Quý khách trúng thưởng, các vé ở các kì tiếp theo vẫn được tiếp tục đặt in cho đến hết số kì mà Quý khách đặt nuôi.")
          ]),
          actions: <Widget>[
            InkWell(
              onTap: () => {Navigator.pop(context)},
              child: Container(
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimen.radiusBorder)),
                    border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
                child: Text(
                  "Đóng",
                  style: TextStyle(color: ColorLot.ColorPrimary),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget buildPayment() {
    if (mode != Common.ANDROID_MODE_UPLOAD ||
        playerProfile!.mobileNumber == Common.MOBILE_OFF) {
      return SizedBox.shrink();
    } else {
      return Row(
        children: [
          Expanded(
              child: OutlinedButton(
            onPressed: next,
            style: OutlinedButton.styleFrom(
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
      );
    }
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
              "Chiến lược",
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
                          contentHeight: 100,
                          productID: Common.ID_KENO_TYPE_SPOT,
                          title: "Chiến lược",
                          value: spot.toString(),
                          callback: (value) {
                            setState(() {
                              spot = int.parse(value);
                            });
                            drawSeleted.clear();
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
                          child: Text(
                              spot == 1 ? "Hệ thống tự chọn" : "Tự đặt nuôi",
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
          width: 5,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chọn kỳ bắt đầu",
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
                        return DialogSelectedDraw(
                            title: "Chọn kỳ bắt đầu",
                            draws: drawKenoResponses ?? [],
                            callback: (value) {
                              GetDrawKenoResponse draw = GetDrawKenoResponse();
                              draw.drawCode = value.toString().split('-')[0];
                              draw.drawDate = value.toString().split('-')[1];
                              setState(() {
                                drawKenoResponse = draw;
                              });
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
                        Text(
                            drawKenoResponse != null
                                ? "#${drawKenoResponse!.drawCode}"
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
                    )),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class LineView extends StatefulWidget {
  const LineView({super.key, required this.line, required this.selectedBall});

  final String line;
  final Function selectedBall;

  @override
  State<LineView> createState() => _LineView();
}

class _LineView extends State<LineView> {
  List<SelectItemModel> listChanLe = [];

  @override
  void initState() {
    super.initState();

    listChanLe.add(
        SelectItemModel(text: "Chẵn", value: Common.CHAN, isSelected: true));
    listChanLe.add(
        SelectItemModel(text: "Hòa", value: Common.HOA, isSelected: false));
    listChanLe
        .add(SelectItemModel(text: "Lẻ", value: Common.LE, isSelected: false));
    listChanLe.add(SelectItemModel(
        text: "Chẵn 11-12", value: Common.C1112, isSelected: false));
    listChanLe.add(SelectItemModel(
        text: "Lẻ 11-12", value: Common.L1112, isSelected: false));
  }

  Widget ball(text, Color bgColor, Color colorText) {
    return Container(
      height: Dimen.sizeBall - 2,
      padding: EdgeInsets.symmetric(horizontal: 6),
      constraints: BoxConstraints(
        minWidth: 60,
      ),
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
      child: Center(
        child: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 15, color: colorText)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: listChanLe.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: () {
                  setState(() {
                    item.isSelected = !item.isSelected!;
                    for (int i = 0; i < listChanLe.length; i++) {
                      if (item.value != listChanLe[i].value) {
                        listChanLe[i].isSelected = false;
                      }
                    }
                    widget.selectedBall(item);
                  });
                },
                child: !item.isSelected!
                    ? ball(item.text, Colors.white, Colors.black)
                    : ball(item.text, ColorLot.ColorPrimary, Colors.white))
          ],
        );
      }).toList(),
    );
  }
}

class LineView1 extends StatefulWidget {
  const LineView1({super.key, required this.line, required this.selectedBall});

  final String line;
  final Function selectedBall;

  @override
  State<LineView1> createState() => _LineView1();
}

class _LineView1 extends State<LineView1> {
  StateSetter? _setState;
  List<SelectItemModel> listChanLe = [];

  onTapBall(value, type) {}

  @override
  void initState() {
    super.initState();

    listChanLe
        .add(SelectItemModel(text: "Lớn", value: Common.LON, isSelected: true));
    listChanLe.add(
        SelectItemModel(text: "Hòa", value: Common.HOA_LN, isSelected: false));
    listChanLe.add(
        SelectItemModel(text: "Nhỏ", value: Common.NHO, isSelected: false));
  }

  Widget ball(text, Color bgColor, Color colorText) {
    return Container(
      height: Dimen.sizeBall - 2,
      padding: EdgeInsets.symmetric(horizontal: 6),
      constraints: BoxConstraints(
        minWidth: 60,
      ),
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
      child: Center(
        child: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 15, color: colorText)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: listChanLe.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: () {
                  setState(() {
                    item.isSelected = !item.isSelected!;
                    for (int i = 0; i < listChanLe.length; i++) {
                      if (item.value != listChanLe[i].value) {
                        listChanLe[i].isSelected = false;
                      }
                    }
                    widget.selectedBall(item);
                  });
                },
                child: !item.isSelected!
                    ? ball(item.text, Colors.white, Colors.black)
                    : ball(item.text, ColorLot.ColorPrimary, Colors.white))
          ],
        );
      }).toList(),
    );
  }
}
