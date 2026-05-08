import 'package:crimchart/features/showcase/notification_showcase_page.dart';
import 'package:crimchart/settings/subsettings/language_page.dart';
import 'package:crimchart/features/channel/channelsettings/channel_settings_page.dart';
import 'package:crimchart/features/newinsidechartstartpage/models/member.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../signing/landing_page.dart';
import '../../mainFeed/pages/main_feed_page.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../profile/pages/profile_page.dart';

import '../../signing/mobile_number_page.dart';
import '../../signing/email_signup_page.dart';
import '../../signing/name_page.dart';
import '../../signing/password_page.dart';
import '../../signing/birthday_page.dart';
import '../../signing/chart_title_page.dart';
import '../../signing/profile_picture_page.dart';
import '../../signing/country_selector_page.dart';
import '../../signing/channel_intro_page.dart';
import '../../signing/channel_suggestions_page.dart';
import '../../signing/login_page.dart';
import '../../signing/account_selector_page.dart';
import '../../settings/settings_page.dart';

class AppRoutes {
  AppRoutes._();

  // Auth
  static const landing = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const language = '/language';
  static const signupCountry = '/signup/country';
  static const phoneNumber = '/signup/phone';
  static const email = '/signup/email';
  static const name = '/signup/name';
  static const password = '/signup/password';
  static const birthday = '/signup/birthday';
  static const ChartTitle = '/signup/Chart-title';
  static const profilePicture = '/signup/profile-picture';
  static const accountSelector = '/account-selector';
  static const channelIntro = '/signup/channel-intro';
  static const channelSuggestions = '/signup/channel-suggestions';

  // Main app shell
  static const feed = '/feed';
  static const explore = '/explore';
  static const post = '/post';
  static const inbox = '/inbox';
  static const profile = '/profile';

  // Feed sub-routes
  static const videoFeed = '/feed/video';
  static const channelPage = '/channel/:channelId';

  // Inbox / Chat sub-routes
  static const chatThread = '/inbox/chat/:userId';
  static const newMessage = '/inbox/new';

  // Post flow
  static const editPost = '/post/edit';
  static const finalizePost = '/post/finalize';

  // Profile sub-routes
  static const editProfile = '/profile/edit';
  static const settings = '/profile/settings';

  static const channelSettings = '/channel-settings';

  // Showcase
  static const notificationShowcase = '/showcase/notifications';
}

