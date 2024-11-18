import 'package:agriplant/models/model/stage.dart';
import 'package:flutter/material.dart';

class UpdateStageForm extends StatefulWidget {
  final Stage? stage;
  final Function(Stage) onSave;

  const UpdateStageForm({super.key, this.stage, required this.onSave});

  @override
  _UpdateStageFormState createState() => _UpdateStageFormState();
}

class _UpdateStageFormState extends State<UpdateStageForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _colorController;
  late TextEditingController _ghichuController;
  late TextEditingController _sttController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.stage?.tenGiaiDoan ?? '');
    _colorController = TextEditingController(text: widget.stage?.color ?? '');
    _ghichuController = TextEditingController(text: widget.stage?.ghichu ?? '');
    _sttController =
        TextEditingController(text: widget.stage?.stt?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              widget.stage == null ? 'Thêm Giai Đoạn' : 'Chỉnh Sửa Giai Đoạn',
              style:
                  theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _nameController,
              labelText: 'Tên giai đoạn',
              icon: Icons.label,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: _colorController,
              labelText: 'Màu sắc',
              icon: Icons.color_lens,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: _sttController,
              labelText: 'Thứ tự',
              icon: Icons.format_list_numbered,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: _ghichuController,
              labelText: 'Ghi chú',
              icon: Icons.note,
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) =>
          value == null || value.isEmpty ? 'Trường này là bắt buộc' : null,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newStage = Stage(
        tenGiaiDoan: _nameController.text,
        color: _colorController.text,
        ghichu: _ghichuController.text,
        stt: int.tryParse(_sttController.text),
      );
      widget.onSave(newStage); // Lưu dữ liệu và đóng BottomSheet
    }
  }
}