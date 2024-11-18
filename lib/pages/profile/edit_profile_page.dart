// edit_personal_info_page.dart
import 'dart:convert';

import 'package:agriplant/api_service.dart';
import 'package:agriplant/models/cubit/user/user_cubit.dart';
import 'package:agriplant/utils/contants.dart';
import 'package:agriplant/widgets/input_field.dart'; // Use the custom InputField
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import 'package:uuid/uuid.dart';

class EditPersonalInfoPage extends StatefulWidget {
  const EditPersonalInfoPage({super.key});

  @override
  _EditPersonalInfoPageState createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final controllers = PersonalInfoControllers();
  String? _imageName;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    final userState = context.read<UserCubit>().state;
    if (userState is UserLoaded && userState.user != null) {
      controllers.id.text = userState.user!.id ?? '';
      controllers.username.text = userState.user!.username ?? '';
      controllers.name.text = userState.user!.name ?? '';
      controllers.email.text = userState.user!.email ?? '';
      controllers.phone.text = userState.user!.phone ?? '';
      controllers.mota.text = userState.user!.mota ?? '';
      controllers.diachi.text = userState.user!.diachi ?? '';
      controllers.dientich.text =
          userState.user!.dientich?.toString() ?? '';
      controllers.donvihtx.text = userState.user!.donvihtx ?? '';
      controllers.masovungtrong.text = userState.user!.masovungtrong ?? '';
      controllers.location.text = userState.user!.location ?? '';
      _imageName = userState.user!.image;
    }
  }

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  String get _imageUrl {
    if (_imageName != null && _imageName!.isNotEmpty) {
      return imageUrl + _imageName!;
    }
    return '';
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        final bytes = await pickedFile.readAsBytes();
        String base64Image = base64Encode(bytes);
        String imageName = '${const Uuid().v4()}.jpg';

        await ApiService().uploadImage(imageName, base64Image);

        setState(() {
          _imageName = imageName;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload hình ảnh thành công!')),
        );
      } catch (e) {
        print('Lỗi upload hình ảnh: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload hình ảnh thất bại: ${e.toString()}'),
            action: SnackBarAction(
              label: 'Thử lại',
              onPressed: _pickImage,
            ),
          ),
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dịch vụ định vị chưa được bật.')),
        );
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quyền truy cập vị trí bị từ chối.')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Quyền truy cập vị trí đã bị từ chối vĩnh viễn. Vui lòng bật trong cài đặt.')),
        );
        Geolocator.openAppSettings();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        controllers.location.text =
            '${position.latitude},${position.longitude}';
      });
    } catch (e) {
      print('Lỗi khi lấy vị trí: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lấy vị trí: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isFetchingLocation = false;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final userState = context.read<UserCubit>().state;
      if (userState is UserLoaded && userState.user != null) {
        final updatedUser = userState.user!.copyWith(
          name: controllers.name.text,
          email: controllers.email.text,
          phone: controllers.phone.text,
          mota: controllers.mota.text,
          diachi: controllers.diachi.text,
          dientich: controllers.dientich.text.isNotEmpty
              ? double.parse(controllers.dientich.text)
              : null,
          donvihtx: controllers.donvihtx.text,
          masovungtrong: controllers.masovungtrong.text,
          location: controllers.location.text,
          image: _imageName ?? "",
        );
        context.read<UserCubit>().updateUser(updatedUser);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể cập nhật thông tin. Vui lòng thử lại.')),
        );
      }
    }
  }

  Widget _buildLocationField() {
    return Row(
      children: [
        Expanded(
          child: InputField(
            controller: controllers.location,
            labelText: 'Vị trí hiện tại',
            prefixIcon: Icon(Icons.location_on,
                color: Theme.of(context).colorScheme.primary),
            readOnly: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập vị trí';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: _isFetchingLocation ? null : _getCurrentLocation,
          icon: _isFetchingLocation
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.my_location, color: Colors.white),
          label: const Text(
            'Lấy vị trí',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15),
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarField() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[200],
        backgroundImage: _imageUrl.isNotEmpty ? NetworkImage(_imageUrl) : null,
        child: _imageUrl.isNotEmpty
            ? null
            : (_isUploading
                ? const Center(child: CircularProgressIndicator())
                : const Center(
                    child: Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                  )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chỉnh sửa thông tin cá nhân'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is UserLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cập nhật thông tin thành công')),
            );
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Avatar
                _buildAvatarField(),
                const SizedBox(height: 20),
                // Username (read-only)
                InputField(
                  controller: controllers.username,
                  labelText: 'Tên đăng nhập',
                  prefixIcon: Icon(Icons.person,
                      color: Theme.of(context).colorScheme.primary),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                // Name
                InputField(
                  controller: controllers.name,
                  labelText: 'Họ và tên',
                  prefixIcon: Icon(Icons.person_outline,
                      color: Theme.of(context).colorScheme.primary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ và tên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Email
                InputField(
                  controller: controllers.email,
                  labelText: 'Email',
                  hintText: 'example@domain.com',
                  prefixIcon: Icon(Icons.email_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  keyboardType: TextInputType.emailAddress,
                  // validator: (value) {
                  //   if (value != null &&
                  //       !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  //     return 'Email không hợp lệ';
                  //   }
                  //   return null;
                  // },
                  autofillHints: const [AutofillHints.email],
                ),
                const SizedBox(height: 16),
                // Phone
                InputField(
                  controller: controllers.phone,
                  labelText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone_android_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    return null;
                  },
                  autofillHints: const [AutofillHints.telephoneNumber],
                ),
                const SizedBox(height: 16),
                // Description
                InputField(
                  controller: controllers.mota,
                  labelText: 'Mô tả',
                  prefixIcon: Icon(Icons.description_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                const SizedBox(height: 16),
                // Address
                InputField(
                  controller: controllers.diachi,
                  labelText: 'Địa chỉ',
                  prefixIcon: Icon(Icons.home_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                const SizedBox(height: 16),
                // Area
                InputField(
                  controller: controllers.dientich,
                  labelText: 'Diện tích',
                  prefixIcon: Icon(Icons.crop_square_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (double.tryParse(value) == null) {
                        return 'Diện tích phải là số';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Cooperative Unit
                InputField(
                  controller: controllers.donvihtx,
                  labelText: 'Đơn vị HTX',
                  prefixIcon: Icon(Icons.business_outlined, 
                      color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: 16),
                // Planting Area Code
                InputField(
                  controller: controllers.masovungtrong,
                  labelText: 'Mã số vùng trồng',
                  prefixIcon: Icon(Icons.code_outlined,
                      color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: 16),
                // Location
                _buildLocationField(),
                const SizedBox(height: 30),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Lưu thay đổi',
                      style:
                          TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// PersonalInfoControllers class
class PersonalInfoControllers {
  final id = TextEditingController();
  final username = TextEditingController();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final mota = TextEditingController();
  final diachi = TextEditingController();
  final dientich = TextEditingController();
  final donvihtx = TextEditingController();
  final masovungtrong = TextEditingController();
  final location = TextEditingController();

  void dispose() {
    id.dispose();
    username.dispose();
    name.dispose();
    email.dispose();
    phone.dispose();
    mota.dispose();
    diachi.dispose();
    dientich.dispose();
    donvihtx.dispose();
    masovungtrong.dispose();
    location.dispose();
  }
}
