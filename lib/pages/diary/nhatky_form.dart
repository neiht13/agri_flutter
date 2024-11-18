import 'dart:convert'; // Để sử dụng base64
import 'dart:typed_data'; // Để xử lý Uint8List

import 'package:agriplant/api_service.dart';
import 'package:agriplant/models/cubit/nhatky/nhatky_cubit.dart';
import 'package:agriplant/models/cubit/product/agrochemicals_cubit.dart';
import 'package:agriplant/models/cubit/season/season_cubit.dart';
import 'package:agriplant/models/cubit/stage/stage_cubit.dart';
import 'package:agriplant/models/cubit/task/task_cubit.dart';
import 'package:agriplant/models/cubit/product/agrochemicals.dart'; // Import AgrochemicalsCubit
import 'package:agriplant/models/cubit/product/agrochemicals_state.dart'; // Import AgrochemicalsState
import 'package:agriplant/models/model/nhatky.dart';
import 'package:agriplant/models/model/season.dart';
import 'package:agriplant/models/model/stage.dart';
import 'package:agriplant/models/model/task.dart';
import 'package:agriplant/utils/contants.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart'; // Thêm package uuid để tạo imageName duy nhất
import 'package:agriplant/widgets/input_field.dart'; // Import InputField
import 'package:agriplant/widgets/custom_dropdown_field.dart'; // Import CustomDropdownField

class FarmingLogForm extends StatefulWidget {
  final FarmingLog? log;
  final int? index;

  const FarmingLogForm({super.key, this.log, this.index});

  @override
  _FarmingLogFormState createState() => _FarmingLogFormState();
}

class _FarmingLogFormState extends State<FarmingLogForm> {
  final _formKey = GlobalKey<FormState>();

  // Các TextEditingController hiện tại...
  late TextEditingController _muaVuController;
  late TextEditingController _chiTietTaskController;
  late TextEditingController _ngayThucHienController;
  late TextEditingController _xIdController;
  late TextEditingController _chiPhiVatTuController;
  late TextEditingController _chiPhiCongController;
  late TextEditingController _soLuongVatTuController;
  late TextEditingController _soLuongCongController;
  late TextEditingController _thanhTienController;
  late TextEditingController _tenPhanController;
  late TextEditingController _tenThuocController;

  // Thay đổi từ File? sang String? để lưu imageName
  String? _imageName;
  // Future<Uint8List?>? _imageFuture; // Để lưu dữ liệu hình ảnh
  bool _isUploading = false;

  String? donViTinh;
  Season? _selectedSeason;
  Stage? _selectedStage;
  Task? _selectedTask;

  List<String> donViTinhs = [
    "",
    "công",
    "kg",
    "lít",
    "gói",
    "chai",
    "bao",
    "người",
    "ngày",
    "lần"
  ];

  final ImagePicker _picker = ImagePicker();

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _muaVuController = TextEditingController(text: widget.log?.muaVu ?? '');
    _chiTietTaskController =
        TextEditingController(text: widget.log?.chiTietCongViec ?? '');
    _ngayThucHienController = TextEditingController(
        text: widget.log?.ngayThucHien ??
            DateFormat('dd/MM/yyyy').format(DateTime.now()));
    _xIdController = TextEditingController(text: widget.log?.xId ?? '');
    _chiPhiVatTuController =
        TextEditingController(text: widget.log?.chiPhiVatTu.toString() ?? '');
    _chiPhiCongController =
        TextEditingController(text: widget.log?.chiPhiCong.toString() ?? '');
    _soLuongVatTuController =
        TextEditingController(text: widget.log?.soLuongVatTu.toString() ?? '');
    _soLuongCongController =
        TextEditingController(text: widget.log?.soLuongCong.toString() ?? '');
    _thanhTienController =
        TextEditingController(text: widget.log?.thanhTien.toString() ?? '');
    _tenPhanController = TextEditingController(text: widget.log?.tenPhan ?? '');
    _tenThuocController =
        TextEditingController(text: widget.log?.tenThuoc ?? '');

    donViTinh = widget.log?.donViTinh ?? '';

    if (widget.log?.image != null && widget.log!.image!.isNotEmpty) {
      _imageName = widget.log!.image!;
      // _imageFuture = ApiService().fetchImage(_imageName!);
    }

