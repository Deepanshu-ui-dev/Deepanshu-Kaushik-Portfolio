import 'package:flutter/material.dart';
import 'package:monofolio/core/theme/app_theme.dart';

class PortfolioDrawer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const PortfolioDrawer({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  static const List<String> _tabs = [
    'HOME',
    'ABOUT',
    'PROJECTS',
    'SKILLS',
    'CONTACT',
  ];

  static const List<IconData> _tabIcons = [
    Icons.home_outlined,
    Icons.person_outline_rounded,
    Icons.work_outline_rounded,
    Icons.auto_awesome_outlined,
    Icons.mail_outline_rounded,
  ];
  static const List<IconData> _tabIconsActive = [
    Icons.home_rounded,
    Icons.person_rounded,
    Icons.work_rounded,
    Icons.auto_awesome,
    Icons.mail_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textTer = isDark ? AppColors.textTerDark : AppColors.textTerLight;
    final surface = isDark ? AppColors.surfaceElevDark : Colors.white;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Drawer(
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  Text(
                    'NAVIGATE',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 12,
                      letterSpacing: 2.0,
                      color: textTer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: textPri),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: border),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _tabs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final isActive = index == currentIndex;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.pop(context); 
                        onSelect(index);
                      },
                      splashColor: accent.withValues(alpha: 0.1),
                      highlightColor: accent.withValues(alpha: 0.05),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isActive ? accent.withValues(alpha: 0.08) : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isActive ? _tabIconsActive[index] : _tabIcons[index],
                              color: isActive ? accent : textPri,
                              size: 22,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '/${_tabs[index]}',
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 16,
                                letterSpacing: 1.0,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                color: isActive ? accent : textPri,
                              ),
                            ),
                            if (isActive) ...[
                              const Spacer(),
                              Icon(Icons.check_rounded, color: accent, size: 18),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
