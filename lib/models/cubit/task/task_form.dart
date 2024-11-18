import 'package:agriplant/models/model/task.dart';
import 'package:flutter/material.dart';

class UpdateTaskForm extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const UpdateTaskForm({super.key, this.task, required this.onSave});

  @override
  _UpdateTaskFormState createState() => _UpdateTaskFormState();
}

class _UpdateTaskFormState extends State<UpdateTaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _detailsController;
  late TextEditingController _costController;
  late TextEditingController _ghichuController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.task?.tenCongViec ?? '');
    _detailsController =
        TextEditingController(text: widget.task?.chitietcongviec ?? '');
    _costController =
        TextEditingController(text: widget.task?.chiphidvt ?? '');
    _ghichuController =
        TextEditingController(text: widget.task?.ghichu ?? '');
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
              widget.task == null ? 'Thêm Công Việc' : 'Chỉnh Sửa Công Việc',
              style:
                  theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _nameController,
              labelText: 'Tên công việc',
              icon: Icons.work_outline,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: _detailsController,
              labelText: 'Chi tiết công việc',
              icon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: _costController,
              labelText: 'Chi phí',
              icon: Icons.attach_money,
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
      final newTask = Task(
        tenCongViec: _nameController.text,
        chitietcongviec: _detailsController.text,
        chiphidvt: _costController.text,
        ghichu: _ghichuController.text,
      );
      widget.onSave(newTask); // Lưu dữ liệu và đóng BottomSheet
    }
  }
}