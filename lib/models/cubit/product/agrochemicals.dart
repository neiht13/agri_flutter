class Agrochemicals {
  final String? id;
  final String name;
  final String type; // 'fertilizer' hoặc 'pesticides'
  final bool isOrganic;
  final String? farmingLogId;
  final String? lieuLuong;
  final String? donViTinh;


  Agrochemicals({
    this.id,
    required this.name,
    required this.type,
    required this.isOrganic,
    this.farmingLogId,
    this.lieuLuong,
    this.donViTinh,
  });

  // Nếu cần, thêm các phương thức chuyển đổi từ/to JSON
  factory Agrochemicals.fromJson(Map<String, dynamic> json) {
    return Agrochemicals(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      isOrganic: json['isOrganic'],
      farmingLogId: json['farmingLogId'],
      lieuLuong: json['lieuLuong'],
      donViTinh: json['donViTinh'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'isOrganic': isOrganic,
        'farmingLogId': farmingLogId,
        'lieuLuong': lieuLuong,
        'donViTinh': donViTinh,
      };
}
