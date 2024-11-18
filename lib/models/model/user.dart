// user.dart
import 'dart:convert';

class User {
  final String id;
  final String username;
  final String? email;
  final String? name;
  final String? image;
  final String? phone;
  final String? mota;
  final String? diachi;
  final double? dientich;
  final String? donvihtx;
  final String? location;
  final String? masovungtrong;
  final String? xId;

  User({
    required this.id,
    required this.username,
    this.email,
    this.name,
    this.image,
    this.phone,
    this.mota,
    this.diachi,
    this.dientich,
    this.donvihtx,
    this.location,
    this.masovungtrong,
    this.xId,
  });

  // copyWith method
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? name,
    String? image,
    String? phone,
    String? mota,
    String? diachi,
    double? dientich,
    String? donvihtx,
    String? location,
    String? masovungtrong,
    String? xId,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      name: name ?? this.name,
      image: image ?? this.image,
      phone: phone ?? this.phone,
      mota: mota ?? this.mota,
      diachi: diachi ?? this.diachi,
      dientich: dientich ?? this.dientich,
      donvihtx: donvihtx ?? this.donvihtx,
      location: location ?? this.location,
      masovungtrong: masovungtrong ?? this.masovungtrong,
      xId: xId ?? this.xId,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'image': image,
      'phone': phone,
      'mota': mota,
      'diachi': diachi,
      'dientich': dientich,
      'donvihtx': donvihtx,
      'location': location,
      'masovungtrong': masovungtrong,
      'xId': xId,
    };
  }

  // fromJson factory method
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'] ?? "",
      email: json['email'] ?? "",
      name: json['name'] ?? "",
      image: json['image'] ?? "",
      phone: json['phone'] ?? "",
      mota: json['mota'] ?? "",
      diachi: json['diachi'] ?? "",
      dientich: json['dientich']?.toDouble(),
      donvihtx: json['donvihtx'] ?? "",
      location: json['location'] ?? "",
      masovungtrong: json['masovungtrong'] ?? "",
      xId: json['xId'] ?? "",
    );
  }

  // Convert User to JSON string
  String toJsonString() => json.encode(toJson());

  // Create User from JSON string
  factory User.fromJsonString(String jsonString) =>
      User.fromJson(json.decode(jsonString));
}
