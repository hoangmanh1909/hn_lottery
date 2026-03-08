import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// Import các controller và model của bạn
import 'package:lottery_flutter_application/controller/result_controller.dart';
import 'package:lottery_flutter_application/models/lottery_result_model.dart';
import 'package:lottery_flutter_application/models/request/base_request.dart';
import 'package:lottery_flutter_application/models/request/xskt_base_request.dart';
import 'package:lottery_flutter_application/models/response/get_result_keno_response.dart';
import 'package:lottery_flutter_application/models/response/get_result_lotomb_response.dart';
import 'package:lottery_flutter_application/models/response/get_result_max3d_response.dart';
import 'package:lottery_flutter_application/models/response/get_result_response.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/view/main/base_detail_view.dart';
import 'package:lottery_flutter_application/view/result/result_keno_view.dart';
import 'package:lottery_flutter_application/view/result/result_lotto_535.dart';
import 'package:lottery_flutter_application/view/result/result_max3d_pro_view.dart';
import 'package:lottery_flutter_application/view/result/result_max3d_view.dart';
import 'package:lottery_flutter_application/view/result/result_mb_view.dart';
import 'package:lottery_flutter_application/view/result/result_mega_view.dart';
import 'package:lottery_flutter_application/view/result/result_miennam_view.dart';
import 'package:lottery_flutter_application/view/result/result_mientrung_view.dart';
import 'package:lottery_flutter_application/view/result/result_power_view.dart';

class FResultView extends StatefulWidget {
  const FResultView({super.key});

  @override
  State<FResultView> createState() => _FResultViewState();
}

class _FResultViewState extends State<FResultView> {
  final ResultController _controller = ResultController();
  late Future<List<LotteryResultModel>> _lotteryFuture;

