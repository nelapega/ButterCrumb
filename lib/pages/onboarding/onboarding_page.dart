
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../auth/role_selection_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'eyebrow': 'BAKED WITH LOVE',
      'title': 'A Little Sweetness\nin Every Bite',
      'description':
          'Temukan cake, cookies, dan freshly baked '
          'treats yang dibuat dengan penuh cinta.',
      'icon': Icons.cake_rounded,
    },
    {
      'eyebrow': 'FRESH FROM OUR OVEN',
      'title': 'Freshly Baked,\nMade for You',
      'description':
          'Nikmati aneka bakery favorit dengan rasa '
          'istimewa di setiap gigitan.',
      'icon': Icons.bakery_dining_rounded,
    },
    {
      'eyebrow': 'YOUR DAILY HAPPINESS',
      'title': 'Make Every Day\nA Little Sweeter',
      'description':
          'Temukan camilan manis favoritmu dan pesan '
          'dengan mudah kapan saja.',
      'icon': Icons.favorite_rounded,
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _openRoleSelection();
    }
  }

  void _openRoleSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RoleSelectionPage(),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxHeight < 700;
            final illustrationSize = isSmallScreen ? 190.0 : 250.0;
            final innerCircleSize = isSmallScreen ? 130.0 : 170.0;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                isSmallScreen ? 4 : 12,
                24,
                isSmallScreen ? 12 : 20,
              ),
              child: Column(
                children: [
                  // Skip
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _openRoleSelection,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.mocha,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Swipeable onboarding pages
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final page = _pages[index];

                        return LayoutBuilder(
                          builder: (context, pageConstraints) {
                            return SingleChildScrollView(
                              physics:
                                  const ClampingScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: pageConstraints.maxHeight,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    // Cake illustration
                                    Container(
                                      width: illustrationSize,
                                      height: illustrationSize,
                                      decoration: const BoxDecoration(
                                        color: AppColors.softPink,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: innerCircleSize,
                                            height: innerCircleSize,
                                            decoration: BoxDecoration(
                                              color: AppColors.cream,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.divider,
                                                width: 2,
                                              ),
                                            ),
                                            child: Icon(
                                              page['icon'] as IconData,
                                              size: isSmallScreen
                                                  ? 68
                                                  : 86,
                                              color:
                                                  AppColors.chocolate,
                                            ),
                                          ),

                                          Positioned(
                                            top: illustrationSize * 0.16,
                                            right: illustrationSize * 0.16,
                                            child: Icon(
                                              Icons.auto_awesome_rounded,
                                              color: AppColors.mocha,
                                              size: isSmallScreen
                                                  ? 20
                                                  : 26,
                                            ),
                                          ),

                                          Positioned(
                                            bottom: illustrationSize * 0.15,
                                            left: illustrationSize * 0.15,
                                            child: Icon(
                                              Icons.favorite_rounded,
                                              color: AppColors.caramel,
                                              size: isSmallScreen
                                                  ? 20
                                                  : 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: isSmallScreen ? 22 : 36,
                                    ),

                                    Text(
                                      page['eyebrow'] as String,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.mocha,
                                        fontSize:
                                            isSmallScreen ? 10 : 11,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 2.2,
                                      ),
                                    ),

                                    SizedBox(
                                      height: isSmallScreen ? 12 : 16,
                                    ),

                                    Text(
                                      page['title'] as String,
                                      textAlign: TextAlign.center,
                                      style: textTheme.headlineLarge
                                          ?.copyWith(
                                        fontSize:
                                            isSmallScreen ? 29 : 36,
                                        height: 1.15,
                                      ),
                                    ),

                                    SizedBox(
                                      height: isSmallScreen ? 10 : 16,
                                    ),

                                    Text(
                                      page['description'] as String,
                                      textAlign: TextAlign.center,
                                      style: textTheme.bodyMedium
                                          ?.copyWith(
                                        fontSize:
                                            isSmallScreen ? 12 : 13,
                                        color:
                                            AppColors.textSecondary,
                                        height: 1.7,
                                      ),
                                    ),

                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) {
                        final isActive = _currentPage == index;

                        return AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          width: isActive ? 24 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.chocolate
                                : AppColors.caramel,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 22 : 30),

                  // Next / Get Started
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _pages.length - 1
                                ? 'Get Started'
                                : 'Next',
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 19,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
