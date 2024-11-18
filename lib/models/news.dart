// lib/models/news.dart
class News {
  final String title;
  final String summary;
  final String image; // Đường dẫn đến hình ảnh trong assets
  final String date;
  final String author;

  News({
    required this.title,
    required this.summary,
    required this.image,
    required this.date,
    required this.author,
  });
}

// Ví dụ danh sách tin tức
List<News> newsList = [
  News(
    title: 'Cập Nhật Nông Nghiệp 2024',
    summary: 'Khám phá những tiến bộ mới trong ngành nông nghiệp năm 2024...',
    image: 'assets/images/news1.jpg',
    date: '10 Tháng 4, 2024',
    author: 'Nguyễn Văn A',
  ),
  News(
    title: 'Kỹ Thuật Canh Tác Hiện Đại',
    summary: 'Những kỹ thuật canh tác tiên tiến giúp tăng năng suất...',
    image: 'assets/images/news2.jpg',
    date: '12 Tháng 4, 2024',
    author: 'Trần Thị B',
  ),
  // Thêm các bài viết khác
];
