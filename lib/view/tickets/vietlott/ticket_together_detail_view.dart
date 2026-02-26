// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/config/api.dart';
import 'package:lottery_flutter_application/models/request/together_ticket_request.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/models/together_ticket_seleted_view_model.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/utils/dialog_update_info_player.dart';
import 'package:lottery_flutter_application/utils/hero_photo_view.dart';
import 'package:lottery_flutter_application/utils/image_product.dart';
import 'package:lottery_flutter_application/utils/text_amount.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:lottery_flutter_application/view/history/history_compare_together_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/common.dart';
import '../../../controller/payment_controller.dart';
import '../../../controller/together_ticket_controller.dart';
import '../../../models/request/get_fee_request.dart';
import '../../../models/request/order_add_request.dart';
import '../../../models/request/together_ticket_add_item_request.dart';
import '../../../models/request/together_ticket_item_search_request.dart';
import '../../../models/response/player_profile.dart';
import '../../../models/response/together_ticket_item_search_response.dart';
import '../../../models/response/together_ticket_response.dart';
import '../../../utils/box_shadow.dart';
import '../../../utils/color_lot.dart';
import '../../../utils/dialog_payment_together_ticket.dart';
import '../../../utils/dialog_process.dart';
import '../../../utils/dialog_qr.dart';
import '../../../utils/dialog_selected_together_ticket.dart';
import '../../../utils/dimen.dart';
import '../../../utils/scaffold_messger.dart';
import '../../../utils/text_bold.dart';
import 'ticket_together_history_view.dart';

class TicketTogetherDetailView extends StatefulWidget {
  const TicketTogetherDetailView({super.key, required this.code});

  final String code;
  @override
  State<StatefulWidget> createState() => _TicketTogetherDetailView();
}

