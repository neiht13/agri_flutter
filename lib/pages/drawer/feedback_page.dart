import 'package:flutter/material.dart';


class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController feedbackController = TextEditingController();
  int rating = 4;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá và Phản hồi'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Chúng tôi rất mong nhận được phản hồi từ bạn.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                // Đánh giá bằng sao
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          rating = index + 1;
                        });
                      },
                      icon: Icon(
                        Icons.star,
                        color: index < rating ? Colors.yellow : Colors.grey,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TextField(
                    controller: feedbackController,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: "Nhập phản hồi của bạn...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed:  () {
                        },
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
