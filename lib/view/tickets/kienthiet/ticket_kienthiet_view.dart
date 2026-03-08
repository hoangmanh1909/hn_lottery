// ignore_for_file: prefer_const_constructors, unused_field, sort_child_properties_last, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottery_flutter_application/config/api.dart';
import 'package:lottery_flutter_application/constants/common.dart';
import 'package:lottery_flutter_application/controller/account_controller.dart';
import 'package:lottery_flutter_application/controller/payment_controller.dart';
import 'package:lottery_flutter_application/controller/xskt_controller.dart';
import 'package:lottery_flutter_application/models/radio_model.dart';
import 'package:lottery_flutter_application/models/request/get_fee_request.dart';
import 'package:lottery_flutter_application/models/request/order_add_request.dart';
import 'package:lottery_flutter_application/models/request/order_item_add_request.dart';
import 'package:lottery_flutter_application/models/request/player_base_request.dart';
import 'package:lottery_flutter_application/models/request/xskt_base_request.dart';
import 'package:lottery_flutter_application/models/request/xskt_search_ticket_request.dart';
import 'package:lottery_flutter_application/models/response/get_balance_response.dart';
import 'package:lottery_flutter_application/models/response/player_profile.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/models/response/xskt_config_prize.dart';
import 'package:lottery_flutter_application/models/response/xskt_search_ticket_response.dart';
import 'package:lottery_flutter_application/models/select_item_list_model.dart';
import 'package:lottery_flutter_application/models/xskt_model.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/utils/dialog_payment.dart';
import 'package:lottery_flutter_application/utils/dialog_process.dart';
import 'package:lottery_flutter_application/utils/dialog_update_info_player.dart';
import 'package:lottery_flutter_application/utils/scaffold_messger.dart';
import 'package:lottery_flutter_application/utils/timer_app.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:lottery_flutter_application/view/payment_view.dart';
import 'package:lottery_flutter_application/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class XSKTBookView extends StatefulWidget {
  const XSKTBookView(
      {Key? key, required this.radioModel, required this.xsktModel})
      : super(key: key);
  final RadioModel radioModel;
  final XSKTModel xsktModel;
  @override
  State<XSKTBookView> createState() => _XSKTBookState();
}

class _XSKTBookState extends State<XSKTBookView> {
  final PaymentController conPay = PaymentController();
  final AccountController _conAcc = AccountController();

  XSKTController con = XSKTController();

  ConfigPrizeResponse? configPrize;
  List<XSKTTickeResponse> tickets = [];
  List<XSKTTickeResponse> tmpTickets = [];
  List<XSKTTickeResponse> tmpTicketsSelected = [];

  List<GetBalanceResponse>? balanceResponse;
  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;
  bool isSelectionMode = false;

  int draftAmount = 0;
  int totalSeleted = 0;
  StateSetter? _setState;
  SelectItemListModel? _symbol;
  var isSelectedAll = false;
  int price = 10000;
  int balance = 0;

