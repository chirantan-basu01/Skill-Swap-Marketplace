import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

/// Button to join a video call
class VideoLinkButton extends StatelessWidget {
  /// The video call URL
  final String? videoLink;

  /// Whether the button is enabled
  final bool enabled;

  /// Callback when link is opened
  final VoidCallback? onOpened;

  /// Callback when link fails to open
  final VoidCallback? onError;

  const VideoLinkButton({
    super.key,
    this.videoLink,
    this.enabled = true,
    this.onOpened,
    this.onError,
  });

  bool get hasLink => videoLink != null && videoLink!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: enabled && hasLink ? () => _openVideoLink(context) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.gray200,
          disabledForegroundColor: AppColors.gray500,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          ),
        ),
        icon: const Icon(Icons.videocam, size: 22),
        label: Text(
          hasLink ? 'Join Video Call' : 'No Video Link',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _openVideoLink(BuildContext context) async {
    if (videoLink == null || videoLink!.isEmpty) return;

    final uri = Uri.tryParse(videoLink!);
    if (uri == null) {
      onError?.call();
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        onOpened?.call();
      } else {
        onError?.call();
      }
    } catch (e) {
      onError?.call();
    }
  }
}

/// Secondary button to open chat
class OpenChatButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const OpenChatButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(
            color: AppColors.primaryBlue,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          ),
        ),
        icon: const Icon(Icons.chat_bubble_outline, size: 20),
        label: const Text(
          'Open Chat',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Report issue link button
class ReportIssueButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ReportIssueButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.error.withValues(alpha: 0.7),
      ),
      icon: const Icon(Icons.flag_outlined, size: 18),
      label: const Text(
        'Report an Issue',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Start session button (for waiting state)
class StartSessionButton extends StatelessWidget {
  final bool isLoading;
  final bool hasStarted;
  final VoidCallback? onPressed;

  const StartSessionButton({
    super.key,
    this.isLoading = false,
    this.hasStarted = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: hasStarted || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasStarted ? AppColors.success : AppColors.primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: hasStarted ? AppColors.success : AppColors.gray200,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hasStarted ? Icons.check : Icons.play_arrow,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    hasStarted ? "You're Ready!" : 'Start Session',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Mark as no-show button
class MarkNoShowButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const MarkNoShowButton({
    super.key,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.gray200,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Mark as No-Show',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

/// End session button
class EndSessionButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const EndSessionButton({
    super.key,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white.withValues(alpha: 0.8),
      ),
      child: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              'End Session',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }
}