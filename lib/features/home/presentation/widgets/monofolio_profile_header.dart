import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/portfolio_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/animated_role_text.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/tap_scale.dart';
import 'package:url_launcher/url_launcher.dart';

class MonofolioProfile extends StatelessWidget {
  const MonofolioProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 32),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.surfaceBorder, width: 1),
              color: AppColors.surfaceBorder.withValues(alpha: 0.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                  ),
                  child: Text(
                    'New',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),  
                const SizedBox(width: 8),
                Text(
                  'Checkout my Article',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_outward, size: 14, color: AppColors.textPrimary),
              ],
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.only(top: 16),
          child: LayoutBuilder(builder: (context, constraints) {
            final isMobile = AppSpacing.isMobile(context);
            
            final details = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, I\'m 👋🏼',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: isMobile ? 11 : 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        PortfolioConfig.name,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: isMobile ? 22 : 28,
                          fontWeight: FontWeight.w600,
                          letterSpacing: isMobile ? 1.5 : 2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.verified, color: AppColors.textPrimary, size: isMobile ? 18 : 24),
                  ],
                ),
                const SizedBox(height: 8),
                const AnimatedRoleText(),
              ],
            );

            final bool isDark = Theme.of(context).brightness == Brightness.dark;
            final socials = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (PortfolioConfig.githubUrl.isNotEmpty) ...[
                  TapScale(
                    onTap: () => launchUrl(Uri.parse(PortfolioConfig.githubUrl)),
                    child: SizedBox(
                      width: 20, height: 20,
                      child: SvgPicture.network(
                        'https://api.iconify.design/simple-icons/github.svg?color=%23${isDark ? 'FFFFFF' : '181717'}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                if (PortfolioConfig.linkedinUrl.isNotEmpty) ...[
                  TapScale(
                    onTap: () => launchUrl(Uri.parse(PortfolioConfig.linkedinUrl)),
                    child: SizedBox(
                      width: 20, height: 20,
                      child: SvgPicture.network(
                        'https://api.iconify.design/simple-icons/linkedin.svg?color=%23${isDark ? 'FFFFFF' : '0A66C2'}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                if (PortfolioConfig.twitterUrl.isNotEmpty) ...[
                  TapScale(
                    onTap: () => launchUrl(Uri.parse(PortfolioConfig.twitterUrl)),
                    child: SizedBox(
                      width: 20, height: 20,
                      child: SvgPicture.network(
                        'https://api.iconify.design/simple-icons/x.svg?color=%23${isDark ? 'FFFFFF' : '000000'}',
                      ),
                    ),
                  ),
                ],
              ],
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isMobile) ...[
                  details,
                  const SizedBox(height: 24),
                  socials,
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: details),
                      socials,
                    ],
                  ),
                const SizedBox(height: 16),
                const RepaintBoundary(child: DashedDivider()),
              ],
            );
          }),
        ),

      ],
    );
  }
}