  String mode = "ON";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initData();
    });
  }

  initData() async {
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
    await getBalance();
    await getAmountPrize();
    await getTicket();
    if (mounted) Navigator.pop(context);
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

  getAmountPrize() async {
    XSKTBaseRequest req = XSKTBaseRequest();
    req.iD = widget.radioModel.region;
    ResponseObject res = await con.getAmountPrize(req);

    if (res.code == "00") {
      configPrize = ConfigPrizeResponse.fromJson(jsonDecode(res.data!));
      price = configPrize!.price!;
      setState(() {});
    } else {
      if (context.mounted) showMessage(context, res.message!, "99");
    }
  }

  getTicket() async {
    XSKTSearchTicketRequest req = XSKTSearchTicketRequest();
    req.fromDrawDate = getByDateDDMMYYYY(widget.xsktModel.date!);
    req.toDrawDate = getByDateDDMMYYYY(widget.xsktModel.date!);
    req.status = "O";
    req.area = widget.radioModel.region;
    req.radioID = widget.radioModel.id;
    ResponseObject res = await con.searchTicket(req);

    if (res.code == "00") {
      tickets = List<XSKTTickeResponse>.from((jsonDecode(res.data!)
          .map((model) => XSKTTickeResponse.fromJson(model))));
      tickets =
          tickets.where((element) => element.remainingTicket! > 0).toList();
      tickets.sort((a, b) => a.type!.compareTo(b.type!));
      tmpTickets.addAll(tickets);
      setState(() {});
    }
  }

  onChangeSearchData(value) {
    setState(() {
      tickets = tmpTickets
          .where((element) => element.value!.contains(value))
          .toList();
    });
  }

  onSelectedTicket(XSKTTickeResponse ticketModel) {
    if (widget.radioModel.region! == 1) {
      if (tmpTicketsSelected.isNotEmpty) {
        var temp =
            tmpTicketsSelected.where((e) => e.value == ticketModel.value);
        if (temp.isNotEmpty) {
          tmpTicketsSelected.removeWhere((e) => e.value == ticketModel.value);
          setState(() {
            tmpTicketsSelected = tmpTicketsSelected;
            draftAmount = tmpTicketsSelected.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.total!) *
                price;
          });
        }
      }
      if (ticketModel.symbol != "") {
        if (tmpTicketsSelected.length < 6) {
          setState(() {
            tmpTicketsSelected.add(ticketModel);
            draftAmount = tmpTicketsSelected.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.total!) *
                price;
          });
        } else {
          showMessage(context, "Bạn đã chọn đủ 6 bộ số", "99");
        }
      }
      Navigator.of(context, rootNavigator: true).pop();
    } else if (widget.radioModel.region! == 2 || ticketModel.type == 2) {
      if (tmpTicketsSelected.isNotEmpty) {
        var temp =
            tmpTicketsSelected.where((e) => e.value == ticketModel.value);
        if (temp.isNotEmpty) {
          tmpTicketsSelected.removeWhere((e) => e.value == ticketModel.value);
          setState(() {
            tmpTicketsSelected = tmpTicketsSelected;
            draftAmount = tmpTicketsSelected.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.total!) *
                price;
          });
        } else {
          if (tmpTicketsSelected.length < 6) {
            setState(() {
              tmpTicketsSelected.add(ticketModel);
              draftAmount = tmpTicketsSelected.fold(
                      0,
                      (previousValue, element) =>
                          previousValue + element.total!) *
                  price;
            });
          } else {
            showMessage(context, "Bạn đã chọn đủ 6 bộ số", "99");
          }
        }
      } else {
        if (tmpTicketsSelected.length < 6) {
          setState(() {
            tmpTicketsSelected.add(ticketModel);
            draftAmount = tmpTicketsSelected.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.total!) *
                price;
          });
        } else {
          showMessage(context, "Bạn đã chọn đủ 6 bộ số", "99");
        }
      }
    } else {
      if (tmpTicketsSelected.isNotEmpty) {
        var temp =
            tmpTicketsSelected.where((e) => e.value == ticketModel.value);
        if (temp.isNotEmpty) {
          tmpTicketsSelected.removeWhere((e) => e.value == ticketModel.value);
          setState(() {
            tmpTicketsSelected = tmpTicketsSelected;
            draftAmount = tmpTicketsSelected.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.total!) *
                price;
          });
        }
      }
      if (ticketModel.total! > 0) {
        if (tmpTicketsSelected.length < 6) {
          setState(() {
            tmpTicketsSelected.add(ticketModel);
            draftAmount = tmpTicketsSelected.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.total!) *
                price;
          });
        } else {
          showMessage(context, "Bạn đã chọn đủ 6 bộ số", "99");
        }
      }
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  next() async {
    if (draftAmount == 0) {
      showMessage(context, "Bạn chưa chọn bộ số dự thưởng", "01");
      return;
    }
    if (playerProfile!.name == null || playerProfile!.pIDNumber == null) {
      if (mounted) {
        dialogBuilderUpdateInfo(context, "Thông báo",
            "Vui lòng cập nhật thông tin cá nhân trước khi đặt vé");
        return;
      }
    }

    OrderAddNewRequest order = OrderAddNewRequest();
    order.price = draftAmount;
    order.productID = widget.radioModel.productID;
    order.quantity = 1;
    order.mobileNumber = playerProfile!.mobileNumber;
    order.fullName = playerProfile!.name;
    order.pIDNumber = playerProfile!.pIDNumber;
    order.emailAddress = playerProfile!.emailAddress;
    order.amount = draftAmount;
    order.fee = 0;
    order.channel = Common.CHANNEL;
    order.desc = "Đặt vé";
    order.productTypeID = 1;
    order.radioID = widget.radioModel.id;

    List<OrderAddItemRequest> items = [];
    OrderAddItemRequest item = OrderAddItemRequest();
    item.productID = widget.radioModel.productID;
    item.drawDate = DateFormat("dd/MM/yyyy").format(widget.xsktModel.date!);
    item.price = 0;
    item.productTypeID = 1;

    for (int i = 0; i < tmpTicketsSelected.length; i++) {
      switch (i) {
        case 0:
          item.lineA = tmpTicketsSelected[i].value;
          item.systemA = tmpTicketsSelected[i].total!;
          item.priceA = tmpTicketsSelected[i].total! * price;
          item.price = tmpTicketsSelected[i].total! * price;
          if (tmpTicketsSelected[i].symbol != null &&
              tmpTicketsSelected[i].symbol!.isNotEmpty) {
            item.symbolA = tmpTicketsSelected[i].symbol!;
          } else {
            item.symbolA = tmpTicketsSelected[i].type!.toString();
          }
          item.drawlerA = tmpTicketsSelected[i].drawlerID!;
          break;
        case 1:
          item.lineB = tmpTicketsSelected[i].value;
          item.systemB = tmpTicketsSelected[i].total!;
          item.priceB = tmpTicketsSelected[i].total! * price;
          item.price = item.price! + (tmpTicketsSelected[i].total! * price);
          if (tmpTicketsSelected[i].symbol != null &&
              tmpTicketsSelected[i].symbol!.isNotEmpty) {
            item.symbolB = tmpTicketsSelected[i].symbol!;
          } else {
            item.symbolB = tmpTicketsSelected[i].type!.toString();
          }
          item.drawlerB = tmpTicketsSelected[i].drawlerID!;
          break;
        case 2:
          item.lineC = tmpTicketsSelected[i].value;
          item.systemC = tmpTicketsSelected[i].total!;
          item.priceC = tmpTicketsSelected[i].total! * price;
          item.price = item.price! + (tmpTicketsSelected[i].total! * price);
          if (tmpTicketsSelected[i].symbol != null &&
              tmpTicketsSelected[i].symbol!.isNotEmpty) {
            item.symbolC = tmpTicketsSelected[i].symbol!;
          } else {
            item.symbolC = tmpTicketsSelected[i].type!.toString();
          }
          item.drawlerC = tmpTicketsSelected[i].drawlerID!;
          break;
        case 3:
          item.lineD = tmpTicketsSelected[i].value;
          item.systemD = tmpTicketsSelected[i].total!;
          item.priceD = tmpTicketsSelected[i].total! * price;
          item.price = item.price! + (tmpTicketsSelected[i].total! * price);
          if (tmpTicketsSelected[i].symbol != null &&
              tmpTicketsSelected[i].symbol!.isNotEmpty) {
            item.symbolD = tmpTicketsSelected[i].symbol!;
          } else {
            item.symbolD = tmpTicketsSelected[i].type!.toString();
          }
          item.drawlerD = tmpTicketsSelected[i].drawlerID!;
          break;
        case 4:
          item.lineE = tmpTicketsSelected[i].value;
          item.systemE = tmpTicketsSelected[i].total!;
          item.priceE = tmpTicketsSelected[i].total! * price;
          item.price = item.price! + (tmpTicketsSelected[i].total! * price);
          if (tmpTicketsSelected[i].symbol != null &&
              tmpTicketsSelected[i].symbol!.isNotEmpty) {
            item.symbolE = tmpTicketsSelected[i].symbol!;
          } else {
            item.symbolE = tmpTicketsSelected[i].type!.toString();
          }
          item.drawlerE = tmpTicketsSelected[i].drawlerID!;
          break;
        case 5:
          item.lineF = tmpTicketsSelected[i].value;
          item.systemF = tmpTicketsSelected[i].total!;
          item.priceF = tmpTicketsSelected[i].total! * price;
          item.price = item.price! + (tmpTicketsSelected[i].total! * price);
          if (tmpTicketsSelected[i].symbol != null &&
              tmpTicketsSelected[i].symbol!.isNotEmpty) {
            item.symbolF = tmpTicketsSelected[i].symbol!;
          } else {
            item.symbolF = tmpTicketsSelected[i].type!.toString();
          }
          item.drawlerF = tmpTicketsSelected[i].drawlerID!;
          break;
      }
    }
    items.add(item);
    order.items = items;
    if (context.mounted) showProcess(context);
    ResponseObject res = await conPay.addOrder(order);

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
        GetFeeRequest(amount: draftAmount, productID: productID);
    return await conPay.getFee(feeRequest);
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
          title: const Text("Xổ số kiến thiết"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Scaffold(
            backgroundColor: ColorLot.ColorBackground,
            body: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(children: [
                  Container(
                      height: 115,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      margin: const EdgeInsets.only(top: 8),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 7),
                                child: Text(
                                  widget.xsktModel.lable!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontSize: 14),
                                ),
                              ),
                              Text(
                                DateFormat("dd/MM/yyyy")
                                    .format(widget.xsktModel.date!),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              TimerApp(
                                eventTime: getDayXSKT(widget.xsktModel.date!),
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  color: ColorLot.ColorPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                          Expanded(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Text(
                                  configPrize != null
                                      ? configPrize!.prize.toString()
                                      : "0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Text(
                                    "Tỷ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ])),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                Image(
                                  image: AssetImage(widget.radioModel.img!),
                                  width: 70,
                                  height: 70,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    widget.radioModel.name!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    margin: const EdgeInsets.only(top: 8),
                    child: TextField(
                      onChanged: (value) {
                        onChangeSearchData(value);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Tìm kiếm bộ số",
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: tickets.isNotEmpty
                              ? buildTicket()
                              : buildEmpty())),
                  Container(
                      height: 110,
                      margin: const EdgeInsets.only(top: 8, bottom: 44),
                      padding: EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Giá vé tạm tính"),
                                Text(formatAmountD(draftAmount),
                                    style: TextStyle(
                                        color: ColorLot.ColorPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    tmpTicketsSelected.clear();
                                    draftAmount = 0;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: ColorLot.ColorXSKT,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Text(
                                    "Chọn lại",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              )),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: InkWell(
                                onTap: next,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: ColorLot.ColorPrimary,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Text(
                                    "Đặt vé",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              )),
                            ],
                          )
                        ],
                      )),
                ]))));
  }

  Widget buildEmpty() {
    return Center(
      child: Text("Danh sách trống"),
    );
  }

  Widget buildTicket() {
    if (widget.radioModel.region! == 1) {
      return buildTicketRegion1();
    } else if (widget.radioModel.region! == 2) {
      return buildTicketRegion2();
    } else {
      return buildTicketRegion3();
    }
  }

  Widget buildTicketRegion3() {
    var size = MediaQuery.of(context).size.width * 0.3 - 8;
    return SingleChildScrollView(
      child: Wrap(
          alignment: WrapAlignment.center,
          children: tickets.map((item) {
            if (item.type == 2) {
              return buildSeletedRegion2(item);
            }
            return InkWell(
              onTap: () => item.type == 2
                  ? onSelectedTicket(item)
                  : showDialogTotal(item),
              child: Container(
                  width: size,
                  height: 36,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1,
                          style: BorderStyle.solid,
                          color: ColorLot.ColorPrimary),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  margin: const EdgeInsets.only(top: 8, left: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTotalSymbol(item),
                      Expanded(
                          child: Center(
                        child: Text(
                          item.value!,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      )),
                      SizedBox(
                        width: 20,
                        child: Text(
                          item.type == 2
                              ? "CN"
                              : item.remainingTicket!.toString(),
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )),
            );
          }).toList()),
    );
  }

  showDialogTotal(XSKTTickeResponse item) {
    List<int> totalTickets = [];
    totalSeleted = 0;
    for (int i = 1; i <= item.total!; i++) {
      totalTickets.add(i);
    }
    if (tmpTicketsSelected.isNotEmpty) {
      var ticketModels =
          tmpTicketsSelected.where((element) => element.value == item.value);
      if (ticketModels.isNotEmpty) {
        totalSeleted = ticketModels.first.total!;
      }
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: Text(
            "Chọn số lượng vé",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorLot.ColorPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          content: SizedBox(child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            _setState = setState;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bộ số: ",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      item.value!,
                      style: TextStyle(
                          color: ColorLot.ColorPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Image.network(
                  urlImage + item.images!,
                  width: 150,
                  height: 150,
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: totalTickets.map((item) {
                    return totalSeleted == item
                        ? buildTotalSelected(item)
                        : buildTotalNormal(item);
                  }).toList(),
                ),
              ],
            );
          })),
          actions: <Widget>[
            Row(
              children: [
                CustomButton(
                    label: "Đóng",
                    backgroundColor: ColorLot.ColorPrimary,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
                SizedBox(
                  width: 8,
                ),
                CustomButton(
                  label: "Đồng ý",
                  backgroundColor: ColorLot.ColorBaoChung,
                  onPressed: () {
                    XSKTTickeResponse ticketModel = XSKTTickeResponse();
                    ticketModel.value = item.value!;
                    ticketModel.total = totalSeleted;
                    ticketModel.type = item.type!;
                    ticketModel.drawlerID = item.drawlerID!;

                    onSelectedTicket(ticketModel);
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }

  Widget buildTotalNormal(item) {
    return InkWell(
      onTap: () => onTapBallTotal(item),
      child: Container(
        width: 40,
        height: 30,
        alignment: Alignment.center,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
        child: Text(item.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.0,
                color: Colors.black)),
      ),
    );
  }

  Widget buildTotalSelected(item) {
    return InkWell(
      onTap: () => onTapBallTotal(item),
      child: Container(
        width: 40,
        height: 30,
        alignment: Alignment.center,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: ColorLot.ColorPrimary,
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
        child: Text(item.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.0,
                color: Colors.white)),
      ),
    );
  }

  Widget buildTicketRegion2() {
    return SingleChildScrollView(
      child: Wrap(
          alignment: WrapAlignment.center,
          children: tickets.map((item) {
            return buildSeletedRegion2(item);
          }).toList()),
    );
  }

  Widget buildSeletedRegion2(XSKTTickeResponse item) {
    var size = MediaQuery.of(context).size.width * 0.3 - 8;
    var isSelected = false;
    if (tmpTicketsSelected.isNotEmpty) {
      var temps = tmpTicketsSelected
          .where((element) => element.value! == item.value!)
          .toList();
      if (temps.isNotEmpty) {
        isSelected = true;
      }
    }
    if (isSelected) {
      return InkWell(
        onTap: () => onSelectedTicket(item),
        child: Container(
            width: size,
            height: 36,
            decoration: BoxDecoration(
                color: ColorLot.ColorPrimary,
                border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: ColorLot.ColorPrimary),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            margin: const EdgeInsets.only(top: 8, left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 15,
                  child: SizedBox.shrink(),
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    item.value!,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                )),
                SizedBox(
                  width: 18,
                  child: Text(
                    item.type == 2 ? "CN" : item.remainingTicket!.toString(),
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                )
              ],
            )),
      );
    } else {
      return InkWell(
        onTap: () => onSelectedTicket(item),
        child: Container(
            width: size,
            height: 36,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: ColorLot.ColorPrimary),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            margin: const EdgeInsets.only(top: 8, left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 15,
                  child: SizedBox.shrink(),
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    item.value!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                )),
                SizedBox(
                  width: 18,
                  child: Text(
                    item.type == 2 ? "CN" : item.total!.toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                )
              ],
            )),
      );
    }
  }

  Widget buildTicketRegion1() {
    var size = MediaQuery.of(context).size.width * 0.3 - 8;
    return SingleChildScrollView(
      child: Wrap(
          alignment: WrapAlignment.center,
          children: tickets.map((item) {
            return InkWell(
              onTap: () => showDialogSymbol(item),
              child: Container(
                  width: size,
                  height: 36,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1,
                          style: BorderStyle.solid,
                          color: ColorLot.ColorPrimary),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  margin: const EdgeInsets.only(top: 8, left: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTotalSymbol(item),
                      Expanded(
                          child: Center(
                        child: Text(
                          item.value!,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      )),
                      SizedBox(
                        width: 15,
                        child: Text(
                          item.remainingTicket!.toString(),
                          style: TextStyle(fontSize: 10),
                        ),
                      )
                    ],
                  )),
            );
          }).toList()),
    );
  }

  showDialogSymbol(XSKTTickeResponse item) {
    setState(() {
      isSelectedAll = false;
    });
    List<String> listSymbols = [];
    for (int i = 0; i < item.symbols!.length; i++) {
      listSymbols.add(item.symbols![i].symbol!);
    }
    _symbol = SelectItemListModel();
    _symbol!.lable = item.value;
    _symbol!.listValue = [];
    if (tmpTicketsSelected.isNotEmpty) {
      var ticketModels =
          tmpTicketsSelected.where((element) => element.value == item.value);
      if (ticketModels.isNotEmpty) {
        if (ticketModels.first.symbol!.split(',').length == item.total) {
          isSelectedAll = true;
        }
        _symbol!.listValue!.addAll(ticketModels.first.symbol!.split(','));
      }
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: Text(
            "Chọn ký hiệu vé",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorLot.ColorPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          content: SizedBox(child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            _setState = setState;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bộ số: ",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      item.value!,
                      style: TextStyle(
                          color: ColorLot.ColorPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      " còn ",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      item.total!.toString(),
                      style: TextStyle(
                          color: ColorLot.ColorPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      " vé ",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
                Text("Bạn muốn mua bao nhiêu vé?",
                    style: TextStyle(color: Colors.black, fontSize: 14)),
                SizedBox(
                  height: 8,
                ),
                Image.network(
                  urlImage + item.images!,
                  width: 150,
                  height: 150,
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Chọn tất cả"),
                  value: isSelectedAll,
                  onChanged: (newValue) {
                    setState(() {
                      isSelectedAll = newValue!;
                      if (newValue) {
                        _symbol!.listValue!.clear();
                        _symbol!.listValue!.addAll(listSymbols);
                      } else {
                        _symbol!.listValue = [];
                      }
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: listSymbols.map((item) {
                    return _symbol!.listValue!.contains(item)
                        ? symbolSelected(item)
                        : symbolNormal(item);
                  }).toList(),
                ),
              ],
            );
          })),
          actions: <Widget>[
            Row(
              children: [
                CustomButton(
                    label: "Đóng",
                    backgroundColor: ColorLot.ColorPrimary,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
                SizedBox(
                  width: 8,
                ),
                CustomButton(
                    label: "Đồng ý",
                    backgroundColor: ColorLot.ColorBaoChung,
                    onPressed: () {
                      XSKTTickeResponse ticketModel = XSKTTickeResponse();
                      ticketModel.symbol = _symbol!.listValue!.join(',');
                      ticketModel.value = _symbol!.lable!;
                      ticketModel.providerID = item.providerID!;
                      ticketModel.total = _symbol!.listValue!.length;
                      ticketModel.type = item.type!;
                      ticketModel.drawlerID = item.drawlerID!;

                      onSelectedTicket(ticketModel);
                    }),
              ],
            )
          ],
        );
      },
    );
  }

  onTapBallTotal(total) {
    _setState!(
      () {
        totalSeleted = total;
      },
    );
  }

  Widget symbolNormal(item) {
    return InkWell(
      onTap: () => onTapBall(item),
      child: Container(
        width: 40,
        height: 30,
        alignment: Alignment.center,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
        child: Text(item,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.0,
                color: Colors.black)),
      ),
    );
  }

  onTapBall(value) {
    if (_symbol!.listValue!.contains(value)) {
      _setState!(() {
        _symbol!.listValue!.remove(value);
      });
    } else {
      _setState!(() {
        _symbol!.listValue!.add(value);
      });
    }
  }

  Widget symbolSelected(item) {
    return InkWell(
      onTap: () => onTapBall(item),
      child: Container(
        width: 40,
        height: 30,
        alignment: Alignment.center,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: ColorLot.ColorPrimary,
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
        child: Text(item,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.0,
                color: Colors.white)),
      ),
    );
  }

  Widget buildTotalSymbol(XSKTTickeResponse item) {
    var isSelected = false;
    List<XSKTTickeResponse>? tks;

    tks = tmpTicketsSelected
        .where((element) => element.value! == item.value!)
        .toList();
    if (tks.isNotEmpty) {
      isSelected = true;
    }

    if (isSelected) {
      return Container(
        alignment: Alignment.center,
        height: double.infinity,
        width: 24,
        decoration: BoxDecoration(
            color: ColorLot.ColorPrimary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7), bottomLeft: Radius.circular(7))),
        child: Text(
          tks[0].total.toString(),
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
        ),
      );
    } else {
      return Container(
          alignment: Alignment.center,
          height: double.infinity,
          width: 24,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7), bottomLeft: Radius.circular(7))),
          child: SizedBox.shrink());
    }
  }
}
