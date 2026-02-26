// ignore_for_file: prefer_const_constructors, unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/config/api.dart';
import 'package:lottery_flutter_application/models/request/base_request.dart';
import 'package:lottery_flutter_application/models/request/together_ticket_request.dart';
import 'package:lottery_flutter_application/models/response/get_together_group_response.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/models/together_ticket_detail.dart';
import 'package:lottery_flutter_application/models/together_ticket_seleted_view_model.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/utils/dialog_update_info_player.dart';
import 'package:lottery_flutter_application/utils/hero_photo_view.dart';
import 'package:lottery_flutter_application/utils/image_product.dart';
import 'package:lottery_flutter_application/utils/text_amount.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:lottery_flutter_application/view/history/history_compare_together_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_together_detail_view.dart';
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

class TicketTogetherGroupDetailView extends StatefulWidget {
  const TicketTogetherGroupDetailView(
      {super.key, required this.ttGroup, this.code});

  final GetTogetherGroupResponse ttGroup;
  final String? code;
  @override
  State<StatefulWidget> createState() => _TicketTogetherGroupDetailView();
}

class _TicketTogetherGroupDetailView
    extends State<TicketTogetherGroupDetailView> {
  final TogetherTicketController _con = TogetherTicketController();
  final PaymentController _conPay = PaymentController();
  SharedPreferences? prefs;
  PlayerProfile? playerProfile;
  TogetherTicketSearchResponse? ticket;
  List<TogetherTicketItemSearchResponse>? items;
  List<TogetherTicketDetail>? details;
  GetTogetherGroupResponse? ttGroup;
  int myPercent = 0;
  String mode = "ON";
  StateSetter? _setState;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initData();
    });
  }

  initData() async {
    ttGroup = widget.ttGroup;
    prefs = await SharedPreferences.getInstance();
    mode = prefs!.getString(Common.SHARE_MODE_UPLOAD)!;
    String? userMap = prefs?.getString('user');
    if (userMap != null) {
      playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      await getGroup();
    } else {
      if (mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginView()));
      }
    }
  }

  getGroup() async {
    if (mounted) showProcess(context);
    BaseRequest req = BaseRequest();
    req.iD = widget.ttGroup.id;
    ResponseObject res = await _con.getTogetherGroup(req);
    if (res.code == "00") {
      List<GetTogetherGroupResponse> groups =
          List<GetTogetherGroupResponse>.from((jsonDecode(res.data!)
              .map((model) => GetTogetherGroupResponse.fromJson(model))));
      ttGroup = groups[0];
      await getTickets();
      setState(() {});
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  getTickets() async {
    if (mounted) showProcess(context);

    TogetherTicketSearchRequest req = TogetherTicketSearchRequest();
    req.groupID = ttGroup!.id;
    if (widget.code != null) {
      req.code = widget.code;
    } else {
      req.fromDate = getByDateDDMMYYYY(DateTime.now());
      req.toDate = getByDateDDMMYYYY(DateTime.now());
    }

    req.type = 2;
    ResponseObject res = await _con.search(req);
    if (res.code == "00") {
      List<TogetherTicketSearchResponse> tickets =
          List<TogetherTicketSearchResponse>.from((jsonDecode(res.data!)
              .map((model) => TogetherTicketSearchResponse.fromJson(model))));
      if (tickets.isNotEmpty) {
        ticket = tickets[0];

        await getItem(ticket!.iD);
        if (ticket!.status == "W" || ticket!.status == "A") {
          await getDetail(ticket!.iD);
        }
        setState(() {});
      }
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  getDetail(id) async {
    BaseRequest req = BaseRequest();
    req.iD = id;
    ResponseObject res = await _con.getTogetherGroupDetail(req);
    if (res.code == "00") {
      details = List<TogetherTicketDetail>.from((jsonDecode(res.data!)
          .map((model) => TogetherTicketDetail.fromJson(model))));
      setState(() {});
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
          (previousValue, element) => previousValue + element.amount!.toInt());
      setState(() {});
    }
  }

  joinTicket() {
    final TextEditingController amount = TextEditingController();
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
            "Số tiền tham gia nhóm",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          content: SizedBox(child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            _setState = setState;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "(Số tiền góp phải là bội số của 10.000)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorLot.ColorPrimary,
                      fontSize: 14,
                      fontStyle: FontStyle.italic),
                ),
                TextFormField(
                  controller: amount,
                  keyboardType: TextInputType.number,
                  onChanged: (string) {
                    string = (string != ''
                        ? formatAmount(int.parse(string.replaceAll(',', '')))
                        : '');
                    amount.value = TextEditingValue(
                      text: string,
                      selection: TextSelection.collapsed(offset: string.length),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: "Nhập số tiền tham gia",
                    labelText: "Số tiền tham gia",
                    floatingLabelStyle: TextStyle(color: ColorLot.ColorPrimary),
                    counterText: "",
                    isDense: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorLot.ColorPrimary),
                    ),
                  ),
                ),
              ],
            );
          })),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      side:
                          BorderSide(width: 1.0, color: ColorLot.ColorPrimary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    "Đóng",
                    style:
                        TextStyle(color: ColorLot.ColorPrimary, fontSize: 16),
                  ),
                )),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: OutlinedButton(
                  onPressed: () {
                    int amount0 = int.parse(amount.text.replaceAll(",", ""));
                    if (amount0 % 10000 == 0) {
                      next(amount0);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 1.0, color: Colors.green),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    "Đồng ý",
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                )),
              ],
            )
          ],
        );
      },
    );
  }

  next(int price) async {
    if (playerProfile!.name == null || playerProfile!.pIDNumber == null) {
      if (mounted) {
        dialogBuilderUpdateInfo(context, "Thông báo",
            "Vui lòng cập nhật thông tin cá nhân trước khi đặt vé");
        return;
      }
    }
    if (mounted) showProcess(context);
    TogetherTicketItemAddRequest req = TogetherTicketItemAddRequest();

    req.channel = Common.CHANNEL;
    req.price = price;
    req.fee = 0;
    req.amount = price;
    req.mobileNumber = playerProfile!.mobileNumber;
    req.name = playerProfile!.name;
    req.pidNumber = playerProfile!.pIDNumber;
    req.groupID = ttGroup!.id;
    ResponseObject res = await _con.addItemGroup(req);
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
          title: const Text("Chi tiết Nhóm chung"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // actions: [
          //   IconButton(
          //     icon: const Icon(
          //       Ionicons.time_outline,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       Future.delayed(Duration.zero, () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => const TicketTogetherHistoryView(
          //                       type: 2,
          //                     )));
          //       });
          //     },
          //   )
          // ],
        ),
        body: Container(
          color: ColorLot.ColorBackground,
          height: double.infinity,
          child: buildBody(),
        ));
  }

  Widget buildBody() {
    if (ttGroup == null || ttGroup!.code == null) {
      return SizedBox.shrink();
    }
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
                      Text(
                        "Mã nhóm: #${ttGroup!.code}",
                        style: TextStyle(
                            fontSize: Dimen.fontSizeValue,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Tên nhóm: ${ttGroup!.name}",
                        style: TextStyle(
                            fontSize: Dimen.fontSizeValue,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              textLable("Bạn đã góp: "),
                              textAmountSize(formatAmountD(myPercent),
                                  Dimen.fontSizeValue),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              textLable("Số tiền góp: "),
                              textAmountSize(formatAmountD(ttGroup!.amount),
                                  Dimen.fontSizeValue)
                            ],
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      ticket != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textBold(
                                    "Kỳ: #${ticket!.drawCode} - ${ticket!.drawDate}",
                                    Colors.black),
                                buildStatus()
                              ],
                            )
                          : SizedBox.shrink()
                    ],
                  )),
              buildPrint(),
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
                          textBold("${ttGroup!.bagYield} người",
                              ColorLot.ColorPrimary)
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      buildItems()
                    ],
                  )),
              buildJoin()
            ],
          ),
        )),
      ],
    );
  }

  Widget buildJoin() {
    if (ticket != null) {
      return ticket!.status == "S"
          ? InkWell(
              onTap: () {
                joinTicket();
              },
              child: Container(
                margin: EdgeInsets.all(Dimen.marginDefault),
                height: Dimen.buttonHeightFooter,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(Dimen.radiusBorderButton)),
                    border: Border.all(width: 1, color: ColorLot.ColorSuccess)),
                child: Text(
                  "Tham gia",
                  style: TextStyle(color: ColorLot.ColorSuccess),
                ),
              ),
            )
          : SizedBox.shrink();
    }
    return InkWell(
      onTap: () {
        joinTicket();
      },
      child: Container(
        margin: EdgeInsets.all(Dimen.marginDefault),
        height: Dimen.buttonHeightFooter,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(Dimen.radiusBorderButton)),
            border: Border.all(width: 1, color: ColorLot.ColorSuccess)),
        child: Text(
          "Tham gia",
          style: TextStyle(color: ColorLot.ColorSuccess),
        ),
      ),
    );
  }

  Widget buildPrint() {
    if (ticket != null) {
      if (ticket!.status == "W" || ticket!.status == "A") {
        if (details != null && details!.isNotEmpty) {
          return Column(
              children: details!.map((e) {
            return Column(
              children: [
                Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: Dimen.marginDefault),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        textLable("Bộ số"),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.center,
                              children: e.numberOfLines!.split(',').map((item) {
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
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HeroPhotoViewRouteWrapper(
                                  imageProvider: NetworkImage(
                                    urlImage + e.imgBefore!,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Image.network(
                            urlImage + e.imgBefore!,
                            width: 150,
                            height: 150,
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: 4,
                )
              ],
            );
          }).toList());
        }
      }
    }
    return SizedBox.shrink();
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
                          details: details,
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
                          details: details,
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
                    child: textBold("${e.percent!}%", Colors.black)),
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