  // Các biến phục vụ tìm kiếm
  List<LotteryResultModel> _allResults = [];
  List<LotteryResultModel> _filteredResults = [];
  List<GetResultResponse> megaResults = [];
  List<GetResultResponse> lotoResults = [];
  List<GetResultMax3DResponse> max3dProResults = [];
  List<GetResultMax3DResponse> max3dResults = [];
  List<GetResultResponse> powerResults = [];
  List<GetResultKenoResponse> kenoResults = [];
  List<GetResultLotoMBResponse> mnResults = [];
  List<GetResultLotoMBResponse> mbResults = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = "";

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi', null); // Khởi tạo tiếng Việt
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _lotteryFuture = _getLotteryResults();
    });
  }

  Future<List<LotteryResultModel>> _getLotteryResults() async {
    try {
      List<LotteryResultModel> results = [];
      ResponseObject resMB = await _controller.getResultMienBac();
      if (resMB.code == "00" && resMB.data != null) {
        var decoded = jsonDecode(resMB.data!);
        mbResults = List<GetResultLotoMBResponse>.from(
            decoded.map((model) => GetResultLotoMBResponse.fromJson(model)));

        if (mbResults.isNotEmpty) {
          results.add(LotteryResultModel(
            title: "Miền Bắc",
            numbers: mbResults.first.result
                    ?.split('')
                    .map((n) => n.trim())
                    .toList() ??
                [],
            prize: "Giải đặc biệt",
            date: mbResults.first.drawDate ?? "",
            type: "mienbac",
            bonus: "",
          ));
        }
      }

      ResponseObject resMienNam =
          await _controller.getXSKT(XSKTBaseRequest(iD: 3));
      if (resMienNam.code == "00" && resMienNam.data != null) {
        var decoded = jsonDecode(resMienNam.data!);
        mnResults = List<GetResultLotoMBResponse>.from(
            decoded.map((model) => GetResultLotoMBResponse.fromJson(model)));

        if (mnResults.isNotEmpty) {
          results.add(LotteryResultModel(
            title: "Miền Nam",
            numbers: mnResults.first.result
                    ?.split('')
                    .map((n) => n.trim())
                    .toList() ??
                [],
            prize: "Giải đặc biệt",
            date: mnResults.first.drawDate ?? "",
            type: "miennam",
            bonus: "",
          ));
        }
      }
      // 1. Keno
      ResponseObject resKeno = await _controller.getResultKeno();
      if (resKeno.code == "00" && resKeno.data != null) {
        var decoded = jsonDecode(resKeno.data!);
        kenoResults = List<GetResultKenoResponse>.from(
            decoded.map((model) => GetResultKenoResponse.fromJson(model)));

        if (kenoResults.isNotEmpty) {
          results.add(LotteryResultModel(
            title: "Keno",
            numbers: kenoResults.first.result
                    ?.split(',')
                    .map((n) => n.trim())
                    .toList() ??
                [],
            prize: "2.000.000.000 đ",
            date: kenoResults.first.drawDate ?? "",
            type: "keno",
            bonus: "",
          ));
        }
      }

      // 2. Power
      ResponseObject resPower = await _controller.getResultPower();
      if (resPower.code == "00" && resPower.data != null) {
        var decoded = jsonDecode(resPower.data!);
        powerResults = List<GetResultResponse>.from(
            decoded.map((model) => GetResultResponse.fromJson(model)));

        if (powerResults.isNotEmpty) {
          results.add(LotteryResultModel(
            title: "Power 6/55",
            numbers: powerResults.first.result
                    ?.split(',')
                    .map((n) => n.trim())
                    .toList() ??
                [],
            prize: formatAmount(powerResults.first.jackpot ?? 0),
            date: powerResults.first.drawDate ?? "",
            type: "power",
            bonus: powerResults.first.bonus ?? "",
          ));
        }
      }

      // 3. Mega
      ResponseObject resMega = await _controller.getResultMega645();
      if (resMega.code == "00" && resMega.data != null) {
        var decoded = jsonDecode(resMega.data!);
        megaResults = List<GetResultResponse>.from(
            decoded.map((model) => GetResultResponse.fromJson(model)));

        if (megaResults.isNotEmpty) {
          results.add(LotteryResultModel(
              title: "Mega 6/45",
              numbers: megaResults.first.result
                      ?.split(',')
                      .map((n) => n.trim())
                      .toList() ??
                  [],
              prize: formatAmount(megaResults.first.jackpot ?? 0),
              date: megaResults.first.drawDate ?? "",
              type: "mega",
              bonus: ""));
        }
      }

      ResponseObject resMax3d = await _controller.getResultMax3D();
      if (resMax3d.code == "00" && resMax3d.data != null) {
        var decoded = jsonDecode(resMax3d.data!);
        max3dResults = List<GetResultMax3DResponse>.from(
            decoded.map((model) => GetResultMax3DResponse.fromJson(model)));

        if (max3dResults.isNotEmpty) {
          results.add(LotteryResultModel(
              title: "Max 3D",
              numbers: max3dResults.first.resultST
                      ?.split(',')
                      .map((n) => n.trim())
                      .toList() ??
                  [],
              prize: "x100.000 lần",
              date: max3dResults.first.drawDate ?? "",
              type: "max3d",
              bonus: ""));
        }
      }

      ResponseObject resMax3dPro = await _controller.getResultMax3DPro();
      if (resMax3dPro.code == "00" && resMax3dPro.data != null) {
        var decoded = jsonDecode(resMax3dPro.data!);
        max3dProResults = List<GetResultMax3DResponse>.from(
            decoded.map((model) => GetResultMax3DResponse.fromJson(model)));

        if (max3dProResults.isNotEmpty) {
          results.add(LotteryResultModel(
            title: "Max 3D Pro",
            numbers: max3dProResults.first.resultST
                    ?.split(',')
                    .map((n) => n.trim())
                    .toList() ??
                [],
            prize: "x200.000 lần",
            date: max3dProResults.first.drawDate ?? "",
            type: "max3dpro",
            bonus: "",
          ));
        }
      }

      ResponseObject resLoto = await _controller.getResultLotto535();
      if (resLoto.code == "00" && resLoto.data != null) {
        var decoded = jsonDecode(resLoto.data!);
        lotoResults = List<GetResultResponse>.from(
            decoded.map((model) => GetResultResponse.fromJson(model)));

        if (lotoResults.isNotEmpty) {
          results.add(LotteryResultModel(
            title: "Loto 5/35",
            numbers: lotoResults.first.result
                    ?.split(',')
                    .map((n) => n.trim())
                    .toList() ??
                [],
            prize: lotoResults.first.jackpot! > 0
                ? formatAmount(lotoResults.first.jackpot!)
                : "Giải đặc biệt",
            date: lotoResults.first.drawDate ?? "",
            type: "loto535",
            bonus: lotoResults.first.bonus ?? "",
          ));
        }
      }

      _allResults = results;
      _filteredResults = results;
      return results;
    } catch (e) {
      throw Exception("Lỗi kết nối máy chủ");
    }
  }

  void _runFilter(String keyword) {
    setState(() {
      _selectedType = keyword; // Cập nhật Tab đang chọn

      if (keyword.isEmpty) {
        _filteredResults = _allResults;
      } else {
        // Lưu ý: Lọc chính xác theo type hoặc chứa trong title
        _filteredResults = _allResults
            .where((item) =>
                item.type.toLowerCase() == keyword.toLowerCase() ||
                item.title.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }
// Trong file f_result_view.dart của bạn:

  @override
  Widget build(BuildContext context) {
    // Không cần bọc thêm BottomNavigationBar ở đây nữa vì đã có ở MainShellView
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _fetchData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildSearchAndTabs(),
                    _buildDynamicContent(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicContent() {
    return FutureBuilder<List<LotteryResultModel>>(
      future: _lotteryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              height: 300,
              child:
                  Center(child: CircularProgressIndicator(color: Colors.red)));
        } else if (snapshot.hasError) {
          return Center(child: Text("Lỗi: ${snapshot.error}"));
        }

        if (_filteredResults.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text("Không tìm thấy kết quả phù hợp"),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: _filteredResults.length,
            itemBuilder: (context, index) =>
                _buildLotteryCard(_filteredResults[index]),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("KẾT QUẢ XỔ SỐ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(getCurrentDateManual(),
              style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildSearchAndTabs() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildTabItem("Tất cả",
                    type: "", isActive: _selectedType == ""),
                _buildTabItem("Miền Bắc",
                    type: "mienbac", isActive: _selectedType == "mienbac"),
                _buildTabItem("Miền Nam",
                    type: "miennam", isActive: _selectedType == "miennam"),
                _buildTabItem("Mega",
                    type: "mega", isActive: _selectedType == "mega"),
                _buildTabItem("Keno",
                    type: "keno", isActive: _selectedType == "keno"),
                _buildTabItem("Power",
                    type: "power", isActive: _selectedType == "power"),
                _buildTabItem("Loto 5/35",
                    type: "loto535", isActive: _selectedType == "loto535"),
                _buildTabItem("Max 3D",
                    type: "max3d", isActive: _selectedType == "max3d"),
                _buildTabItem("Max 3D Pro",
                    type: "max3dpro", isActive: _selectedType == "max3dpro"),
              ],
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _searchController,
            onChanged: _runFilter,
            decoration: InputDecoration(
              hintText: "Tìm nhanh: keno, mega...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _runFilter('');
                      })
                  : null,
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title,
      {required String type, bool isActive = false}) {
    return GestureDetector(
      onTap: () {
        _searchController
            .clear(); // Xóa text trong ô search khi bấm Tab cho đồng bộ
        _runFilter(type);
      },
      child: AnimatedContainer(
        // Dùng AnimatedContainer cho hiệu ứng chuyển màu mượt hơn
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [
                  BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2))
                ]
              : [],
          border: Border.all(
            color: isActive ? Colors.red : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black87,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Color _getCardColor(String type) {
    switch (type.toLowerCase()) {
      case 'mega':
        return ColorLot.ColorMega;
      case 'power':
        return ColorLot.ColorPower;
      case 'keno':
        return ColorLot.ColorKeno;
      case 'mienbac':
        return ColorLot.ColorXSKT;
      case 'miennam':
        return ColorLot.ColorRandomFast;
      case 'loto535':
        return ColorLot.ColorLotto535;
      case 'max3d':
        return ColorLot.Color3D;
      case 'max3dpro':
        return ColorLot.Color3DPro;
      default:
        return Colors.blueGrey; // Màu mặc định nếu không khớp loại nào
    }
  }

  Widget _buildLotteryCard(LotteryResultModel item) {
    Color cardColor = _getCardColor(item.type);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 35,
            width: double.infinity,
            decoration: BoxDecoration(
                color: cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15))),
            child: Center(
                child: Text(item.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13))),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(item.date,
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: [
                    // Vẽ danh sách số chính
                    ...item.numbers.map((n) => _buildNumberCircle(n)).toList(),

                    // Nếu có số bonus thì vẽ thêm một vòng tròn đặc biệt
                    if (item.bonus.isNotEmpty)
                      _buildNumberCircle(item.bonus, isBonus: true),
                  ],
                ),
                const SizedBox(height: 12),
                Text(item.prize,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: cardColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => actionProduct(item.type),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getCardColor(item.type).withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    minimumSize: const Size(double.infinity, 30),
                    elevation: 0,
                  ),
                  child: const Text("Chi tiết",
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  actionProduct(String type) {
    Widget detailScreen = const SizedBox();
    String title = "";

    switch (type.toLowerCase()) {
      case 'mega':
        title = "Kết quả Mega 6/45";
        detailScreen = ResultMegaView(megaResults: megaResults);
        break;
      case 'power':
        title = "Kết quả Power 6/55";
        detailScreen = ResultPowerView(powerResults: powerResults);
        break;
      case 'keno':
        title = "Kết quả Keno";
        detailScreen = ResultKenoView(kenoResults: kenoResults);
        break;
      case 'mienbac':
        title = "Kết quả Miền Bắc";
        detailScreen = ResultMienBacView(xsktMienBac: mbResults);
        break;
      case 'miennam':
        title = "Kết quả Miền Nam";
        detailScreen = ResultMienTrungView(xsktMienTrung: mnResults);
        break;
      case 'loto535':
        title = "Kết quả Loto 5/35";
        detailScreen = ResultLotto535View(powerResults: lotoResults);
        break;
      case 'max3d':
        title = "Kết quả Max 3D";
        detailScreen = ResultMax3DView(max3dResults: max3dResults);
        break;
      case 'max3dpro':
        title = "Kết quả Max 3D Pro";
        detailScreen = ResultMax3DProView(max3dResults: max3dProResults);
        break;
      default:
        return;
    }

    // PUSH CÁI KHUNG DÙNG CHUNG LÀ XONG!
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BaseDetailView(title: title, body: detailScreen),
      ),
    );
  }

  Widget _buildNumberCircle(String num, {bool isBonus = false}) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Nếu là số bonus thì tô nền vàng/đỏ, nếu không thì để trắng viền xám
        color: isBonus ? Colors.yellow[700] : Colors.white,
        border: Border.all(
          color: isBonus ? Colors.orange : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          num,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isBonus ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