class _TicketTogetherDetailView extends State<TicketTogetherDetailView> {
  final TogetherTicketController _con = TogetherTicketController();
  final PaymentController _conPay = PaymentController();
  SharedPreferences? prefs;
  PlayerProfile? playerProfile;
  TogetherTicketSearchResponse? ticket;
  List<TogetherTicketItemSearchResponse>? items;
  int myPercent = 0;
  String mode = "ON";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initData();
    });
  }

  initData() async {
    prefs = await SharedPreferences.getInstance();
    mode = prefs!.getString(Common.SHARE_MODE_UPLOAD)!;
    String? userMap = prefs?.getString('user');
    if (userMap != null) {
      playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      await getTickets();
    } else {
      if (mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginView()));
      }
    }
  }

  getTickets() async {
    if (mounted) showProcess(context);

    TogetherTicketSearchRequest req = TogetherTicketSearchRequest();
    req.code = widget.code;
    ResponseObject res = await _con.search(req);
    if (res.code == "00") {
      List<TogetherTicketSearchResponse> tickets =
          List<TogetherTicketSearchResponse>.from((jsonDecode(res.data!)
              .map((model) => TogetherTicketSearchResponse.fromJson(model))));
      ticket = tickets[0];
      await getItem(ticket!.iD);
      setState(() {});
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  getItem(id) async {
    TogetherTicketSearchItemRequest req = TogetherTicketSearchItemRequest();
    req.iD = id;
    ResponseObject res = await _con.searchItem(req);
    if (res.code == "00") {
      items = List<TogetherTicketItemSearchResponse>.from((jsonDecode(res.data!)
          .map((model) => TogetherTicketItemSearchResponse.fromJson(model))));

      List<TogetherTicketItemSearchResponse> myItems = items!
          .where(
              (element) => element.mobileNumber == playerProfile!.mobileNumber)
          .toList();
      myPercent = myItems.fold(0,
          (previousValue, element) => previousValue + element.percent!.toInt());
      setState(() {});
    }
  }

  joinTicket() {
    List<TogetherSelectedPercentViewModel> models = [];
    double remain = 100 - ticket!.percent!;
    int step = 5;
    switch (ticket!.systematic) {
      case 5:
      case 7:
        step = 10;
        break;
      case 8:
      case 9:
        step = 5;
        break;
      case 10:
      case 11:
        step = 4;
        break;
      case 12:
      case 13:
      case 14:
        step = 2;
        break;
      case 15:
      case 18:
        step = 1;
        break;
    }
    int value = step;
    int priceBase = ticket!.price!;

    for (int i = 0; i < 20; i++) {
      if (value < remain) {
        double price = (priceBase * value) / 100;
        TogetherSelectedPercentViewModel item =
            TogetherSelectedPercentViewModel();
        item.selected = false;
        item.text = "$value% - ${formatAmountD(price)}";
        item.value = value.toString();

        models.add(item);
      }
      value += step;
    }
    double price0 = priceBase * remain / 100;
    TogetherSelectedPercentViewModel item = TogetherSelectedPercentViewModel();
    item.selected = false;
    item.text = "${remain.toStringAsFixed(0)}% - ${formatAmountD(price0)}";
    item.value = remain.toString();

    models.add(item);

    return showDialog(
        context: context,
        builder: (context) {
          return DialogSelectedTogetherTicket(
              title: "Chọn cổ phần đóng góp",
              models: models,
              callback: (value) {
                next(double.parse(value));
              });
        });
  }

  next(double percent) async {
    if (mode != Common.ANDROID_MODE_UPLOAD ||
        playerProfile!.mobileNumber == Common.MOBILE_OFF) {
      return dialogQR(context,
          "${playerProfile!.mobileNumber}|$percent|${getProductName(Common.ID_BAOCHUNG)}");
    }
    if (playerProfile!.name == null || playerProfile!.pIDNumber == null) {
      if (mounted) {
        dialogBuilderUpdateInfo(context, "Thông báo",
            "Vui lòng cập nhật thông tin cá nhân trước khi đặt vé");
        return;
      }
    }
    if (mounted) showProcess(context);
    TogetherTicketItemAddRequest req = TogetherTicketItemAddRequest();
    int price = ticket!.price! * percent.toInt() ~/ 100;
    req.channel = Common.CHANNEL;
    req.price = price;
    req.amount = price;
    req.productID = ticket!.productID;
    req.togetherTicketID = ticket!.iD;
    req.mobileNumber = playerProfile!.mobileNumber;
    req.name = playerProfile!.name;
    req.pidNumber = playerProfile!.pIDNumber;
    req.percent = percent.toInt();

    ResponseObject res = await _con.addItem(req);
    if (res.code == "00") {
      if (context.mounted) {
        ResponseObject resFee = await getFee(req.productID!, price);
        if (context.mounted) Navigator.pop(context);
        if (resFee.code == "00") {
          OrderAddNewRequest order = OrderAddNewRequest();
          order.mobileNumber = playerProfile!.mobileNumber;
          order.fullName = playerProfile!.name;
          order.pIDNumber = playerProfile!.pIDNumber;
          order.emailAddress = playerProfile!.emailAddress;
          double fee = jsonDecode(resFee.data!)["Fee"];
          order.fee = fee.round();
          order.amount = price;
          if (mounted) {
            dialogPaymentTogetherTicket(context, playerProfile!, order,
                jsonDecode(res.data!)["Code"], prefs);
          }
        } else {
          if (context.mounted) showMessage(context, res.message!, "98");
        }
      }
    } else {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) showMessage(context, res.message!, "98");
    }
  }

  Future<ResponseObject> getFee(int productID, int price) async {
    GetFeeRequest feeRequest =
        GetFeeRequest(amount: price, productID: productID);
    return await _conPay.getFee(feeRequest);
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
          title: const Text("Chi tiết Bao chung"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Ionicons.time_outline,
                color: Colors.white,
              ),
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TicketTogetherHistoryView(
                                type: 1,
                              )));
                });
              },
            )
          ],
        ),
        body: Container(
          color: ColorLot.ColorBackground,
          height: double.infinity,
          child: buildBody(),
        ));
  }

  Widget buildBody() {
    if (ticket != null) {
      return Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(Dimen.marginDefault),
                    padding: const EdgeInsets.all(Dimen.padingDefault),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [boxShadow()],
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimen.radiusBorder))),
                    child: Column(
                      children: [
                        textBold(
                            "Nhóm #${ticket!.code} - Bao ${ticket!.systematic} - ${formatAmountD(ticket!.price)}",
                            Colors.black),
                        Image(
                          image: imageProduct(ticket!.productID),
                          width: 52,
                          height: 52,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                textLable("Bạn đã góp"),
                                textAmount("${formatAmount(myPercent)}%")
                              ],
                            )),
                            Expanded(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                textLable("Nhóm hoàn thành"),
                                textAmount("${formatAmount(ticket!.percent)}%")
                              ],
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textBold(
                                "Kỳ: #${ticket!.drawCode} - ${ticket!.drawDate}",
                                Colors.black),
                            buildStatus()
                          ],
                        )
                      ],
                    )),
                ticket!.imgBefore!.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HeroPhotoViewRouteWrapper(
                                imageProvider: NetworkImage(
                                  urlImage + ticket!.imgBefore!,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          urlImage + ticket!.imgBefore!,
                          width: 150,
                          height: 150,
                        ),
                      )
                    : SizedBox.shrink(),
                ticket!.numberOfLines!.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimen.marginDefault),
                        padding: const EdgeInsets.all(Dimen.padingDefault),
                        width: double.infinity,
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [boxShadow()],
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimen.radiusBorder))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textLable("Bộ số"),
                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  children: ticket!.numberOfLines!
                                      .split(',')
                                      .map((item) {
                                    return Container(
                                      width: 30,
                                      height: 30,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(3),
                                      margin: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorLot.ColorPrimary,
                                          border: Border.all(
                                              color: ColorLot.ColorPrimary,
                                              width: 1)),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Text(item,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                letterSpacing: 0.0,
                                                color: Colors.white)),
                                      ),
                                    );
                                  }).toList()),
                            )
                          ],
                        ))
                    : SizedBox.shrink(),
                Container(
                    margin: EdgeInsets.all(Dimen.marginDefault),
                    padding: const EdgeInsets.all(Dimen.padingDefault),
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [boxShadow()],
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimen.radiusBorder))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            textLable("Danh sách thành viên tham gia: "),
                            textBold("${ticket!.quantity} người",
                                ColorLot.ColorPrimary)
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        buildItems()
                      ],
                    )),
              ],
            ),
          )),
          ticket!.status == "S"
              ? InkWell(
                  onTap: () {
                    joinTicket();
                  },
                  child: Container(
                    margin: EdgeInsets.all(Dimen.marginDefault),
                    height: Dimen.buttonHeightFooter,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimen.radiusBorderButton)),
                        border:
                            Border.all(width: 1, color: ColorLot.ColorSuccess)),
                    child: Text(
                      "Tham gia",
                      style: TextStyle(color: ColorLot.ColorSuccess),
                    ),
                  ),
                )
              : SizedBox.shrink()
        ],
      );
    } else {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: const [
            Icon(
              Ionicons.clipboard_outline,
              size: 40,
              color: Colors.black54,
            ),
            SizedBox(
              height: 10,
            ),
            Text("Không lấy được thông tin chi tiết bao!")
          ],
        ),
      );
    }
  }

  Widget buildStatus() {
    if (ticket!.isResult == "N") {
      if (ticket!.status == "C") {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(width: 1, color: ColorLot.ColorWarring)),
          child: textStatus("Đã hủy", ColorLot.ColorWarring),
        );
      } else {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(width: 1, color: ColorLot.ColorSuccess)),
          child: textStatus("Chưa xổ", ColorLot.ColorSuccess),
        );
      }
    } else if (ticket!.isResult == "W") {
      return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HistoryCompareTogetherView(
                          ticket: ticket!,
                          items: items ?? [],
                          mobile: playerProfile!.mobileNumber!,
                        )));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(width: 1, color: ColorLot.ColorPrimary)),
            child: Row(
              children: [
                Icon(
                  Ionicons.trophy_outline,
                  color: ColorLot.ColorPrimary,
                  size: 20,
                ),
                textStatus("Trúng thưởng", ColorLot.ColorPrimary)
              ],
            ),
          ));
    } else {
      return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HistoryCompareTogetherView(
                          ticket: ticket!,
                          items: items ?? [],
                          mobile: playerProfile!.mobileNumber!,
                        )));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(width: 1, color: Colors.black54)),
            child: Text(
              "So kết quả",
              style: TextStyle(
                  color: Colors.black54, fontSize: Dimen.fontSizeDefault),
            ),
          ));
    }
  }

  Widget textStatus(text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: Dimen.fontSizeDefault),
    );
  }

  Widget buildItems() {
    if (items != null) {
      int idx = 0;
      return Column(
          children: items!.map(
        (e) {
          idx++;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    textLable("#$idx: "),
                    textBold(
                        "xxxxxx${e.mobileNumber!.substring(6)}", Colors.black)
                  ],
                )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: textBold(
                        "${e.percent!.toStringAsFixed(0)}%", Colors.black)),
                Container(
                    alignment: Alignment.topRight,
                    width: 100,
                    child: textBold(
                        formatAmountD(e.price), ColorLot.ColorPrimary)),
              ],
            ),
          );
        },
      ).toList());
    } else {
      return SizedBox.shrink();
    }
  }
}
