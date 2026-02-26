// ignore_for_file: unnecessary_new, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unnecessary_cast, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/models/request/search_order_history_request.dart';
import 'package:lottery_flutter_application/models/response/get_order_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/view/history/history_item_keno_view.dart';
import 'package:lottery_flutter_application/view/history/history_item_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/common.dart';
import '../../../controller/history_controller.dart';
import '../../../models/response/player_profile.dart';
import '../../../models/response/response_object.dart';
import '../../../utils/common.dart';
import '../../../utils/dialog_process.dart';

class TicketKenoFeedHistoryDetailView extends StatefulWidget {
  const TicketKenoFeedHistoryDetailView({Key? key, required this.code})
      : super(key: key);

  final String code;

  @override
  State<TicketKenoFeedHistoryDetailView> createState() =>
      _TicketKenoFeedHistoryDetailViewState();
}

class _TicketKenoFeedHistoryDetailViewState
    extends State<TicketKenoFeedHistoryDetailView> {
  final HistoryController _con = HistoryController();
  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;

  List<GetOrderResponse> orderList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initPref();
    });
  }

  initPref() async {
    _prefs = await SharedPreferences.getInstance();
    String? userMap = _prefs?.getString('user');
    if (userMap != null) {
      setState(() {
        playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      });
      getHistory();
    }
  }

  getHistory() async {
    if (mounted) showProcess(context);

    SearchOrderHistoryRequest req = SearchOrderHistoryRequest();
    req.mobileNumber = playerProfile!.mobileNumber!;
    req.codePayment = widget.code;
    req.productType = 4;

    ResponseObject res = await _con.searchHistory(req);
    if (res.code == "00") {
      orderList = List<GetOrderResponse>.from((jsonDecode(res.data!)
          .map((model) => GetOrderResponse.fromJson(model))));
      orderList.sort((a, b) => a.iD!.compareTo(b.iD!));
      setState(() {});
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  onItem(GetOrderResponse item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HistoryItemKenoView(order: item)));
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
          title: Text("Đơn hàng"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: buildBody());
  }

  Widget buildBody() {
    if (orderList.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: orderList.map((item) {
            return InkWell(
              onTap: () => onItem(item),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(12),
                              child: Image(
                                image: _buildImageProduct(item.productID),
                                width: 46,
                                height: 46,
                              )),
                          Padding(
                              padding: EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${item.name}",
                                    style: TextStyle(
                                        fontSize: Dimen.fontSizeValue,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    item.pIDNumber!,
                                    style: TextStyle(
                                        fontSize: Dimen.fontSizeDefault),
                                  ),
                                  Text(
                                    item.productName!,
                                    style: TextStyle(
                                        fontSize: Dimen.fontSizeDefault),
                                  ),
                                  Text(item.createdDate!,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: Dimen.fontSizeDefault))
                                ],
                              )),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("#${item.code}",
                                  style: TextStyle(
                                      fontSize: Dimen.fontSizeValue,
                                      color: Colors.black)),
                              buildStatus(item),
                              Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(formatAmountD(item.amount),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ColorLot.ColorPrimary)))
                            ],
                          )),
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey[200],
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

Widget buildStatus(GetOrderResponse item) {
  if (item.status == "S" || item.status == "D") {
    return Text(getOrderStatus(item.status),
        style: TextStyle(
            color: ColorLot.ColorWait, fontSize: Dimen.fontSizeAmount));
  } else if (item.status == "X") {
    return Text(getOrderStatus(item.status),
        style: TextStyle(
            color: ColorLot.ColorPrimary, fontSize: Dimen.fontSizeAmount));
  } else if (item.status == "A") {
    if (item.isResult == "Y" && item.isWin == "Y") {
      return Row(
        children: [
          Icon(
            Ionicons.trophy_outline,
            color: ColorLot.ColorSuccess,
            size: 20,
          ),
          SizedBox(
            width: 4,
          ),
          Text(getOrderStatus(item.status),
              style: TextStyle(
                  color: ColorLot.ColorSuccess, fontSize: Dimen.fontSizeAmount))
        ],
      );
    }
    if (item.isResult == "Y" && item.isWin == "N") {
      return Row(
        children: [
          Icon(
            Icons.laptop_mac_outlined,
            color: ColorLot.ColorPrimary,
            size: 20,
          ),
          SizedBox(
            width: 4,
          ),
          Text(getOrderStatus(item.status),
              style: TextStyle(
                  color: ColorLot.ColorSuccess, fontSize: Dimen.fontSizeAmount))
        ],
      );
    }
    return Text(getOrderStatus(item.status),
        style: TextStyle(
            color: ColorLot.ColorSuccess, fontSize: Dimen.fontSizeAmount));
  } else {
    return Text(getOrderStatus(item.status),
        style: TextStyle(
            color: ColorLot.ColorPrimary, fontSize: Dimen.fontSizeAmount));
  }
}

ImageProvider<Object> _buildImageProduct(productID) {
  switch (productID) {
    case Common.ID_KENO:
      return AssetImage('assets/img/keno.png');
    case Common.ID_MEGA:
      return AssetImage('assets/img/mega.png');
    case Common.ID_POWER:
      return AssetImage('assets/img/power.png');
    case Common.ID_MAX3D:
      return AssetImage('assets/img/max3dtrang.png');
    case Common.ID_MAX3D_PLUS:
      return AssetImage('assets/img/max3dcongtrang.png');
    case Common.ID_MAX3D_PRO:
      return AssetImage('assets/img/max_3dpro.png');
    default:
      return AssetImage('assets/img/mienbac.png');
  }
}
