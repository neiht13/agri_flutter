// import 'package:agriplant/models/cubit/contact/contact.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class NotificationsPage extends StatelessWidget {
//   const NotificationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => Contact()..fetchContacts(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Thông tin liên hệ'),
//         ),
//         body: BlocBuilder<ContactCubit, ContactState>(
//           builder: (context, state) {
//             if (state.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             final unreadContacts = state.contacts
//                 .where((contact) => contact['isRead'] == false)
//                 .toList();
//             final readContacts = state.contacts
//                 .where((contact) => contact['isRead'] == true)
//                 .toList();

//             return ListView(
//               children: [
//                 if (unreadContacts.isNotEmpty)
//                   const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       'Chưa đọc',
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ...unreadContacts.map((contact) {
//                   return ContactItem(contact: contact);
//                 }).toList(),
//                 if (readContacts.isNotEmpty)
//                   const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       'Đã đọc',
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ...readContacts.map((contact) {
//                   return ContactItem(contact: contact, isRead: true);
//                 }).toList(),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class ContactItem extends StatelessWidget {
//   final Map<String, dynamic> contact;
//   final bool isRead;

//   const ContactItem({super.key, required this.contact, this.isRead = false});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ListTile(
//         title: Text(contact['name']),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Email: ${contact['email']}'),
//             Text('SĐT: ${contact['phone']}'),
//             Text('Tin nhắn: ${contact['message']}'),
//           ],
//         ),
//         trailing: isRead
//             ? const Icon(Icons.done, color: Colors.green)
//             : IconButton(
//                 icon: const Icon(Icons.mark_email_read, color: Colors.blue),
//                 onPressed: () {
//                   context.read<ContactCubit>().markAsRead(contact['id']);
//                 },
//               ),
//       ),
//     );
//   }
// }
