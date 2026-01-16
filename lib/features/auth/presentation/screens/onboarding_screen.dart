import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/services/storage_service.dart';

/// Provider for current onboarding page index
final _currentPageProvider = StateProvider.autoDispose<int>((ref) => 0);

/// Onboarding page data
class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}

const _pages = [
  OnboardingPage(
    icon: Icons.swap_horiz_rounded,
    title: 'Trade Skills, Not Money',
    description:
        'Exchange your expertise with others. No cash needed - just your valuable skills and time.',
  ),
  OnboardingPage(
    icon: Icons.school_rounded,
    title: 'Teach & Learn',
    description:
        'Share what you know and learn what you want. Everyone has something valuable to offer.',
  ),
  OnboardingPage(
    icon: Icons.access_time_rounded,
    title: '1 Hour = 1 Credit',
    description:
        'Simple time-based currency. Teach for an hour, earn a credit. Learn for an hour, spend a credit.',
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    ref.read(_currentPageProvider.notifier).state = page;
  }

  void _nextPage() {
    final currentPage = ref.read(_currentPageProvider);
    if (currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final storageService = await ref.read(storageServiceProvider.future);
    await storageService.setOnboardingSeen();

    if (mounted) {
      const LoginRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(_currentPageProvider);
    final isLastPage = currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.md),
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    isLastPage ? '' : 'Skip',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPageWidget(page: _pages[index]);
                },
              ),
            ),

            // Bottom section
            Padding(
              padding: const EdgeInsets.all(Dimensions.screenPaddingH),
              child: Column(
                children: [
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 12,
                      activeDotColor: AppColors.primaryBlue,
                      dotColor: AppColors.gray200,
                    ),
                  ),
                  const SizedBox(height: Dimensions.xl),

                  // Next/Get Started button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(isLastPage ? 'Get Started' : 'Next'),
                    ),
                  ),
                  const SizedBox(height: Dimensions.md),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const _OnboardingPageWidget({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.screenPaddingH),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 160,
            height: 160,
            decoration: const BoxDecoration(
              color: AppColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 80,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: Dimensions.xxl),

          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.md),

          // Description
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}