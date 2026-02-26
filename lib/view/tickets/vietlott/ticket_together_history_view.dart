// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/controller/together_ticket_controller.dart';
import 'package:lottery_flutter_application/models/request/together_ticket_request.dart';
import 'package:lottery_flutter_application/models/response/get_together_group_response.dart';
import 'package:lottery_flutter_application/models/response/player_profile.dart';
import 'package:lottery_flutter_application/models/response/together_ticket_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/image_product.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_together_group_detail_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/request/together_ticket_item_search_request.dart';
import '../../../models/response/response_object.dart';
import '../../../models/response/together_ticket_item_search_response.dart';
import '../../../utils/box_shadow.dart';
import '../../../utils/common.dart';
import '../../../utils/dialog_process.dart';
import '../../../utils/dimen.dart';
import 'ticket_together_detail_view.dart';

class TicketTogetherHistoryView extends StatefulWidget {
  const TicketTogetherHistoryView({super.key, required this.type});
  final int type;

  @override
  State<StatefulWidget> createState() => _TicketTogetherHistoryView();
}

class _TicketTogetherHistoryView extends State<TicketTogetherHistoryView> {
  final TogetherTicketController _con = TogetherTicketController();
  SharedPreferences? prefs;
  PlayerProfile? playerProfile;
  List<TogetherTicketItemSearchResponse> items = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getTickets();
    });
  }

  getTickets() async {
    prefs = await SharedPreferences.getInstance();
    String? userMap = prefs?.getString('user');
    if (userMap != null) {
      playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      if (mounted) showProcess(context);

      TogetherTicketSearchItemRequest req = TogetherTicketSearchItemRequest();
      req.type = widget.type;
      req.mobileNumber = playerProfile!.mobileNumber!;
      ResponseObject res = await _con.searchItem(req);
      if (res.code == "00") {
        items = List<TogetherTicketItemSearchResponse>.from(
            (jsonDecode(res.data!).map(
                (model) => TogetherTicketItemSearchResponse.fromJson(model))));

        setState(() {});
      }

      if (mounted) {
        Navigator.pop(context);
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
          title: widget.type == 1
              ? Text("Lịch sử góp bao chung")
              : Text("Lịch sử góp nhóm chung"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: buildBody());
  }

  Widget buildBody() {
    if (items.isEmpty) {
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
            Text("Danh sách trống!")
          ],
        ),
      );
    }
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: items.map((item) {
            return InkWell(
                onTap: () {
                  if (item.type == 2) {
                    GetTogetherGroupResponse tk = GetTogetherGroupResponse();
                    tk.id = item.groupID!;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TicketTogetherGroupDetailView(
                                ttGroup: tk, code: item.tTCode)));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TicketTogetherDetailView(code: item.tTCode!)));
                  }
                },
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[boxShadow()],
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                item.productID != 0
                                    ? Padding(
                                        padding: EdgeInsets.all(6),
                                        child: Image(
                                          image: imageProduct(item.productID),
                                          width: 50,
                                          height: 50,
                                        ))
                                    : SizedBox.shrink(),
                                Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textBold("Mã nhóm ${item.tTCode}",
                                            Colors.black),
                                        item.tTSystematic! > 0
                                            ? textBold(
                                                "Bao ${item.tTSystematic} - ${formatAmountD(item.price)}",
                                                Colors.blue)
                                            : SizedBox.shrink(),
                                        item.tTCode!.isNotEmpty
                                            ? textNormal(
                                                "Kỳ: #${item.tTCode} - ${item.tTDrawDate}")
                                            : SizedBox.shrink(),
                                        item.percent! > 0
                                            ? textNormal(
                                                "Bạn đã góp: ${item.percent!.toStringAsFixed(0)}%")
                                            : SizedBox.shrink(),
                                        Row(
                                          children: [
                                            textNormal("Số tiền góp: "),
                                            textBold(formatAmountD(item.price),
                                                ColorLot.ColorPrimary)
                                          ],
                                        ),
                                        Text(
                                          item.createdDate!,
                                          style: TextStyle(
                                              fontSize: Dimen.fontSizeDefault,
                                              color: Colors.black45),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  alignment: Alignment.topRight,
                                  margin:
                                      EdgeInsetsDirectional.only(bottom: 12),
                                  width: 120,
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: ColorLot.ColorBaoChung,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(
                                              Dimen.radiusBorder))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      textBold("${item.tTQuantity} người góp",
                                          Colors.white),
                                      item.percent! > 0
                                          ? textBold(
                                              "${item.percent!.toStringAsFixed(0)}% hoàn thành",
                                              Colors.white)
                                          : SizedBox.shrink()
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: Dimen.marginDefault),
                                  child: buildStatus(item),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    )));
          }).toList(),
        ),
      ),
    );
  }

  Widget buildStatus(TogetherTicketItemSearchResponse ticket) {
    if (ticket.isResult == "N") {
      if (ticket.status == "C") {
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
    } else if (ticket.isResult == "W") {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(width: 1, color: ColorLot.ColorPrimary)),
          child: textStatus("Trúng thưởng", ColorLot.ColorPrimary));
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(width: 1, color: Colors.black54)),
        child: Text(
          "Đã xổ",
          style:
              TextStyle(color: Colors.black54, fontSize: Dimen.fontSizeDefault),
        ),
      );
    }
  }

  Widget textStatus(text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: Dimen.fontSizeDefault),
    );
  }

  Widget textBold(text, Color color) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: Dimen.fontSizeDefault,
          color: color),
    );
  }

  Widget textNormal(text) {
    return Text(
      text,
      style: TextStyle(fontSize: Dimen.fontSizeDefault, color: Colors.black),
    );
  }
}
