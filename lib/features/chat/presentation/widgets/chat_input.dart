import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

/// Chat input widget with text field and send button
class ChatInput extends StatefulWidget {
  final Function(String) onSend;
  final VoidCallback? onAttachmentTap;
  final Function(bool)? onTypingChanged;
  final bool enabled;
  final bool isSending;

  const ChatInput({
    super.key,
    required this.onSend,
    this.onAttachmentTap,
    this.onTypingChanged,
    this.enabled = true,
    this.isSending = false,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }

    // Handle typing indicator
    if (widget.onTypingChanged != null) {
      if (hasText) {
        widget.onTypingChanged!(true);
        _typingTimer?.cancel();
        _typingTimer = Timer(const Duration(seconds: 3), () {
          widget.onTypingChanged!(false);
        });
      } else {
        _typingTimer?.cancel();
        widget.onTypingChanged!(false);
      }
    }
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSending) return;

    widget.onSend(text);
    _controller.clear();
    _typingTimer?.cancel();
    widget.onTypingChanged?.call(false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.sm,
        vertical: Dimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.gray200, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Attachment button (optional)
            if (widget.onAttachmentTap != null)
              IconButton(
                onPressed: widget.enabled ? widget.onAttachmentTap : null,
                icon: const Icon(Icons.camera_alt_outlined),
                color: AppColors.textSecondary,
                splashRadius: 20,
              ),

            // Text input
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.md,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
            ),

            const SizedBox(width: Dimensions.xs),

            // Send button
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              child: Material(
                color: _hasText && widget.enabled
                    ? AppColors.primaryBlue
                    : AppColors.gray300,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: _hasText && widget.enabled && !widget.isSending
                      ? _handleSend
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: widget.isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Icon(
                            Icons.send_rounded,
                            size: 20,
                            color: _hasText && widget.enabled
                                ? Colors.white
                                : AppColors.textTertiary,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick reply suggestions widget
class QuickReplySuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onTap;

  const QuickReplySuggestions({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.screenPaddingH,
        vertical: Dimensions.sm,
      ),
      child: Row(
        children: suggestions.map((suggestion) {
          return Padding(
            padding: const EdgeInsets.only(right: Dimensions.sm),
            child: ActionChip(
              label: Text(
                suggestion,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.primaryBlue,
                ),
              ),
              backgroundColor: AppColors.primarySurface,
              side: BorderSide.none,
              onPressed: () => onTap(suggestion),
            ),
          );
        }).toList(),
      ),
    );
  }
}