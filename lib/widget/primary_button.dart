import 'package:flutter/material.dart';
import 'package:keep_note/core/color_const.dart';
import 'package:keep_note/core/image_const.dart';
import 'package:lottie/lottie.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final String? imagePath;
  final VoidCallback onTap;
  final Color? bgColor;
  final bool? isProgress;
  final bool? isDisabled;
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
    this.bgColor,
    this.imagePath = "",
    this.isProgress = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled! ? () {} : onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(
              color: bgColor != null ? Colors.black : ColorConstants.primary,
            ),
            borderRadius: BorderRadius.circular(8),
            color: bgColor ?? ColorConstants.primary),
        child: isProgress!
            ? Lottie.asset(ImageConstants.loadingLottie)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (imagePath!.isNotEmpty) ...[
                    Image.asset(
                      imagePath!,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 10)
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: bgColor != null ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
