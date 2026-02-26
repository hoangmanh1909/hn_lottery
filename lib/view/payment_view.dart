import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/constants/common.dart';
import 'package:lottery_flutter_application/utils/dialog_notify_sucess.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/utils/head_balance_view.dart';
import 'package:lottery_flutter_application/utils/scaffold_messger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/utils/widget_divider.dart';
import 'package:lottery_flutter_application/controller/payment_controller.dart';
import 'package:lottery_flutter_application/models/request/order_add_request.dart';
import 'package:lottery_flutter_application/models/request/trans_payment_request.dart';
import 'package:lottery_flutter_application/models/response/player_profile.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';

class PaymentView extends StatefulWidget {
  final PlayerProfile profile;
  final OrderAddNewRequest order;
  final String code;
  final SharedPreferences? preferences;
  final int balance;
  final String mode;
  const PaymentView({
    super.key,
    required this.profile,
    required this.order,
    required this.code,
    required this.balance,
    this.preferences,
    required this.mode,
  });

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final PaymentController _con = PaymentController();
  bool _isLoading = false;
  Future<void> _handlePayment() async {
    setState(() => _isLoading = true);

    TransPaymentRequest req = TransPaymentRequest(
        fee: widget.order.fee,
        orderCode: widget.code,
        mobileNumber: widget.profile.mobileNumber);

    // Hiển thị loading overlay nếu cần (hoặc dùng biến _isLoading cho nút bấm)
    ResponseObject res = await _con.payment(req);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res.code == "00") {
      // Logic xử lý MAIN_INDEX dựa trên ProductID như code cũ của bro
      if (widget.order.productID == Common.ID_DIENTOAN_636 ||
          widget.order.productID == Common.ID_LOTO234 ||
          widget.order.productID == Common.ID_LOTO235) {
        widget.preferences?.setString(Common.MAIN_INDEX, "1");
      } else {
        widget.preferences?.setString(Common.MAIN_INDEX, "0");
      }

      // Thông báo thành công và đóng màn hình này
      // dialogBuilderSucess là widget cũ của bro
      dialogBuilderSucess(
          context, "Thanh toán thành công", "Mã đơn hàng ${widget.code}");

      // Có thể thêm Navigator.pop(context) sau khi đóng thông báo thành công
    } else {
      // Show lỗi nếu thất bại
      showMessage(context, res.message!, "98");
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalAmount = (widget.order.amount ?? 0) + (widget.order.fee ?? 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Thanh toán",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: ColorLot.ColorPrimary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsetsGeometry.only(
                    left: Dimen.marginDefault,
                    right: Dimen.marginDefault,
                    top: Dimen.marginDefault),
                child: headBalance(
                    widget.balance, widget.mode, widget.profile.mobileNumber!)),

            const SizedBox(height: 12),

            // Card chi tiết thông tin đơn hàng
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimen.marginDefault),
              padding: EdgeInsets.all(Dimen.padingDefault),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _infoRow("Hình thức nhận vé", "Đại lý giữ hộ"),
                  _infoRow("Mã đơn hàng", widget.code),
                  _infoRow("Họ tên", widget.profile.name ?? ""),
                  _infoRow("Số GTTT", widget.profile.pIDNumber ?? ""),
                  _infoRow("Email", widget.profile.emailAddress ?? ""),

                  dividerLot(), // Divider dùng chung của bro

                  _infoRow("Tiền vé", formatAmountD(widget.order.amount)),

                  // Hiển thị phí nếu có (logic buildFee cũ)
                  if (widget.order.fee != null && widget.order.fee! > 0)
                    _infoRow("Phí giao dịch", formatAmountD(widget.order.fee)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tổng tiền",
                          style: TextStyle(color: Colors.black54)),
                      Text(formatAmountD(totalAmount),
                          style: TextStyle(
                            color: ColorLot.ColorPrimary,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Nút Xác nhận
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handlePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorLot.ColorPrimary,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Xác nhận",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.black54, fontSize: 14)),
          const SizedBox(width: 10),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
