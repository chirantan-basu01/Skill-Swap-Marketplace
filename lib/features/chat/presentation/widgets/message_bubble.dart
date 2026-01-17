import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/chat/domain/models/chat_model.dart';
import 'package:skill_swap_marketplace/features/chat/domain/models/message_model.dart';
import 'package:skill_swap_marketplace/features/chat/presentation/providers/chat_provider.dart';

/// Message bubble widget for chat
class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMine;
  final bool showTimestamp;
  final bool isRead;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.showTimestamp = true,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    // System messages have different styling
    if (message.type == MessageType.system) {
      return _buildSystemMessage();
    }

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: isMine ? 48 : 0,
          right: isMine ? 0 : 48,
          bottom: Dimensions.sm,
        ),
        child: Column(
          crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Message bubble
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.md,
                vertical: Dimensions.sm,
              ),
              decoration: BoxDecoration(
                color: isMine ? AppColors.primaryBlue : AppColors.gray100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMine ? 16 : 4),
                  bottomRight: Radius.circular(isMine ? 4 : 16),
                ),
              ),
              child: _buildContent(),
            ),

            // Timestamp and read receipt
            if (showTimestamp)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatMessageTime(message.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    if (isMine) ...[
                      const SizedBox(width: 4),
                      Icon(
                        isRead ? Icons.done_all : Icons.done,
                        size: 14,
                        color: isRead ? AppColors.primaryBlue : AppColors.textTertiary,
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (message.type == MessageType.image && message.imageUrl != null) {
      return _buildImageMessage();
    }

    return Text(
      message.content,
      style: TextStyle(
        fontSize: 15,
        color: isMine ? Colors.white : AppColors.textPrimary,
        height: 1.4,
      ),
    );
  }

  Widget _buildImageMessage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 200,
          maxHeight: 280,
        ),
        child: Image.network(
          message.imageUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 200,
              height: 150,
              color: AppColors.gray100,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryBlue,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 200,
              height: 150,
              color: AppColors.gray100,
              child: const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: AppColors.textTertiary,
                  size: 32,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSystemMessage() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Dimensions.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.md,
          vertical: Dimensions.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.content,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Date separator widget for chat
class DateSeparator extends StatelessWidget {
  final DateTime date;

  const DateSeparator({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Dimensions.md),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.md,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          formatDateSeparator(date),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}

/// Typing indicator widget
class TypingIndicator extends StatefulWidget {
  final String userName;

  const TypingIndicator({
    super.key,
    required this.userName,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dot1;
  late Animation<double> _dot2;
  late Animation<double> _dot3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _dot1 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );
    _dot2 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.easeInOut),
      ),
    );
    _dot3 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.md,
              vertical: Dimensions.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDot(_dot1),
                    const SizedBox(width: 4),
                    _buildDot(_dot2),
                    const SizedBox(width: 4),
                    _buildDot(_dot3),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Animation<double> animation) {
    return Transform.translate(
      offset: Offset(0, -4 * animation.value * (1 - animation.value) * 4),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: AppColors.textTertiary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}