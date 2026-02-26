// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/constants/common.dart';

import 'package:lottery_flutter_application/models/response/get_result_response.dart';
import 'package:lottery_flutter_application/models/together_ticket_detail.dart';
import 'package:lottery_flutter_application/utils/text_bold.dart';
import 'package:lottery_flutter_application/view/result/result_mega_view.dart';
import 'package:lottery_flutter_application/view/result/result_power_view.dart';

import '../../models/response/together_ticket_item_search_response.dart';
import '../../models/response/together_ticket_response.dart';
import '../../utils/color_lot.dart';
import '../../utils/common.dart';
import '../../utils/dimen.dart';

class HistoryCompareTogetherView extends StatefulWidget {
  const HistoryCompareTogetherView(
      {Key? key,
      required this.ticket,
      required this.items,
      required this.mobile,
      this.details})
      : super(key: key);
  final TogetherTicketSearchResponse ticket;
  final List<TogetherTicketItemSearchResponse> items;
  final List<TogetherTicketDetail>? details;
  final String mobile;

  @override
  State<HistoryCompareTogetherView> createState() =>
      _HistoryCompareTogetherViewState();
}

class _HistoryCompareTogetherViewState
    extends State<HistoryCompareTogetherView> {
  List<TogetherTicketItemSearchResponse> myItems = [];

  @override
  void initState() {
    super.initState();

    myItems = widget.items
        .where((element) => element.mobileNumber == widget.mobile)
        .toList();
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
          title: const Text('So vé'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Scaffold(
          backgroundColor: ColorLot.ColorBackground,
          body: SingleChildScrollView(
            child: buildResult(widget.ticket),
          ),
        ));
  }

  Widget buildResult(TogetherTicketSearchResponse item) {
    if (item.productID == Common.ID_MEGA) {
      List<GetResultResponse> results = [];
      GetResultResponse result =
          GetResultResponse.fromJson(jsonDecode(item.result!));
      results.add(result);

      return Column(children: [
        SizedBox(
          height: 66,
          child: ResultMegaView(megaResults: results),
        ),
        Container(
          margin: EdgeInsets.all(Dimen.marginDefault),
          padding: EdgeInsets.all(Dimen.padingDefault),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 0.75))
              ],
              borderRadius:
                  BorderRadius.all(Radius.circular(Dimen.radiusBorder))),
          child: buildTicket(item),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: Dimen.marginDefault),
          padding: EdgeInsets.all(Dimen.padingDefault),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 0.75))
              ],
              borderRadius:
                  BorderRadius.all(Radius.circular(Dimen.radiusBorder))),
          child: buildMyTicket(item),
        ),
      ]);
    } else if (item.productID == Common.ID_POWER) {
      List<GetResultResponse> results = [];
      GetResultResponse result =
          GetResultResponse.fromJson(jsonDecode(item.result!));
      results.add(result);

      return Column(children: [
        SizedBox(
          height: 62,
          child: ResultPowerView(powerResults: results),
        ),
        Container(
          margin: EdgeInsets.all(Dimen.marginDefault),
          padding: EdgeInsets.all(Dimen.padingDefault),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 0.75))
              ],
              borderRadius:
                  BorderRadius.all(Radius.circular(Dimen.radiusBorder))),
          child: buildTicket(item),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: Dimen.marginDefault),
          padding: EdgeInsets.all(Dimen.padingDefault),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 0.75))
              ],
              borderRadius:
                  BorderRadius.all(Radius.circular(Dimen.radiusBorder))),
          child: buildMyTicket(item),
        ),
      ]);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildMyTicket(TogetherTicketSearchResponse item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textBold("Tiền thưởng của bạn:", Colors.black),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textBold("Tiền thưởng:", Colors.black),
            textBold(
                myItems.isNotEmpty
                    ? formatAmountD(myItems.fold(
                        0,
                        (previousValue, element) =>
                            previousValue + element.prize!))
                    : "0đ",
                ColorLot.ColorPrimary)
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textBold("Thuế (10%):", Colors.black),
            textBold(
                myItems.isNotEmpty
                    ? formatAmountD(myItems.fold(
                        0,
                        (previousValue, element) =>
                            previousValue + element.tax!))
                    : "0đ",
                ColorLot.ColorPrimary)
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textBold("Trả thưởng:", Colors.black),
            textBold(
                myItems.isNotEmpty
                    ? formatAmountD(myItems.fold(
                        0,
                        (previousValue, element) =>
                            previousValue + element.payout!))
                    : "0đ",
                ColorLot.ColorPrimary)
          ],
        )
      ],
    );
  }

  Widget buildTicket(TogetherTicketSearchResponse item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textBold("Vé bao chung:", Colors.black),
        _buildLine(item),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textBold("Tiền thưởng:", Colors.black),
            textBold(formatAmountD(item.prize), ColorLot.ColorPrimary)
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textBold("Thuế (10%):", Colors.black),
            textBold(formatAmountD(item.tax), ColorLot.ColorPrimary)
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textBold("Trả thưởng:", Colors.black),
            textBold(formatAmountD(item.payout), ColorLot.ColorPrimary)
          ],
        )
      ],
    );
  }

  Widget _buildLine(TogetherTicketSearchResponse item) {
    if (widget.details != null) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.details!.map((e) {
              return _buildLineDetail(e.numberOfLines!,
                  item.systematic!.toString(), item.prize!, item);
            }).toList()),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLineDetail(item.numberOfLines!, item.systematic!.toString(),
                item.prize!, item),
          ],
        ),
      );
    }
  }

  Widget _buildLineDetail(String line, String system, int amount,
      TogetherTicketSearchResponse item) {
    List<String> results = [];
    GetResultResponse mb = GetResultResponse.fromJson(jsonDecode(item.result!));
    results.addAll(mb.result!.split(','));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(
                child: Wrap(
              children: line.split(",").map((e) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(e,
                      style: TextStyle(
                          color: results.contains(e)
                              ? ColorLot.ColorPrimary
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                );
              }).toList(),
            )),
          ],
        )),
        SizedBox(
          width: 30,
          child: (amount > 0)
              ? Icon(Ionicons.trophy_outline, color: ColorLot.ColorSuccess)
              : SizedBox.shrink(),
        )
      ],
    );
  }
}
