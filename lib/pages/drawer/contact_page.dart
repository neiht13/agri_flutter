import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Liên hệ/Hỗ trợ'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: "Tiêu đề",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      labelText: "Nội dung",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: (){},
                  child: const Text("Gửi"),
                ),
              ],
            ),
          ),
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
