import 'package:crown/core/errors/exceptions.dart';
import 'package:crown/core/network/api_client.dart';
import 'package:crown/core/supabase/supabase_config.dart';
import 'package:crown/features/auth/domain/entities/auth_params.dart';
import 'package:crown/features/auth/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

@injectable
class AuthRemoteSource {
  const AuthRemoteSource(ApiClient client);

  supabase.SupabaseClient get _supabase => SupabaseConfig.client;

  Future<({UserEntity user, AuthTokens tokens})> signUp(
    SignUpParams params,
  ) async {
    try {
      // 1. Sign up via Supabase Auth using the email
      final sanitizedEmail = params.email.trim();
      final supabase.AuthResponse res = await _supabase.auth.signUp(
        email: sanitizedEmail,
        password: params.password,
      );

      final supabase.Session? session = res.session;
      final supabase.User? authUser = res.user;

      if (authUser == null || session == null) {
        throw const supabase.AuthException(
          'Signup failed: No user or session returned.',
        );
      }

      // 2. Insert into custom "users" or "profiles" table if you want to store metadata
      // (Assuming a table named "profiles" exists with an "id" tracTop authUser.id)
      final profileData = {
        'id': authUser.id, // Must match the auth.user id
        'username': params.username,
        'display_name': params.displayName,
        'Chart_title': params.ChartTitle,
        'birthday': params.birthday?.toIso8601String(),
        'gender': params.gender,
      };

      try {
        await _supabase.from('profiles').insert(profileData);
      } catch (e) {
        // Log the error to help debug why the initial insert is failing.
        print("AuthRemoteSource: Profile insert failed: $e");
      }

      // 3. Return our application entity
      return (
        user: UserEntity(
          id: authUser.id,
          username: params.username,
          displayName: params.displayName,
          profileImageUrl: null,
          ChartTitle: params.ChartTitle,
          birthday: params.birthday,
          gender: params.gender,
          createdAt: DateTime.now(),
        ),
        tokens: AuthTokens(
          accessToken: session.accessToken,
          refreshToken: session.refreshToken ?? '',
          expiresAt: DateTime.now().add(const Duration(seconds: 3600)),
        ),
      );
    } on supabase.AuthException catch (e) {
      throw supabase.AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<({UserEntity user, AuthTokens tokens})> login(
    LoginParams params,
  ) async {
    try {
      // params.identifier is used as email for Supabase Auth
      final sanitizedIdentifier = params.identifier.trim().replaceAll(
        RegExp(r'\s+'),
        '',
      );
      final supabase.AuthResponse res = await _supabase.auth.signInWithPassword(
        email: sanitizedIdentifier,
        password: params.password,
      );

      final supabase.Session? session = res.session;
      final supabase.User? authUser = res.user;

      if (authUser == null || session == null) {
        throw const AuthException('Login failed: Invalid credentials.');
      }

      // Fetch profile from our custom 'profiles' table
      Map<String, dynamic>? profile;
      try {
        final data = await _supabase
            .from('profiles')
            .select()
            .eq('id', authUser.id)
            .maybeSingle();
        profile = data;
      } catch (_) {
        // Fallback for missing table
      }

      return (
        user: UserEntity(
          id: authUser.id,
          username: profile?['username'] ?? params.identifier.split('@')[0],
          displayName:
              profile?['display_name'] ?? params.identifier.split('@')[0],
          profileImageUrl: profile?['profile_image_url'],
          ChartTitle: profile?['Chart_title'],
          birthday: profile?['birthday'] != null
              ? DateTime.parse(profile?['birthday'] as String)
              : null,
          gender: profile?['gender'],
          isVerified: profile?['is_verified'] ?? false,
          followersCount: profile?['followers_count'] ?? 0,
          followingCount: profile?['following_count'] ?? 0,
          postsCount: profile?['posts_count'] ?? 0,
          ChartsCount: profile?['Charts_count'] ?? 0,
          channelsCount: profile?['channels_count'] ?? 0,
          createdAt: profile?['created_at'] != null
              ? DateTime.parse(profile?['created_at'] as String)
              : DateTime.now(),
        ),
        tokens: AuthTokens(
          accessToken: session.accessToken,
          refreshToken: session.refreshToken ?? '',
          expiresAt: DateTime.now().add(const Duration(seconds: 3600)),
        ),
      );
    } on supabase.AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<({UserEntity user, AuthTokens tokens})> loginWithGoogle(
    String googleToken,
  ) async {
    // For now, return mock/error as the real flow will be added later
    throw const AuthException('Google login is not implemented yet.');
  }

  Future<AuthTokens> refreshToken(String refreshToken) async {
    // With supabase-flutter, sessions auto-refresh. We rarely need to manually trigger this.
    // If you do, you can use: final response = await _supabase.auth.refreshSession();
    throw const AuthException(
      'Manual token refresh not typically needed for Supabase.',
    );
  }

  Future<bool> checkUsernameAvailable(String username) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select('id')
          .eq('username', username)
          .maybeSingle();
      return data == null; // Available if no profile matches
    } catch (_) {
      return true; // Assume available if table missing/error
    }
  }

  Future<void> signOut(String accessToken) async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }

  Future<UserEntity> updateProfile(Map<String, dynamic> updates) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('No authenticated user found for update.');
    }

    try {
      // 1. Update the 'profiles' table
      final response = await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', user.id)
          .select()
          .single();

      // 2. Map updated data to our entity
      return UserEntity(
        id: response['id'],
        username: response['username'] ?? '',
        displayName: response['display_name'] ?? '',
        profileImageUrl: response['profile_image_url'],
        ChartTitle: response['Chart_title'],
        birthday: response['birthday'] != null
            ? DateTime.parse(response['birthday'] as String)
            : null,
        gender: response['gender'],
        isVerified: response['is_verified'] ?? false,
        followersCount: response['followers_count'] ?? 0,
        followingCount: response['following_count'] ?? 0,
        postsCount: response['posts_count'] ?? 0,
        ChartsCount: response['Charts_count'] ?? 0,
        channelsCount: response['channels_count'] ?? 0,
        createdAt:
            DateTime.tryParse(response['created_at'] ?? '') ?? DateTime.now(),
      );
    } catch (e) {
      throw AuthException('Update failed: ${e.toString()}');
    }
  }
}











