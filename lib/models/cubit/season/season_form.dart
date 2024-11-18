import 'package:agriplant/models/cubit/season/season_cubit.dart';
import 'package:agriplant/models/model/season.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeasonForm extends StatefulWidget {
  final Season? season;
  final Function(Season) onSave;

  const SeasonForm({super.key, this.season, required this.onSave});

  @override
  _SeasonFormState createState() => _SeasonFormState();
}

class _SeasonFormState extends State<SeasonForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _muavuController;
  late TextEditingController _namController;
  late TextEditingController _ngaybatdauController;
  late TextEditingController _phuongphapController;
  late TextEditingController _giongController;
  late TextEditingController _dientichController;
  late TextEditingController _soluongController;
  late TextEditingController _giagiongController;
  late TextEditingController _ghichuController;
  late String _selectedSeason;
  List<String> muaVus = ['', 'Đông Xuân', 'Hè Thu', 'Thu Đông'];

  @override
  void initState() {
    super.initState();
    _muavuController = TextEditingController(text: widget.season?.muavu ?? '');
    _namController = TextEditingController(text: widget.season?.nam ?? '');
    _ngaybatdauController =
        TextEditingController(text: widget.season?.ngaybatdau ?? '');
    _phuongphapController =
        TextEditingController(text: widget.season?.phuongphap ?? '');
    _giongController = TextEditingController(text: widget.season?.giong ?? '');
    _dientichController =
        TextEditingController(text: widget.season?.dientich?.toString() ?? '');
    _soluongController =
        TextEditingController(text: widget.season?.soluong?.toString() ?? '');
    _giagiongController =
        TextEditingController(text: widget.season?.giagiong?.toString() ?? '');
    _ghichuController =
        TextEditingController(text: widget.season?.ghichu ?? '');
        setState(() {
          _selectedSeason = widget.season?.muavu ?? '';
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SeasonCubit, List<Season>>(
      builder: (context, state) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    widget.season == null ? 'Thêm Mùa Vụ' : 'Chỉnh Sửa Mùa Vụ',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),  
                  ),
                  const SizedBox(height: 20),
                  // _buildTextField(
                  //   controller: _muavuController,
                  //   labelText: 'Mùa vụ',
                  //   icon: Icons.grass,
                  // ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Mùa Vụ',
                      prefixIcon: const Icon(Icons.emoji_nature),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: _selectedSeason,
                    items: muaVus.map((muaVu) {
                      return DropdownMenuItem(
                        value: muaVu,
                        child: Text(muaVu),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSeason = value!;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Vui lòng chọn mùa vụ'
                        : null,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _namController,
                    labelText: 'Năm',
                    icon: Icons.date_range,
                  ),
                  const SizedBox(height: 15),
                  _buildDateField(),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _phuongphapController,
                    labelText: 'Phương pháp',
                    icon: Icons.science,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _giongController,
                    labelText: 'Giống',
                    icon: Icons.grain,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _dientichController,
                    labelText: 'Diện tích (ha)',
                    icon: Icons.square_foot,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _soluongController,
                    labelText: 'Số lượng',
                    icon: Icons.format_list_numbered,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _giagiongController,
                    labelText: 'Giá giống',
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
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Lưu'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
      // validator: (value) =>
      //     value == null || value.isEmpty ? 'Trường này là bắt buộc' : null,
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

  Widget _buildDateField() {
    return TextFormField(
      controller: _ngaybatdauController,
      readOnly: true,
      validator: (value) =>
          value == null || value.isEmpty ? 'Vui lòng chọn ngày' : null,
      onTap: _pickDate,
      decoration: InputDecoration(
        labelText: 'Ngày bắt đầu',
        prefixIcon: const Icon(Icons.calendar_today),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _ngaybatdauController.text.isNotEmpty
          ? DateTime.parse(_ngaybatdauController.text)
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _ngaybatdauController.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newSeason = Season(
        id: widget.season?.id,
        muavu: _selectedSeason,
        nam: _namController.text,
        ngaybatdau: _ngaybatdauController.text,
        phuongphap: _phuongphapController.text,
        giong: _giongController.text,
        dientich: double.tryParse(_dientichController.text),
        soluong: int.tryParse(_soluongController.text),
        giagiong: int.tryParse(_giagiongController.text),
        ghichu: _ghichuController.text,
      );
      context.read<SeasonCubit>().addUpdateSeason(newSeason);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm mới thành công!')),
      );
      Navigator.pop(context);
    }
  }
}
