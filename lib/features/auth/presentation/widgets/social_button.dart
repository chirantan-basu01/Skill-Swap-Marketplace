import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final String? svgPath;

  const SocialButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.svgPath,
  }) : assert(icon != null || svgPath != null, 'Either icon or svgPath must be provided');

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.border, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (svgPath != null)
            SvgPicture.asset(
              svgPath!,
              width: Dimensions.iconMd,
              height: Dimensions.iconMd,
            )
          else if (icon != null)
            Icon(icon, size: Dimensions.iconMd),
          const SizedBox(width: Dimensions.sm),
          Text(label),
        ],
      ),
    );
  }
}