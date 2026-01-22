import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

/// Calendar widget for selecting a date
class SessionCalendar extends StatefulWidget {
  final DateTime? selectedDate;
  final DateTime? minDate;
  final ValueChanged<DateTime> onDateSelected;

  const SessionCalendar({
    super.key,
    this.selectedDate,
    this.minDate,
    required this.onDateSelected,
  });

  @override
  State<SessionCalendar> createState() => _SessionCalendarState();
}

class _SessionCalendarState extends State<SessionCalendar> {
  late DateTime _displayedMonth;
  late DateTime _today;
  late DateTime _minDate;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _minDate = widget.minDate ?? _today;
    _displayedMonth = widget.selectedDate ?? DateTime(_today.year, _today.month);
  }

  @override
  void didUpdateWidget(SessionCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.minDate != oldWidget.minDate) {
      _minDate = widget.minDate ?? _today;
    }
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isDateSelectable(DateTime date) {
    return !date.isBefore(DateTime(_minDate.year, _minDate.month, _minDate.day));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
      ),
      padding: const EdgeInsets.all(Dimensions.md),
      child: Column(
        children: [
          _buildMonthNavigation(),
          const SizedBox(height: Dimensions.md),
          _buildWeekdayHeaders(),
          const SizedBox(height: Dimensions.sm),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _previousMonth,
          icon: const Icon(Icons.chevron_left, color: AppColors.gray400),
          splashRadius: 20,
        ),
        Text(
          '${months[_displayedMonth.month - 1]} ${_displayedMonth.year}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: _nextMonth,
          icon: const Icon(Icons.chevron_right, color: AppColors.gray400),
          splashRadius: 20,
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map((day) => SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray500,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final lastDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0);
    final startingWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    final days = <Widget>[];

    // Empty cells for days before the first of the month
    for (int i = 0; i < startingWeekday; i++) {
      days.add(const SizedBox(width: 40, height: 40));
    }

    // Days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
      days.add(_buildDayCell(date));
    }

    return Wrap(
      spacing: 0,
      runSpacing: 4,
      children: days,
    );
  }

  Widget _buildDayCell(DateTime date) {
    final isSelected = widget.selectedDate != null && _isSameDay(date, widget.selectedDate!);
    final isToday = _isSameDay(date, _today);
    final isSelectable = _isDateSelectable(date);

    return GestureDetector(
      onTap: isSelectable ? () => widget.onDateSelected(date) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          shape: BoxShape.circle,
          border: isToday && !isSelected
              ? Border.all(color: AppColors.primaryBlue, width: 1.5)
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? Colors.white
                  : isSelectable
                      ? AppColors.textPrimary
                      : AppColors.gray300,
            ),
          ),
        ),
      ),
    );
  }
}

/// Time picker dropdown
class SessionTimePicker extends StatelessWidget {
  final String? selectedTime;
  final List<String> timeSlots;
  final ValueChanged<String> onTimeSelected;

  const SessionTimePicker({
    super.key,
    this.selectedTime,
    required this.timeSlots,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTimePickerSheet(context),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.gray300, width: 1.5),
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: AppColors.gray400, size: 20),
            const SizedBox(width: Dimensions.sm),
            Expanded(
              child: Text(
                selectedTime ?? 'Select time',
                style: TextStyle(
                  fontSize: 16,
                  color: selectedTime != null
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }

  void _showTimePickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TimePickerSheet(
        selectedTime: selectedTime,
        timeSlots: timeSlots,
        onTimeSelected: (time) {
          onTimeSelected(time);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _TimePickerSheet extends StatefulWidget {
  final String? selectedTime;
  final List<String> timeSlots;
  final ValueChanged<String> onTimeSelected;

  const _TimePickerSheet({
    required this.selectedTime,
    required this.timeSlots,
    required this.onTimeSelected,
  });

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late String _selectedTime;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.selectedTime ?? widget.timeSlots.first;
    _scrollController = ScrollController();

    // Scroll to selected time after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = widget.timeSlots.indexOf(_selectedTime);
      if (index > 0) {
        _scrollController.animateTo(
          index * 52.0 - 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLg)),
      ),
      child: Column(
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
            'Select Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Dimensions.md),
          // Time list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.md),
              itemCount: widget.timeSlots.length,
              itemBuilder: (context, index) {
                final time = widget.timeSlots[index];
                final isSelected = time == _selectedTime;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedTime = time);
                  },
                  child: Container(
                    height: 52,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primarySurface : Colors.transparent,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSm),
                      border: isSelected
                          ? Border.all(color: AppColors.primaryBlue, width: 1.5)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Done button
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimensions.md,
              Dimensions.md,
              Dimensions.md,
              Dimensions.md + MediaQuery.of(context).padding.bottom,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => widget.onTimeSelected(_selectedTime),
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
          ),
        ],
      ),
    );
  }
}

/// Video link input field
class VideoLinkInput extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const VideoLinkInput({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.url,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Paste your Google Meet or Zoom link',
            hintStyle: const TextStyle(color: AppColors.textTertiary),
            prefixIcon: const Icon(Icons.link, color: AppColors.gray400),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusMd),
              borderSide: BorderSide(
                color: errorText != null ? AppColors.error : AppColors.gray300,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusMd),
              borderSide: BorderSide(
                color: errorText != null ? AppColors.error : AppColors.gray300,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusMd),
              borderSide: BorderSide(
                color: errorText != null ? AppColors.error : AppColors.primaryBlue,
                width: 1.5,
              ),
            ),
            errorText: errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Dimensions.md,
              vertical: Dimensions.md,
            ),
          ),
        ),
        const SizedBox(height: Dimensions.sm),
        // Quick links
        Row(
          children: [
            Text(
              'Or create: ',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.gray500,
              ),
            ),
            TextButton(
              onPressed: () => _launchUrl('https://meet.google.com/new'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Google Meet',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _launchUrl('https://zoom.us/start/videomeeting'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Zoom',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _launchUrl(String url) {
    // Note: In a real app, use url_launcher package
    // For now, just show a snackbar indicating what would happen
    debugPrint('Would launch: $url');
  }
}

/// Swap summary card for scheduling screen
class SwapSummaryCard extends StatelessWidget {
  final String skillOffered;
  final String skillWanted;
  final double duration;

  const SwapSummaryCard({
    super.key,
    required this.skillOffered,
    required this.skillWanted,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final durationText = duration == 1.0
        ? '1 hour session'
        : '${duration.toStringAsFixed(duration.truncateToDouble() == duration ? 0 : 1)} hour session';

    return Container(
      padding: const EdgeInsets.all(Dimensions.sm + 4),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(Dimensions.radiusSm),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                skillOffered,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.swap_horiz,
                  size: 18,
                  color: AppColors.gray500,
                ),
              ),
              Text(
                skillWanted,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            durationText,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}