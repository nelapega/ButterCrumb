
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;
  final bool showMessage;

  const LoadingWidget({
    super.key,
    this.message,
    this.size = 36,
    this.color,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    final loadingColor = color ?? AppColors.chocolate;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                loadingColor,
              ),
            ),
          ),
          if (showMessage) ...[
            const SizedBox(height: 16),
            Text(
              message ?? 'Preparing your treats...',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
