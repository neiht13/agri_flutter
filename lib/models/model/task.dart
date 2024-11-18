class Task {
  final String? id;               // ID của công việc
  final int? stt;                 // Số thứ tự của công việc
  final String? tenCongViec;      // Tên công việc
  final String? chitietcongviec;  // Chi tiết công việc
  final String? ghichu;           // Ghi chú về công việc
  final String? chiphidvt;        // Chi phí đơn vị tính
  final String? giaidoanId;       // ID của giai đoạn liên quan
  final String? tenGiaiDoan;      // Tên của giai đoạn liên quan

  Task({
    this.id,
    this.stt,
    this.tenCongViec,
    this.chitietcongviec,
    this.ghichu,
    this.chiphidvt,
    this.giaidoanId,
    this.tenGiaiDoan,
  });

  // Tạo Task từ JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] as String?,
      stt: json['stt'] as int?,
      tenCongViec: json['tenCongViec'] as String?,
      chitietcongviec: json['chitietcongviec'] as String?,
      ghichu: json['ghichu'] as String?,
      chiphidvt: json['chiphidvt'] as String?,
      giaidoanId: json['giaidoanId'] as String?,
      tenGiaiDoan: json['tenGiaiDoan'] as String?,
    );
  }

  // Chuyển Task thành JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'stt': stt,
      'tenCongViec': tenCongViec,
      'chitietcongviec': chitietcongviec,
      'ghichu': ghichu,
      'chiphidvt': chiphidvt,
      'giaidoanId': giaidoanId,
      'tenGiaiDoan': tenGiaiDoan,
    };
  }
}