    // Khởi tạo danh sách sản phẩm từ Cubit nếu có FarmingLog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final agrochemicalsCubit = context.read<AgrochemicalsCubit>()
        ..fetchAgrochemicalss(widget.log);
      if (widget.log != null) {
        if (widget.log!.agrochemicals != null &&
            widget.log!.agrochemicals!.isNotEmpty) {
          agrochemicalsCubit.setAgrochemicalss(
              List<Agrochemicals>.from(widget.log!.agrochemicals!));
        } else {
          // Nếu không có sản phẩm từ FarmingLog, thêm sản phẩm dựa trên công việc
          List<Agrochemicals> initialAgrochemicalss = [];
          if (widget.log!.tenPhan != null && widget.log!.tenPhan!.isNotEmpty) {
            initialAgrochemicalss.add(Agrochemicals(
              name: widget.log!.tenPhan!,
              type: 'fertilizer',
              isOrganic: false,
            ));
          }
          if (widget.log!.tenThuoc != null &&
              widget.log!.tenThuoc!.isNotEmpty) {
            initialAgrochemicalss.add(Agrochemicals(
              name: widget.log!.tenThuoc!,
              type: 'pesticides',
              isOrganic: false,
            ));
          }
          agrochemicalsCubit.setAgrochemicalss(initialAgrochemicalss);
        }
      } else {
        // Nếu thêm mới FarmingLog, có thể khởi tạo danh sách sản phẩm rỗng hoặc theo công việc mặc định
        if (_selectedTask != null) {
          String productType = _selectedTask!.tenCongViec == 'Bón phân'
              ? 'fertilizer'
              : 'pesticides';
          agrochemicalsCubit.setAgrochemicalss([]);
        }
      }
    });
  }

  void _initializeSelectedItems(
      List<Stage> giaiDoans, List<Task> tasks, List<Season> seasons) {
    if (_initialized) return;

    if (widget.log != null) {
      _selectedSeason = seasons.firstWhereOrNull(
        (season) => season.id == widget.log!.muaVuId,
      );

      _selectedStage = giaiDoans.firstWhereOrNull(
        (stage) => stage.tenGiaiDoan == widget.log!.giaiDoan,
      );

      if (_selectedStage != null) {
        final filteredTasks = tasks
            .where((task) => task.giaidoanId == _selectedStage!.id)
            .toList();
        _selectedTask = filteredTasks.firstWhereOrNull(
          (task) => task.tenCongViec == widget.log!.congViec,
        );
      }
    }
    _initialized = true;
  }

  @override
  void dispose() {
    _muaVuController.dispose();
    _chiTietTaskController.dispose();
    _ngayThucHienController.dispose();
    _xIdController.dispose();
    _chiPhiVatTuController.dispose();
    _chiPhiCongController.dispose();
    _soLuongVatTuController.dispose();
    _soLuongCongController.dispose();
    _thanhTienController.dispose();
    _tenPhanController.dispose();
    _tenThuocController.dispose();
    super.dispose();
  }

  void _addAgrochemicals(FarmingLog? log) {
    TextEditingController productName = TextEditingController();
    TextEditingController lieuLuong = TextEditingController();
    TextEditingController donViTinh2 = TextEditingController();
    bool isOrganic = false;
    String productType =
        _selectedTask!.tenCongViec == 'Bón phân' ? 'phân' : 'thuốc';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                  'Thêm ${_selectedTask!.tenCongViec == 'Bón phân' ? 'phân' : 'thuốc'}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputField(
                    labelText:
                        'Tên ${_selectedTask!.tenCongViec == 'Bón phân' ? 'phân' : 'thuốc'}',
                    controller: productName,
                    prefixIcon: const Icon(Icons.grass),
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    labelText: 'Liều lượng',
                    controller: lieuLuong,
                    prefixIcon: const Icon(Icons.local_florist),
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    labelText: 'Đơn vị',
                    controller: donViTinh2,
                    prefixIcon: const Icon(Icons.work_outline),
                  ),
                  const SizedBox(height: 15),
                  CheckboxListTile(
                    title: Text(
                        '${_selectedTask!.tenCongViec == 'Bón phân' ? 'Phân' : 'Thuốc'} hữu cơ'),
                    value: isOrganic,
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onChanged: (value) {
                      setStateDialog(() {
                        isOrganic = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Hủy'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Thêm'),
                  onPressed: () {
                    if (productName.text.isNotEmpty) {
                      final newAgrochemicals = Agrochemicals(
                        id: CustomObjectId().toHexString(),
                        name: productName.text,
                        type: productType,
                        isOrganic: isOrganic,
                        lieuLuong: lieuLuong.text,
                        donViTinh: donViTinh2.text,
                        farmingLogId: log?.id,
                      );
                      context
                          .read<AgrochemicalsCubit>()
                          .addAgrochemicals(newAgrochemicals);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vui lòng nhập tên sản phẩm'),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _pickDate() async {
    DateTime initialDate = _ngayThucHienController.text.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parse(_ngayThucHienController.text)
        : DateFormat('dd/MM/yyyy')
            .parse(DateFormat('dd/MM/yyyy').format(DateTime.now()));
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _ngayThucHienController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        // Đọc file và chuyển đổi sang base64
        final bytes = await pickedFile.readAsBytes();
        String base64Image = base64Encode(bytes);

        // Tạo imageName duy nhất (sử dụng UUID)
        String imageName = '${Uuid().v4()}.jpg';

        // Upload hình ảnh
        await ApiService().uploadImage(imageName, base64Image);

        setState(() {
          _imageName = imageName;
          // _imageFuture = imageFuture;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload hình ảnh thành công!')),
        );
      } catch (e) {
        print('Lỗi upload hình ảnh: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload hình ảnh thất bại: $e')),
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Debug: In giá trị của _selectedSeason trước khi submit
      print('Selected Season: ${_selectedSeason?.id}');

      ApiService apiService = ApiService();
      String? currentUser = await apiService.getCurrentUser();

      // Lấy danh sách sản phẩm từ Cubit
      List<Agrochemicals> agrochemicals = [];
      if (context.read<AgrochemicalsCubit>().state is AgrochemicalsLoaded) {
        agrochemicals =
            (context.read<AgrochemicalsCubit>().state as AgrochemicalsLoaded)
                .agrochemicalss;
      }

      FarmingLog newLog = FarmingLog(
        id: widget.log?.id,
        muaVu: _selectedSeason?.muavu ?? '',
        muaVuId: _selectedSeason?.id ?? '',
        giaiDoan: _selectedStage?.tenGiaiDoan ?? '',
        giaiDoanId: _selectedStage?.id ?? '',
        congViecId: _selectedTask?.id ?? '',
        congViec: _selectedTask?.tenCongViec ?? '',
        chiTietCongViec: _chiTietTaskController.text,
        donViTinh: donViTinh,
        ngayThucHien: _ngayThucHienController.text,
        xId: _xIdController.text,
        chiPhiVatTu: double.tryParse(_chiPhiVatTuController.text) ?? 0.0,
        chiPhiCong: double.tryParse(_chiPhiCongController.text) ?? 0.0,
        soLuongVatTu: double.tryParse(_soLuongVatTuController.text) ?? 0.0,
        soLuongCong: double.tryParse(_soLuongCongController.text) ?? 0.0,
        thanhTien: double.tryParse(_thanhTienController.text) ?? 0.0,
        image: _imageName,
        tenPhan: _tenPhanController.text,
        tenThuoc: _tenThuocController.text,
        agrochemicals: agrochemicals,
        uId: currentUser ?? '',
      );

      if (widget.log == null) {
        context.read<FarmingLogCubit>().addFarmingLog(newLog);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thêm mới thành công!')));
      } else {
        context.read<FarmingLogCubit>().updateFarmingLog(newLog);
        showCustomSnackBar(
          context,
          'Cập nhật thành công!',
          type: "warning",
        );
      }
      Navigator.pop(context);
    }
  }

  void _calculateThanhTien() {
    double chiPhiVatTu = double.tryParse(_chiPhiVatTuController.text) ?? 0.0;
    double chiPhiCong = double.tryParse(_chiPhiCongController.text) ?? 0.0;
    double soLuongVatTu = double.tryParse(_soLuongVatTuController.text) ?? 0.0;
    double soLuongCong = double.tryParse(_soLuongCongController.text) ?? 0.0;

    double dientich = _selectedSeason?.dientich ?? 1;

    double thanhTien =
        dientich * ((chiPhiVatTu * soLuongVatTu) + (chiPhiCong * soLuongCong));
    setState(() {
      _thanhTienController.text = thanhTien.toStringAsFixed(0);
    });
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, FarmingLog log) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return showAdvancedAlertDialog(
              context: context,
              title: 'Cảnh báo',
              content: 'Xóa nhật ký công việc này?',
              icon: Icon(Icons.warning, color: Colors.orange),
              backgroundColor: Colors.white,
              titleColor: Colors.orange,
              confirmText: 'Đồng ý',
              confirmTextColor: Colors.blueAccent,
              cancelText: 'Hủy',
              cancelTextColor: Colors.red,
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<StageCubit, List<Stage>>(
      builder: (context, giaiDoans) {
        return BlocBuilder<TaskCubit, List<Task>>(
          builder: (context, tasks) {
            return BlocBuilder<SeasonCubit, List<Season>>(
              builder: (context, seasons) {
                if (giaiDoans.isEmpty || tasks.isEmpty || seasons.isEmpty) {
                  return const FractionallySizedBox(
                  heightFactor: 0.9,
                  widthFactor: 1,
                    child: CupertinoActivityIndicator(),
                  );
                }

                if (!_initialized) {
                  _initializeSelectedItems(giaiDoans, tasks, seasons);
                }

                List<Task> filteredTasks = _selectedStage != null
                    ? tasks
                        .where((task) => task.giaidoanId == _selectedStage!.id)
                        .toList()
                    : [];

                bool showTenPhan = _selectedTask != null &&
                    _selectedTask!.tenCongViec == 'Bón phân';
                bool showTenThuoc = _selectedTask != null &&
                    _selectedTask!.tenCongViec == 'Phun thuốc';
                bool showAgrochemicalsInput = _selectedTask != null &&
                    (_selectedTask!.tenCongViec == 'Bón phân' ||
                        _selectedTask!.tenCongViec == 'Phun thuốc');

                return FractionallySizedBox(
                  heightFactor: 0.9,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                              widget.log == null
                                  ? 'Thêm Nhật Ký Mới'
                                  : 'Chỉnh Sửa Nhật Ký',
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          // Hình ảnh
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: _imageName != null &&
                                      _imageName!.isNotEmpty
                                  ? Image.network(
                                      imageUrl + _imageName!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                          child: Text(
                                            'Lỗi khi tải hình ảnh',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        );
                                      },
                                    )
                                  : (_isUploading
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : const Center(
                                          child: Icon(Icons.camera_alt,
                                              size: 50, color: Colors.grey))),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Các trường nhập liệu và dropdown
                          // Chọn Mùa Vụ
                          CustomDropdownField<Season>(
                            labelText: 'Mùa Vụ',
                            value: _selectedSeason,
                            prefixIcon: Icons.emoji_nature,
                            items: seasons.map((season) {
                              return DropdownMenuItem(
                                value: season,
                                child: Text("${season.muavu} - ${season.nam}"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSeason = value;
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          // Chọn Giai Đoạn
                          CustomDropdownField<Stage>(
                            labelText: 'Giai Đoạn',
                            value: _selectedStage,
                            items: giaiDoans.map((stage) {
                              return DropdownMenuItem<Stage>(
                                value: stage,
                                child: Row(children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: hexToColor(stage.color)),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(stage.tenGiaiDoan ?? "")
                                ]),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedStage = value;
                                _selectedTask =
                                    null; // Reset lựa chọn công việc
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          // Chọn Công Việc
                          CustomDropdownField<Task>(
                            labelText: 'Công Việc',
                            value: _selectedTask,
                            prefixIcon: Icons.work_outline,
                            items: filteredTasks.map((task) {
                              return DropdownMenuItem<Task>(
                                value: task,
                                child: Text(task.tenCongViec ?? ""),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedTask = value;
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          if (showAgrochemicalsInput)
                            BlocBuilder<AgrochemicalsCubit, AgrochemicalsState>(
                              builder: (context, state) {
                                List<Agrochemicals> agrochemicals = [];
                                if (state is AgrochemicalsLoaded)
                                  agrochemicals = state.agrochemicalss;

                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Danh sách ${_selectedTask!.tenCongViec == 'Bón phân' ? 'phân' : 'thuốc'} ",
                                          style: theme.textTheme.titleMedium),
                                      const SizedBox(height: 10),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: agrochemicals.length,
                                        itemBuilder: (context, index) {
                                          final product = agrochemicals[index];
                                          return ListTile(
                                            title: Text(product.name),
                                            subtitle: Text(
                                                "Loại: ${product.type}, Hữu cơ: ${product.isOrganic ? 'Có' : 'Không'}"),
                                            trailing: IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.redAccent),
                                              onPressed: () {
                                                product.id != null
                                                    ? context
                                                        .read<
                                                            AgrochemicalsCubit>()
                                                        .removeAgrochemicals(
                                                            product.id ?? "")
                                                    : null;
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          _addAgrochemicals(widget.log);
                                        },
                                        icon: const Icon(Icons.add),
                                        label: Text(
                                            "Thêm ${_selectedTask!.tenCongViec == 'Bón phân' ? 'phân' : 'th'}"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: theme.primaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 18),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 15),

                          // Chi Tiết Công Việc
                          InputField(
                            labelText: 'Chi Tiết Công Việc',
                            controller: _chiTietTaskController,
                            prefixIcon: const Icon(Icons.description),
                            maxLines: 2,
                            // validator: (value) => value == null || value.isEmpty
                            //     ? 'Vui lòng nhập chi tiết công việc'
                            //     : null,
                          ),
                          const SizedBox(height: 15),
                          // Conditional Input: Tên Phân
                          if (showTenPhan)
                            InputField(
                              labelText: 'Tên Phân',
                              controller: _tenPhanController,
                              prefixIcon: const Icon(Icons.grass),
                            ),
                          if (showTenPhan) const SizedBox(height: 15),
                          // Conditional Input: Tên Thuốc
                          if (showTenThuoc)
                            InputField(
                              labelText: 'Tên Thuốc',
                              controller: _tenThuocController,
                              prefixIcon: const Icon(Icons.local_florist),
                            ),
                          if (showTenThuoc) const SizedBox(height: 15),
                          // Chi Phí Vật Tư
                          InputField(
                            labelText: 'Chi Phí Vật Tư',
                            controller: _chiPhiVatTuController,
                            prefixIcon: const Icon(Icons.attach_money),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => _calculateThanhTien(),
                          ),
                          const SizedBox(height: 15),
                          // Số Lượng Vật Tư
                          InputField(
                            labelText: 'Số Lượng vật tư /ha',
                            controller: _soLuongVatTuController,
                            prefixIcon: const Icon(Icons.confirmation_number),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => _calculateThanhTien(),
                          ),
                          const SizedBox(height: 15),
                          // Chi Phí Công
                          InputField(
                            labelText: 'Chi Phí Công',
                            controller: _chiPhiCongController,
                            prefixIcon: const Icon(Icons.attach_money),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => _calculateThanhTien(),
                          ),
                          const SizedBox(height: 15),
                          // Số Lượng Công
                          InputField(
                            labelText: 'Số Lượng Công /ha',
                            controller: _soLuongCongController,
                            prefixIcon: const Icon(Icons.confirmation_number),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => _calculateThanhTien(),
                          ),
                          const SizedBox(height: 15),
                          // Thành Tiền (Read-Only)
                          InputField(
                            labelText: 'Thành Tiền',
                            controller: _thanhTienController,
                            prefixIcon: const Icon(Icons.attach_money),
                            readOnly: true,
                          ),
                          const SizedBox(height: 15),
                          // Đơn Vị
                          CustomDropdownField<String>(
                            labelText: 'Đơn vị tính',
                            value: donViTinh,
                            prefixIcon: Icons.work_outline,
                            items: donViTinhs.map((donViTinh) {
                              return DropdownMenuItem<String>(
                                value: donViTinh,
                                child: Text(donViTinh.isNotEmpty
                                    ? donViTinh
                                    : "Chọn đơn vị"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                donViTinh = value;
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          // Ngày Thực Hiện
                          InputField(
                            labelText: 'Ngày Thực Hiện',
                            controller: _ngayThucHienController,
                            prefixIcon: const Icon(Icons.calendar_today),
                            readOnly: true,
                            onTap: _pickDate,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Vui lòng chọn ngày'
                                : null,
                          ),
                          const SizedBox(height: 30),
                          // Nút hành động
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (widget.log != null)
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    bool confirm =
                                        await _showConfirmationDialog(
                                            context, widget.log!);
                                    if (confirm) {
                                      context
                                          .read<FarmingLogCubit>()
                                          .deleteFarmingLog(widget.log!);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Đã xóa thành công!')));
                                      await Future.delayed(
                                          const Duration(milliseconds: 300));
                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Xóa'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 18)),
                                ),
                              ElevatedButton.icon(
                                onPressed: _submitForm,
                                icon: const Icon(Icons.save),
                                label: Text(widget.log == null
                                    ? 'Thêm Mới'
                                    : 'Cập Nhật'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
