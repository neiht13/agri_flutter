// lib/presentation/screen/profile/profile_page.dart
import 'package:agriplant/api_service.dart';
import 'package:agriplant/models/cubit/user/user_cubit.dart';
import 'package:agriplant/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late QrImage qrImage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var currentUser = await ApiService().getCurrentUser();
    context.read<UserCubit>().fetchUser(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
        // backgroundColor: Colors.green[700],

        actions: [
          IconButton(
            onPressed: () {
              // Hiển thị hộp thoại xác nhận đăng xuất
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Đăng xuất'),
                  content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.go('/login');
                        showCustomSnackBar(
                          context,
                          "Đăng xuất thành công",
                          icon: FontAwesomeIcons.info,
                        );
                      },
                      child: const Text(
                        'Đăng xuất',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(IconlyBroken.logout),
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserLoaded) {

            var user = state.user;

                                  var url = baseUrl.replaceAll("api", "") + 'timeline?user=${user?.username}';

              final qrCode = QrCode(
            4,
            QrErrorCorrectLevel.M,
          )..addData(url);

          qrImage = QrImage(qrCode);
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Hình ảnh hồ sơ và tên người dùng
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.green.shade200,
                        backgroundImage: user?.image != null
                            ? NetworkImage(imageUrl + (user?.image ?? ""))
                            : null,
                        child: user?.image == null
                            ? Text(
                          user!.name!.substring(0, 1).toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            // Thêm chức năng thay đổi hình ảnh hồ sơ
                            // Ví dụ: mở dialog để chọn ảnh từ thư viện
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Tên và email
                Center(
                  child: Column(
                    children: [
                      Text(
                        user?.name ?? "",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user?.email ?? "",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Các mục chức năng
                Column(
                  children: [
                    _buildProfileOption(
                      context,
                      icon: FontAwesomeIcons.userPen,
                      title: "Chỉnh sửa thông tin",
                      onTap: () {
                        context.push('/editprofile');
                      },
                    ),
                    const Divider(height: 1),
                    _buildProfileOption(
                      context,
                      icon: FontAwesomeIcons.lock,
                      title: "Thay đổi mật khẩu",
                      onTap: () {
                        // Điều hướng đến trang thay đổi mật khẩu
                        context.push('/changepassword');
                      },
                    ),
                    const Divider(height: 1),
                    _buildProfileOption(
                      context,
                      icon: FontAwesomeIcons.bell,
                      title: "Thông báo",
                      onTap: () {
                        // Điều hướng đến trang thông báo
                        context.push('/notifications');
                      },
                    ),
                    const Divider(height: 1),
                    _buildProfileOption(
                      context,
                      icon: FontAwesomeIcons.gear,
                      title: "Cài đặt",
                      onTap: () {
                        context.push('/settings');
                      },
                    ),
                    const Divider(height: 1),
                    _buildProfileOption(
                      context,
                      icon: FontAwesomeIcons.circleQuestion,
                      title: "Trợ giúp",
                      onTap: () {
                        // Điều hướng đến trang trợ giúp
                        context.push('/help');
                      },
                    ),
                    const Divider(height: 1),
                    _buildProfileOption(
                      context,
                      icon: FontAwesomeIcons.circleInfo,
                      title: "Giới thiệu",
                      onTap: () {
                        // Điều hướng đến trang giới thiệu
                        context.push('/about');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
               Container(
                height: 200,
                width: 200,
                alignment: Alignment.center,
                 child: PrettyQrView(
                    qrImage: qrImage,
                    decoration: const PrettyQrDecoration(
                      background: Colors.white,
                      shape: PrettyQrSmoothSymbol(
                        color: primaryColor
                      )
                     
                    ),
                  ),
               ),
                const SizedBox(height: 20),
                // Thêm các phần khác nếu cần
              ],
            );
          }
          return const SizedBox();
          
        },
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context,
      {required IconData icon,
        required String title,
        required VoidCallback onTap}) {
    return ListTile(
      leading: FaIcon(
        icon,
        color: Colors.green[700],
      ),
      title: Text(title),
      trailing:
      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
