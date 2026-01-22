import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/session/presentation/providers/session_provider.dart';
import 'package:skill_swap_marketplace/features/session/presentation/widgets/datetime_picker.dart';
import 'package:skill_swap_marketplace/features/swap/domain/models/swap_model.dart';

/// Schedule session screen for setting up a swap session
class ScheduleSessionScreen extends ConsumerStatefulWidget {
  final String swapId;

  const ScheduleSessionScreen({
    super.key,
    required this.swapId,
  });

  @override
  ConsumerState<ScheduleSessionScreen> createState() => _ScheduleSessionScreenState();
}

class _ScheduleSessionScreenState extends ConsumerState<ScheduleSessionScreen> {
  final _videoLinkController = TextEditingController();
  final _timeSlots = generateTimeSlots();

  @override
  void dispose() {
    _videoLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final swapAsync = ref.watch(swapByIdProvider(widget.swapId));
    final scheduleState = ref.watch(scheduleSessionNotifierProvider(widget.swapId));

    // Listen for success state
    ref.listen(scheduleSessionNotifierProvider(widget.swapId), (previous, next) {
      if (next.status == ScheduleSessionStatus.success) {
        _showSuccessDialog(context);
      }
    });

    return swapAsync.when(
      data: (swap) {
        if (swap == null) {
          return _buildErrorScreen('Swap not found');
        }
        return _buildContent(context, swap, scheduleState);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => _buildErrorScreen(error.toString()),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Session'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.gray300,
            ),
            const SizedBox(height: Dimensions.md),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: Dimensions.lg),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SwapModel swap,
    ScheduleSessionState scheduleState,
  ) {
    final authRepo = ref.watch(authRepositoryProvider);
    final currentUser = authRepo.currentUser;
    final isRequester = currentUser?.uid == swap.requesterId;

    // Determine partner info
    final partnerName = isRequester ? swap.providerName : swap.requesterName;
    final partnerPhoto = isRequester ? swap.providerPhoto : swap.requesterPhoto;

    // Get skill names
    final skillOffered = isRequester
        ? swap.requesterOffers.skillName
        : swap.requesterWants.skillName;
    final skillWanted = isRequester
        ? swap.requesterWants.skillName
        : swap.requesterOffers.skillName;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('Schedule Session'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.screenPaddingH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Partner info
            Center(
              child: Column(
                children: [
                  UserAvatar(
                    imageUrl: partnerPhoto,
                    name: partnerName,
                    size: AvatarSize.lg,
                  ),
                  const SizedBox(height: Dimensions.sm),
                  Text(
                    'with $partnerName',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.lg),

            // Swap summary
            SwapSummaryCard(
              skillOffered: skillOffered,
              skillWanted: skillWanted,
              duration: swap.duration,
            ),
            const SizedBox(height: Dimensions.xl),

            // Date picker section
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gray700,
              ),
            ),
            const SizedBox(height: Dimensions.sm),
            SessionCalendar(
              selectedDate: scheduleState.selectedDate,
              minDate: DateTime.now(),
              onDateSelected: (date) {
                ref
                    .read(scheduleSessionNotifierProvider(widget.swapId).notifier)
                    .selectDate(date);
              },
            ),
            const SizedBox(height: Dimensions.lg),

            // Time picker section
            const Text(
              'Select Time',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gray700,
              ),
            ),
            const SizedBox(height: Dimensions.sm),
            SessionTimePicker(
              selectedTime: scheduleState.selectedTime,
              timeSlots: _timeSlots,
              onTimeSelected: (time) {
                ref
                    .read(scheduleSessionNotifierProvider(widget.swapId).notifier)
                    .selectTime(time);
              },
            ),
            const SizedBox(height: Dimensions.lg),

            // Video link section
            const Text(
              'Video Call Link',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gray700,
              ),
            ),
            const SizedBox(height: Dimensions.sm),
            VideoLinkInput(
              controller: _videoLinkController,
              onChanged: (value) {
                ref
                    .read(scheduleSessionNotifierProvider(widget.swapId).notifier)
                    .updateVideoLink(value);
              },
            ),

            // Warning if no link
            if (!scheduleState.hasVideoLink && scheduleState.canSubmit) ...[
              const SizedBox(height: Dimensions.sm),
              Container(
                padding: const EdgeInsets.all(Dimensions.sm),
                decoration: BoxDecoration(
                  color: AppColors.warningSurface,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: Dimensions.sm),
                    Expanded(
                      child: Text(
                        'Add a video link so you can meet. You can also add it later in chat.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Error message
            if (scheduleState.errorMessage != null) ...[
              const SizedBox(height: Dimensions.md),
              Container(
                padding: const EdgeInsets.all(Dimensions.sm),
                decoration: BoxDecoration(
                  color: AppColors.errorSurface,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 16,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: Dimensions.sm),
                    Expanded(
                      child: Text(
                        scheduleState.errorMessage!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: Dimensions.xl),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: scheduleState.canSubmit &&
                        scheduleState.status != ScheduleSessionStatus.loading
                    ? () => _scheduleSession()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.gray200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                  ),
                ),
                child: scheduleState.status == ScheduleSessionStatus.loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Confirm Schedule',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: Dimensions.lg),
          ],
        ),
      ),
    );
  }

  Future<void> _scheduleSession() async {
    final notifier = ref.read(scheduleSessionNotifierProvider(widget.swapId).notifier);
    await notifier.scheduleSession();
  }

  void _showSuccessDialog(BuildContext context) {
    final scheduleState = ref.read(scheduleSessionNotifierProvider(widget.swapId));
    final formattedDateTime = scheduleState.selectedDate != null &&
            scheduleState.selectedTime != null
        ? formatScheduledDateTime(
            scheduleState.selectedDate!,
            scheduleState.selectedTime!,
          )
        : '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusLg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.successSurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 32,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: Dimensions.md),

              // Title
              const Text(
                'Session Scheduled!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: Dimensions.md),

              // Date/time
              Container(
                padding: const EdgeInsets.all(Dimensions.sm),
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(width: Dimensions.sm),
                    Text(
                      formattedDateTime,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.md),

              // Reminder note
              Text(
                "You'll both receive reminders before the session.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.gray500,
                ),
              ),
              const SizedBox(height: Dimensions.lg),

              // Open chat button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Pop back to previous screen (usually chat or matches)
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Show schedule session as a bottom sheet
Future<bool?> showScheduleSessionSheet(
  BuildContext context, {
  required String swapId,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.radiusLg),
          ),
        ),
        child: _ScheduleSessionSheetContent(
          swapId: swapId,
          scrollController: scrollController,
        ),
      ),
    ),
  );
}

