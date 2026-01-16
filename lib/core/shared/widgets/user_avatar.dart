import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

/// Size variants for user avatar
enum AvatarSize {
  xs(Dimensions.avatarXs),
  sm(Dimensions.avatarSm),
  md(Dimensions.avatarMd),
  lg(Dimensions.avatarLg),
  xl(Dimensions.avatarXl);

  final double size;
  const AvatarSize(this.size);
}

/// Reusable user avatar widget with online indicator
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final AvatarSize size;
  final bool showOnlineIndicator;
  final bool isOnline;
  final VoidCallback? onTap;
  final double? borderWidth;
  final Color? borderColor;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AvatarSize.md,
    this.showOnlineIndicator = false,
    this.isOnline = false,
    this.onTap,
    this.borderWidth,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = size.size;
    final indicatorSize = avatarSize * 0.22;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Avatar container
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: borderWidth != null
                  ? Border.all(
                      color: borderColor ?? AppColors.surface,
                      width: borderWidth!,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: _buildAvatarContent(avatarSize),
            ),
          ),
          // Online indicator
          if (showOnlineIndicator && isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: indicatorSize,
                height: indicatorSize,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surface,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarContent(double avatarSize) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: avatarSize,
        height: avatarSize,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(avatarSize),
        errorWidget: (context, url, error) => _buildPlaceholder(avatarSize),
      );
    }
    return _buildPlaceholder(avatarSize);
  }

  Widget _buildPlaceholder(double avatarSize) {
    final initials = _getInitials();
    final fontSize = avatarSize * 0.35;

    return Container(
      width: avatarSize,
      height: avatarSize,
      color: AppColors.primarySurface,
      child: Center(
        child: initials.isNotEmpty
            ? Text(
                initials,
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Icon(
                Icons.person_rounded,
                size: avatarSize * 0.5,
                color: AppColors.primaryBlue,
              ),
      ),
    );
  }

  String _getInitials() {
    if (name == null || name!.isEmpty) return '';

    final parts = name!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }
}