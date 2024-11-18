// lib/data/model/farming_log.dart
import 'package:agriplant/models/cubit/product/agrochemicals.dart';
import 'package:equatable/equatable.dart';

class FarmingLog extends Equatable {
  final String? id;
  final String? uId;
  final String? xId;
  final double chiPhiVatTu;
  final double chiPhiCong;
  final double soLuongCong;
  final double soLuongVatTu;
  final String? donViTinh;
  final String? congViec;
  final String? congViecId;
  final String? giaiDoan;
  final String? giaiDoanId;
  final String? ngayCapNhat;
  final double thanhTien;
  final String? loaiPhan;
  final String? tenPhan;
  final String? loaiThuoc;
  final String? tenThuoc;
  final String? ngayThucHien;
  final String? image;
  final String? muaVu;
  final String? muaVuId;
  final String? chiTietCongViec;
  final String? ghiChu;
  final String? year;
  final List<Agrochemicals>? agrochemicals;


  const FarmingLog({
    this.id,
    this.uId,
    this.xId,
    this.chiPhiVatTu = 0,
    this.chiPhiCong = 0,
    this.soLuongCong = 0,
    this.soLuongVatTu = 0,
    this.donViTinh,
    this.congViec,
    this.congViecId,
    this.giaiDoan,
    this.giaiDoanId,
    this.ngayCapNhat,
    this.thanhTien = 0,
    this.loaiPhan,
    this.tenPhan,
    this.loaiThuoc,
    this.tenThuoc,
    this.ngayThucHien,
    this.image,
    this.muaVu,
    this.muaVuId,
    this.chiTietCongViec,
    this.ghiChu,
    this.year,
    this.agrochemicals,
  });

  @override
  List<Object?> get props => [
    id,
    uId,
    xId,
    chiPhiVatTu,
    chiPhiCong,
    soLuongCong,
    soLuongVatTu,
    donViTinh,
    congViec,
    congViecId,
    giaiDoan,
    giaiDoanId,
    ngayCapNhat,
    thanhTien,
    loaiPhan,
    tenPhan,
    loaiThuoc,
    tenThuoc,
    ngayThucHien,
    image,
    muaVu,
    muaVuId,
    chiTietCongViec,
    ghiChu,
    year,
    agrochemicals,
  ];

  factory FarmingLog.fromJson(Map<String?, dynamic> json) {
    return FarmingLog(
      id: json['_id'] as String?,
      uId: json['uId'] as String?,
      xId: json['xId'] as String?,
      chiPhiVatTu: json['chiPhiVatTu']?.toDouble() ?? 0.0,
      chiPhiCong: json['chiPhiCong']?.toDouble() ?? 0.0,
      soLuongCong: json['soLuongCong']?.toDouble() ?? 0.0,
      soLuongVatTu: json['soLuongVatTu']?.toDouble() ?? 0.0,
      donViTinh: json['donViTinh'] as String?,
      congViec: json['congViec'] as String?,
      congViecId: json['congViecId'] as String?,
      giaiDoan: json['giaiDoan'] as String?,
      giaiDoanId: json['giaiDoanId'] as String?,
      ngayCapNhat: json['ngayCapNhat'] as String?,
      thanhTien: json['thanhTien']?.toDouble() ?? 0.0,
      loaiPhan: json['loaiPhan'] as String?,
      tenPhan: json['tenPhan'] as String?,
      loaiThuoc: json['loaiThuoc'] as String?,
      tenThuoc: json['tenThuoc'] as String?,
      ngayThucHien: json['ngayThucHien'] as String?,
      image: json['image'] as String?,
      muaVu: json['muaVu'] as String?,
      muaVuId: json['muaVuId'] as String?,
      chiTietCongViec: json['chiTietCongViec'] as String?,
      ghiChu: json['ghiChu'] as String?,
      year: json['year'] as String?,
      agrochemicals: json['agrochemicals'] != null
          ? (json['agrochemicals'] as List)
              .map((item) => Agrochemicals.fromJson(item))
              .toList()
          : null,    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uId': uId,
      'xId': xId,
      'chiPhiVatTu': chiPhiVatTu,
      'chiphicong': chiPhiCong,
      'chiPhiCong': soLuongCong,
      'soLuongVatTu': soLuongVatTu,
      'donViTinh': donViTinh,
      'congViec': congViec,
      'congViecId': congViecId,
      'giaiDoan': giaiDoan,
      'giaiDoanId': giaiDoanId,
      'ngayCapNhat': ngayCapNhat,
      'thanhTien': thanhTien,
      'loaiPhan': loaiPhan,
      'tenPhan': tenPhan,
      'loaiThuoc': loaiThuoc,
      'tenThuoc': tenThuoc,
      'ngayThucHien': ngayThucHien,
      'image': image,
      'muaVu': muaVu,
      'muaVuId': muaVuId,
      'chiTietCongViec': chiTietCongViec,
      'ghiChu': ghiChu,
      'year': year,
      'agrochemicals': agrochemicals?.map((item) => item.toJson()).toList(),
    };
  }
}
