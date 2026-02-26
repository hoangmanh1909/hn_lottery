// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/controller/together_ticket_controller.dart';
import 'package:lottery_flutter_application/models/request/base_request.dart';
import 'package:lottery_flutter_application/models/request/together_ticket_request.dart';
import 'package:lottery_flutter_application/models/response/get_together_group_response.dart';
import 'package:lottery_flutter_application/models/response/together_ticket_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_together_group_detail_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_together_view.dart';

import '../../../constants/common.dart';
import '../../../models/response/response_object.dart';
import '../../../utils/box_shadow.dart';
import '../../../utils/common.dart';
import '../../../utils/dialog_process.dart';
import '../../../utils/dimen.dart';
import 'ticket_together_detail_view.dart';
import 'ticket_together_history_view.dart';

class TicketTogetherGroupView extends StatefulWidget {
  const TicketTogetherGroupView({super.key});

  @override
  State<StatefulWidget> createState() => _TicketTogetherGroupViewState();
}

class _TicketTogetherGroupViewState extends State<TicketTogetherGroupView> {
  final TogetherTicketController _con = TogetherTicketController();

  List<GetTogetherGroupResponse> tickets = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getTickets();
    });
  }

  getTickets() async {
    if (mounted) showProcess(context);

    ResponseObject res = await _con.getTogetherGroup(BaseRequest());
    if (res.code == "00") {
      tickets = List<GetTogetherGroupResponse>.from((jsonDecode(res.data!)
          .map((model) => GetTogetherGroupResponse.fromJson(model))));

      setState(() {});
    }

    if (mounted) {
      Navigator.pop(context);
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
          title: Text("Danh sách nhóm bao"),
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
                                type: 2,
                              )));
                });
              },
            )
          ],
        ),
        body: buildBody());
  }

  Widget buildBody() {
    if (tickets.isEmpty) {
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
          children: tickets.map((item) {
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TicketTogetherGroupDetailView(
                                ttGroup: item,
                              )));
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
                                Container(
                                    width: 50,
                                    height: 50,
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: ColorLot.ColorPrimary,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    alignment: Alignment.center,
                                    child: Text(
                                        item.name!
                                            .substring(0, 2)
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Dimen.fontSizeTitle,
                                            fontWeight: FontWeight.w700))),
                                Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textBold("Mã nhóm: ${item.code}",
                                            Colors.black),
                                        textBold("Tên nhóm: ${item.name}",
                                            Colors.black),
                                        textNormal("Địa chỉ: ${item.address}"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                textNormal("Số người góp: "),
                                                Text(
                                                  "${item.bagYield!}",
                                                  style: TextStyle(
                                                      fontSize:
                                                          Dimen.fontSizeValue,
                                                      color:
                                                          ColorLot.ColorPrimary,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Row(
                                              children: [
                                                textNormal("Số tiền góp: "),
                                                Text(
                                                  formatAmountD(item.amount),
                                                  style: TextStyle(
                                                      fontSize:
                                                          Dimen.fontSizeValue,
                                                      color:
                                                          ColorLot.ColorPrimary,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
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
