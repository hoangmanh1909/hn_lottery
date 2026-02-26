// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/constants/common.dart';
import 'package:lottery_flutter_application/controller/reward_controller.dart';
import 'package:lottery_flutter_application/models/request/reward_exchange_request.dart';
import 'package:lottery_flutter_application/models/response/bank_response.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/utils/dialog_process.dart';
import 'package:lottery_flutter_application/utils/widget_divider.dart';
import 'package:lottery_flutter_application/view/personal/reward_history_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/request/player_base_request.dart';
import '../../models/response/get_balance_response.dart';
import '../../models/response/player_profile.dart';
import '../../models/response/response_object.dart';
import '../../utils/color_lot.dart';
import '../../utils/dialog_notify_sucess.dart';
import '../../utils/dimen.dart';
import '../../utils/scaffold_messger.dart';

class RewardView extends StatefulWidget {
  const RewardView({Key? key, required this.type}) : super(key: key);
  final int type;
  @override
  State<RewardView> createState() => _RewardViewState();
}

class _RewardViewState extends State<RewardView> {
  final RewardController _con = RewardController();
  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;
  List<GetBalanceResponse>? balanceResponse;
  List<BankResponse>? banks;
  int balance = 0;
  BankResponse? selectedBank;

  final TextEditingController _amount = TextEditingController();
  final TextEditingController _accBank = TextEditingController();
  final TextEditingController _accNumber = TextEditingController();
  final TextEditingController _accNameNumber = TextEditingController();

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
      getBalance();
    }
    await getBank();
  }

  getBalance() async {
    if (playerProfile != null) {
      PlayerBaseRequest request =
          PlayerBaseRequest(mobileNumber: playerProfile!.mobileNumber!);
      ResponseObject res = await _con.getBalance(request);
      if (res.code == "00") {
        if (mounted) {
          balanceResponse = List<GetBalanceResponse>.from((jsonDecode(res.data!)
              .map((model) => GetBalanceResponse.fromJson(model))));
          GetBalanceResponse bl = balanceResponse!
              .where((element) => element.accountType == "W")
              .first;
          setState(() {
            balance = bl.amount!;
          });
        }
      }
    }
  }

  getBank() async {
    ResponseObject res = await _con.getBank();
    if (res.code == "00") {
      if (mounted) {
        banks = List<BankResponse>.from((jsonDecode(res.data!)
            .map((model) => BankResponse.fromJson(model))));
      }
    }
  }

  onOk() async {
    String amount = _amount.text.replaceAll(',', '');
    RewardExchangeAddRequest req = RewardExchangeAddRequest();
    req.method = Common.REWARD_TOPUP;
    if (amount == '') {
      showMessage(context, "Bạn chưa nhập số tiền đổi thưởng", "100");
      return;
    } else {
      if (int.parse(amount) <= 0) {
        showMessage(context, "Số tiền đổi thưởng phải lớn 0", "100");
        return;
      }
    }
    if (widget.type == 2) {
      if (selectedBank == null) {
        showMessage(context, "Bạn chưa chọn ngân hàng", "100");
        return;
      }
      if (_accNumber.text == '') {
        showMessage(context, "Bạn chưa nhập số tài khoản", "100");
        return;
      }
      if (_accNameNumber.text == '') {
        showMessage(context, "Bạn chưa nhập chủ tài khoản", "100");
        return;
      }
      req.accountName = _accNameNumber.text;
      req.accountNumber = _accNumber.text;
      req.bankID = selectedBank!.iD;
      req.method = Common.REWARD_BANK;
    }

    req.amount = int.parse(amount);
    req.totalAmount = int.parse(amount);
    req.mobileNumber = playerProfile!.mobileNumber!;

    showProcess(context);
    ResponseObject res = await _con.rewardExchangeAdd(req);
    if (context.mounted) Navigator.pop(context);
    if (res.code == "00") {
      if (context.mounted) {
        dialogBuilderSucess(context, "Đổi thưởng thành công",
            "Mã giao dịch ${jsonDecode(res.data!)["RetRefNumber"]}");
      }
    } else {
      if (context.mounted) showMessage(context, res.message!, "98");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorLot.ColorPrimary,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          title: const Text('Đổi thưởng'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.history,
                color: Colors.white,
              ),
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RewardHistoryView()));
                });
              },
            )
          ],
        ),
        body: Scaffold(
            backgroundColor: ColorLot.ColorBackground,
            body: Container(
                height: size.height,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Ionicons.wallet_outline,
                              size: 20, color: ColorLot.ColorPrimary),
                          Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text("Số dư đổi thưởng"),
                          )
                        ],
                      ),
                      Text(
                        formatAmountD(balance),
                        style: TextStyle(
                            color: ColorLot.ColorPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.all(Dimen.padingDefault),
                      margin: EdgeInsets.only(
                          left: Dimen.marginDefault,
                          right: Dimen.marginDefault,
                          top: Dimen.marginDefault),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimen.radiusBorder)),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _amount,
                            keyboardType: TextInputType.number,
                            onChanged: (string) {
                              string = (string != ''
                                  ? formatAmount(
                                      int.parse(string.replaceAll(',', '')))
                                  : '');
                              _amount.value = TextEditingValue(
                                text: string,
                                selection: TextSelection.collapsed(
                                    offset: string.length),
                              );
                            },
                            decoration: InputDecoration(
                              hintText: "Nhập số tiền đổi thưởng",
                              labelText: "Số tiền đổi thưởng",
                              floatingLabelStyle:
                                  TextStyle(color: ColorLot.ColorPrimary),
                              counterText: "",
                              isDense: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorLot.ColorPrimary),
                              ),
                            ),
                          ),
                          widget.type == 2 ? _buildBank() : SizedBox.shrink()
                        ],
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: onOk,
                    child: Container(
                      height: 40,
                      width: size.width - 32,
                      decoration: BoxDecoration(
                          color: ColorLot.ColorPrimary,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                          child: Text(
                        "Xác nhận",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                ]))));
  }

  void openDialog() async {
    BankResponse? bankModel =
        await Navigator.of(context).push(MaterialPageRoute<BankResponse>(
            builder: (BuildContext context) {
              return BankDialog(
                banks: banks ?? [],
              );
            },
            fullscreenDialog: true));
    if (bankModel != null) {
      setState(() {
        selectedBank = bankModel;
        _accBank.text = selectedBank!.shortName!;
      });
    }
  }

  Widget _buildBank() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 10,
      ),
      TextFormField(
        onTap: openDialog,
        readOnly: true,
        controller: _accBank,
        decoration: InputDecoration(
          hintText: "Chọn ngân hàng",
          labelText: "Ngân hàng",
          counterText: "",
          isDense: true,
          floatingLabelStyle: TextStyle(color: ColorLot.ColorPrimary),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorLot.ColorPrimary),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: _accNumber,
        decoration: InputDecoration(
          hintText: "Nhập số tài khoản",
          labelText: "Số tài khoản",
          floatingLabelStyle: TextStyle(color: ColorLot.ColorPrimary),
          counterText: "",
          isDense: true,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorLot.ColorPrimary),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: _accNameNumber,
        decoration: InputDecoration(
          hintText: "Nhập chủ tài khoản",
          labelText: "Chủ tài khoản",
          floatingLabelStyle: TextStyle(color: ColorLot.ColorPrimary),
          counterText: "",
          isDense: true,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorLot.ColorPrimary),
          ),
        ),
      ),
    ]);
  }
}

class BankDialog extends StatelessWidget {
  const BankDialog({super.key, required this.banks});

  final List<BankResponse> banks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorLot.ColorPrimary,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          title: const Text('Chọn ngân hàng'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(color: Colors.white),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: banks.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).pop(banks[index]);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    banks[index].shortName!.trim(),
                                  ),
                                  Icon(
                                    Ionicons.chevron_forward_outline,
                                    size: 18,
                                    color: Colors.black54,
                                  )
                                ],
                              )),
                          dividerLot()
                        ],
                      ));
                })));
  }
}
