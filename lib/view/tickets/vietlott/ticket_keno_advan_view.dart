// ignore_for_file: public_member_api_docs, sort_constructors_first, await_only_futures, use_build_context_synchronously, prefer_interpolation_to_compose_strings, unused_field, unnecessary_brace_in_string_interps
// ignore_for_file: prefer_const_constructors, sort_child_properties_last, must_be_immutable, unnecessary_new, prefer_const_literals_to_create_immutables, unnecessary_this, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottery_flutter_application/controller/account_controller.dart';
import 'package:lottery_flutter_application/controller/dictionary_controller.dart';
import 'package:lottery_flutter_application/controller/payment_controller.dart';
import 'package:lottery_flutter_application/models/request/get_fee_request.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/dialog_update_info_player.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/utils/widget_divider.dart';
import 'package:lottery_flutter_application/view/payment_view.dart';
import 'package:lottery_flutter_application/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/common.dart';
import '../../../models/request/order_add_request.dart';
import '../../../models/request/order_item_add_request.dart';
import '../../../models/response/get_draw_keno_response.dart';
import '../../../models/response/player_profile.dart';
import '../../../models/selected_item_model.dart';
import '../../../utils/box_shadow.dart';
import '../../../utils/color_lot.dart';
import '../../../utils/common.dart';
import '../../../utils/dialog_payment.dart';
import '../../../utils/dialog_process.dart';
import '../../../utils/dialog_qr.dart';
import '../../../utils/scaffold_messger.dart';

final key = new GlobalKey<_TicketLotoState>();

class TicketKenoAdvanView extends StatefulWidget {
  const TicketKenoAdvanView({Key? key, this.drawKeno, required this.balance})
      : super(key: key);

  final int balance;
  final GetDrawKenoResponse? drawKeno;

  @override
  State<TicketKenoAdvanView> createState() => _TicketLotoState();
}

class _TicketLotoState extends State<TicketKenoAdvanView> {
  final DictionaryController _con = DictionaryController();
  final AccountController _conAcc = AccountController();
  final PaymentController _conPay = PaymentController();

  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;
  bool isSelectionMode = false;

  int drafAmount = 0;

  int? drawTime;
  String? draw = "1";
  int system = 0;
  Timer? _timer;

  List<int>? listAmount = [10000, 20000, 50000, 100000, 200000, 500000];

  String lineA = "";
  String lineB = "";
  String lineC = "";
  String lineD = "";
  String lineE = "";
  String lineF = "";
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
  }

  getData() async {
    _prefs = await SharedPreferences.getInstance();
    mode = _prefs!.getString(Common.SHARE_MODE_UPLOAD)!;
    String? userMap = _prefs?.getString('user');
    if (userMap != null) {
      setState(() {
        playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      });
    }
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

  calculator() {
    int price = 0;
    if (lineA != "") {
      price = price + amountA;
    }
    if (lineB != "") {
      price = price + amountB;
    }
    if (lineC != "") {
      price = price + amountC;
    }
    if (lineD != "") {
      price = price + amountD;
    }
    if (lineE != "") {
      price = price + amountE;
    }
    if (lineF != "") {
      price = price + amountF;
    }
    setState(() {
      drafAmount = price * int.parse(draw!);
    });
  }

  selectDraw(String _draw) {
    draw = _draw.split(' ')[0];
    calculator();
  }

  selectedBall(String line, SelectItemModel selected) {
    switch (line) {
      case "A":
        if (selected.isSelected!) {
          setState(() {
            lineA = selected.value!;
          });
        } else {
          lineA = "";
        }
        break;
      case "B":
        if (selected.isSelected!) {
          setState(() {
            lineB = selected.value!;
          });
        } else {
          lineB = "";
        }
        break;
      case "C":
        if (selected.isSelected!) {
          setState(() {
            lineC = selected.value!;
          });
        } else {
          lineC = "";
        }
        break;
      case "D":
        if (selected.isSelected!) {
          setState(() {
            lineD = selected.value!;
          });
        } else {
          lineD = "";
        }
        break;
      case "E":
        if (selected.isSelected!) {
          setState(() {
            lineE = selected.value!;
          });
        } else {
          lineE = "";
        }
        break;
      case "F":
        if (selected.isSelected!) {
          setState(() {
            lineF = selected.value!;
          });
        } else {
          lineF = "";
        }
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
    List<String> _lineName = [];
    if (lineA != "") {
      _line.add(lineA + "|" + amountA.toString());
      _lineName.add(getProductTypeName(lineA));
    }
    if (lineB != "") {
      _line.add(lineB + "|" + amountB.toString());
      _lineName.add(getProductTypeName(lineB));
    }
    if (lineC != "") {
      _line.add(lineC + "|" + amountC.toString());
      _lineName.add(getProductTypeName(lineC));
    }
    if (lineD != "") {
      _line.add(lineD + "|" + amountD.toString());
      _lineName.add(getProductTypeName(lineD));
    }
    if (lineE != "") {
      _line.add(lineE + "|" + amountE.toString());
      _lineName.add(getProductTypeName(lineE));
    }
    if (lineF != "") {
      _line.add(lineF + "|" + amountF.toString());
      _lineName.add(getProductTypeName(lineF));
    }
    if (mode != Common.ANDROID_MODE_UPLOAD ||
        playerProfile!.mobileNumber == Common.MOBILE_OFF) {
      return dialogQR(context,
          "${_lineName.join("|")}|$drafAmount|${getProductName(Common.ID_KENO)}");
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
    order.productTypeID = 3;
    order.terminalID = playerProfile!.terminalID!;

    int drawCode = int.parse(widget.drawKeno!.drawCode!);

    List<OrderAddItemRequest> items = [];
    for (int k = 0; k < order.quantity!; k++) {
      OrderAddItemRequest item = new OrderAddItemRequest();
      item.productID = Common.ID_KENO;
      item.productTypeID = 3;
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
                                      selectedBall: selectedBall, line: "A")),
                              SizedBox(
                                width: 10,
                              ),
                              buildAmountRow("A", amountA)
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
                                      selectedBall: selectedBall, line: "B")),
                              SizedBox(
                                width: 10,
                              ),
                              buildAmountRow("B", amountB)
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
                                      selectedBall: selectedBall, line: "C")),
                              SizedBox(
                                width: 10,
                              ),
                              buildAmountRow("C", amountC)
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
                                  child: LineView1(
                                      selectedBall: selectedBall, line: "D")),
                              SizedBox(
                                width: 10,
                              ),
                              buildAmountRow("D", amountD)
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
                                  child: LineView1(
                                      selectedBall: selectedBall, line: "E")),
                              SizedBox(
                                width: 10,
                              ),
                              buildAmountRow("E", amountE)
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
                                  child: LineView1(
                                      selectedBall: selectedBall, line: "F")),
                              SizedBox(
                                width: 10,
                              ),
                              buildAmountRow("F", amountF),
                            ],
                          ),
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

  Widget buildAmountRow(String label, dynamic amount) {
    return
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

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
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
                  label: "Đặt vé",
                  backgroundColor: ColorLot.ColorPrimary,
                  onPressed: next)
            ],
          ),
        ],
      );
    }
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
        SelectItemModel(text: "Chẵn", value: Common.CHAN, isSelected: false));
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
                    widget.selectedBall(widget.line, item);
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

    listChanLe.add(
        SelectItemModel(text: "Lớn", value: Common.LON, isSelected: false));
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
                    widget.selectedBall(widget.line, item);
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
