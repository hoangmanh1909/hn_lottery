import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/models/lottery_result_model.dart';

// Giả sử bạn đã có DictionaryController
// import 'package:lottery_flutter_application/controller/dictionary_controller.dart';

class FResultView extends StatefulWidget {
  const FResultView({super.key});

  @override
  State<FResultView> createState() => _FResultViewState();
}

class _FResultViewState extends State<FResultView> {
  // 1. Khai báo controller và biến chứa Future
  // final DictionaryController _controller = DictionaryController();
  late Future<List<LotteryResultModel>> _lotteryFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Hàm gọi server
  void _fetchData() {
    setState(() {
      _lotteryFuture = _getLotteryResults();
    });
  }

  // Logic gọi API (Bạn thay thế bằng logic thực tế từ DictionaryController của bạn)
  Future<List<LotteryResultModel>> _getLotteryResults() async {
    try {
      // Ví dụ: ResponseObject res = await _controller.getResults();
      // Ở đây mình giả lập delay server 2 giây
      await Future.delayed(const Duration(seconds: 2));

      // Dữ liệu giả lập (Sau này bạn parse từ res.data)
      return [
        LotteryResultModel(
            title: "Mega 6/45",
            numbers: ["01", "10", "21", "25", "39", "42"],
            prize: "18.735.000.000 đ",
            date: "Kỳ #1234 - 02/03/2026",
            type: "mega"),
        LotteryResultModel(
            title: "Power 6/55",
            numbers: ["05", "23", "35", "50", "10", "10"],
            prize: "52.355.000.000 đ",
            date: "Kỳ #1102 - 02/03/2026",
            type: "power"),
        LotteryResultModel(
            title: "Keno",
            numbers: ["23", "05", "69", "97", "95", "10"],
            prize: "Trúng 2.000.000 đ",
            date: "Kỳ #8872 - Giờ: 14:10",
            type: "keno"),
        LotteryResultModel(
            title: "Miền Bắc",
            numbers: ["1", "2", "3", "4", "5"],
            prize: "Giải đặc biệt",
            date: "Ngày 03/03/2026",
            type: "mien_bac"),
      ];
    } catch (e) {
      throw Exception("Không thể lấy dữ liệu từ máy chủ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _fetchData(), // Vuốt để cập nhật
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildSearchAndTabs(),
                    _buildDynamicContent(), // Nội dung động dựa trên API
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // 2. Xử lý logic hiển thị các trạng thái (Loading, Error, Success)
  Widget _buildDynamicContent() {
    return FutureBuilder<List<LotteryResultModel>>(
      future: _lotteryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator(color: Colors.red)),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Lỗi: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Không có dữ liệu kết quả."));
        }

        // Khi đã có dữ liệu thành công
        return _buildLotteryGrid(snapshot.data!);
      },
    );
  }

  // --- UI COMPONENTS ---

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              const Text("KẾT QUẢ XỔ SỐ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const Icon(Icons.notifications, color: Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          const Text("Thứ 3, 03/03/2026",
              style: TextStyle(color: Colors.white70)),
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
                _buildTabItem("Mega / Power", isActive: true),
                _buildTabItem("Keno"),
                _buildTabItem("Miền Bắc"),
                _buildTabItem("Miền Nam"),
              ],
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            decoration: InputDecoration(
              hintText: "Tìm kiếm kết quả xổ số...",
              prefixIcon: const Icon(Icons.search),
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

  Widget _buildTabItem(String title, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.red : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Text(title,
          style: TextStyle(
              color: isActive ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold)),
    );
  }

  // Đã chuyển thành GridView.builder để tối ưu hiệu năng
  Widget _buildLotteryGrid(List<LotteryResultModel> data) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72, // Điều chỉnh tỉ lệ để vừa với card
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return _buildLotteryCard(item);
      },
    );
  }

  Widget _buildLotteryCard(LotteryResultModel item) {
    // Logic xác định màu dựa trên type
    Color cardColor;
    switch (item.type) {
      case 'mega':
        cardColor = Colors.orange;
        break;
      case 'power':
        cardColor = Colors.red;
        break;
      case 'keno':
        cardColor = Colors.purple;
        break;
      default:
        cardColor = Colors.blue;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
                color: cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15))),
            child: Center(
                child: Text(item.title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(item.date,
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children:
                      item.numbers.map((n) => _buildNumberCircle(n)).toList(),
                ),
                const SizedBox(height: 10),
                Text(item.prize,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: cardColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(double.infinity, 30),
                  ),
                  child: const Text("Xem Kết Quả",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNumberCircle(String num) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!)),
      child: Center(
          child: Text(num,
              style:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang Chủ"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Kết Quả"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Thống Kê"),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: "Tin Tức"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá Nhân"),
      ],
    );
  }
}
