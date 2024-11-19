import 'package:agriplant/models/model/nhatky.dart';
import 'package:agriplant/pages/diary/nhatky_form.dart';
import 'package:agriplant/utils/contants.dart';
import 'package:flutter/material.dart';

class FarmingLogItem extends StatelessWidget {
  final FarmingLog log;
  final int index;

  const FarmingLogItem({Key? key, required this.log, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _openBottomSheet(context),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Hình ảnh bên trái
              GestureDetector(
                onTap: () {
                  _showImageDialog(context, log.image != null ? imageUrl + log.image! : noImage, index);
                },
                child: Hero(
                  tag: 'imageHero$index',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      log.image != null ? imageUrl + log.image! : noImage,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          noImage,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Thông tin bên phải
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.congViec ?? "Không có tiêu đề",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.calendar_today, log.ngayThucHien ?? "Không có thông tin"),
                    const SizedBox(height: 6),
                    _buildInfoRow(Icons.timeline, log.giaiDoan ?? "Không có thông tin"),
                    const SizedBox(height: 6),
                    _buildInfoRow(Icons.description, log.chiTietCongViec ?? "Không có thông tin"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: FarmingLogForm(
            log: log,
            index: index,
          ),
        );
      },
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Hero(
              tag: 'imageHero$index',
              child: InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        noImage,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
