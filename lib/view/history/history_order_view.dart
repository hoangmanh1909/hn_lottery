// ignore_for_file: unnecessary_new, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unnecessary_cast, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/config/api.dart';
import 'package:lottery_flutter_application/models/response/get_order_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/view/history/history_item_view.dart';

import '../../constants/common.dart';
import '../../utils/common.dart';
import 'history_item_keno_view.dart';

class HistoryOrderView extends StatefulWidget {
  const HistoryOrderView({Key? key, required this.orderModels})
      : super(key: key);

  final List<GetOrderResponse> orderModels;

  @override
  State<HistoryOrderView> createState() => _HistoryOrderViewState();
}

class _HistoryOrderViewState extends State<HistoryOrderView> {
  onItem(GetOrderResponse item) {
    if (item.productID == Common.ID_KENO) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HistoryItemKenoView(order: item)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HistoryItemView(order: item)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orderModels.isEmpty) {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Icon(
              Icons.content_paste_outlined,
              size: 40,
              color: Colors.black54,
            ),
            SizedBox(
              height: 10,
            ),
            Text("Bạn chưa có đơn hàng nào!")
          ],
        ),
      );
    }
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: widget.orderModels.map((item) {
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
                              child: (item.productID == 14 ||
                                      item.productID == 15)
                                  ? buildImageRadio(item.radioLogo)
                                  : Image(
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
                                  (item.productID == 7 ||
                                          item.productID == 14 ||
                                          item.productID == 15)
                                      ? Text(
                                          item.radioName!,
                                          style: TextStyle(
                                              fontSize: Dimen.fontSizeDefault),
                                        )
                                      : Text(
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
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
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
    case Common.ID_LOTTO_535:
      return AssetImage('assets/img/lotto535.png');
    default:
      return AssetImage('assets/img/mienbac.png');
  }
}

Image buildImageRadio(images) {
  return Image.network(
    urlImage + images!,
    width: 46,
    height: 46,
  );
}
