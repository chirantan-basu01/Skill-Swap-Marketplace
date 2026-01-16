import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

class SetupProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const SetupProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Step indicators with animated progress
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: isCompleted || isCurrent
                            ? const LinearGradient(
                                colors: [
                                  AppColors.primaryBlue,
                                  Color(0xFF5B8DEF),
                                ],
                              )
                            : null,
                        color: isCompleted || isCurrent ? null : AppColors.gray200,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: isCompleted || isCurrent
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryBlue.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                  if (index < totalSteps - 1) const SizedBox(width: 6),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: Dimensions.md),

        // Step label with icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getStepIcon(currentStep),
                    size: 16,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Step ${currentStep + 1} of $totalSteps',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getStepIcon(int step) {
    switch (step) {
      case 0:
        return Icons.person_outline_rounded;
      case 1:
        return Icons.school_outlined;
      case 2:
        return Icons.menu_book_outlined;
      case 3:
        return Icons.schedule_outlined;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }
}