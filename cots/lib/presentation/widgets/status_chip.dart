import 'package:flutter/material.dart';
import '../../design_system/app_color.dart';

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    if (status == 'SELESAI') {
      bg = AppColors.successBg;
      fg = AppColors.successText;
    } else if (status == 'TERLAMBAT') {
      bg = AppColors.lateBg;
      fg = AppColors.danger;
    } else {
      bg = AppColors.primary.withOpacity(.12);
      fg = AppColors.primary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: TextStyle(color: fg, fontSize: 12)),
    );
  }
}
