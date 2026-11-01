library portfolio;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/portfolio_config.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_extensions.dart';
import 'core/theme/theme_provider.dart';
import 'core/widgets/cat_cursor_follower.dart';
import 'features/home/presentation/editorial/ed_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: PortfolioConfig.supabaseUrl,
    anonKey: PortfolioConfig.supabaseAnonKey,
  );

  GestureBinding.instance.resamplingEnabled = true;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 256 << 20;

  ThemeTransitionUtils.initializeColorCache();
  runApp(const ProviderScope(child: PortfolioApp()));
}

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    ref.watch(themeSyncProvider);

    return MaterialApp(
      title: 'Deepanshu Kaushik — UI/UX Designer & Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const CatCursorFollower(child: EditorialShell()),
    );
  }
}
