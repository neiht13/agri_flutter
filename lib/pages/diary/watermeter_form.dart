import 'package:flutter/material.dart';
import 'package:agriplant/widgets/input_field.dart';
import 'package:agriplant/widgets/custom_dropdown_field.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class WaterMeterForm extends StatefulWidget {
  const WaterMeterForm({Key? key}) : super(key: key);

  @override
  State<WaterMeterForm> createState() => _WaterMeterFormState();
}

class _WaterMeterFormState extends State<WaterMeterForm> {
  final TextEditingController _startReadingController = TextEditingController();
  final TextEditingController _endReadingController = TextEditingController();
  final TextEditingController _consumptionController = TextEditingController();
  final TextEditingController _unitPriceController =
      TextEditingController(text: '5000');
  final TextEditingController _totalPaymentController = TextEditingController();
  final TextEditingController _customerSearchController =
      TextEditingController();

  String _paymentMethod = 'TM/CK';
  String _billingRoute = 'Tuyến thu 1';
  bool _isInvoiceEnabled = true;

  void _calculateConsumption() {
    double start = double.tryParse(_startReadingController.text) ?? 0;
    double end = double.tryParse(_endReadingController.text) ?? 0;
    double consumption = end - start;
    double unitPrice = double.tryParse(_unitPriceController.text) ?? 0;

    if (consumption >= 0) {
      _consumptionController.text = consumption.toStringAsFixed(2);
      double totalPayment = consumption * unitPrice;
      _totalPaymentController.text = totalPayment.toStringAsFixed(0);
    } else {
      _consumptionController.text = "0.00";
      _totalPaymentController.text = "0";
    }
  }

  Future<pw.Document> _generateInvoicePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Hóa đơn',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.Text('Khách hàng: ${_customerSearchController.text}'),
              pw.Text('HT Thanh toán: $_paymentMethod'),
              pw.Text('Tuyến thu: $_billingRoute'),
              pw.Text('Chỉ số đầu: ${_startReadingController.text}'),
              pw.Text('Chỉ số cuối: ${_endReadingController.text}'),
              pw.Text('Số m3 tiêu thụ: ${_consumptionController.text}'),
              pw.Text('Tổng tiền thanh toán: ${_totalPaymentController.text}'),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  void _printInvoice() async {
    try {
      final pdf = await _generateInvoicePdf();

      // Hiển thị hộp thoại chọn máy in và thực hiện in
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi in hóa đơn: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Màu sắc chủ đạo
        final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        
        title: const Text("Ghi Chỉ Số Lưu Lượng Kế"),
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
        automaticallyImplyLeading: false,
        elevation: 2,
        centerTitle: false,
        actions: [
          Center(
            child: Text(
              'Tháng ${DateTime.now().month}/${DateTime.now().year}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Thông tin khách hàng
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin khách hàng',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    InputField(
                      labelText: 'Tìm kiếm khách hàng',
                      controller: _customerSearchController,
                      prefixIcon: const Icon(Icons.search),
                      onChanged: (value) {
                        // Implement customer search logic here
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildCustomerDropdown(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdownField<String>(
                            labelText: 'HT Thanh toán',
                            value: _paymentMethod,
                            items: ['TM/CK', 'Thẻ tín dụng', 'Ví điện tử']
                                .map((method) => DropdownMenuItem<String>(
                                      value: method,
                                      child: Text(method),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _paymentMethod = value!;
                              });
                            },
                            prefixIcon: Icons.payment,
                          ),
                        ),
                        Expanded(
                          child: CustomDropdownField<String>(
                            labelText: 'Tuyến thu',
                            value: _billingRoute,
                            items: ['Tuyến thu 1', 'Tuyến thu 2']
                                .map((route) => DropdownMenuItem<String>(
                                      value: route,
                                      child: Text(route),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _billingRoute = value!;
                              });
                            },
                            prefixIcon: Icons.route,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Chỉ số nước
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chỉ số nước',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCounterInputField(
                            labelText: 'Chỉ số đầu',
                            controller: _startReadingController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCounterInputField(
                            labelText: 'Chỉ số cuối',
                            controller: _endReadingController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            labelText: 'Số m3',
                            floatLabel: true,
                            controller: _consumptionController,
                            prefixIcon: const Icon(Icons.water_drop),
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InputField(
                            labelText: 'Đơn giá',
                            floatLabel: true,
                            controller: _unitPriceController,
                            prefixIcon: const Icon(Icons.attach_money),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _calculateConsumption(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      labelText: 'Tổng tiền thanh toán',
                      controller: _totalPaymentController,
                      prefixIcon: const Icon(Icons.monetization_on),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 1),
            // Cài đặt in hóa đơn
            SwitchListTile(
              title: const Text('In hóa đơn'),
              value: _isInvoiceEnabled,
              onChanged: (value) {
                setState(() {
                  _isInvoiceEnabled = value;
                });
              },
              secondary: const Icon(Icons.print),
            ),
            const SizedBox(height: 1),
            // Nút hành động
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _printInvoice,
                  icon: const Icon(Icons.receipt),
                  label: const Text('Hóa Đơn'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Meter Reading & Bill
                  },
                  icon: const Icon(Icons.water_damage),
                  label: const Text('Ghi chỉ số'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Thoát'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterInputField({
    required String labelText,
    required TextEditingController controller,
  }) {
    return InputField(
      labelText: labelText,
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      floatLabel: true,
      prefixIcon: IconButton(
        onPressed: () {
          setState(() {
            double currentValue = double.tryParse(controller.text) ?? 0;
            controller.text = (currentValue + 1).toString();
            _calculateConsumption();
          });
        },
        icon: const Icon(Icons.add),
      ),
      onChanged: (_) => _calculateConsumption(),
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            double currentValue = double.tryParse(controller.text) ?? 0;
            if (currentValue > 0) {
              controller.text = (currentValue - 1).toString();
              _calculateConsumption();
            }
          });
        },
        icon: const Icon(Icons.remove),
      ),
    );
  }

  Widget _buildCustomerDropdown() {
    return CustomDropdownField<String>(
      labelText: 'Chọn khách hàng',
      value: 'Khách hàng A', // Replace with your actual customer data
      items: ['Khách hàng A', 'Khách hàng B', 'Khách hàng C']
          .map((customer) => DropdownMenuItem<String>(
                value: customer,
                child: Text(customer),
              ))
          .toList(),
      onChanged: (value) {
        // Handle customer selection
      },
      prefixIcon: Icons.person,
    );
  }
}
