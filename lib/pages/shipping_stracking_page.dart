import 'package:flutter/material.dart';

class ShippingTrackingPage extends StatelessWidget {
  const ShippingTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Giả lập trạng thái đơn hàng
    const String trackingNumber = "DH123456789";
    const String status = "Đang giao hàng";
    const String estimatedDelivery = "Dự kiến giao: 20/10/2023";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theo dõi vận chuyển'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Mã vận đơn: $trackingNumber",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              status,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              estimatedDelivery,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            // Hiển thị tiến trình giao hàng
            // ...
          ],
        ),
      ),
    );
  }
}