/// Provider for the app router, allowing it to react to authentication state.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.profile,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // ✅ Read the state down here inside the redirect callback!
      final authState = ref.read(authControllerProvider);

      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final path = state.uri.path;

      // Routes accessible without authentication
      final bool isPublicRoute =
          path == AppRoutes.landing ||
          path == AppRoutes.accountSelector ||
          path.startsWith('/signup') ||
          path.startsWith('/login') ||
          path.startsWith('/language');

      // Special Rule: Authenticated users can stay on signup-related setup pages
      final bool isSignupSetupRoute =
          path == AppRoutes.birthday ||
          path == AppRoutes.ChartTitle ||
          path == AppRoutes.profilePicture ||
          path == AppRoutes.channelIntro ||
          path == AppRoutes.channelSuggestions;

      // Rule 1: Not logged in? Stay on public/auth pages.
      if (!isAuthenticated && !isPublicRoute) {
        return AppRoutes.landing;
      }

      // Rule 2: Logged in? Move from auth pages to feed, UNLESS in setup flow.
      if (isAuthenticated && isPublicRoute && !isSignupSetupRoute) {
        return AppRoutes.feed;
      }

      return null;
    },
    routes: [
      // ── Auth ──────────────────────────────────────────────────────────────
      GoRoute(path: AppRoutes.landing, builder: (_, __) => const LandingPage()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
      GoRoute(
        path: AppRoutes.accountSelector,
        builder: (_, __) => const AccountSelectorPage(),
      ),
      GoRoute(
        path: AppRoutes.language,
        builder: (_, __) => const LanguagePage(),
      ),
      GoRoute(
        path: AppRoutes.signupCountry,
        builder: (_, __) => const CountrySelectorPage(),
      ),
      GoRoute(
        path: AppRoutes.phoneNumber,
        builder: (_, __) => const MobileNumberPage(),
      ),
      GoRoute(
        path: AppRoutes.email,
        builder: (_, __) => const EmailSignupPage(),
      ),
      GoRoute(path: AppRoutes.name, builder: (_, __) => const NamePage()),
      GoRoute(
        path: AppRoutes.password,
        builder: (_, __) => const PasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.birthday,
        builder: (_, __) => const BirthdayPage(),
      ),
      GoRoute(
        path: AppRoutes.ChartTitle,
        builder: (_, __) => const ChartTitlePage(),
      ),
      GoRoute(
        path: AppRoutes.profilePicture,
        builder: (_, __) => const ProfilePicturePage(),
      ),
      GoRoute(
        path: AppRoutes.channelIntro,
        builder: (_, __) => const ChannelIntroPage(),
      ),
      GoRoute(
        path: AppRoutes.channelSuggestions,
        builder: (_, __) => const ChannelSuggestionsPage(),
      ),

      // ── Main Feed ─────────────────────────────────────────────────────────
      GoRoute(path: AppRoutes.feed, builder: (_, __) => const MainFeedPage()),

      // ── Inbox / Chat ──────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.inbox,
        builder: (_, __) => const _InboxPlaceholderPage(),
        routes: [
          GoRoute(
            path: 'chat/:userId',
            builder: (context, state) {
              final userId = state.pathParameters['userId']!;
              return _ChatPlaceholderPage(userId: userId);
            },
          ),
          GoRoute(
            path: 'new',
            builder: (_, __) => const _NewMessagePlaceholderPage(),
          ),
        ],
      ),

      // ── Explore ───────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.explore,
        builder: (_, __) => const _PlaceholderPage(title: 'Explore'),
      ),

      // ── Profile ───────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePage(showBack: false),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (_, __) => const _PlaceholderPage(title: 'Edit Profile'),
          ),
          GoRoute(path: 'settings', builder: (_, __) => const SettingsPage()),
        ],
      ),

      // ── Post Flow ─────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.post,
        builder: (_, __) => const _PlaceholderPage(title: 'New Post'),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (_, __) => const _PlaceholderPage(title: 'Edit Post'),
          ),
          GoRoute(
            path: 'finalize',
            builder: (_, __) => const _PlaceholderPage(title: 'Finalize Post'),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.channelSettings,
        builder: (context, state) {
          final Map<String, dynamic>? extra =
              state.extra as Map<String, dynamic>?;
          return ChannelSettingsPage(
            channelId: extra?['channelId'] ?? 'dummy_id',
            channelTitle: extra?['channelTitle'] ?? 'Chart Channel',
            memberCount: extra?['memberCount'] ?? 0,
            createdAt: extra?['createdAt'] as DateTime? ?? DateTime.now(),
            staterAvatarUrl: extra?['staterAvatarUrl'],
            description: extra?['description'],
            ageRestriction: extra?['ageRestriction'],
            visibleToOtherChannelMembers:
                extra?['visibleToOtherChannelMembers'] ?? false,
            visibleToFollowedUsers: extra?['visibleToFollowedUsers'] ?? true,
            joinMethod: extra?['joinMethod'] ?? 'invite',
            preventLeaving: extra?['preventLeaving'] ?? false,
            countryRestrictions:
                extra?['countryRestrictions'] as List<String>? ??
                const ['Global'],
            allowCommentingBy: extra?['allowCommentingBy'] ?? 'all',
            allowStatusPostingBy: extra?['allowStatusPostingBy'] ?? 'all',
            members: extra?['members'] as List<Member>? ?? const [],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.notificationShowcase,
        builder: (_, __) => const NotificationShowcasePage(),
      ),
    ],

    // Error page for unknown routes
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page not found: ${state.uri}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ),
  );
});

// ── Placeholder pages (to be replaced with real implementations) ──────────────

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title\n(Coming soon)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

class _InboxPlaceholderPage extends StatelessWidget {
  const _InboxPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Inbox',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(AppRoutes.newMessage),
            tooltip: 'New Message',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Your messages will appear here',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.newMessage),
              icon: const Icon(Icons.add),
              label: const Text('New Message'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatPlaceholderPage extends StatelessWidget {
  final String userId;
  const _ChatPlaceholderPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with $userId')),
      body: const Center(child: Text('Chat UI — coming in Phase 3')),
    );
  }
}

class _NewMessagePlaceholderPage extends StatelessWidget {
  const _NewMessagePlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Message')),
      body: const Center(child: Text('Select a recipient')),
    );
  }
}
