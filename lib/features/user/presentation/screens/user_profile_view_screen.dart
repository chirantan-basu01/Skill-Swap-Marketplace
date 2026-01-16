import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';
import 'package:skill_swap_marketplace/features/home/presentation/providers/users_provider.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/skill_model.dart';

/// Provider for fetching a user by ID
final userByIdProvider =
    FutureProvider.family<UserModel?, String>((ref, userId) async {
  final doc = await FirebaseFirestore.instance
      .collection(FirestoreCollections.users)
      .doc(userId)
      .get();

  if (!doc.exists) return null;
  return UserModel.fromJson(doc.data()!);
});

class UserProfileViewScreen extends ConsumerWidget {
  final String userId;

  const UserProfileViewScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(userId));
    final currentUserAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return _buildNotFound(context);
          }
          return _buildContent(context, ref, user, currentUserAsync.valueOrNull);
        },
        loading: () => _buildLoading(),
        error: (_, __) => _buildError(context),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
    UserModel? currentUser,
  ) {
    final matchInfo = currentUser != null
        ? _calculateMatchInfo(currentUser, user)
        : null;

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          pinned: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.textPrimary,
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: AppColors.textPrimary,
              ),
              onSelected: (value) => _handleMenuAction(context, value, user),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share_outlined, size: 20),
                      SizedBox(width: 12),
                      Text('Share Profile'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'report',
                  child: Row(
                    children: [
                      Icon(Icons.flag_outlined, size: 20),
                      SizedBox(width: 12),
                      Text('Report User'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'block',
                  child: Row(
                    children: [
                      Icon(Icons.block_outlined, size: 20, color: AppColors.error),
                      SizedBox(width: 12),
                      Text('Block User', style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // Content
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(user),

              // Stats Row
              _buildStatsRow(user),

              // Action Buttons
              _buildActionButtons(context, user),

              // Match Indicator
              if (matchInfo != null && matchInfo.matchPercentage > 0)
                _buildMatchIndicator(matchInfo),

              // About Section
              if (user.bio.isNotEmpty) _buildAboutSection(user),

              // Skills They Teach
              if (user.skillsOffered.isNotEmpty)
                _buildSkillsTeachSection(context, user, currentUser),

              // Skills They Want
              if (user.skillsWanted.isNotEmpty)
                _buildSkillsWantSection(user, currentUser),

              // Availability
              _buildAvailabilitySection(user),

              // Reviews section (placeholder for now)
              _buildReviewsSection(user),

              // Rating Tags
              if (user.rating.tags.isNotEmpty) _buildRatingTags(user),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    final isOnline = isUserOnline(user);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.lg),
      child: Column(
        children: [
          // Avatar
          UserAvatar(
            imageUrl: user.photoUrl,
            name: user.displayName,
            size: AvatarSize.lg,
            borderWidth: 3,
            borderColor: AppColors.surface,
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            user.displayName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // Online Status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isOnline ? AppColors.success : AppColors.gray400,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                isOnline ? 'Active now' : _getLastSeenText(user.lastActiveAt),
                style: TextStyle(
                  fontSize: 13,
                  color: isOnline ? AppColors.success : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(UserModel user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.screenPaddingH),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Row(
        children: [
          _StatItem(
            value: '${user.swapsCompleted}',
            label: 'swaps',
          ),
          _buildDivider(),
          _StatItem(
            value: '${user.hoursExchanged.toStringAsFixed(0)}hrs',
            label: 'exchanged',
          ),
          _buildDivider(),
          _StatItem(
            value: user.rating.average.toStringAsFixed(1),
            label: '',
            isRating: true,
            ratingCount: user.rating.count,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.gray200,
    );
  }

  Widget _buildActionButtons(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.screenPaddingH),
      child: Column(
        children: [
          // Request Swap button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => SwapRequestRoute(userId: user.uid).push(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                ),
              ),
              child: const Text(
                'Request Swap',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Send Message button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Navigate to or create chat
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                ),
              ),
              child: const Text(
                'Send Message',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchIndicator(_MatchInfo matchInfo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.screenPaddingH),
      padding: const EdgeInsets.all(Dimensions.md),
      decoration: BoxDecoration(
        color: matchInfo.isPerfectMatch
            ? AppColors.primarySurface
            : AppColors.gray50,
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                color: AppColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '${matchInfo.matchPercentage}% Match',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (matchInfo.theyTeachWhatYouWant)
            _buildMatchCheckItem('They teach what you want!'),
          if (matchInfo.youTeachWhatTheyWant)
            _buildMatchCheckItem('You teach what they want!'),
          if (matchInfo.isPerfectMatch) ...[
            const SizedBox(height: 8),
            const Text(
              'This is a perfect swap match!',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMatchCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(UserModel user) {
    return _Section(
      title: 'About',
      child: Text(
        user.bio,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildSkillsTeachSection(
    BuildContext context,
    UserModel user,
    UserModel? currentUser,
  ) {
    final matchingSkills = currentUser != null
        ? currentUser.skillsWanted
            .map((s) => s.skillName.toLowerCase())
            .toSet()
        : <String>{};

    return _Section(
      title: 'Skills They Teach (${user.skillsOffered.length})',
      child: Column(
        children: user.skillsOffered.map((skill) {
          final isMatching =
              matchingSkills.contains(skill.skillName.toLowerCase());
          return _SkillTeachCard(
            skill: skill,
            isMatching: isMatching,
            onRequestTap: () =>
                SwapRequestRoute(userId: user.uid).push(context),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSkillsWantSection(UserModel user, UserModel? currentUser) {
    final matchingSkills = currentUser != null
        ? currentUser.skillsOffered
            .map((s) => s.skillName.toLowerCase())
            .toSet()
        : <String>{};

    return _Section(
      title: 'Skills They Want (${user.skillsWanted.length})',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: user.skillsWanted.map((skill) {
          final isMatching =
              matchingSkills.contains(skill.skillName.toLowerCase());
          return _SkillWantChip(
            skill: skill,
            isMatching: isMatching,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAvailabilitySection(UserModel user) {
    return _Section(
      title: 'Availability',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AvailabilityChip(
                icon: _getAvailabilityIcon(user.availability),
                label: _getAvailabilityLabel(user.availability),
              ),
            ],
          ),
          if (user.timezone.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  '🌍 ',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  user.timezone,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewsSection(UserModel user) {
    if (user.rating.count == 0) {
      return const SizedBox.shrink();
    }

    return _Section(
      title: 'Reviews (${user.rating.count})',
      trailing: GestureDetector(
        onTap: () {
          // Navigate to all reviews
        },
        child: const Text(
          'See All',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.md),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reviews will be shown here',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingTags(UserModel user) {
    final sortedTags = user.rating.tags.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return _Section(
      title: 'Rating Tags',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: sortedTags.take(6).map((entry) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(Dimensions.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${entry.value}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryBlue),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_off_outlined,
            size: 64,
            color: AppColors.gray300,
          ),
          const SizedBox(height: 16),
          const Text(
            'User not found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action, UserModel user) {
    switch (action) {
      case 'share':
        // Share profile
        break;
      case 'report':
        ReportRoute(userId: user.uid).push(context);
        break;
      case 'block':
        // Show block confirmation dialog
        break;
    }
  }

  String _getLastSeenText(DateTime lastActive) {
    final now = DateTime.now();
    final diff = now.difference(lastActive);

    if (diff.inMinutes < 60) {
      return 'Last seen ${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return 'Last seen ${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return 'Last seen ${diff.inDays}d ago';
    } else {
      return 'Last seen ${lastActive.month}/${lastActive.day}';
    }
  }

  String _getAvailabilityIcon(Availability availability) {
    switch (availability) {
      case Availability.morning:
        return '🌅';
      case Availability.afternoon:
        return '☀️';
      case Availability.evening:
        return '🌙';
      case Availability.flexible:
        return '📅';
    }
  }

  String _getAvailabilityLabel(Availability availability) {
    switch (availability) {
      case Availability.morning:
        return 'Morning';
      case Availability.afternoon:
        return 'Afternoon';
      case Availability.evening:
        return 'Evening';
      case Availability.flexible:
        return 'Flexible';
    }
  }

  _MatchInfo? _calculateMatchInfo(UserModel currentUser, UserModel otherUser) {
    final myOfferedSkills =
        currentUser.skillsOffered.map((s) => s.skillName.toLowerCase()).toSet();
    final myWantedSkills =
        currentUser.skillsWanted.map((s) => s.skillName.toLowerCase()).toSet();
    final theirOfferedSkills =
        otherUser.skillsOffered.map((s) => s.skillName.toLowerCase()).toSet();
    final theirWantedSkills =
        otherUser.skillsWanted.map((s) => s.skillName.toLowerCase()).toSet();

    final theyTeachWhatYouWant =
        myWantedSkills.intersection(theirOfferedSkills).isNotEmpty;
    final youTeachWhatTheyWant =
        myOfferedSkills.intersection(theirWantedSkills).isNotEmpty;

    int score = 0;
    if (theyTeachWhatYouWant && youTeachWhatTheyWant) {
      score += 50;
    } else if (theyTeachWhatYouWant || youTeachWhatTheyWant) {
      score += 25;
    }
    score += ((otherUser.rating.average / 5) * 20).round();
    score += otherUser.swapsCompleted > 15 ? 15 : otherUser.swapsCompleted;

    return _MatchInfo(
      matchPercentage: score > 100 ? 100 : score,
      theyTeachWhatYouWant: theyTeachWhatYouWant,
      youTeachWhatTheyWant: youTeachWhatTheyWant,
      isPerfectMatch: theyTeachWhatYouWant && youTeachWhatTheyWant,
    );
  }
}

/// Match info data class
class _MatchInfo {
  final int matchPercentage;
  final bool theyTeachWhatYouWant;
  final bool youTeachWhatTheyWant;
  final bool isPerfectMatch;

  _MatchInfo({
    required this.matchPercentage,
    required this.theyTeachWhatYouWant,
    required this.youTeachWhatTheyWant,
    required this.isPerfectMatch,
  });
}

/// Section widget with title
class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _Section({
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.screenPaddingH,
        Dimensions.lg,
        Dimensions.screenPaddingH,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Stat item widget
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool isRating;
  final int? ratingCount;

  const _StatItem({
    required this.value,
    required this.label,
    this.isRating = false,
    this.ratingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          if (isRating)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.warning,
                  size: 18,
                ),
                const SizedBox(width: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            )
          else
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          const SizedBox(height: 2),
          Text(
            isRating ? '(${ratingCount ?? 0} reviews)' : label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Skill teach card widget
class _SkillTeachCard extends StatelessWidget {
  final SkillOffered skill;
  final bool isMatching;
  final VoidCallback? onRequestTap;

  const _SkillTeachCard({
    required this.skill,
    required this.isMatching,
    this.onRequestTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(Dimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        border: Border.all(
          color: isMatching ? AppColors.primaryBlue : AppColors.gray200,
          width: isMatching ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  skill.skillName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _LevelBadge(level: skill.level),
            ],
          ),
          if (skill.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '"${skill.description}"',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (isMatching) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.success,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'You want this!',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onRequestTap,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                  child: const Text(
                    'Request This Skill',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Level badge widget
class _LevelBadge extends StatelessWidget {
  final SkillLevel level;

  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (level) {
      case SkillLevel.beginner:
        bgColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        break;
      case SkillLevel.intermediate:
        bgColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        break;
      case SkillLevel.expert:
        bgColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        level.name[0].toUpperCase() + level.name.substring(1),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

/// Skill want chip widget
class _SkillWantChip extends StatelessWidget {
  final SkillWanted skill;
  final bool isMatching;

  const _SkillWantChip({
    required this.skill,
    required this.isMatching,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isMatching ? AppColors.success.withValues(alpha: 0.1) : AppColors.secondarySurface,
        borderRadius: BorderRadius.circular(Dimensions.radiusFull),
        border: isMatching
            ? Border.all(color: AppColors.success, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skill.skillName,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isMatching ? AppColors.success : AppColors.secondaryTeal,
            ),
          ),
          if (isMatching) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.check_circle_rounded,
              size: 14,
              color: AppColors.success,
            ),
          ],
        ],
      ),
    );
  }
}

/// Availability chip widget
class _AvailabilityChip extends StatelessWidget {
  final String icon;
  final String label;

  const _AvailabilityChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(Dimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}