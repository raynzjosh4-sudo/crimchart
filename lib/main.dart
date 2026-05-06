import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide Consumer, ChangeNotifierProvider;
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/localization/localization_provider.dart';
import 'core/utils/responsive_size.dart';
import 'core/router/app_router.dart';
import 'core/supabase/supabase_config.dart';
import 'core/di/injection.dart';
import 'package:toastification/toastification.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    MediaKit.ensureInitialized();

    // Initialize core services safely
    await SupabaseConfig.initialize().timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        print("Supabase Init Timeout: Continuing anyway...");
      },
    );

    await configureDependencies();

    runApp(const ProviderScope(child: ChartAppRoot()));
  } catch (e, stack) {
    print("FATAL STARTUP ERROR: $e");
    print(stack);

    // Fallback error UI if startup fails completely
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    "Chart failed to start",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Root widget — bootstraps both Riverpod (new) and Provider (existing).
/// Provider is kept for ThemeProvider and LocalizationProvider until
/// they are migrated to Riverpod in a later phase.
class ChartAppRoot extends StatelessWidget {
  const ChartAppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocalizationProvider()),
      ],
      child: const ChartApp(),
    );
  }
}

class ChartApp extends ConsumerWidget {
  const ChartApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ToastificationWrapper(
          child: MaterialApp.router(
            routerConfig: router,
            title: 'Chart',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme(
              brightness: Brightness.light,
              primaryColor: themeProvider.currentColor,
              fontFamily: themeProvider.currentFontFamily,
            ),
            darkTheme: AppTheme.theme(
              brightness: Brightness.dark,
              primaryColor: themeProvider.currentColor,
              fontFamily: themeProvider.currentFontFamily,
            ),
            themeMode: themeProvider.themeMode,
            builder: (context, child) {
              SizeConfig.init(
                context,
                userScaleFactor: themeProvider.displayScale,
              );
              final isDark = themeProvider.themeMode == ThemeMode.dark ||
                  (themeProvider.themeMode == ThemeMode.system &&
                      MediaQuery.platformBrightnessOf(context) ==
                          Brightness.dark);
              return Container(
                decoration: AppTheme.globalBackgroundDecoration(context, isDark: isDark),
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}
