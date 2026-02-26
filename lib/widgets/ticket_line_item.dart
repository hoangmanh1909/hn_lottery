import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/widgets/ticket_line.dart';

class TicketLineItem extends StatelessWidget {
  final String label;
  final List<String>? balls;
  final dynamic amount;
  final int systemType;
  final Function(String) onShowAmount;
  final Widget actionWidget;

  // Thêm callback xử lý chọn bóng
  final Function(String, int)
      onBallTap; // Truyền vào line (A,B,C) và index quả bóng

  const TicketLineItem({
    super.key,
    required this.label,
    this.balls,
    this.amount,
    required this.systemType,
    required this.onShowAmount,
    required this.actionWidget,
    required this.onBallTap, // Yêu cầu truyền vào
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 25,
            child: Text(label,
                style: const TextStyle(
                    color: ColorLot.ColorPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          Expanded(
            child: TicketLineView(
              system: systemType,
              listBall: balls,
              // Ở đây ta gọi callback truyền từ ngoài vào
              selectedBall: (line, balls) => onBallTap(line, balls.length),
              line: label,
            ),
          ),
          actionWidget,
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => onShowAmount(label),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(80, 30),
              fixedSize: const Size.fromHeight(30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
              side: BorderSide(width: 1, color: ColorLot.ColorPrimary),
            ),
            child: Text(
              formatAmount(amount),
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: ColorLot.ColorPrimary),
            ),
          )
        ],
      ),
    );
  }
}
