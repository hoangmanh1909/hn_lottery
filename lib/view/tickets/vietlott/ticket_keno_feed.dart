// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, sort_child_properties_last

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/constants/common.dart';
import 'package:lottery_flutter_application/controller/dictionary_controller.dart';
import 'package:lottery_flutter_application/controller/payment_controller.dart';
import 'package:lottery_flutter_application/models/request/order_add_request.dart';
import 'package:lottery_flutter_application/models/request/order_item_add_request.dart';
import 'package:lottery_flutter_application/models/request/order_list_add_request.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dialog_selected_draw.dart';
import 'package:lottery_flutter_application/utils/dialog_selected_radio.dart';
import 'package:lottery_flutter_application/utils/dialog_update_info_player.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/utils/head_balance_view.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_keno_feed_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/account_controller.dart';
import '../../../models/feedbody_view_model.dart';
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
import '../../../utils/scaffold_messger.dart';
import '../../../utils/widget_divider.dart';

class TicketKenoFeedView extends StatefulWidget {
  const TicketKenoFeedView({Key? key}) : super(key: key);

  @override
  State<TicketKenoFeedView> createState() => _TicketKenoFeedViewState();
}

class _TicketKenoFeedViewState extends State<TicketKenoFeedView>
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
  List<int>? listAmount = [10000, 20000, 50000, 100000, 200000, 500000];
  List<String>? listBall;
  List<String>? listBallA;
  int amountA = 10000;
  int system = 5;
  int drafAmount = 0;
  bool iscancel = false;
  int spot = 1;
  int totalRow = 30;
  int totalSelectedDefault = 15;
  String mode = "ON";
  List<TextEditingController> pricesController = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
    });
    listBall = List<String>.generate(system, (index) => "");
    listBallA = List<String>.generate(system, (index) => "");
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
    await getDrawKenoByDay();
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
    if (mounted) {
      showProcess(context);
    }
    listBall = List<String>.generate(system, (index) => "");
    listBallA = List<String>.generate(system, (index) => "");
    if (spot == 1) {
      if (drawKenoResponses != null && drawKenoResponses!.isNotEmpty) {
        drawSeleted.clear();
        pricesController.clear();
        totalRow = drawKenoResponses!.length;
        totalSelectedDefault =
            drawKenoResponses!.length > 15 ? 15 : drawKenoResponses!.length;
        if (system == 1 && totalRow > 10) {
          totalRow = 10;
          totalSelectedDefault = 10;
        }
        if (system < 5 && drawKenoResponses!.length > 30) {
          totalRow = 30;
        }
        double totalAmount = 0;
        for (int i = 0; i < totalRow; i++) {
          pricesController.add(TextEditingController());
          double priceBase = getPriceBase(i);
          totalAmount += priceBase;
          double prize = 0;
          switch (system) {
            case 1:
              prize = priceBase / 10000 * 20000;
              break;
            case 2:
              prize = priceBase / 10000 * 90000;
              break;
            case 3:
              prize = priceBase / 10000 * 200000;
              break;
            case 4:
              prize = priceBase / 10000 * 400000;
              break;
            case 5:
              prize = priceBase / 10000 * 4400000;
              break;
            case 6:
              prize = priceBase / 10000 * 12000000;
              break;
            case 7:
              prize = priceBase / 10000 * 40000000;
              break;
            case 8:
              prize = priceBase / 10000 * 200000000;
              break;
            case 9:
              prize = priceBase / 10000 * 800000000;
              break;
            case 10:
              prize = priceBase / 10000 * 2000000000;
              break;
          }
          drawSeleted.add(FeedBodyViewModel(
              isSelected: i < totalSelectedDefault ? true : false,
              numberDraw: i + 1,
              price: priceBase,
              prize: prize,
              totalAmount: totalAmount,
              profit: prize - totalAmount));
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
          switch (system) {
            case 1:
              break;
            case 2:
              break;
            case 3:
              break;
            case 4:
              break;
            case 5:
              break;
            case 6:
              break;
            case 7:
              break;
            case 8:
              break;
            case 9:
              break;
            case 10:
              break;
          }
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

  getPriceBase(i) {
    double priceBase = double.parse(amountA.toString());
    int playType = system;
    if (playType != 1) {
      if (playType == 2) {
        if (i > 4) {
          switch (i) {
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
              priceBase = 20000;
              break;
            case 10:
            case 11:
            case 12:
              priceBase = 50000;
              break;
            case 13:
            case 14:
            case 15:
              priceBase = 100000;
              break;
            case 16:
            case 17:
            case 18:
            case 19:
              priceBase = 200000;
              break;
            case 20:
            case 21:
            case 22:
              priceBase = 500000;
              break;
            case 23:
            case 24:
              priceBase = 1000000;
              break;
            case 25:
            case 26:
              priceBase = 1500000;
              break;
            case 27:
            case 28:
              priceBase = 2000000;
              break;
            case 29:
              priceBase = 2500000;
              break;
            default:
              priceBase = 0;
              break;
          }
        }
      } else if (playType == 3) {
        if (i > 9) {
          switch (i) {
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
              priceBase = 20000;
              break;
            case 20:
            case 21:
            case 22:
            case 23:
            case 24:
              priceBase = 50000;
              break;
            case 25:
            case 26:
            case 27:
            case 28:
            case 29:
              priceBase = 100000;
              break;

            default:
              priceBase = 0;
              break;
          }
        }
      } else if (playType == 4) {
        if (i > 9) {
          switch (i) {
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
              priceBase = 20000;
              break;
            case 20:
            case 21:
            case 22:
            case 23:
            case 24:
            case 25:
            case 26:
            case 27:
            case 28:
            case 29:
              priceBase = 50000;
              break;

            default:
              priceBase = 0;
              break;
          }
        }
      }
    } else {
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
          priceBase = 2000000;
          break;
        case 8:
          priceBase = 5000000;
          break;
        case 9:
          priceBase = 12000000;
          break;
        default:
          priceBase = 0;
          break;
      }
    }
    return priceBase;
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
    setState(() {
      listBallA = _listBall;
    });
    calculator();
  }

  selectAmount(int index, String line) {
    amountA = listAmount![index];

    Navigator.pop(context);
    initData();
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
    setState(() {
      listBallA = List<String>.generate(system, (index) => "");
    });
    calculator();
  }

  calculator() {
    List<FeedBodyViewModel> datas =
        drawSeleted.where((element) => element.isSelected!).toList();

    if (datas.isNotEmpty) {
      drafAmount = datas[datas.length - 1].totalAmount!.toInt();
    }

    setState(() {});
  }

  selectedBall(String line, List<String> _balls) {
    _balls.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    setState(() {
      listBallA = _balls;
    });
    calculator();
  }

  Future<ResponseObject> getFee(int productID) async {
    GetFeeRequest feeRequest =
        GetFeeRequest(amount: drafAmount, productID: productID);
    return await _conPay.getFee(feeRequest);
  }

  next() async {
    List<FeedBodyViewModel> datas =
        drawSeleted.where((element) => element.isSelected!).toList();

    if (datas.isEmpty || drafAmount == 0 || listBallA![0] == "") {
      if (mounted) {
        showMessage(
            context, "Bạn chưa chọn bộ số hoặc số tiền dự thưởng", "01");
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
    // if (res.code == "00") {
    //   GetDrawKenoResponse dr =
    //       GetDrawKenoResponse.fromJson(jsonDecode(res.data!));
    //   if (int.parse(drawKenoResponse!.drawCode!) < int.parse(dr.drawCode!)) {
    //     if (mounted) {
    //       Navigator.of(context).pop();
    //       showMessage(
    //           context, "Kỳ bắt đầu đã quá kỳ mua, vui lòng chọn lại!", "01");
    //     }
    //     return;
    //   }
    // } else {
    //   if (mounted) {
    //     Navigator.of(context).pop();
    //     showMessage(context, "Không có thông tin kỳ quay thưởng", "01");
    //     return;
    //   }
    // }
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
      item.productTypeID = 4;
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
            item.lineA = listBallA!.join(",");
            item.priceA = newPrice[i];
            item.systemA = system;
            priceItem += newPrice[i];
            break;
          case 2:
            item.lineB = listBallA!.join(",");
            item.priceB = newPrice[i];
            item.systemB = system;
            priceItem += newPrice[i];
            break;
          case 3:
            item.lineC = listBallA!.join(",");
            item.priceC = newPrice[i];
            item.systemC = system;
            priceItem += newPrice[i];
            break;
          case 4:
            item.lineD = listBallA!.join(",");
            item.priceD = newPrice[i];
            item.systemD = system;
            priceItem += newPrice[i];
            break;
          case 5:
            item.lineE = listBallA!.join(",");
            item.priceE = newPrice[i];
            item.systemE = system;
            priceItem += newPrice[i];
            break;
          case 6:
            item.lineF = listBallA!.join(",");
            item.priceF = newPrice[i];
            item.systemF = system;
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

            item.productTypeID = 4;
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
      order.bagBalls = listBallA!.join(",");
      order.productTypeID = 4;
      order.terminalID = playerProfile!.terminalID!;
      order.items = items;
      orders.add(order);
    }
    req.orders = orders;
    res = await _conPay.paymentList(req);
    if (res.code == "00") {
      if (mounted) {
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
      if (mounted) {
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
        title: Text("Nuôi Keno"),
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
              child: Text(
                "Lịch sử nuôi Keno",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
          // IconButton(
          //   icon: const Icon(
          //     Ionicons.time_outline,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     Future.delayed(Duration.zero, () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) =>
          //                   const TicketKenoFeedHistoryView()));
          //     });
          //   },
          // )
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
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            alignment: AlignmentDirectional.center,
                            child: Row(
                              children: [
                                Expanded(
                                    child: LineView(
                                        system: system,
                                        listBall: listBallA,
                                        selectedBall: selectedBall,
                                        line: "A")),
                                listBallA?[0] == ""
                                    ? tcBall(listBallA!, "A")
                                    : clearBall("A"),
                                SizedBox(
                                  width: 4,
                                ),
                                system > 4 && spot == 1
                                    ? OutlinedButton(
                                        onPressed: () => showAmount("A"),
                                        child: Text(
                                          formatAmount(amountA),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400),
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
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ),
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

  Widget buildPayment() {
    if (mode != Common.ANDROID_MODE_UPLOAD ||
        playerProfile!.mobileNumber == Common.MOBILE_OFF) {
      return SizedBox.shrink();
    } else {
      return Column(children: [
        SizedBox(
          height: 9,
        ),
        Row(
          children: [
            Expanded(
                child: OutlinedButton(
              onPressed: () {
                _clearBall("A");
              },
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  side: BorderSide(width: 1, color: ColorLot.ColorPrimary)),
              child: Text("Chọn lại",
                  style: TextStyle(color: ColorLot.ColorPrimary)),
            )),
            SizedBox(width: 8),
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
        ),
      ]);
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
                width: 50,
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
                        e.prize = getPrize(system, price);
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
                              drawSeleted[i].prize = getPrize(system, _price);
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
        padding: EdgeInsets.all(2),
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
      width: size.width - 80,
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
