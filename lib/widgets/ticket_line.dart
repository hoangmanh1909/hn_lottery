import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/widgets/custom_button.dart';

class TicketLineView extends StatefulWidget {
  TicketLineView(
      {super.key,
      required this.system,
      required this.listBall,
      required this.line,
      required this.selectedBall});

  final int system;
  List<String>? listBall;
  final String line;
  final Function selectedBall;

  @override
  State<TicketLineView> createState() => _TicketLineViewState();
}

class _TicketLineViewState extends State<TicketLineView> {
  StateSetter? _setState;
  List<String> balss =
      List.generate(100, (index) => (index).toString().padLeft(2, '0'));

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
                      Text("Bạn đã chọn : ${_balls.length}"),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          CustomButton(
                              label: "Chọn lại",
                              backgroundColor: ColorLot.ColorPrimary,
                              onPressed: onClear),
                          SizedBox(
                            width: 10,
                          ),
                          CustomButton(
                              label: "Đồng ý",
                              backgroundColor: ColorLot.ColorBaoChung,
                              onPressed: onSelectedBall)
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
      width: size.width - 180,
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
                            fontSize: 14,
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
