import 'package:flutter/material.dart';
import '../../design_system/app_color.dart';
import '../../design_system/app_typography.dart';

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
      // avoid deprecated withOpacity; use withAlpha (~0.12 * 255 = 31)
      bg = AppColors.primary.withAlpha(31);
      fg = AppColors.primary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status == 'SELESAI' ? 'Selesai' : status == 'TERLAMBAT' ? 'Terlambat' : 'Berjalan',
        style: AppTypography.caption.copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
} 
