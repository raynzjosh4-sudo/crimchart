import 'package:equatable/equatable.dart';

/// Represents a user's sign-up context collected across the multi-step flow.
/// Passed between signing pages and ultimately submitted to the auth repository.
class SignUpParams extends Equatable {
  final String countryCode;
  final String countryName;
  final String phoneNumber;
  final String email;
  final String password;
  final String username;
  final String displayName;
  final DateTime? birthday;
  final String? gender;
  final String? ChartTitle;
  final String? profileImagePath; // local file path before upload

  const SignUpParams({
    required this.countryCode,
    required this.countryName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.username,
    required this.displayName,
    this.birthday,
    this.gender,
    this.ChartTitle,
    this.profileImagePath,
  });

  SignUpParams copyWith({
    String? countryCode,
    String? countryName,
    String? phoneNumber,
    String? email,
    String? password,
    String? username,
    String? displayName,
    DateTime? birthday,
    String? gender,
    String? ChartTitle,
    String? profileImagePath,
  }) {
    return SignUpParams(
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      ChartTitle: ChartTitle ?? this.ChartTitle,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'countryCode': countryCode,
      'countryName': countryName,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'username': username,
      'displayName': displayName,
      'birthday': birthday?.toIso8601String(),
      'gender': gender,
      'ChartTitle': ChartTitle,
      'profileImagePath': profileImagePath,
    };
  }

  factory SignUpParams.fromMap(Map<String, dynamic> map) {
    return SignUpParams(
      countryCode: map['countryCode'] ?? '',
      countryName: map['countryName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      username: map['username'] ?? '',
      displayName: map['displayName'] ?? '',
      birthday: map['birthday'] != null ? DateTime.parse(map['birthday']) : null,
      gender: map['gender'],
      ChartTitle: map['ChartTitle'],
      profileImagePath: map['profileImagePath'],
    );
  }

  @override
  List<Object?> get props => [
    countryCode, countryName, phoneNumber, email, password,
    username, displayName, birthday, gender, ChartTitle, profileImagePath,
  ];
}

/// Parameters for login.
class LoginParams extends Equatable {
  final String identifier; // phone number or username or email
  final String password;

  const LoginParams({required this.identifier, required this.password});

  @override
  List<Object?> get props => [identifier, password];
}

/// Auth token pair returned after successful login/signup.
class AuthTokens extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt];
}





























