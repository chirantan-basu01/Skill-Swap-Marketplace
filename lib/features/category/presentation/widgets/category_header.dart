import 'package:flutter/material.dart';

/// Category header with emoji cluster and gradient background
class CategoryHeader extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryHeader({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = _getCategoryTheme(categoryId);

    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.color.withValues(alpha: 0.15),
            theme.color.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Emoji cluster
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: theme.emojis.map((emoji) {
                final index = theme.emojis.indexOf(emoji);
                final size = index == theme.emojis.length ~/ 2 ? 36.0 : 28.0;
                final offset = (index - theme.emojis.length ~/ 2) * 8.0;

                return Transform.translate(
                  offset: Offset(0, offset.abs() * 0.3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      emoji,
                      style: TextStyle(fontSize: size),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  _CategoryTheme _getCategoryTheme(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'technology':
        return _CategoryTheme(
          color: const Color(0xFF4F46E5), // Indigo
          emojis: ['\ud83d\udcbb', '\ud83d\udcf1', '\u2328\ufe0f', '\ud83d\udda5\ufe0f', '\ud83e\udd16'],
        );
      case 'creative':
        return _CategoryTheme(
          color: const Color(0xFF9333EA), // Purple
          emojis: ['\ud83c\udfa8', '\ud83d\udd8c\ufe0f', '\ud83d\udcf7', '\u2728', '\ud83c\udfad'],
        );
      case 'music':
        return _CategoryTheme(
          color: const Color(0xFFE11D48), // Rose
          emojis: ['\ud83c\udfb5', '\ud83c\udfb8', '\ud83c\udfb9', '\ud83e\udd41', '\ud83c\udfa4'],
        );
      case 'languages':
        return _CategoryTheme(
          color: const Color(0xFF059669), // Emerald
          emojis: ['\ud83c\udf0d', '\ud83d\udcac', '\ud83d\udde3\ufe0f', '\ud83d\udcd6', '\u2709\ufe0f'],
        );
      case 'business':
        return _CategoryTheme(
          color: const Color(0xFFD97706), // Amber
          emojis: ['\ud83d\udcbc', '\ud83d\udcc8', '\ud83d\udcb0', '\ud83e\udd1d', '\ud83c\udfaf'],
        );
      case 'lifestyle':
        return _CategoryTheme(
          color: const Color(0xFF0D9488), // Teal
          emojis: ['\ud83e\uddd8', '\ud83c\udfcb\ufe0f', '\ud83c\udf3f', '\u2615', '\ud83e\udec0'],
        );
      case 'academic':
        return _CategoryTheme(
          color: const Color(0xFF475569), // Slate
          emojis: ['\ud83d\udcda', '\ud83c\udf93', '\ud83d\udcdd', '\ud83e\uddea', '\ud83d\udcca'],
        );
      default:
        return _CategoryTheme(
          color: const Color(0xFF4F46E5),
          emojis: ['\u2728', '\ud83c\udf1f', '\ud83d\udcab', '\u2b50', '\ud83c\udf1f'],
        );
    }
  }
}

class _CategoryTheme {
  final Color color;
  final List<String> emojis;

  _CategoryTheme({
    required this.color,
    required this.emojis,
  });
}