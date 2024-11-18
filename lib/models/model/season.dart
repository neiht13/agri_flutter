class Season {
  final String? id;
  final String? muavu;
  final String? nam;
  final String? ngaybatdau;
  final String? phuongphap;
  final String? giong;
  final double? dientich;
  final int? soluong;
  final int? giagiong;
  final String? stt;
  final String? ghichu;
  final String? uId;

  Season({
    this.id,
    this.muavu,
    this.nam,
    this.ngaybatdau,
    this.phuongphap,
    this.giong,
    this.dientich,
    this.soluong,
    this.giagiong,
    this.stt,
    this.ghichu,
    this.uId,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['_id'] as String,
      muavu: json['muavu'] as String?,
      nam: json['nam'] as String?,
      ngaybatdau: json['ngaybatdau'] as String?,
      phuongphap: json['phuongphap'] as String?,
      giong: json['giong'] as String?,
      dientich: json['dientich'] != null
          ? (json['dientich'] is num
              ? (json['dientich'] as num).toDouble()
              : double.tryParse(json['dientich'].toString()))
          : null,
      soluong: json['soluong'] != null
          ? (json['soluong'] is int
              ? json['soluong'] as int
              : int.tryParse(json['soluong'].toString()))
          : null,
      giagiong: json['giagiong'] != null
          ? (json['giagiong'] is int
              ? json['giagiong'] as int
              : int.tryParse(json['giagiong'].toString()))
          : null,
      stt: json['stt'] as String?,
      ghichu: json['ghichu'] as String?,
      uId: json['uId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'muavu': muavu,
      'nam': nam,
      'ngaybatdau': ngaybatdau,
      'phuongphap': phuongphap,
      'giong': giong,
      'dientich': dientich,
      'soluong': soluong,
      'giagiong': giagiong,
      'stt': stt,
      'ghichu': ghichu,
      'uId': uId,
    };
  }
}