class _ScheduleSessionSheetContent extends ConsumerStatefulWidget {
  final String swapId;
  final ScrollController scrollController;

  const _ScheduleSessionSheetContent({
    required this.swapId,
    required this.scrollController,
  });

  @override
  ConsumerState<_ScheduleSessionSheetContent> createState() =>
      _ScheduleSessionSheetContentState();
}

class _ScheduleSessionSheetContentState
    extends ConsumerState<_ScheduleSessionSheetContent> {
  final _videoLinkController = TextEditingController();
  final _timeSlots = generateTimeSlots();

  @override
  void dispose() {
    _videoLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final swapAsync = ref.watch(swapByIdProvider(widget.swapId));
    final scheduleState = ref.watch(scheduleSessionNotifierProvider(widget.swapId));

    // Listen for success state
    ref.listen(scheduleSessionNotifierProvider(widget.swapId), (previous, next) {
      if (next.status == ScheduleSessionStatus.success) {
        Navigator.of(context).pop(true);
      }
    });

    return swapAsync.when(
      data: (swap) {
        if (swap == null) {
          return const Center(child: Text('Swap not found'));
        }
        return _buildSheetContent(context, swap, scheduleState);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(error.toString())),
    );
  }

  Widget _buildSheetContent(
    BuildContext context,
    SwapModel swap,
    ScheduleSessionState scheduleState,
  ) {
    final authRepo = ref.watch(authRepositoryProvider);
    final currentUser = authRepo.currentUser;
    final isRequester = currentUser?.uid == swap.requesterId;

    final partnerName = isRequester ? swap.providerName : swap.requesterName;
    final skillOffered = isRequester
        ? swap.requesterOffers.skillName
        : swap.requesterWants.skillName;
    final skillWanted = isRequester
        ? swap.requesterWants.skillName
        : swap.requesterOffers.skillName;

    return Column(
      children: [
        // Handle
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.gray300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: Dimensions.md),

        // Title
        const Text(
          'Schedule Session',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          'with $partnerName',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: Dimensions.md),

        // Content
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(Dimensions.screenPaddingH),
            children: [
              // Swap summary
              SwapSummaryCard(
                skillOffered: skillOffered,
                skillWanted: skillWanted,
                duration: swap.duration,
              ),
              const SizedBox(height: Dimensions.lg),

              // Date picker
              const Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray700,
                ),
              ),
              const SizedBox(height: Dimensions.sm),
              SessionCalendar(
                selectedDate: scheduleState.selectedDate,
                minDate: DateTime.now(),
                onDateSelected: (date) {
                  ref
                      .read(scheduleSessionNotifierProvider(widget.swapId).notifier)
                      .selectDate(date);
                },
              ),
              const SizedBox(height: Dimensions.lg),

              // Time picker
              const Text(
                'Select Time',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray700,
                ),
              ),
              const SizedBox(height: Dimensions.sm),
              SessionTimePicker(
                selectedTime: scheduleState.selectedTime,
                timeSlots: _timeSlots,
                onTimeSelected: (time) {
                  ref
                      .read(scheduleSessionNotifierProvider(widget.swapId).notifier)
                      .selectTime(time);
                },
              ),
              const SizedBox(height: Dimensions.lg),

              // Video link
              const Text(
                'Video Call Link',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray700,
                ),
              ),
              const SizedBox(height: Dimensions.sm),
              VideoLinkInput(
                controller: _videoLinkController,
                onChanged: (value) {
                  ref
                      .read(scheduleSessionNotifierProvider(widget.swapId).notifier)
                      .updateVideoLink(value);
                },
              ),

              // Error message
              if (scheduleState.errorMessage != null) ...[
                const SizedBox(height: Dimensions.md),
                Text(
                  scheduleState.errorMessage!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.error,
                  ),
                ),
              ],

              const SizedBox(height: Dimensions.xl),
            ],
          ),
        ),

        // Submit button
        Padding(
          padding: EdgeInsets.fromLTRB(
            Dimensions.screenPaddingH,
            Dimensions.md,
            Dimensions.screenPaddingH,
            Dimensions.md + MediaQuery.of(context).padding.bottom,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: scheduleState.canSubmit &&
                      scheduleState.status != ScheduleSessionStatus.loading
                  ? () async {
                      final notifier = ref.read(
                          scheduleSessionNotifierProvider(widget.swapId).notifier);
                      await notifier.scheduleSession();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.gray200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                ),
              ),
              child: scheduleState.status == ScheduleSessionStatus.loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Confirm Schedule',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}