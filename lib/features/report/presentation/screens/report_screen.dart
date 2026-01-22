import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/report/domain/models/report_model.dart';
import 'package:skill_swap_marketplace/features/report/presentation/providers/report_provider.dart';

/// Provider for tracking selected report reason
final _selectedReasonProvider = StateProvider.autoDispose<ReportReason?>((ref) => null);

/// Provider for tracking description text
final _descriptionProvider = StateProvider.autoDispose<String>((ref) => '');

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({
    super.key,
    required this.reportedUserId,
    required this.reportedUserName,
    this.swapId,
    this.messageId,
  });

  final String reportedUserId;
  final String reportedUserName;
  final String? swapId;
  final String? messageId;

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      ref.read(_descriptionProvider.notifier).state = _descriptionController.text;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    final selectedReason = ref.read(_selectedReasonProvider);
    final description = ref.read(_descriptionProvider);

    if (selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a reason for your report'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (description.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a description'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final success = await ref.read(reportNotifierProvider.notifier).submitReport(
      reportedUserId: widget.reportedUserId,
      reportedUserName: widget.reportedUserName,
      reason: selectedReason,
      description: description.trim(),
      swapId: widget.swapId,
      messageId: widget.messageId,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report submitted successfully. We\'ll review it shortly.'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportState = ref.watch(reportNotifierProvider);
    final selectedReason = ref.watch(_selectedReasonProvider);
    final description = ref.watch(_descriptionProvider);

    // Show error if any
    ref.listen(reportNotifierProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Report User'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.screenPaddingH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(Dimensions.md),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: Dimensions.sm),
                  Expanded(
                    child: Text(
                      'You are reporting ${widget.reportedUserName}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.xl),

            // Reason selection
            const Text(
              'Why are you reporting this user?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Dimensions.md),

            ..._buildReasonOptions(selectedReason),

            const SizedBox(height: Dimensions.xl),

            // Description
            const Text(
              'Please describe what happened',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Dimensions.sm),
            const Text(
              'Provide as much detail as possible to help us investigate.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: Dimensions.md),

            TextField(
              controller: _descriptionController,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Describe the issue...',
                hintStyle: const TextStyle(color: AppColors.gray400),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                  borderSide: const BorderSide(color: AppColors.gray300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                  borderSide: const BorderSide(color: AppColors.gray300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
                ),
              ),
            ),

            const SizedBox(height: Dimensions.xl),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: reportState.isLoading ||
                        selectedReason == null ||
                        description.trim().isEmpty
                    ? null
                    : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: reportState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Submit Report',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: Dimensions.md),

            // Info text
            const Text(
              'False reports may result in action against your account. '
              'Reports are reviewed by our team within 24-48 hours.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: Dimensions.xl),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReasonOptions(ReportReason? selectedReason) {
    return ReportReason.values.map((reason) {
      final isSelected = selectedReason == reason;
      return Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.sm),
        child: InkWell(
          onTap: () {
            ref.read(_selectedReasonProvider.notifier).state = reason;
          },
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.md),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryBlue.withValues(alpha: 0.1)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(Dimensions.radiusMd),
              border: Border.all(
                color: isSelected ? AppColors.primaryBlue : AppColors.gray300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getReasonIcon(reason),
                  color: isSelected ? AppColors.primaryBlue : AppColors.gray500,
                ),
                const SizedBox(width: Dimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getReasonTitle(reason),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getReasonDescription(reason),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<ReportReason>(
                  value: reason,
                  groupValue: selectedReason,
                  onChanged: (value) {
                    ref.read(_selectedReasonProvider.notifier).state = value;
                  },
                  activeColor: AppColors.primaryBlue,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  IconData _getReasonIcon(ReportReason reason) {
    switch (reason) {
      case ReportReason.inappropriate:
        return Icons.block_rounded;
      case ReportReason.spam:
        return Icons.mark_email_unread_rounded;
      case ReportReason.noShow:
        return Icons.event_busy_rounded;
      case ReportReason.fraud:
        return Icons.gpp_bad_rounded;
      case ReportReason.other:
        return Icons.more_horiz_rounded;
    }
  }

  String _getReasonTitle(ReportReason reason) {
    switch (reason) {
      case ReportReason.inappropriate:
        return 'Inappropriate Behavior';
      case ReportReason.spam:
        return 'Spam or Advertising';
      case ReportReason.noShow:
        return 'No Show';
      case ReportReason.fraud:
        return 'Fraud or Scam';
      case ReportReason.other:
        return 'Other';
    }
  }

  String _getReasonDescription(ReportReason reason) {
    switch (reason) {
      case ReportReason.inappropriate:
        return 'Harassment, offensive language, or inappropriate content';
      case ReportReason.spam:
        return 'Unwanted promotional messages or repetitive content';
      case ReportReason.noShow:
        return 'User did not show up for scheduled session';
      case ReportReason.fraud:
        return 'Misleading profile, fake skills, or dishonest behavior';
      case ReportReason.other:
        return 'Something else not listed above';
    }
  }
}