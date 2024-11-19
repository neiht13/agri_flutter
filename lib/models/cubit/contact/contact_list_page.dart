import 'package:agriplant/models/cubit/contact/contact.dart';
import 'package:flutter/material.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  late Future<List<Contact>> futureContacts;

  @override
  void initState() {
    super.initState();
    // futureContacts = fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>>(
      future: futureContacts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Contact>? contacts = snapshot.data;
          return ListView.builder(
            itemCount: contacts!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(contacts[index].name ??""),
                subtitle: Text(contacts[index].email ??""),
                trailing: Switch(
                  value: contacts[index].status,
                  onChanged: (bool value) {
                    setState(() {
                      contacts[index].status = value;
                      // Gọi hàm để cập nhật trạng thái trên server nếu cần
                      // Contact().updateStatus(contacts[index].id, value);
                    });
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        // Hiển thị vòng tròn chờ nếu đang load dữ liệu
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
