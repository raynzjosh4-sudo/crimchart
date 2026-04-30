import 'dart:convert';
import 'package:crown/core/network/api_client.dart';
import 'package:crown/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:crown/features/auth/data/sources/auth_local_source.dart';
import 'package:crown/features/auth/data/sources/auth_remote_source.dart';
import 'package:crown/features/auth/domain/entities/auth_params.dart';
import 'package:crown/features/auth/domain/entities/user_entity.dart';
import 'package:crown/features/auth/domain/repositories/auth_repository.dart';
import 'package:crown/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:crown/features/auth/domain/use_cases/login.dart';
import 'package:crown/features/auth/domain/use_cases/sign_up.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final _apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final _authLocalSourceProvider = Provider<AuthLocalSource>(
  (ref) => AuthLocalSource(),
);

final _authRemoteSourceProvider = Provider<AuthRemoteSource>(
  (ref) => AuthRemoteSource(ref.read(_apiClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.read(_authRemoteSourceProvider),
    ref.read(_authLocalSourceProvider),
  ),
);

// Individual use case providers
final _signUpProvider = Provider<SignUp>(
  (ref) => SignUp(ref.read(authRepositoryProvider)),
);
final _loginProvider = Provider<Login>(
  (ref) => Login(ref.read(authRepositoryProvider)),
);
final _loginGoogleProvider = Provider<LoginWithGoogle>(
  (ref) => LoginWithGoogle(ref.read(authRepositoryProvider)),
);
final _signOutProvider = Provider<SignOut>(
  (ref) => SignOut(ref.read(authRepositoryProvider)),
);
final _getCurrentUserProvider = Provider<GetCurrentUser>(
  (ref) => GetCurrentUser(ref.read(authRepositoryProvider)),
);
final _checkUsernameProvider = Provider<CheckUsernameAvailable>(
  (ref) => CheckUsernameAvailable(ref.read(authRepositoryProvider)),
);

// ── Auth State ─────────────────────────────────────────────────────────────────

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final bool isLoading;
  final String? errorMessage;

  /// Collects signup data across pages (grows at each step)
  final SignUpParams? pendingSignUp;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.pendingSignUp,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;
  String? get phoneNumber => pendingSignUp?.phoneNumber;
  String? get email => pendingSignUp?.email;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    bool? isLoading,
    String? errorMessage,
    SignUpParams? pendingSignUp,
    bool clearError = false,
    bool clearUser = false,
    bool clearPendingSignUp = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      pendingSignUp: clearPendingSignUp
          ? null
          : (pendingSignUp ?? this.pendingSignUp),
    );
  }
}

// ── Auth Controller ────────────────────────────────────────────────────────────

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      signUp: ref.read(_signUpProvider),
      login: ref.read(_loginProvider),
      loginWithGoogle: ref.read(_loginGoogleProvider),
      signOut: ref.read(_signOutProvider),
      getCurrentUser: ref.read(_getCurrentUserProvider),
      checkUsernameAvailable: ref.read(_checkUsernameProvider),
      localSource: ref.read(_authLocalSourceProvider),
      repository: ref.read(authRepositoryProvider),
    );
  },
);

class AuthController extends StateNotifier<AuthState> {
  final SignUp _signUp;
  final Login _login;
  final LoginWithGoogle _loginWithGoogle;
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;
  final CheckUsernameAvailable _checkUsernameAvailable;
  final AuthLocalSource _local;
  final AuthRepository _repository;

  final _storage = const FlutterSecureStorage();
  static const _pendingKey = 'saved_pending_signup';

  AuthController({
    required SignUp signUp,
    required Login login,
    required LoginWithGoogle loginWithGoogle,
    required SignOut signOut,
    required GetCurrentUser getCurrentUser,
    required CheckUsernameAvailable checkUsernameAvailable,
    required AuthLocalSource localSource,
    required AuthRepository repository,
  }) : _signUp = signUp,
       _login = login,
       _loginWithGoogle = loginWithGoogle,
       _signOut = signOut,
       _getCurrentUser = getCurrentUser,
       _checkUsernameAvailable = checkUsernameAvailable,
       _local = localSource,
       _repository = repository,
       super(const AuthState()) {
    _checkSession();
    _loadPendingSignUp();
  }

  // ── Session Check (on app start) ─────────────────────────────────────────

  Future<void> _checkSession() async {
    final result = await _getCurrentUser();
    result.fold(
      (_) => state = state.copyWith(status: AuthStatus.unauthenticated),
      (user) => state = user != null
          ? state.copyWith(status: AuthStatus.authenticated, user: user)
          : state.copyWith(status: AuthStatus.unauthenticated),
    );
  }

  // ── Persistence ──────────────────────────────────────────────────────────

  Future<void> _loadPendingSignUp() async {
    try {
      final savedData = await _storage.read(key: _pendingKey);
      if (savedData != null) {
        final map = jsonDecode(savedData) as Map<String, dynamic>;
        state = state.copyWith(pendingSignUp: SignUpParams.fromMap(map));
      }
    } catch (e) {
      await _storage.delete(key: _pendingKey);
    }
  }

