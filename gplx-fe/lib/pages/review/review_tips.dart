import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mẹo ghi nhớ'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề chính
            Text(
              'Mẹo 600 câu hỏi ôn thi GPLX',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // Cấp phép
            Text(
              'Cấp phép',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Đường cấm dừng, cấm đỗ, cấm đi do UBND cấp tỉnh cấp\n'
                  '• Xe quá khổ, quá tải do: cơ quan quản lý đường bộ có thẩm quyền cấp phép',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Nồng độ cồn
            Text(
              'Nồng độ cồn',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Người điều khiển xe mô tô, ô tô, máy kéo trên đường mà trong máu hoặc hơi thở có nồng độ cồn: Bị nghiêm cấm',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Khoảng cách an toàn tối thiểu
            Text(
              'Khoảng cách an toàn tối thiểu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• 35m nếu vận tốc lưu hành(V) = 60 (km/h)\n'
                  '• 55m nếu 60<V≤80\n'
                  '• 70m nếu 80<V≤100\n'
                  '• 100m nếu 100<V≤120\n'
                  '• Dưới 60km/h: Chịu động và đảm bảo khoảng cách.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),


            Text(
              'Hỏi về tuổi (T)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Tuổi tối đa hạng E: nam 55, nữ 50\n'
                  '• Túi lấy bằng lại xe (cách nhau 3 tuổi)\n'
                  '  ○ Gắn máy: 16T (dưới 50cm3)\n'
                  '  ○ Mô tô + B1 + B2: 18T\n'
                  '  ○ C, FB: 21T\n'
                  '  ○ D, FC: 24T\n'
                  '  ○ E, FD: 27T',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Trên đường cao tốc, trong đường hầm...
            Text(
              'Trên đường cao tốc, trong đường hầm, đường vòng, đầu dốc, nơi tầm nhìn hạn chế',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Không được quay đầu xe, không lùi, không vượt\n'
                  '• Không được vượt trên cầu hẹp có một làn xe.\n'
                  '• Không được phép quay đầu xe ở phần đường dành cho người đi bộ qua đường.\n'
                  '• Cấm lùi xe ở khu vực cấm dừng và nơi đường bộ giao nhau.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Tài nơi giao nhau không có tín hiệu
            Text(
              'Tài nơi giao nhau không có tín hiệu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Có vòng xuyến: Nhường đường bên trái\n'
                  '• Không có vòng xuyến nhường bên phải',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Niên hạn sử dụng (tính từ năm SX)
            Text(
              'Niên hạn sử dụng (tính từ năm SX)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• 25 năm: ô tô tải\n'
                  '• 20 năm: ô tô chở người trên 9 chỗ',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Biển báo cấm
            Text(
              'Biển báo cấm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Cấm ô tô (Gồm: mô tô 3 bánh, Xe Lam, xe khách) → Cấm xe tải → Cấm Máy kéo → Cấm rơ mooc, sơ mi rơ mooc',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Nhật chởm, nhi ưu, tạm dừng, tự hướng
            Text(
              'Nhất chớm, nhì ưu, tam dừng, tứ hướng',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '1. Nhất chớm: Xe nào chởm tới vạch trước thì được đi trước.\n'
                  '2. Nhì ưu: Xe ưu tiên được đi trước. Thứ tự xe ưu tiên: Hoả-Sy-An-Thương (Cứu hoả - Quân sự - Công an - Cứu thương - Hộ đê - Đoàn xe tang).\n'
                  '3. Tam dừng: Xe ở đường chính, đường ưu tiên.\n'
                  '4. Tứ hướng: Thứ tự hướng: Bên phải trống - Rẽ phải - Đi thẳng - Rẽ trái.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Thứ tự ưu tiên với xe ưu tiên
            Text(
              'Thứ tự ưu tiên với xe ưu tiên: Hoả-Sự-An-Thương',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Hoả: Xe Cứu hoả\n'
                  '• Sự: Xe Quân sự\n'
                  '• An: Xe Công an\n'
                  '• Thương: Xe cứu thương\n'
                  '• Xe hộ đê, xe đi làm nhiệm vụ khẩn cấp\n'
                  '• Đoàn xe tang',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Các hạng GPLX
            Text(
              'Các hạng GPLX',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• A1 mô tô dưới 175 cm3 và xe 3 bánh của người khuyết tật\n'
                  '• A2 mô tô 175 cm3 trở lên\n'
                  '• A3 xe mô tô 3 bánh\n'
                  '• B1 không hành nghề lái xe\n'
                  '• B1, B2 đến 9 chỗ ngồi, xe tải dưới 3.500kg\n'
                  '• C đến 9 chỗ ngồi, xe trên 3.500kg\n'
                  '• D chở đến 30 người\n'
                  '• E chở trên 30 người.\n'
                  '• FC: C + kéo (ô tô đầu kéo, kéo sơ mi rơ moóc)\n'
                  '• FE: E + kéo (ô tô chở khách nối toa)',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Phần nhóm biển báo hiệu
            Text(
              'Phần nhóm biển báo hiệu: bao gồm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Biển nguy hiểm (hình tam giác vàng)\n'
                  '• Biển cấm (vòng tròn đỏ)\n'
                  '• Biển hiệu lệnh (vòng tròn xanh)\n'
                  '• Biển chỉ dẫn (vuông hoặc hình chữ nhật xanh)\n'
                  '• Biển phụ (vuông, chữ nhật trắng đen): Hiệu lực năm ở biển phụ khi có đặt biển phụ',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Tốc độ tối đa TRONG khu vực đông dân cư
            Text(
              'Tốc độ tối đa TRONG khu vực đông dân cư',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• 60km/h: Đổi với đường đôi hoặc đường 1 chiều có từ 2 làn xe cơ giới trở lên\n'
                  '• 50km/h: Đổi với đường 2 chiều hoặc đường 1 chiều có 1 làn xe cơ giới',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Tốc độ tối đa NGOÀI khu vực đông dân cư (trừ đường cao tốc)
            Text(
              'Tốc độ tối đa NGOÀI khu vực đông dân cư (trừ đường cao tốc)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Đối với đường đôi hoặc đường 1 chiều có từ 2 làn xe cơ giới trở lên\n'
                  '• 90km/h: Xe ô tô con, xe ô tô chở người đến 30 chỗ (trừ xe buýt), ô tô tải có trọng tải ≤3.5 tấn.\n'
                  '• 80km/h: Xe ô tô chở người trên 30 chỗ (trừ xe buýt), ô tô tải có trọng tải >3.5 tấn (trừ ô tô xitec).\n'
                  '• 70km/h: Ô tô buýt, ô tô đầu kéo kéo sơ mi rơ moóc, xe mô tô, ô tô chuyên dùng (trừ ô tô trộn vữa, trộn bê tông).\n'
                  '• 60km/h: Ô tô kéo rơ moóc, ô tô kéo xe khác, ô tô trộn vữa, ô tô trộn bê tông, ô tô xitec.\n'
                  '\n'
                  'Đối với đường 2 chiều hoặc đường 1 chiều có 1 làn xe cơ giới\n'
                  '• 80km/h: Xe ô tô con, xe ô tô chở người đến 30 chỗ (trừ xe buýt), ô tô tải có trọng tải ≤3.5 tấn.\n'
                  '• 70km/h: Xe ô tô chở người trên 30 chỗ (trừ xe buýt), ô tô tải có trọng tải >3.5 tấn (trừ ô tô xitec).\n'
                  '• 60km/h: Ô tô buýt, ô tô đầu kéo kéo sơ mi rơ moóc, xe mô tô, ô tô chuyên dùng (trừ ô tô trộn vữa, trộn bê tông).\n'
                  '• 50km/h: Ô tô kéo rơ moóc, ô tô kéo xe khác, ô tô trộn vữa, ô tô trộn bê tông, ô tô xitec.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}