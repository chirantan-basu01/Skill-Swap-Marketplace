import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';

/// Interactive star rating widget
class StarRating extends StatefulWidget {
  final int rating;
  final ValueChanged<int>? onRatingChanged;
  final double size;
  final bool readOnly;
  final Color? filledColor;
  final Color? emptyColor;

  const StarRating({
    super.key,
    this.rating = 0,
    this.onRatingChanged,
    this.size = 32,
    this.readOnly = false,
    this.filledColor,
    this.emptyColor,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  int _currentRating = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;

    _controllers = List.generate(
      5,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.3).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void didUpdateWidget(StarRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rating != oldWidget.rating) {
      _currentRating = widget.rating;
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleTap(int index) {
    if (widget.readOnly) return;

    final newRating = index + 1;

    // Animate the tapped star
    _controllers[index].forward().then((_) {
      _controllers[index].reverse();
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _currentRating = newRating;
    });

    widget.onRatingChanged?.call(newRating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isFilled = index < _currentRating;

        return GestureDetector(
          onTap: () => _handleTap(index),
          child: AnimatedBuilder(
            animation: _scaleAnimations[index],
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimations[index].value,
                child: Container(
                  width: widget.size + 12,
                  height: widget.size + 12,
                  alignment: Alignment.center,
                  child: Icon(
                    isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: widget.size,
                    color: isFilled
                        ? (widget.filledColor ?? AppColors.warning)
                        : (widget.emptyColor ?? AppColors.gray300),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

/// Get rating label based on star count
String getRatingLabel(int rating) {
  switch (rating) {
    case 0:
      return 'Tap to rate';
    case 1:
      return 'Poor';
    case 2:
      return 'Fair';
    case 3:
      return 'Good';
    case 4:
      return 'Very Good';
    case 5:
      return 'Excellent!';
    default:
      return '';
  }
}

/// Display-only star rating for showing ratings
class StarRatingDisplay extends StatelessWidget {
  final double rating;
  final double size;
  final Color? filledColor;
  final Color? emptyColor;
  final bool showValue;

  const StarRatingDisplay({
    super.key,
    required this.rating,
    this.size = 16,
    this.filledColor,
    this.emptyColor,
    this.showValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final fillAmount = (rating - index).clamp(0.0, 1.0);

          return SizedBox(
            width: size + 2,
            height: size,
            child: Stack(
              children: [
                Icon(
                  Icons.star_rounded,
                  size: size,
                  color: emptyColor ?? AppColors.gray200,
                ),
                ClipRect(
                  clipper: _StarClipper(fillAmount),
                  child: Icon(
                    Icons.star_rounded,
                    size: size,
                    color: filledColor ?? AppColors.warning,
                  ),
                ),
              ],
            ),
          );
        }),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.875,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ],
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double fillAmount;

  _StarClipper(this.fillAmount);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * fillAmount, size.height);
  }

  @override
  bool shouldReclip(_StarClipper oldClipper) {
    return fillAmount != oldClipper.fillAmount;
  }
}