  Future<void> _autoSavePendingSignUp(SignUpParams pending) async {
    await _storage.write(key: _pendingKey, value: jsonEncode(pending.toMap()));
  }

  // ── Signup Flow — step-by-step data collection ───────────────────────────

  void startSignUp({required String countryCode, required String countryName}) {
    final pending = SignUpParams(
      countryCode: countryCode,
      countryName: countryName,
      phoneNumber: '',
      email: '',
      password: '',
      username: '',
      displayName: '',
    );
    state = state.copyWith(pendingSignUp: pending);
    _autoSavePendingSignUp(pending);
  }

  void setPhoneNumber(String phoneNumber) {
    final pending = state.pendingSignUp;
    if (pending == null) return;
    final updated = pending.copyWith(phoneNumber: phoneNumber);
    state = state.copyWith(pendingSignUp: updated);
    _autoSavePendingSignUp(updated);
  }

  void setEmail(String email) {
    final pending = state.pendingSignUp;
    if (pending == null) return;
    final updated = pending.copyWith(email: email);
    state = state.copyWith(pendingSignUp: updated);
    _autoSavePendingSignUp(updated);
  }

  void setPassword(String password) {
    final pending = state.pendingSignUp;
    if (pending == null) return;
    final updated = pending.copyWith(password: password);
    state = state.copyWith(pendingSignUp: updated);
    _autoSavePendingSignUp(updated);
  }

  void setDisplayName(String displayName) {
    final pending = state.pendingSignUp;
    if (pending == null) return;
    final autoUsername = displayName.replaceAll(' ', '').toLowerCase();
    final updated = pending.copyWith(
      displayName: displayName,
      username: autoUsername,
    );
    state = state.copyWith(pendingSignUp: updated);
    _autoSavePendingSignUp(updated);
  }

  void setBirthday(DateTime birthday) {
    final pending = state.pendingSignUp;
    if (pending == null) return;
    final updated = pending.copyWith(birthday: birthday);
    state = state.copyWith(pendingSignUp: updated);
    _autoSavePendingSignUp(updated);
  }

  void setGender(String gender) {
    final pending = state.pendingSignUp;
    if (pending == null) return;
    final updated = pending.copyWith(gender: gender);
    state = state.copyWith(pendingSignUp: updated);
    _autoSavePendingSignUp(updated);
  }

  void setChartTitle(String ChartTitle) {
    final pending = state.pendingSignUp;
    if (pending == null) return;
    final updated = pending.copyWith(ChartTitle: ChartTitle);
    state = state.copyWith(pendingSignUp: updated);
    _autoSavePendingSignUp(updated);
  }

  Future<bool> setUsernameAndCheck(String username) async {
    final pending = state.pendingSignUp;
    if (pending == null) return false;

    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _checkUsernameAvailable(username);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (available) {
        if (available) {
          final updated = pending.copyWith(username: username);
          state = state.copyWith(
            isLoading: false,
            pendingSignUp: updated,
            clearError: true,
          );
          _autoSavePendingSignUp(updated);
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'This username is already taken',
          );
        }
        return available;
      },
    );
  }

  /// Triggered at Password Page to create the official Supabase account
  Future<bool> completeSignUp() async {
    final pending = state.pendingSignUp;
    if (pending == null) return false;

    // Supabase needs Email, Password, and we want Name + Country for initial profile
    if (pending.email.isEmpty ||
        pending.password.isEmpty ||
        pending.displayName.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Email, Name, and Password are required.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _signUp(pending);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (user) async {
        await _storage.delete(key: _pendingKey);
        state = state.copyWith(
          isLoading: false,
          status: AuthStatus.authenticated,
          user: user,
          clearPendingSignUp: true,
        );
        return true;
      },
    );
  }

  /// Triggered at Birthday, Title, and Profile Picture pages for direct DB updates
  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.updateProfile(updates);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
        return true;
      },
    );
  }

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _login(
      LoginParams(identifier: identifier, password: password),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          status: AuthStatus.authenticated,
          user: user,
        );
        return true;
      },
    );
  }

  Future<bool> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _loginWithGoogle();

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          status: AuthStatus.authenticated,
          user: user,
        );
        return true;
      },
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await _signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> logout() => signOut();

  Future<void> bypassAuthForDevelopment() async {
    final hardcodedUser = UserEntity(
      id: 'dev-user-123',
      username: 'devuser',
      displayName: 'Dev User',
      profileImageUrl: null,
      bio: 'Development account',
      ChartTitle: 'Developer',
      isVerified: true,
      followersCount: 0,
      followingCount: 0,
      postsCount: 0,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: hardcodedUser,
      clearPendingSignUp: true,
      clearError: true,
    );

    await _local.saveUser(
      hardcodedUser,
      accessToken: 'dev-token',
      refreshToken: 'dev-refresh',
    );
  }

  void clearError() => state = state.copyWith(clearError: true);
}











