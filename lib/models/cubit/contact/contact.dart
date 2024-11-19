import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Contact {
  final String? id;
  final String? xId;
  final String? uId;
  final String? name;
  final String? email;
  final String? phone;
  final String? message;
  bool status;
  final DateTime? createAt;
  Contact({
     this.id,
     this.xId,
     this.uId,
     this.name,
     this.email,
     this.phone,
     this.message,
     this.status = false,
     this.createAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['_id']['\$oid' ] ?? "",
      xId: json['xId'] ?? "",
      uId: json['uId' ] ?? "",
      name: json['name' ] ?? "",
      email: json['email' ] ?? "",
      phone: json['phone' ] ?? "",
      message: json['message' ] ?? "",
      status: json['status' ] ?? "",
      createAt: DateTime.parse(json['createAt']['\$date']),
    );
  }


  Future<List<Contact>> fetchContacts() async {
    final response = await http.get(Uri.parse('https://your-api.com/contacts'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Contact.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  Future<void> updateStatus(String id, bool status) async {
    final response = await http.put(
      Uri.parse('https://your-api.com/contacts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      // Xử lý lỗi nếu cần
      throw Exception('Failed to update status');
    }
  }
}

