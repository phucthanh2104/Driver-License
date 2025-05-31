import 'package:flutter/material.dart';

class ReviewSignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      // Updated to 6 tabs: Prohibition, Warning, Instruction, Direction, Auxiliary, Road Markings


      child: Scaffold(
        appBar: AppBar(
          title: Text('Biển báo đường bộ'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Quay lại màn hình trước
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0), // Độ cao của TabBar
            child: Builder(
              builder: (context) {
                final padding = MediaQuery.of(context).padding.left; // Lấy padding hệ thống bên trái
                return Transform.translate(
                  offset: Offset(-padding - 33.0, 0.0), // Dịch chuyển dựa trên padding hệ thống + thêm một chút để sát mép
                  child: TabBar(
                    isScrollable: true, // Cho phép cuộn ngang
                    labelColor: Colors.black, // Màu chữ tab được chọn
                    unselectedLabelColor: Colors.black87, // Màu chữ tab không được chọn
                    indicatorColor: Colors.black, // Màu đường gạch dưới
                    labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Kiểu chữ tab được chọn
                    unselectedLabelStyle: TextStyle(fontSize: 14), // Kiểu chữ tab không được chọn
                    padding: EdgeInsets.zero, // Loại bỏ padding ngoài cùng
                    indicatorPadding: EdgeInsets.zero, // Loại bỏ padding của indicator
                    labelPadding: EdgeInsets.symmetric(horizontal: 8.0), // Điều chỉnh khoảng cách giữa các tab
                    tabs: [
                      Tab(text: 'Biển báo cấm'),
                      Tab(text: 'Biển báo nguy hiểm'),
                      Tab(text: 'Biển báo hiệu lệnh'),
                      Tab(text: 'Biển báo chỉ dẫn'),
                      Tab(text: 'Biển báo phụ'),
                      Tab(text: 'Vạch kẻ đường'),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Prohibition Signs
            ListView(
              children: [
                SignTile(
                  code: 'P.101',
                  description: 'Đường cấm',
                  imagePath: 'assets/signs/cam/signP101.png',
                ),
                SignTile(
                  code: 'P.102',
                  description: 'Cấm đi ngược chiều',
                  imagePath: 'assets/signs/cam/signP102.png',
                ),
                SignTile(
                  code: 'P.103a',
                  description: 'Cấm ô tô',
                  imagePath: 'assets/signs/cam/signP103a.png',
                ),
                SignTile(
                  code: 'P.103b',
                  description: 'Cấm ô tô rẽ phải',
                  imagePath: 'assets/signs/cam/signP103b.png',
                ),
                SignTile(
                  code: 'P.103c',
                  description: 'Cấm ô tô rẽ trái',
                  imagePath: 'assets/signs/cam/signP103c.png',
                ),
                SignTile(
                  code: 'P.104',
                  description: 'Cấm mô tô',
                  imagePath: 'assets/signs/cam/signP104.png',
                ),
                SignTile(
                  code: 'P.105',
                  description: 'Cấm ô tô và mô tô',
                  imagePath: 'assets/signs/cam/signP105.png',
                ),
                SignTile(
                  code: 'P.106a',
                  description: 'Cấm ô tô tải',
                  imagePath: 'assets/signs/cam/signP106a.png',
                ),
                SignTile(
                  code: 'P.106b',
                  description: 'Cấm ô tô tải theo trọng lượng',
                  imagePath: 'assets/signs/cam/signP106b.png',
                ),
                SignTile(
                  code: 'P.106c',
                  description: 'Cấm ô tô tải chở hàng nguy hiểm',
                  imagePath: 'assets/signs/cam/signP106c.png',
                ),
                SignTile(
                  code: 'P.107',
                  description: 'Cấm ô tô khách và ô tô tải',
                  imagePath: 'assets/signs/cam/signP107.png',
                ),
                SignTile(
                  code: 'P.107a',
                  description: 'Cấm ô tô khách',
                  imagePath: 'assets/signs/cam/signP107a.png',
                ),
                SignTile(
                  code: 'P.107b',
                  description: 'Cấm xe taxi',
                  imagePath: 'assets/signs/cam/signP107b.png',
                ), SignTile(
                  code: 'P.108',
                  description: 'Cấm ô tô kéo rơ moóc',
                  imagePath: 'assets/signs/cam/signP108.png',
                ), SignTile(
                  code: 'P.108a',
                  description: 'Cấm xe sơ-mi rơ-moóc',
                  imagePath: 'assets/signs/cam/signP108a.png',
                ), SignTile(
                  code: 'P.109',
                  description: 'Cấm máy kéo',
                  imagePath: 'assets/signs/cam/signP109.png',
                ), SignTile(
                  code: 'P.110a',
                  description: 'Cấm xe đạp',
                  imagePath: 'assets/signs/cam/signP110a.png',
                ), SignTile(
                  code: 'P.110b',
                  description: 'Cấm xe đạp thồ',
                  imagePath: 'assets/signs/cam/signP110b.png',
                ), SignTile(
                  code: 'P.111a',
                  description: 'Cấm xe gắn máy',
                  imagePath: 'assets/signs/cam/signP111a.png',
                ), SignTile(
                  code: 'P.112',
                  description: 'Cấm người đi bộ',
                  imagePath: 'assets/signs/cam/signP112.png',
                ), SignTile(
                  code: 'P.113',
                  description: 'Cấm xe người kéo, đẩy',
                  imagePath: 'assets/signs/cam/signP113.png',
                ), SignTile(
                  code: 'P.114',
                  description: 'Cấm xe súc vật kéo',
                  imagePath: 'assets/signs/cam/signP114.png',
                ), SignTile(
                  code: 'P.115',
                  description: 'Hạn chế trọng lượng xe',
                  imagePath: 'assets/signs/cam/signP115.png',
                ), SignTile(
                  code: 'P.116',
                  description: 'Hạn chế trọng lượng trên trục xe',
                  imagePath: 'assets/signs/cam/signP116.png',
                ),
                SignTile(
                  code: 'P.117',
                  description: 'Hạn chế chiều cao',
                  imagePath: 'assets/signs/cam/signP117.png',
                ),
                SignTile(
                  code: 'P.118',
                  description: 'Hạn chế chiều ngang',
                  imagePath: 'assets/signs/cam/signP118.png',
                ),
                SignTile(
                  code: 'P.119',
                  description: 'Hạn chế chiều dài ô tô',
                  imagePath: 'assets/signs/cam/signP119.png',
                ),
                SignTile(
                  code: 'P.120',
                  description: 'Hạn chế chiều dài ô tô kéo moóc',
                  imagePath: 'assets/signs/cam/signP120.png',
                ),
                SignTile(
                  code: 'P.121',
                  description: 'Cự ly tối thiểu giữa hai xe',
                  imagePath: 'assets/signs/cam/signP121.png',
                ),
                SignTile(
                  code: 'P.123a',
                  description: 'Cấm rẽ trái',
                  imagePath: 'assets/signs/cam/signP123a.png',
                ),
                SignTile(
                  code: 'P.123b',
                  description: 'Cấm rẽ phải',
                  imagePath: 'assets/signs/cam/signP123b.png',
                ),
                SignTile(
                  code: 'P.124a',
                  description: 'Cấm quay đầu xe',
                  imagePath: 'assets/signs/cam/signP124a.png',
                ),
                SignTile(
                  code: 'P.124b',
                  description: 'Cấm ô tô quay đầu',
                  imagePath: 'assets/signs/cam/signP124b.png',
                ),
                SignTile(
                  code: 'P.124c',
                  description: 'Cấm rẽ trái và quay đầu xe',
                  imagePath: 'assets/signs/cam/signP124c.png',
                ),
                SignTile(
                  code: 'P.124d',
                  description: 'Cấm rẽ phải và quay đầu xe',
                  imagePath: 'assets/signs/cam/signP124d.png',
                ),
                SignTile(
                  code: 'P.124e',
                  description: 'Cấm ô tô rẽ trái và quay xe',
                  imagePath: 'assets/signs/cam/signP124e.png',
                ),
                SignTile(
                  code: 'P.124f',
                  description: 'Cấm ô tô rẽ phải và quay xe',
                  imagePath: 'assets/signs/cam/signP124f.png',
                ),
                SignTile(
                  code: 'P.125',
                  description: 'Cấm vượt',
                  imagePath: 'assets/signs/cam/signP125.png',
                ),
                SignTile(
                  code: 'P.126',
                  description: 'Cấm ôtô tải vượt',
                  imagePath: 'assets/signs/cam/signP126.png',
                ),
                SignTile(
                  code: 'P.127a',
                  description: 'Tốc độ tối đa cho phép về ban đêm',
                  imagePath: 'assets/signs/cam/signP127a.png',
                ),
                SignTile(
                  code: 'P.127b',
                  description: 'Tốc độ tối đa trên từng làn đường',
                  imagePath: 'assets/signs/cam/signP127b.png',
                ),
                SignTile(
                  code: 'P.127c',
                  description: 'Tốc độ tối đa phương tiện trên từng làn đường',
                  imagePath: 'assets/signs/cam/signP127c.png',
                ),
                SignTile(
                  code: 'P.127d',
                  description: 'Biển hết hạn chế tốc độ tối đa',
                  imagePath: 'assets/signs/cam/signP127d.png',
                ),
                SignTile(
                  code: 'P.128',
                  description: 'Cấm bóp còi',
                  imagePath: 'assets/signs/cam/signP128.png',
                ),  SignTile(
                  code: 'P.129',
                  description: 'Kiểm tra',
                  imagePath: 'assets/signs/cam/signP129.png',
                ),  SignTile(
                  code: 'P.130',
                  description: 'Cấm dừng và đỗ xe',
                  imagePath: 'assets/signs/cam/signP130.png',
                ),  SignTile(
                  code: 'P.131a',
                  description: 'Cấm đỗ xe',
                  imagePath: 'assets/signs/cam/signP131a.png',
                ),  SignTile(
                  code: 'P.131b',
                  description: 'Cấm đỗ xe ngày lẻ',
                  imagePath: 'assets/signs/cam/signP131b.png',
                ),  SignTile(
                  code: 'P.131c',
                  description: 'Cấm đỗ xe ngày chẵn',
                  imagePath: 'assets/signs/cam/signP131c.png',
                ),  SignTile(
                  code: 'P.132',
                  description: 'Nhường cho xe ngược chiều qua đường hẹp',
                  imagePath: 'assets/signs/cam/signP132.png',
                ),  SignTile(
                  code: 'DP.133',
                  description: 'Hết cấm vượt',
                  imagePath: 'assets/signs/cam/signDP133.png',
                ),  SignTile(
                  code: 'DP.134',
                  description: 'Hết hạn chế tốc độ tối đa',
                  imagePath: 'assets/signs/cam/signDP134.png',
                ),  SignTile(
                  code: 'DP.135',
                  description: 'Hết tất cả các lệnh cấm',
                  imagePath: 'assets/signs/cam/signDP135.png',
                ),  SignTile(
                  code: 'P.136',
                  description: 'Cấm đi thẳng',
                  imagePath: 'assets/signs/cam/signP136.png',
                ),  SignTile(
                  code: 'P.137',
                  description: 'Cấm rẽ trái và rẽ phải',
                  imagePath: 'assets/signs/cam/signP137.png',
                ),  SignTile(
                  code: 'P.138',
                  description: 'Cấm đi thẳng và rẽ trái',
                  imagePath: 'assets/signs/cam/signP138.png',
                ),  SignTile(
                  code: 'P.139',
                  description: 'Cấm đi thẳng và rẽ phải',
                  imagePath: 'assets/signs/cam/signP139.png',
                ),  SignTile(
                  code: 'P.140',
                  description: 'Cấm xe công nông và các loại xe tương tự',
                  imagePath: 'assets/signs/cam/signP140.png',
                ),  SignTile(
                  code: 'S.508a',
                  description: 'Biển cấm theo giờ',
                  imagePath: 'assets/signs/cam/signS508a.png',
                ),  SignTile(
                  code: 'S.508b',
                  description: 'Biển cấm theo giờ',
                  imagePath: 'assets/signs/cam/signS508b.png',
                )






























              ],
            ),
            // Tab 2: Warning Signs
            ListView(
              children: [
                SignTile(
                  code: 'W.201a',
                  description: 'Chỗ ngoặt nguy hiểm bên trái',
                  imagePath: 'assets/signs/danger/signW201a.png',
                ),
                SignTile(
                  code: 'W.201b',
                  description: 'Chỗ ngoặt nguy hiểm bên phải',
                  imagePath: 'assets/signs/danger/signW201b.png',
                ),
                SignTile(
                  code: 'W.201c',
                  description: 'Chỗ ngoặt nguy hiểm có nguy cơ lật bên phải',
                  imagePath: 'assets/signs/danger/signW201c.png',
                ),
                SignTile(
                  code: 'W.201d',
                  description: 'Chỗ ngoặt nguy hiểm có nguy cơ lật bên trái',
                  imagePath: 'assets/signs/danger/signW201d.png',
                ),
                SignTile(
                  code: 'W.202a',
                  description: 'Nhiều chỗ ngoặt nguy hiểm liên tiếp',
                  imagePath: 'assets/signs/danger/signW202a.png',
                ),
                SignTile(
                  code: 'W.202b',
                  description: 'Nhiều chỗ ngoặt nguy hiểm liên tiếp',
                  imagePath: 'assets/signs/danger/signW202b.png',
                ),
                SignTile(
                  code: 'W.203a',
                  description: 'Đường bị hẹp cả hai bên',
                  imagePath: 'assets/signs/danger/signW203a.png',
                ),
                SignTile(
                  code: 'W.203b',
                  description: 'Đường bị hẹp bên trái',
                  imagePath: 'assets/signs/danger/signW203b.png',
                ),
                SignTile(
                  code: 'W.203c',
                  description: 'Đường bị hẹp bên phải',
                  imagePath: 'assets/signs/danger/signW203c.png',
                ),
                SignTile(
                  code: 'W.204',
                  description: 'Đường hai chiều',
                  imagePath: 'assets/signs/danger/signW204.png',
                ),
                SignTile(
                  code: 'W.205a',
                  description: 'Nơi giao nhau của đường đồng cấp',
                  imagePath: 'assets/signs/danger/signW205a.png',
                ),
                SignTile(
                  code: 'W.205b',
                  description: 'Nơi giao nhau của đường đồng cấp',
                  imagePath: 'assets/signs/danger/signW205b.png',
                ),
                SignTile(
                  code: 'W.205c',
                  description: 'Nơi giao nhau của đường đồng cấp',
                  imagePath: 'assets/signs/danger/signW205c.png',
                ),
                SignTile(
                  code: 'W.205d',
                  description: 'Nơi giao nhau của đường đồng cấp',
                  imagePath: 'assets/signs/danger/signW205d.png',
                ),
                SignTile(
                  code: 'W.205e',
                  description: 'Nơi giao nhau của đường đồng cấp',
                  imagePath: 'assets/signs/danger/signW205e.png',
                ),
                SignTile(
                  code: 'W.206',
                  description: 'Giao nhau chạy theo vòng xuyến',
                  imagePath: 'assets/signs/danger/signW206.png',
                ),
                SignTile(
                  code: 'W.207a',
                  description: 'Giao nhau với đường không ưu tiên',
                  imagePath: 'assets/signs/danger/signW207a.png',
                ),
                SignTile(
                  code: 'W.207b',
                  description: 'Giao nhau với đường không ưu tiên',
                  imagePath: 'assets/signs/danger/signW207b.png',
                ),
                SignTile(
                  code: 'W.207c',
                  description: 'Giao nhau với đường không ưu tiên',
                  imagePath: 'assets/signs/danger/signW207c.png',
                ),
                SignTile(
                  code: 'W.207d',
                  description: 'Giao nhau với đường không ưu tiên',
                  imagePath: 'assets/signs/danger/signW207d.png',
                ),SignTile(
                  code: 'W.207e',
                  description: 'Giao nhau với đường không ưu tiên',
                  imagePath: 'assets/signs/danger/signW207e.png',
                ),
                SignTile(
                  code: 'W.207f',
                  description: 'Giao nhau với đường không ưu tiên',
                  imagePath: 'assets/signs/danger/signW207f.png',
                ),
                SignTile(
                  code: 'W.207g',
                  description: 'Giao nhau với đường không ưu tiên',
                  imagePath: 'assets/signs/danger/signW207g.png',
                ),SignTile(
                  code: 'W.207h',
                  description: 'Giao nhau với đường không ưu tiên',
                  imagePath: 'assets/signs/danger/signW207h.png',
                ),
                SignTile(
                  code: 'W.207i',
                  description: 'Giao nhau với đường không ưu tiên',
                  imagePath: 'assets/signs/danger/signW207i.png',
                ),
                SignTile(
                  code: 'W.207k',
                  description: 'Giao nhau với đường không ưu tiên',
                  imagePath: 'assets/signs/danger/signW207k.png',
                ),
                SignTile(
                  code: 'W.207l',
                  description: 'Giao nhau với đường không ưu tiên',
                  imagePath: 'assets/signs/danger/signW207l.png',
                ),
                SignTile(
                  code: 'W.208',
                  description: 'Giao nhau với đường ưu tiên',
                  imagePath: 'assets/signs/danger/signW208.png',
                ),
                SignTile(
                  code: 'W.209',
                  description: 'Giao nhau có tín hiệu đèn',
                  imagePath: 'assets/signs/danger/signW209.png',
                ),
                SignTile(
                  code: 'W.210',
                  description: 'Giao nhau với đường sắt có rào chắn',
                  imagePath: 'assets/signs/danger/signW210.png',
                ),
                SignTile(
                  code: 'W.211a',
                  description: 'Giao nhau với đường sắt không có rào chắn',
                  imagePath: 'assets/signs/danger/signW211a.png',
                ),
                SignTile(
                  code: 'W.211b',
                  description: 'Giao nhau với đường tàu điện',
                  imagePath: 'assets/signs/danger/signW211b.png',
                ),
                SignTile(
                  code: 'W.212',
                  description: 'Cầu hẹp',
                  imagePath: 'assets/signs/danger/signW212.png',
                ),
                SignTile(
                  code: 'W.213',
                  description: 'Cầu tạm',
                  imagePath: 'assets/signs/danger/signW213.png',
                ),
                SignTile(
                  code: 'W.214',
                  description: 'Cầu xoay-cầu cất',
                  imagePath: 'assets/signs/danger/signW214.png',
                ),
                SignTile(
                  code: 'W.215a',
                  description: 'Kè, vực sâu phía trước',
                  imagePath: 'assets/signs/danger/signW215a.png',
                ),
                SignTile(
                  code: 'W.215b',
                  description: 'Kè, vực sâu bên đường phía bên phải',
                  imagePath: 'assets/signs/danger/signW215b.png',
                ), SignTile(
                  code: 'W.215c',
                  description: 'Kè, vực sâu bên đường phía bên trái',
                  imagePath: 'assets/signs/danger/signW215c.png',
                ),
                SignTile(
                  code: 'W.216a',
                  description: 'Đường ngầm',
                  imagePath: 'assets/signs/danger/signW216a.png',
                ),
                SignTile(
                  code: 'W.216b',
                  description: 'Đường ngầm có nguy cơ lũ quét',
                  imagePath: 'assets/signs/danger/signW216b.png',
                ),
                SignTile(
                  code: 'W.217',
                  description: 'Bến phà',
                  imagePath: 'assets/signs/danger/signW217.png',
                ),
                SignTile(
                  code: 'W.218',
                  description: 'Cửa chui',
                  imagePath: 'assets/signs/danger/signW218.png',
                ), SignTile(
                  code: 'W.219',
                  description: 'Dốc xuống nguy hiểm',
                  imagePath: 'assets/signs/danger/signW219.png',
                ), SignTile(
                  code: 'W.220',
                  description: 'Dốc lên nguy hiểm',
                  imagePath: 'assets/signs/danger/signW220.png',
                ), SignTile(
                  code: 'W.221a',
                  description: 'Đường ổ gà, sống trâu',
                  imagePath: 'assets/signs/danger/signW221a.png',
                ),
                SignTile(
                  code: 'W.221b',
                  description: 'Đường có gồ giảm tốc',
                  imagePath: 'assets/signs/danger/signW221b.png',
                ),
                SignTile(
                  code: 'W.222a',
                  description: 'Đường trơn',
                  imagePath: 'assets/signs/danger/signW222a.png',
                ),
                SignTile(
                  code: 'W.222b',
                  description: 'Lề đường nguy hiểm',
                  imagePath: 'assets/signs/danger/signW222b.png',
                ), SignTile(
                  code: 'W.223a',
                  description: 'Vách núi nguy hiểm',
                  imagePath: 'assets/signs/danger/signW223b.png',
                ),
                SignTile(
                  code: 'W.224',
                  description: 'Đường người đi bộ cắt ngang',
                  imagePath: 'assets/signs/danger/signW224.png',
                ),
                SignTile(
                  code: 'W.225',
                  description: 'Trẻ em',
                  imagePath: 'assets/signs/danger/signW225.png',
                ),
                SignTile(
                  code: 'W.226',
                  description: 'Đường người đi xe đạp cắt ngang',
                  imagePath: 'assets/signs/danger/signW226.png',
                ),
                SignTile(
                  code: 'W.227',
                  description: 'Công trường',
                  imagePath: 'assets/signs/danger/signW227.png',
                ),
                SignTile(
                  code: 'W.228a',
                  description: 'Đá lở',
                  imagePath: 'assets/signs/danger/signW228a.png',
                ),
                SignTile(
                  code: 'W.228b',
                  description: 'Đá lở',
                  imagePath: 'assets/signs/danger/signW228b.png',
                ), SignTile(
                  code: 'W.228c',
                  description: 'Sỏi đá bắn lên',
                  imagePath: 'assets/signs/danger/signW228c.png',
                ), SignTile(
                  code: 'W.228d',
                  description: 'Nền đường yếu',
                  imagePath: 'assets/signs/danger/signW228d.png',
                ), SignTile(
                  code: 'W.229',
                  description: 'Dải máy bay lên xuống',
                  imagePath: 'assets/signs/danger/signW229.png',
                ),
                SignTile(
                  code: 'W.230',
                  description: 'Gia súc',
                  imagePath: 'assets/signs/danger/signW230.png',
                ), SignTile(
                  code: 'W.231',
                  description: 'Thú rừng vượt qua đường',
                  imagePath: 'assets/signs/danger/signW231.png',
                ), SignTile(
                  code: 'W.232',
                  description: 'Gió ngang',
                  imagePath: 'assets/signs/danger/signW232.png',
                ), SignTile(
                  code: 'W.233',
                  description: 'Nguy hiểm khác',
                  imagePath: 'assets/signs/danger/signW233.png',
                ), SignTile(
                  code: 'W.234',
                  description: 'Giao nhau với đường hai chiều',
                  imagePath: 'assets/signs/danger/signW234.png',
                ), SignTile(
                  code: 'W.235',
                  description: 'Đường đôi',
                  imagePath: 'assets/signs/danger/signW235.png',
                ), SignTile(
                  code: 'W.236',
                  description: 'Hết đường đôi',
                  imagePath: 'assets/signs/danger/signW236.png',
                ), SignTile(
                  code: 'W.237',
                  description: 'Đường có độ vòng lớn',
                  imagePath: 'assets/signs/danger/signW237.png',
                ),
                SignTile(
                  code: 'W.238',
                  description: 'Đường cao tốc phía trước',
                  imagePath: 'assets/signs/danger/signW238.png',
                ), SignTile(
                  code: 'W.239',
                  description: 'Đường cáp điện ở phía trên',
                  imagePath: 'assets/signs/danger/signW239.png',
                ), SignTile(
                  code: 'W.240',
                  description: 'Đường hầm phía trước',
                  imagePath: 'assets/signs/danger/signW240.png',
                ),
                SignTile(
                  code: 'W.241',
                  description: 'Ùn tắc giao thông',
                  imagePath: 'assets/signs/danger/signW241.png',
                ),
                SignTile(
                  code: 'W.242a',
                  description: 'Nơi đường sắt giao vuông góc với đường bộ',
                  imagePath: 'assets/signs/danger/signW242a.png',
                ), SignTile(
                  code: 'W.242b',
                  description: 'Nơi 2 đường sắt giao nhau với đường bộ',
                  imagePath: 'assets/signs/danger/signW242b.png',
                ), SignTile(
                  code: 'W.243a',
                  description: 'Nơi đường sắt giao không vuông góc với đường bộ',
                  imagePath: 'assets/signs/danger/signW243a.png',
                ), SignTile(
                  code: 'W.243b',
                  description: 'Nơi đường sắt giao không vuông góc với đường bộ',
                  imagePath: 'assets/signs/danger/signW243b.png',
                ),
                SignTile(
                  code: 'W.243c',
                  description: 'Nơi đường sắt giao không vuông góc với đường bộ',
                  imagePath: 'assets/signs/danger/signW243c.png',
                ),
                SignTile(
                  code: 'W.244',
                  description: 'Đoạn đường hay xảy ra tai nạn',
                  imagePath: 'assets/signs/danger/signW244.png',
                ),
                SignTile(
                  code: 'W.245a',
                  description: 'Đi chậm',
                  imagePath: 'assets/signs/danger/signW245a.png',
                ), SignTile(
                  code: 'W.245b',
                  description: 'Đi chậm',
                  imagePath: 'assets/signs/danger/signW245b.png',
                ), SignTile(
                  code: 'W.246a',
                  description: 'Chú ý chướng ngại vật: Vòng tránh sang hai bên',
                  imagePath: 'assets/signs/danger/signW246a.png',
                ),
                SignTile(
                  code: 'W.246b',
                  description: 'Chú ý chướng ngại vật: Vòng tránh sang hai bên',
                  imagePath: 'assets/signs/danger/signW246b.png',
                ), SignTile(
                  code: 'W.246c',
                  description: 'Chú ý chướng ngại vật: Vòng tránh sang hai bên',
                  imagePath: 'assets/signs/danger/signW246c.png',
                ),
                SignTile(
                  code: 'W.247',
                  description: 'Chú ý xe đỗ',
                  imagePath: 'assets/signs/danger/signW247.png',
                ),
              ],
            ),
            // Tab 3: Instruction Signs
            ListView(
              children: [
                SignTile(
                  code: 'R.122',
                  description: 'Dừng lại',
                  imagePath: 'assets/signs/direction/signR122.png',
                ),
                SignTile(
                  code: 'R.301a',
                  description: 'Các xe chỉ được đi thẳng',
                  imagePath: 'assets/signs/direction/signR301a.png',
                ),
                SignTile(
                  code: 'R.301b',
                  description: 'Các xe chỉ được rẽ phải',
                  imagePath: 'assets/signs/direction/signR301b.png',
                ),
                SignTile(
                  code: 'R.301c',
                  description: 'Các xe chỉ được rẽ trái',
                  imagePath: 'assets/signs/direction/signR301c.png',
                ), SignTile(
                  code: 'R.301d',
                  description: 'Các xe chỉ được rẽ phải',
                  imagePath: 'assets/signs/direction/signR301d.png',
                ),
                SignTile(
                  code: 'R.301e',
                  description: 'Các xe chỉ được rẽ trái',
                  imagePath: 'assets/signs/direction/signR301e.png',
                ),
                SignTile(
                  code: 'R.301f',
                  description: 'Các xe chỉ được đi thẳng và rẽ phải',
                  imagePath: 'assets/signs/direction/signR301f.png',
                ),
                SignTile(
                  code: 'R.301g',
                  description: 'Các xe chỉ được đi thẳng và rẽ trái',
                  imagePath: 'assets/signs/direction/signR301g.png',
                ),
                SignTile(
                  code: 'R.301h',
                  description: 'Các xe chỉ được rẽ trái và phải',
                  imagePath: 'assets/signs/direction/signR301h.png',
                ),
                SignTile(
                  code: 'R.302a',
                  description: 'Hướng phải đi vòng chướng ngại vật',
                  imagePath: 'assets/signs/direction/signR301b.png',
                ),
                SignTile(
                  code: 'R.302b',
                  description: 'Hướng phải đi vòng chướng ngại vật',
                  imagePath: 'assets/signs/direction/signR302b.png',
                ),
                SignTile(
                  code: 'R.302c',
                  description: 'Hướng phải đi vòng chướng ngại vật',
                  imagePath: 'assets/signs/direction/signR302c.png',
                ),
                SignTile(
                  code: 'R.303',
                  description: 'Nơi giao nhau chạy theo vòng xuyến',
                  imagePath: 'assets/signs/direction/signR303.png',
                ),
                SignTile(
                  code: 'R.304',
                  description: 'Đường dành cho xe thô sơ',
                  imagePath: 'assets/signs/direction/signR304.png',
                ),
                SignTile(
                  code: 'R.305',
                  description: 'Đường dành cho người đi bộ',
                  imagePath: 'assets/signs/direction/signR305.png',
                ),
                SignTile(
                  code: 'R.306',
                  description: 'Tốc độ tối thiểu cho phép',
                  imagePath: 'assets/signs/direction/signR306.png',
                ), SignTile(
                  code: 'R.307',
                  description: 'Hết hạn chế tốc độ tối thiểu',
                  imagePath: 'assets/signs/direction/signR307.png',
                ),
                SignTile(
                  code: 'R.308a',
                  description: 'Tuyến đường cầu vượt cắt qua',
                  imagePath: 'assets/signs/direction/signR308a.png',
                ),
                SignTile(
                  code: 'R.308b',
                  description: 'Tuyến đường cầu vượt cắt qua',
                  imagePath: 'assets/signs/direction/signR308b.png',
                ),
                SignTile(
                  code: 'R.309',
                  description: 'Ấn còi',
                  imagePath: 'assets/signs/direction/signR309.png',
                ),
                SignTile(
                  code: 'R.310a',
                  description: 'Hướng đi phải theo cho xe chở hàng nguy hiểm',
                  imagePath: 'assets/signs/direction/signR310a.png',
                ),
                SignTile(
                  code: 'R.310b',
                  description: 'Hướng đi phải theo cho xe chở hàng nguy hiểm',
                  imagePath: 'assets/signs/direction/signR310b.png',
                ),
                SignTile(
                  code: 'R.310c',
                  description: 'Hướng đi phải theo cho xe chở hàng nguy hiểm',
                  imagePath: 'assets/signs/direction/signR310c.png',
                ),
                SignTile(
                  code: 'R.403a',
                  description: 'Đường dành cho ôtô',
                  imagePath: 'assets/signs/direction/signR403a.png',
                ),
                SignTile(
                  code: 'R.403b',
                  description: 'Đường dành cho ôtô, xe máy',
                  imagePath: 'assets/signs/direction/signR403b.png',
                ),
                SignTile(
                  code: 'R.404a',
                  description: 'Hết đoạn đường dành cho ôtô',
                  imagePath: 'assets/signs/direction/signR404a.png',
                ),
                SignTile(
                  code: 'R.404b',
                  description: 'Hết đoạn đường dành cho ôtô và xe máy',
                  imagePath: 'assets/signs/direction/signR404b.png',
                ),
                SignTile(
                  code: 'R.411',
                  description: 'Hướng đi trên mỗi làn đường phải theo',
                  imagePath: 'assets/signs/direction/signR411.png',
                ),
                SignTile(
                  code: 'R.412a',
                  description: 'Làn đường dành cho xe khách',
                  imagePath: 'assets/signs/direction/signR412a.png',
                ),
                SignTile(
                  code: 'R.412b',
                  description: 'Làn đường dành cho xe con',
                  imagePath: 'assets/signs/direction/signR412b.png',
                ),
                SignTile(
                  code: 'R.412c',
                  description: 'Làn đường dành cho xe tải',
                  imagePath: 'assets/signs/direction/signR412c.png',
                ),
                SignTile(
                  code: 'R.412d',
                  description: 'Làn đường dành cho xe mô tô',
                  imagePath: 'assets/signs/direction/signR412d.png',
                ), SignTile(
                  code: 'R.412f',
                  description: 'Làn đường dành cho xe ô tô',
                  imagePath: 'assets/signs/direction/signR412f.png',
                ), SignTile(
                  code: 'R.413i',
                  description: 'Kết thúc làn đường dành cho xe khách',
                  imagePath: 'assets/signs/direction/signR413i.png',
                ),
                SignTile(
                  code: 'R.413j',
                  description: 'Kết thúc làn đường dành cho xe con',
                  imagePath: 'assets/signs/direction/signR413j.png',
                ),
                SignTile(
                  code: 'R.413k',
                  description: 'Kết thúc làn đường dành cho xe tải',
                  imagePath: 'assets/signs/direction/signR413k.png',
                ),
                SignTile(
                  code: 'R.413l',
                  description: 'Kết thúc làn đường dành cho xe mô tô',
                  imagePath: 'assets/signs/direction/signR413l.png',
                ),
                SignTile(
                  code: 'R.413n',
                  description: 'Kết thúc làn đường dành cho xe ô tô',
                  imagePath: 'assets/signs/direction/signR413n.png',
                ),
                SignTile(
                  code: 'R.415',
                  description: 'Biển gộp làn đường theo phương tiện',
                  imagePath: 'assets/signs/direction/signR415.png',
                ),
                SignTile(
                  code: 'R.420',
                  description: 'Bắt đầu khu dân cư',
                  imagePath: 'assets/signs/direction/signR420.png',
                ),
                SignTile(
                  code: 'R.421',
                  description: 'Hết khu đông dân cư',
                  imagePath: 'assets/signs/direction/signR421.png',
                ),
                SignTile(
                  code: 'R.E,9a',
                  description: 'Cấm đỗ xe trong khu vực',
                  imagePath: 'assets/signs/direction/signRE9a.png',
                ), SignTile(
                  code: 'R.E,9b',
                  description: 'Cấm đỗ xe theo giờ trong khu vực',
                  imagePath: 'assets/signs/direction/signRE9b.png',
                ), SignTile(
                  code: 'R.E,9c',
                  description: 'Khu vực đỗ xe',
                  imagePath: 'assets/signs/direction/signRE9c.png',
                ), SignTile(
                  code: 'R.E,9d',
                  description: 'Hạn chế tốc độ tối đa trong khu vực',
                  imagePath: 'assets/signs/direction/signRE9d.png',
                ),
                SignTile(
                  code: 'R.E,10a',
                  description: 'Hết cấm đỗ xe trong khu vực',
                  imagePath: 'assets/signs/direction/signRE10a.png',
                ), SignTile(
                  code: 'R.E,10c',
                  description: 'Hết khu vực đỗ xe',
                  imagePath: 'assets/signs/direction/signRE10c.png',
                ),
                SignTile(
                  code: 'R.E,10d',
                  description: 'Hết hạn chế tốc độ tối đa trong khu vực',
                  imagePath: 'assets/signs/direction/signRE10d.png',
                ), SignTile(
                  code: 'R.E,11a',
                  description: 'Báo hiệu có hầm chui',
                  imagePath: 'assets/signs/direction/signRE11a.png',
                ), SignTile(
                  code: 'R.E,11b',
                  description: 'Kết thúc hầm chui',
                  imagePath: 'assets/signs/direction/signRE11b.png',
                ),
              ],
            ),
            // Tab 4: Direction Signs
            ListView(
              children: [
                SignTile(
                  code: 'I.401',
                  description: 'Bắt đầu đường ưu tiên',
                  imagePath: 'assets/signs/instruction/signI401.png',
                ),
                SignTile(
                  code: 'I.402',
                  description: 'Hết đường ưu tiên',
                  imagePath: 'assets/signs/instruction/signI402.png',
                ),
                SignTile(
                  code: 'I.405a',
                  description: 'Đường cụt',
                  imagePath: 'assets/signs/instruction/signI401.png',
                ),
                SignTile(
                  code: 'I.405b',
                  description: 'Đường cụt',
                  imagePath: 'assets/signs/instruction/signI405b.png',
                ),
                SignTile(
                  code: 'I.405c',
                  description: 'Đường cụt',
                  imagePath: 'assets/signs/instruction/signI405c.png',
                ),
                SignTile(
                  code: 'I.406',
                  description: 'Được ưu tiên qua đường hẹp',
                  imagePath: 'assets/signs/instruction/signI406.png',
                ),
                SignTile(
                  code: 'I.407a',
                  description: 'Đường một chiều',
                  imagePath: 'assets/signs/instruction/signI407a.png',
                ),
                SignTile(
                  code: 'I.407b',
                  description: 'Đường một chiều',
                  imagePath: 'assets/signs/instruction/signI407b.png',
                ),
                SignTile(
                  code: 'I.407c',
                  description: 'Đường một chiều',
                  imagePath: 'assets/signs/instruction/signI407c.png',
                ),
                SignTile(
                  code: 'I.408',
                  description: 'Nơi đỗ xe',
                  imagePath: 'assets/signs/instruction/signI408.png',
                ),
                SignTile(
                  code: 'I.408a',
                  description: 'Nơi đỗ xe một phần trên hè phố',
                  imagePath: 'assets/signs/instruction/signI408a.png',
                ),
                SignTile(
                  code: 'I.409',
                  description: 'Chỗ quay xe',
                  imagePath: 'assets/signs/instruction/signI409.png',
                ),
                SignTile(
                  code: 'I.410',
                  description: 'Khu vực quay xe',
                  imagePath: 'assets/signs/instruction/signI410.png',
                ),
                SignTile(
                  code: 'I.413a',
                  description: 'Đường phía trước có làn đường dành cho ô tô khách',
                  imagePath: 'assets/signs/instruction/signI413a.png',
                ),
                SignTile(
                  code: 'I.413b',
                  description: 'Rẽ ra đường có làn dành cho xe khách',
                  imagePath: 'assets/signs/instruction/signI413b.png',
                ),
                SignTile(
                  code: 'I.413c',
                  description: 'Rẽ ra đường có làn dành cho xe khách',
                  imagePath: 'assets/signs/instruction/signI413c.png',
                ),
                SignTile(
                  code: 'I.418',
                  description: 'Lối đi ở những chỗ cấm rẽ',
                  imagePath: 'assets/signs/instruction/signI418.png',
                ),
                SignTile(
                  code: 'I.423a',
                  description: 'Đường người đi bộ sang ngang',
                  imagePath: 'assets/signs/instruction/signI423a.png',
                ),
                SignTile(
                  code: 'I.437',
                  description: 'Đường cao tốc',
                  imagePath: 'assets/signs/instruction/signI437.png',
                ),
                SignTile(
                  code: 'I.444',
                  description: 'Xe kéo moóc',
                  imagePath: 'assets/signs/instruction/signI444.png',
                ),
                SignTile(
                  code: 'I.446',
                  description: 'Nơi đỗ xe dành cho người tàn tật',
                  imagePath: 'assets/signs/instruction/signI446.png',
                ),
                SignTile(
                  code: 'I.447a',
                  description: 'Cầu vượt liên thông',
                  imagePath: 'assets/signs/instruction/signI447a.png',
                ),
                SignTile(
                  code: 'I.446b',
                  description: 'Cầu vượt liên thông',
                  imagePath: 'assets/signs/instruction/signI447b.png',
                ),
                SignTile(
                  code: 'I.448',
                  description: 'Làn đường cứu nạn hay làn thoát xe khẩn cấp',
                  imagePath: 'assets/signs/instruction/signI448.png',
                ),
                SignTile(
                  code: 'I.449',
                  description: 'Biển tên đường',
                  imagePath: 'assets/signs/instruction/signI449.png',
                ),

              ],
            ),
            // Tab 5:Extra Signs
            ListView(
              children: [
                SignTile(
                  code: 'S.501',
                  description: 'Phạm vi tác dụng của biển',
                  imagePath: 'assets/signs/extra/signS501.png',
                ), SignTile(
                  code: 'S.502',
                  description: 'Khoảng cách đến đối tượng báo hiệu',
                  imagePath: 'assets/signs/extra/signS502.png',
                ),
                SignTile(
                  code: 'S.503a',
                  description: 'Hướng tác dụng của biển',
                  imagePath: 'assets/signs/extra/signS503a.png',
                ),
                SignTile(
                  code: 'S.503b',
                  description: 'Hướng tác dụng của biển',
                  imagePath: 'assets/signs/extra/signS503b.png',
                ),
                SignTile(
                  code: 'S.503c',
                  description: 'Hướng tác dụng của biển',
                  imagePath: 'assets/signs/extra/signS503c.png',
                ),
                SignTile(
                  code: 'S.503d',
                  description: 'Hướng tác dụng của biển',
                  imagePath: 'assets/signs/extra/signS503d.png',
                ),
                SignTile(
                  code: 'S.503e',
                  description: 'Hướng tác dụng của biển',
                  imagePath: 'assets/signs/extra/signS503e.png',
                ),
                SignTile(
                  code: 'S.503f',
                  description: 'Hướng tác dụng của biển',
                  imagePath: 'assets/signs/extra/signS503f.png',
                ),
                SignTile(
                  code: 'S.504',
                  description: 'Làn đường',
                  imagePath: 'assets/signs/extra/signS504.png',
                ), SignTile(
                  code: 'S.506a',
                  description: 'Hướng đường ưu tiên',
                  imagePath: 'assets/signs/extra/signS506a.png',
                ),
                SignTile(
                  code: 'S.506b',
                  description: 'Hướng đường ưu tiên',
                  imagePath: 'assets/signs/extra/signS506b.png',
                ),
              ],
            ),
            // Tab 6: Road Line Signs
            ListView(
              children: [
                SignTile(
                  code: 'Vạch 1.1',
                  description: 'Vạch phân chia hai chiều xe chạy (vạch tim đường), dạng vạch đơn, đứt nét',
                  imagePath: 'assets/signs/roadLine/signG11.png',
                ),
                SignTile(
                  code: 'Vạch 1.2',
                  description: 'Vạch phân chia hai chiều xe chạy (vạch tim đường), dạng vạch đơn, nét liền',
                  imagePath: 'assets/signs/roadLine/signG12.png',
                ),
                SignTile(
                  code: 'Vạch 1.3',
                  description: 'Vạch phân chia hai chiều xe chạy ngược chiều (vạch tim đường), dạng vạch đôi, nét liền',
                  imagePath: 'assets/signs/roadLine/signG13.png',
                ),
                SignTile(
                  code: 'Vạch 1.4',
                  description: 'Vạch phân chia hai chiều xe chạy, dạng vạch đôi gồm một vạch nét liền, một vạch nét đứt',
                  imagePath: 'assets/signs/roadLine/signG14.png',
                ),
                SignTile(
                  code: 'Vạch 1.5',
                  description: 'Vạch xác định ranh giới làn đường có thể thay đổi hướng xe chạy',
                  imagePath: 'assets/signs/roadLine/signG15.png',
                ),
                SignTile(
                  code: 'Vạch 2.1',
                  description: 'Vạch phân chia các làn xe cùng chiều, dạng vạch đơn, đứt nét',
                  imagePath: 'assets/signs/roadLine/signG21.png',
                ),
                SignTile(
                  code: 'Vạch 2.2',
                  description: 'Vạch phân chia các làn xe cùng chiều, dạng vạch đơn, liền nét.',
                  imagePath: 'assets/signs/roadLine/signG22.png',
                ),
                SignTile(
                  code: 'Vạch 7.6',
                  description: 'Vạch chỉ dẫn sắp đến chỗ có bố trí vạch đi bộ qua đường',
                  imagePath: 'assets/signs/roadLine/signG76.png',
                ),
                SignTile(
                  code: 'Vạch 7.8',
                  description: 'Vạch xác định khoảng cách xe trên đường.',
                  imagePath: 'assets/signs/roadLine/signG78.png',
                ),
                SignTile(
                  code: 'Vạch 9.2',
                  description: 'Vạch quy định vị trí dừng đỗ của phương tiện giao thông công cộng trên đường',
                  imagePath: 'assets/signs/roadLine/signG92.png',
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget to display each sign
class SignTile extends StatelessWidget {
  final String code;
  final String description;
  final String imagePath;

  SignTile({
    required this.code,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sign image
          Image.asset(
            imagePath,
            width: 73,
            height: 73,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, color: Colors.red);
            },
          ),
          SizedBox(width: 16),
          // Code and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}