class Stage {
  final String? id;            // ID của giai đoạn
  final int? giaidoan;          // Mã giai đoạn
  final String? tenGiaiDoan;    // Tên giai đoạn
  final String? color;          // Màu sắc đại diện cho giai đoạn
  final String? ghichu;         // Ghi chú
  final int? stt;               // Số thứ tự của giai đoạn
  final String? xId;            // ID bổ sung

  Stage({
    this.id,
    this.giaidoan,
    this.tenGiaiDoan,
    this.color,
    this.ghichu,
    this.stt,
    this.xId,
  });

  // Tạo Stage từ JSON
  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['_id'] as String?,
      giaidoan: json['giaidoan'] as int?,
      tenGiaiDoan: json['tengiaidoan'] as String?,
      color: json['color'] as String?,
      ghichu: json['ghichu'] as String?,
      stt: json['stt'] as int?,
      xId: json['xId'] as String?,
    );
  }

  // Chuyển Stage thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'giaidoan': giaidoan,
      'tengiaidoan': tenGiaiDoan,
      'color': color,
      'ghichu': ghichu,
      'stt': stt,
      'xId': xId,
    };
  }
}