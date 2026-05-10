// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_db.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profileImageUrlMeta = const VerificationMeta(
    'profileImageUrl',
  );
  @override
  late final GeneratedColumn<String> profileImageUrl = GeneratedColumn<String>(
    'profile_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta(
    'isVerified',
  );
  @override
  late final GeneratedColumn<int> isVerified = GeneratedColumn<int>(
    'is_verified',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _followersCountMeta = const VerificationMeta(
    'followersCount',
  );
  @override
  late final GeneratedColumn<int> followersCount = GeneratedColumn<int>(
    'followers_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _followingCountMeta = const VerificationMeta(
    'followingCount',
  );
  @override
  late final GeneratedColumn<int> followingCount = GeneratedColumn<int>(
    'following_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postsCountMeta = const VerificationMeta(
    'postsCount',
  );
  @override
  late final GeneratedColumn<int> postsCount = GeneratedColumn<int>(
    'posts_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chartsCountMeta = const VerificationMeta(
    'chartsCount',
  );
  @override
  late final GeneratedColumn<int> chartsCount = GeneratedColumn<int>(
    'ChartsCount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _channelsCountMeta = const VerificationMeta(
    'channelsCount',
  );
  @override
  late final GeneratedColumn<int> channelsCount = GeneratedColumn<int>(
    'channelsCount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chartTitleMeta = const VerificationMeta(
    'chartTitle',
  );
  @override
  late final GeneratedColumn<String> chartTitle = GeneratedColumn<String>(
    'ChartTitle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthdayMeta = const VerificationMeta(
    'birthday',
  );
  @override
  late final GeneratedColumn<String> birthday = GeneratedColumn<String>(
    'birthday',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accessTokenMeta = const VerificationMeta(
    'accessToken',
  );
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
    'access_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _refreshTokenMeta = const VerificationMeta(
    'refreshToken',
  );
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
    'refresh_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    displayName,
    profileImageUrl,
    bio,
    title,
    isVerified,
    followersCount,
    followingCount,
    postsCount,
    chartsCount,
    channelsCount,
    chartTitle,
    birthday,
    gender,
    createdAt,
    accessToken,
    refreshToken,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('profile_image_url')) {
      context.handle(
        _profileImageUrlMeta,
        profileImageUrl.isAcceptableOrUnknown(
          data['profile_image_url']!,
          _profileImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('is_verified')) {
      context.handle(
        _isVerifiedMeta,
        isVerified.isAcceptableOrUnknown(data['is_verified']!, _isVerifiedMeta),
      );
    }
    if (data.containsKey('followers_count')) {
      context.handle(
        _followersCountMeta,
        followersCount.isAcceptableOrUnknown(
          data['followers_count']!,
          _followersCountMeta,
        ),
      );
    }
    if (data.containsKey('following_count')) {
      context.handle(
        _followingCountMeta,
        followingCount.isAcceptableOrUnknown(
          data['following_count']!,
          _followingCountMeta,
        ),
      );
    }
    if (data.containsKey('posts_count')) {
      context.handle(
        _postsCountMeta,
        postsCount.isAcceptableOrUnknown(data['posts_count']!, _postsCountMeta),
      );
    }
    if (data.containsKey('ChartsCount')) {
      context.handle(
        _chartsCountMeta,
        chartsCount.isAcceptableOrUnknown(
          data['ChartsCount']!,
          _chartsCountMeta,
        ),
      );
    }
    if (data.containsKey('channelsCount')) {
      context.handle(
        _channelsCountMeta,
        channelsCount.isAcceptableOrUnknown(
          data['channelsCount']!,
          _channelsCountMeta,
        ),
      );
    }
    if (data.containsKey('ChartTitle')) {
      context.handle(
        _chartTitleMeta,
        chartTitle.isAcceptableOrUnknown(data['ChartTitle']!, _chartTitleMeta),
      );
    }
    if (data.containsKey('birthday')) {
      context.handle(
        _birthdayMeta,
        birthday.isAcceptableOrUnknown(data['birthday']!, _birthdayMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('access_token')) {
      context.handle(
        _accessTokenMeta,
        accessToken.isAcceptableOrUnknown(
          data['access_token']!,
          _accessTokenMeta,
        ),
      );
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
        _refreshTokenMeta,
        refreshToken.isAcceptableOrUnknown(
          data['refresh_token']!,
          _refreshTokenMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      profileImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_image_url'],
      ),
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      isVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_verified'],
      ),
      followersCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}followers_count'],
      ),
      followingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}following_count'],
      ),
      postsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}posts_count'],
      ),
      chartsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ChartsCount'],
      ),
      channelsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}channelsCount'],
      ),
      chartTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ChartTitle'],
      ),
      birthday: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birthday'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      accessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token'],
      ),
      refreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refresh_token'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String? username;
  final String? displayName;
  final String? profileImageUrl;
  final String? bio;
  final String? title;
  final int? isVerified;
  final int? followersCount;
  final int? followingCount;
  final int? postsCount;
  final int? chartsCount;
  final int? channelsCount;
  final String? chartTitle;
  final String? birthday;
  final String? gender;
  final String? createdAt;
  final String? accessToken;
  final String? refreshToken;
  const User({
    required this.id,
    this.username,
    this.displayName,
    this.profileImageUrl,
    this.bio,
    this.title,
    this.isVerified,
    this.followersCount,
    this.followingCount,
    this.postsCount,
    this.chartsCount,
    this.channelsCount,
    this.chartTitle,
    this.birthday,
    this.gender,
    this.createdAt,
    this.accessToken,
    this.refreshToken,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || profileImageUrl != null) {
      map['profile_image_url'] = Variable<String>(profileImageUrl);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || isVerified != null) {
      map['is_verified'] = Variable<int>(isVerified);
    }
    if (!nullToAbsent || followersCount != null) {
      map['followers_count'] = Variable<int>(followersCount);
    }
    if (!nullToAbsent || followingCount != null) {
      map['following_count'] = Variable<int>(followingCount);
    }
    if (!nullToAbsent || postsCount != null) {
      map['posts_count'] = Variable<int>(postsCount);
    }
    if (!nullToAbsent || chartsCount != null) {
      map['ChartsCount'] = Variable<int>(chartsCount);
    }
    if (!nullToAbsent || channelsCount != null) {
      map['channelsCount'] = Variable<int>(channelsCount);
    }
    if (!nullToAbsent || chartTitle != null) {
      map['ChartTitle'] = Variable<String>(chartTitle);
    }
    if (!nullToAbsent || birthday != null) {
      map['birthday'] = Variable<String>(birthday);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || accessToken != null) {
      map['access_token'] = Variable<String>(accessToken);
    }
    if (!nullToAbsent || refreshToken != null) {
      map['refresh_token'] = Variable<String>(refreshToken);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      profileImageUrl: profileImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImageUrl),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      isVerified: isVerified == null && nullToAbsent
          ? const Value.absent()
          : Value(isVerified),
      followersCount: followersCount == null && nullToAbsent
          ? const Value.absent()
          : Value(followersCount),
      followingCount: followingCount == null && nullToAbsent
          ? const Value.absent()
          : Value(followingCount),
      postsCount: postsCount == null && nullToAbsent
          ? const Value.absent()
          : Value(postsCount),
      chartsCount: chartsCount == null && nullToAbsent
          ? const Value.absent()
          : Value(chartsCount),
      channelsCount: channelsCount == null && nullToAbsent
          ? const Value.absent()
          : Value(channelsCount),
      chartTitle: chartTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(chartTitle),
      birthday: birthday == null && nullToAbsent
          ? const Value.absent()
          : Value(birthday),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      accessToken: accessToken == null && nullToAbsent
          ? const Value.absent()
          : Value(accessToken),
      refreshToken: refreshToken == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshToken),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String?>(json['username']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      profileImageUrl: serializer.fromJson<String?>(json['profileImageUrl']),
      bio: serializer.fromJson<String?>(json['bio']),
      title: serializer.fromJson<String?>(json['title']),
      isVerified: serializer.fromJson<int?>(json['isVerified']),
      followersCount: serializer.fromJson<int?>(json['followersCount']),
      followingCount: serializer.fromJson<int?>(json['followingCount']),
      postsCount: serializer.fromJson<int?>(json['postsCount']),
      chartsCount: serializer.fromJson<int?>(json['chartsCount']),
      channelsCount: serializer.fromJson<int?>(json['channelsCount']),
      chartTitle: serializer.fromJson<String?>(json['chartTitle']),
      birthday: serializer.fromJson<String?>(json['birthday']),
      gender: serializer.fromJson<String?>(json['gender']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      accessToken: serializer.fromJson<String?>(json['accessToken']),
      refreshToken: serializer.fromJson<String?>(json['refreshToken']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String?>(username),
      'displayName': serializer.toJson<String?>(displayName),
      'profileImageUrl': serializer.toJson<String?>(profileImageUrl),
      'bio': serializer.toJson<String?>(bio),
      'title': serializer.toJson<String?>(title),
      'isVerified': serializer.toJson<int?>(isVerified),
      'followersCount': serializer.toJson<int?>(followersCount),
      'followingCount': serializer.toJson<int?>(followingCount),
      'postsCount': serializer.toJson<int?>(postsCount),
      'chartsCount': serializer.toJson<int?>(chartsCount),
      'channelsCount': serializer.toJson<int?>(channelsCount),
      'chartTitle': serializer.toJson<String?>(chartTitle),
      'birthday': serializer.toJson<String?>(birthday),
      'gender': serializer.toJson<String?>(gender),
      'createdAt': serializer.toJson<String?>(createdAt),
      'accessToken': serializer.toJson<String?>(accessToken),
      'refreshToken': serializer.toJson<String?>(refreshToken),
    };
  }

  User copyWith({
    String? id,
    Value<String?> username = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
    Value<String?> profileImageUrl = const Value.absent(),
    Value<String?> bio = const Value.absent(),
    Value<String?> title = const Value.absent(),
    Value<int?> isVerified = const Value.absent(),
    Value<int?> followersCount = const Value.absent(),
    Value<int?> followingCount = const Value.absent(),
    Value<int?> postsCount = const Value.absent(),
    Value<int?> chartsCount = const Value.absent(),
    Value<int?> channelsCount = const Value.absent(),
    Value<String?> chartTitle = const Value.absent(),
    Value<String?> birthday = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
    Value<String?> accessToken = const Value.absent(),
    Value<String?> refreshToken = const Value.absent(),
  }) => User(
    id: id ?? this.id,
    username: username.present ? username.value : this.username,
    displayName: displayName.present ? displayName.value : this.displayName,
    profileImageUrl: profileImageUrl.present
        ? profileImageUrl.value
        : this.profileImageUrl,
    bio: bio.present ? bio.value : this.bio,
    title: title.present ? title.value : this.title,
    isVerified: isVerified.present ? isVerified.value : this.isVerified,
    followersCount: followersCount.present
        ? followersCount.value
        : this.followersCount,
    followingCount: followingCount.present
        ? followingCount.value
        : this.followingCount,
    postsCount: postsCount.present ? postsCount.value : this.postsCount,
    chartsCount: chartsCount.present ? chartsCount.value : this.chartsCount,
    channelsCount: channelsCount.present
        ? channelsCount.value
        : this.channelsCount,
    chartTitle: chartTitle.present ? chartTitle.value : this.chartTitle,
    birthday: birthday.present ? birthday.value : this.birthday,
    gender: gender.present ? gender.value : this.gender,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    accessToken: accessToken.present ? accessToken.value : this.accessToken,
    refreshToken: refreshToken.present ? refreshToken.value : this.refreshToken,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      profileImageUrl: data.profileImageUrl.present
          ? data.profileImageUrl.value
          : this.profileImageUrl,
      bio: data.bio.present ? data.bio.value : this.bio,
      title: data.title.present ? data.title.value : this.title,
      isVerified: data.isVerified.present
          ? data.isVerified.value
          : this.isVerified,
      followersCount: data.followersCount.present
          ? data.followersCount.value
          : this.followersCount,
      followingCount: data.followingCount.present
          ? data.followingCount.value
          : this.followingCount,
      postsCount: data.postsCount.present
          ? data.postsCount.value
          : this.postsCount,
      chartsCount: data.chartsCount.present
          ? data.chartsCount.value
          : this.chartsCount,
      channelsCount: data.channelsCount.present
          ? data.channelsCount.value
          : this.channelsCount,
      chartTitle: data.chartTitle.present
          ? data.chartTitle.value
          : this.chartTitle,
      birthday: data.birthday.present ? data.birthday.value : this.birthday,
      gender: data.gender.present ? data.gender.value : this.gender,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      accessToken: data.accessToken.present
          ? data.accessToken.value
          : this.accessToken,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('bio: $bio, ')
          ..write('title: $title, ')
          ..write('isVerified: $isVerified, ')
          ..write('followersCount: $followersCount, ')
          ..write('followingCount: $followingCount, ')
          ..write('postsCount: $postsCount, ')
          ..write('chartsCount: $chartsCount, ')
          ..write('channelsCount: $channelsCount, ')
          ..write('chartTitle: $chartTitle, ')
          ..write('birthday: $birthday, ')
          ..write('gender: $gender, ')
          ..write('createdAt: $createdAt, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    displayName,
    profileImageUrl,
    bio,
    title,
    isVerified,
    followersCount,
    followingCount,
    postsCount,
    chartsCount,
    channelsCount,
    chartTitle,
    birthday,
    gender,
    createdAt,
    accessToken,
    refreshToken,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.profileImageUrl == this.profileImageUrl &&
          other.bio == this.bio &&
          other.title == this.title &&
          other.isVerified == this.isVerified &&
          other.followersCount == this.followersCount &&
          other.followingCount == this.followingCount &&
          other.postsCount == this.postsCount &&
          other.chartsCount == this.chartsCount &&
          other.channelsCount == this.channelsCount &&
          other.chartTitle == this.chartTitle &&
          other.birthday == this.birthday &&
          other.gender == this.gender &&
          other.createdAt == this.createdAt &&
          other.accessToken == this.accessToken &&
          other.refreshToken == this.refreshToken);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String?> username;
  final Value<String?> displayName;
  final Value<String?> profileImageUrl;
  final Value<String?> bio;
  final Value<String?> title;
  final Value<int?> isVerified;
  final Value<int?> followersCount;
  final Value<int?> followingCount;
  final Value<int?> postsCount;
  final Value<int?> chartsCount;
  final Value<int?> channelsCount;
  final Value<String?> chartTitle;
  final Value<String?> birthday;
  final Value<String?> gender;
  final Value<String?> createdAt;
  final Value<String?> accessToken;
  final Value<String?> refreshToken;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.bio = const Value.absent(),
    this.title = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.followersCount = const Value.absent(),
    this.followingCount = const Value.absent(),
    this.postsCount = const Value.absent(),
    this.chartsCount = const Value.absent(),
    this.channelsCount = const Value.absent(),
    this.chartTitle = const Value.absent(),
    this.birthday = const Value.absent(),
    this.gender = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.bio = const Value.absent(),
    this.title = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.followersCount = const Value.absent(),
    this.followingCount = const Value.absent(),
    this.postsCount = const Value.absent(),
    this.chartsCount = const Value.absent(),
    this.channelsCount = const Value.absent(),
    this.chartTitle = const Value.absent(),
    this.birthday = const Value.absent(),
    this.gender = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? profileImageUrl,
    Expression<String>? bio,
    Expression<String>? title,
    Expression<int>? isVerified,
    Expression<int>? followersCount,
    Expression<int>? followingCount,
    Expression<int>? postsCount,
    Expression<int>? chartsCount,
    Expression<int>? channelsCount,
    Expression<String>? chartTitle,
    Expression<String>? birthday,
    Expression<String>? gender,
    Expression<String>? createdAt,
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      if (bio != null) 'bio': bio,
      if (title != null) 'title': title,
      if (isVerified != null) 'is_verified': isVerified,
      if (followersCount != null) 'followers_count': followersCount,
      if (followingCount != null) 'following_count': followingCount,
      if (postsCount != null) 'posts_count': postsCount,
      if (chartsCount != null) 'ChartsCount': chartsCount,
      if (channelsCount != null) 'channelsCount': channelsCount,
      if (chartTitle != null) 'ChartTitle': chartTitle,
      if (birthday != null) 'birthday': birthday,
      if (gender != null) 'gender': gender,
      if (createdAt != null) 'created_at': createdAt,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String?>? username,
    Value<String?>? displayName,
    Value<String?>? profileImageUrl,
    Value<String?>? bio,
    Value<String?>? title,
    Value<int?>? isVerified,
    Value<int?>? followersCount,
    Value<int?>? followingCount,
    Value<int?>? postsCount,
    Value<int?>? chartsCount,
    Value<int?>? channelsCount,
    Value<String?>? chartTitle,
    Value<String?>? birthday,
    Value<String?>? gender,
    Value<String?>? createdAt,
    Value<String?>? accessToken,
    Value<String?>? refreshToken,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      title: title ?? this.title,
      isVerified: isVerified ?? this.isVerified,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      chartsCount: chartsCount ?? this.chartsCount,
      channelsCount: channelsCount ?? this.channelsCount,
      chartTitle: chartTitle ?? this.chartTitle,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (profileImageUrl.present) {
      map['profile_image_url'] = Variable<String>(profileImageUrl.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<int>(isVerified.value);
    }
    if (followersCount.present) {
      map['followers_count'] = Variable<int>(followersCount.value);
    }
    if (followingCount.present) {
      map['following_count'] = Variable<int>(followingCount.value);
    }
    if (postsCount.present) {
      map['posts_count'] = Variable<int>(postsCount.value);
    }
    if (chartsCount.present) {
      map['ChartsCount'] = Variable<int>(chartsCount.value);
    }
    if (channelsCount.present) {
      map['channelsCount'] = Variable<int>(channelsCount.value);
    }
    if (chartTitle.present) {
      map['ChartTitle'] = Variable<String>(chartTitle.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<String>(birthday.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('bio: $bio, ')
          ..write('title: $title, ')
          ..write('isVerified: $isVerified, ')
          ..write('followersCount: $followersCount, ')
          ..write('followingCount: $followingCount, ')
          ..write('postsCount: $postsCount, ')
          ..write('chartsCount: $chartsCount, ')
          ..write('channelsCount: $channelsCount, ')
          ..write('chartTitle: $chartTitle, ')
          ..write('birthday: $birthday, ')
          ..write('gender: $gender, ')
          ..write('createdAt: $createdAt, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostsTable extends Posts with TableInfo<$PostsTable, Post> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userProfileImageUrlMeta =
      const VerificationMeta('userProfileImageUrl');
  @override
  late final GeneratedColumn<String> userProfileImageUrl =
      GeneratedColumn<String>(
        'user_profile_image_url',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _channelNameMeta = const VerificationMeta(
    'channelName',
  );
  @override
  late final GeneratedColumn<String> channelName = GeneratedColumn<String>(
    'channel_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _videoUrlMeta = const VerificationMeta(
    'videoUrl',
  );
  @override
  late final GeneratedColumn<String> videoUrl = GeneratedColumn<String>(
    'video_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _videoUrlsMeta = const VerificationMeta(
    'videoUrls',
  );
  @override
  late final GeneratedColumn<String> videoUrls = GeneratedColumn<String>(
    'video_urls',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sdVideoUrlMeta = const VerificationMeta(
    'sdVideoUrl',
  );
  @override
  late final GeneratedColumn<String> sdVideoUrl = GeneratedColumn<String>(
    'sd_video_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlsMeta = const VerificationMeta(
    'imageUrls',
  );
  @override
  late final GeneratedColumn<String> imageUrls = GeneratedColumn<String>(
    'image_urls',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailUrlsMeta = const VerificationMeta(
    'thumbnailUrls',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrls = GeneratedColumn<String>(
    'thumbnail_urls',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isVideoMeta = const VerificationMeta(
    'isVideo',
  );
  @override
  late final GeneratedColumn<int> isVideo = GeneratedColumn<int>(
    'is_video',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAudioMeta = const VerificationMeta(
    'isAudio',
  );
  @override
  late final GeneratedColumn<int> isAudio = GeneratedColumn<int>(
    'is_audio',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _folderNameMeta = const VerificationMeta(
    'folderName',
  );
  @override
  late final GeneratedColumn<String> folderName = GeneratedColumn<String>(
    'folder_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('public_posts'),
  );
  static const VerificationMeta _aspectRatioMeta = const VerificationMeta(
    'aspectRatio',
  );
  @override
  late final GeneratedColumn<double> aspectRatio = GeneratedColumn<double>(
    'aspect_ratio',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _likesMeta = const VerificationMeta('likes');
  @override
  late final GeneratedColumn<int> likes = GeneratedColumn<int>(
    'likes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _commentsMeta = const VerificationMeta(
    'comments',
  );
  @override
  late final GeneratedColumn<int> comments = GeneratedColumn<int>(
    'comments',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeAgoMeta = const VerificationMeta(
    'timeAgo',
  );
  @override
  late final GeneratedColumn<String> timeAgo = GeneratedColumn<String>(
    'time_ago',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'createdAt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sharesMeta = const VerificationMeta('shares');
  @override
  late final GeneratedColumn<int> shares = GeneratedColumn<int>(
    'shares',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isLikedMeta = const VerificationMeta(
    'isLiked',
  );
  @override
  late final GeneratedColumn<int> isLiked = GeneratedColumn<int>(
    'is_liked',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chartedCountMeta = const VerificationMeta(
    'chartedCount',
  );
  @override
  late final GeneratedColumn<int> chartedCount = GeneratedColumn<int>(
    'charted_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localFileCacheMeta = const VerificationMeta(
    'localFileCache',
  );
  @override
  late final GeneratedColumn<String> localFileCache = GeneratedColumn<String>(
    'local_file_cache',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPendingMeta = const VerificationMeta(
    'isPending',
  );
  @override
  late final GeneratedColumn<int> isPending = GeneratedColumn<int>(
    'is_pending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _linkedPostIdMeta = const VerificationMeta(
    'linkedPostId',
  );
  @override
  late final GeneratedColumn<String> linkedPostId = GeneratedColumn<String>(
    'linked_post_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedAuthorUsernameMeta =
      const VerificationMeta('linkedAuthorUsername');
  @override
  late final GeneratedColumn<String> linkedAuthorUsername =
      GeneratedColumn<String>(
        'linked_author_username',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _linkedCaptionMeta = const VerificationMeta(
    'linkedCaption',
  );
  @override
  late final GeneratedColumn<String> linkedCaption = GeneratedColumn<String>(
    'linked_caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedChannelIdMeta = const VerificationMeta(
    'linkedChannelId',
  );
  @override
  late final GeneratedColumn<String> linkedChannelId = GeneratedColumn<String>(
    'linked_channel_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postTypeMeta = const VerificationMeta(
    'postType',
  );
  @override
  late final GeneratedColumn<String> postType = GeneratedColumn<String>(
    'post_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('post'),
  );
  static const VerificationMeta _parentPostIdMeta = const VerificationMeta(
    'parentPostId',
  );
  @override
  late final GeneratedColumn<String> parentPostId = GeneratedColumn<String>(
    'parent_post_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkChainMeta = const VerificationMeta(
    'linkChain',
  );
  @override
  late final GeneratedColumn<String> linkChain = GeneratedColumn<String>(
    'link_chain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _linkDepthMeta = const VerificationMeta(
    'linkDepth',
  );
  @override
  late final GeneratedColumn<int> linkDepth = GeneratedColumn<int>(
    'link_depth',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPublicMeta = const VerificationMeta(
    'isPublic',
  );
  @override
  late final GeneratedColumn<int> isPublic = GeneratedColumn<int>(
    'is_public',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _allowCommentsMeta = const VerificationMeta(
    'allowComments',
  );
  @override
  late final GeneratedColumn<int> allowComments = GeneratedColumn<int>(
    'allow_comments',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _taggerNameMeta = const VerificationMeta(
    'taggerName',
  );
  @override
  late final GeneratedColumn<String> taggerName = GeneratedColumn<String>(
    'tagger_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taggerAvatarMeta = const VerificationMeta(
    'taggerAvatar',
  );
  @override
  late final GeneratedColumn<String> taggerAvatar = GeneratedColumn<String>(
    'tagger_avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceChannelNameMeta = const VerificationMeta(
    'sourceChannelName',
  );
  @override
  late final GeneratedColumn<String> sourceChannelName =
      GeneratedColumn<String>(
        'source_channel_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceChannelAvatarMeta =
      const VerificationMeta('sourceChannelAvatar');
  @override
  late final GeneratedColumn<String> sourceChannelAvatar =
      GeneratedColumn<String>(
        'source_channel_avatar',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _tagsCountMeta = const VerificationMeta(
    'tagsCount',
  );
  @override
  late final GeneratedColumn<int> tagsCount = GeneratedColumn<int>(
    'tags_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    authorId,
    username,
    userProfileImageUrl,
    channelName,
    channelId,
    caption,
    videoUrl,
    videoUrls,
    audioUrl,
    sdVideoUrl,
    imageUrls,
    thumbnailUrls,
    isVideo,
    isAudio,
    folderName,
    aspectRatio,
    likes,
    comments,
    timeAgo,
    createdAt,
    shares,
    isLiked,
    chartedCount,
    localFileCache,
    isPending,
    linkedPostId,
    linkedAuthorUsername,
    linkedCaption,
    linkedChannelId,
    postType,
    parentPostId,
    linkChain,
    linkDepth,
    isPublic,
    allowComments,
    taggerName,
    taggerAvatar,
    sourceChannelName,
    sourceChannelAvatar,
    tagsCount,
    metadata,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'posts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Post> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('user_profile_image_url')) {
      context.handle(
        _userProfileImageUrlMeta,
        userProfileImageUrl.isAcceptableOrUnknown(
          data['user_profile_image_url']!,
          _userProfileImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('channel_name')) {
      context.handle(
        _channelNameMeta,
        channelName.isAcceptableOrUnknown(
          data['channel_name']!,
          _channelNameMeta,
        ),
      );
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('video_url')) {
      context.handle(
        _videoUrlMeta,
        videoUrl.isAcceptableOrUnknown(data['video_url']!, _videoUrlMeta),
      );
    }
    if (data.containsKey('video_urls')) {
      context.handle(
        _videoUrlsMeta,
        videoUrls.isAcceptableOrUnknown(data['video_urls']!, _videoUrlsMeta),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('sd_video_url')) {
      context.handle(
        _sdVideoUrlMeta,
        sdVideoUrl.isAcceptableOrUnknown(
          data['sd_video_url']!,
          _sdVideoUrlMeta,
        ),
      );
    }
    if (data.containsKey('image_urls')) {
      context.handle(
        _imageUrlsMeta,
        imageUrls.isAcceptableOrUnknown(data['image_urls']!, _imageUrlsMeta),
      );
    }
    if (data.containsKey('thumbnail_urls')) {
      context.handle(
        _thumbnailUrlsMeta,
        thumbnailUrls.isAcceptableOrUnknown(
          data['thumbnail_urls']!,
          _thumbnailUrlsMeta,
        ),
      );
    }
    if (data.containsKey('is_video')) {
      context.handle(
        _isVideoMeta,
        isVideo.isAcceptableOrUnknown(data['is_video']!, _isVideoMeta),
      );
    }
    if (data.containsKey('is_audio')) {
      context.handle(
        _isAudioMeta,
        isAudio.isAcceptableOrUnknown(data['is_audio']!, _isAudioMeta),
      );
    }
    if (data.containsKey('folder_name')) {
      context.handle(
        _folderNameMeta,
        folderName.isAcceptableOrUnknown(data['folder_name']!, _folderNameMeta),
      );
    }
    if (data.containsKey('aspect_ratio')) {
      context.handle(
        _aspectRatioMeta,
        aspectRatio.isAcceptableOrUnknown(
          data['aspect_ratio']!,
          _aspectRatioMeta,
        ),
      );
    }
    if (data.containsKey('likes')) {
      context.handle(
        _likesMeta,
        likes.isAcceptableOrUnknown(data['likes']!, _likesMeta),
      );
    }
    if (data.containsKey('comments')) {
      context.handle(
        _commentsMeta,
        comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta),
      );
    }
    if (data.containsKey('time_ago')) {
      context.handle(
        _timeAgoMeta,
        timeAgo.isAcceptableOrUnknown(data['time_ago']!, _timeAgoMeta),
      );
    }
    if (data.containsKey('createdAt')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['createdAt']!, _createdAtMeta),
      );
    }
    if (data.containsKey('shares')) {
      context.handle(
        _sharesMeta,
        shares.isAcceptableOrUnknown(data['shares']!, _sharesMeta),
      );
    }
    if (data.containsKey('is_liked')) {
      context.handle(
        _isLikedMeta,
        isLiked.isAcceptableOrUnknown(data['is_liked']!, _isLikedMeta),
      );
    }
    if (data.containsKey('charted_count')) {
      context.handle(
        _chartedCountMeta,
        chartedCount.isAcceptableOrUnknown(
          data['charted_count']!,
          _chartedCountMeta,
        ),
      );
    }
    if (data.containsKey('local_file_cache')) {
      context.handle(
        _localFileCacheMeta,
        localFileCache.isAcceptableOrUnknown(
          data['local_file_cache']!,
          _localFileCacheMeta,
        ),
      );
    }
    if (data.containsKey('is_pending')) {
      context.handle(
        _isPendingMeta,
        isPending.isAcceptableOrUnknown(data['is_pending']!, _isPendingMeta),
      );
    }
    if (data.containsKey('linked_post_id')) {
      context.handle(
        _linkedPostIdMeta,
        linkedPostId.isAcceptableOrUnknown(
          data['linked_post_id']!,
          _linkedPostIdMeta,
        ),
      );
    }
    if (data.containsKey('linked_author_username')) {
      context.handle(
        _linkedAuthorUsernameMeta,
        linkedAuthorUsername.isAcceptableOrUnknown(
          data['linked_author_username']!,
          _linkedAuthorUsernameMeta,
        ),
      );
    }
    if (data.containsKey('linked_caption')) {
      context.handle(
        _linkedCaptionMeta,
        linkedCaption.isAcceptableOrUnknown(
          data['linked_caption']!,
          _linkedCaptionMeta,
        ),
      );
    }
    if (data.containsKey('linked_channel_id')) {
      context.handle(
        _linkedChannelIdMeta,
        linkedChannelId.isAcceptableOrUnknown(
          data['linked_channel_id']!,
          _linkedChannelIdMeta,
        ),
      );
    }
    if (data.containsKey('post_type')) {
      context.handle(
        _postTypeMeta,
        postType.isAcceptableOrUnknown(data['post_type']!, _postTypeMeta),
      );
    }
    if (data.containsKey('parent_post_id')) {
      context.handle(
        _parentPostIdMeta,
        parentPostId.isAcceptableOrUnknown(
          data['parent_post_id']!,
          _parentPostIdMeta,
        ),
      );
    }
    if (data.containsKey('link_chain')) {
      context.handle(
        _linkChainMeta,
        linkChain.isAcceptableOrUnknown(data['link_chain']!, _linkChainMeta),
      );
    }
    if (data.containsKey('link_depth')) {
      context.handle(
        _linkDepthMeta,
        linkDepth.isAcceptableOrUnknown(data['link_depth']!, _linkDepthMeta),
      );
    }
    if (data.containsKey('is_public')) {
      context.handle(
        _isPublicMeta,
        isPublic.isAcceptableOrUnknown(data['is_public']!, _isPublicMeta),
      );
    }
    if (data.containsKey('allow_comments')) {
      context.handle(
        _allowCommentsMeta,
        allowComments.isAcceptableOrUnknown(
          data['allow_comments']!,
          _allowCommentsMeta,
        ),
      );
    }
    if (data.containsKey('tagger_name')) {
      context.handle(
        _taggerNameMeta,
        taggerName.isAcceptableOrUnknown(data['tagger_name']!, _taggerNameMeta),
      );
    }
    if (data.containsKey('tagger_avatar')) {
      context.handle(
        _taggerAvatarMeta,
        taggerAvatar.isAcceptableOrUnknown(
          data['tagger_avatar']!,
          _taggerAvatarMeta,
        ),
      );
    }
    if (data.containsKey('source_channel_name')) {
      context.handle(
        _sourceChannelNameMeta,
        sourceChannelName.isAcceptableOrUnknown(
          data['source_channel_name']!,
          _sourceChannelNameMeta,
        ),
      );
    }
    if (data.containsKey('source_channel_avatar')) {
      context.handle(
        _sourceChannelAvatarMeta,
        sourceChannelAvatar.isAcceptableOrUnknown(
          data['source_channel_avatar']!,
          _sourceChannelAvatarMeta,
        ),
      );
    }
    if (data.containsKey('tags_count')) {
      context.handle(
        _tagsCountMeta,
        tagsCount.isAcceptableOrUnknown(data['tags_count']!, _tagsCountMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Post map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Post(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      ),
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      userProfileImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_profile_image_url'],
      ),
      channelName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_name'],
      ),
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      ),
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      videoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_url'],
      ),
      videoUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_urls'],
      )!,
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
      sdVideoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sd_video_url'],
      ),
      imageUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_urls'],
      ),
      thumbnailUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_urls'],
      ),
      isVideo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_video'],
      ),
      isAudio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_audio'],
      ),
      folderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_name'],
      )!,
      aspectRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}aspect_ratio'],
      ),
      likes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}likes'],
      ),
      comments: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}comments'],
      ),
      timeAgo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_ago'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}createdAt'],
      ),
      shares: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shares'],
      ),
      isLiked: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_liked'],
      ),
      chartedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}charted_count'],
      ),
      localFileCache: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_file_cache'],
      ),
      isPending: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_pending'],
      )!,
      linkedPostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_post_id'],
      ),
      linkedAuthorUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_author_username'],
      ),
      linkedCaption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_caption'],
      ),
      linkedChannelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_channel_id'],
      ),
      postType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}post_type'],
      )!,
      parentPostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_post_id'],
      ),
      linkChain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link_chain'],
      )!,
      linkDepth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}link_depth'],
      )!,
      isPublic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_public'],
      )!,
      allowComments: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allow_comments'],
      )!,
      taggerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tagger_name'],
      ),
      taggerAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tagger_avatar'],
      ),
      sourceChannelName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_channel_name'],
      ),
      sourceChannelAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_channel_avatar'],
      ),
      tagsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tags_count'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
    );
  }

  @override
  $PostsTable createAlias(String alias) {
    return $PostsTable(attachedDatabase, alias);
  }
}

class Post extends DataClass implements Insertable<Post> {
  final String id;
  final String? authorId;
  final String? username;
  final String? userProfileImageUrl;
  final String? channelName;
  final String? channelId;
  final String? caption;
  final String? videoUrl;
  final String videoUrls;
  final String? audioUrl;
  final String? sdVideoUrl;
  final String? imageUrls;
  final String? thumbnailUrls;
  final int? isVideo;
  final int? isAudio;
  final String folderName;
  final double? aspectRatio;
  final int? likes;
  final int? comments;
  final String? timeAgo;
  final String? createdAt;
  final int? shares;
  final int? isLiked;
  final int? chartedCount;
  final String? localFileCache;
  final int isPending;
  final String? linkedPostId;
  final String? linkedAuthorUsername;
  final String? linkedCaption;
  final String? linkedChannelId;
  final String postType;
  final String? parentPostId;
  final String linkChain;
  final int linkDepth;
  final int isPublic;
  final int allowComments;
  final String? taggerName;
  final String? taggerAvatar;
  final String? sourceChannelName;
  final String? sourceChannelAvatar;
  final int tagsCount;
  final String? metadata;
  const Post({
    required this.id,
    this.authorId,
    this.username,
    this.userProfileImageUrl,
    this.channelName,
    this.channelId,
    this.caption,
    this.videoUrl,
    required this.videoUrls,
    this.audioUrl,
    this.sdVideoUrl,
    this.imageUrls,
    this.thumbnailUrls,
    this.isVideo,
    this.isAudio,
    required this.folderName,
    this.aspectRatio,
    this.likes,
    this.comments,
    this.timeAgo,
    this.createdAt,
    this.shares,
    this.isLiked,
    this.chartedCount,
    this.localFileCache,
    required this.isPending,
    this.linkedPostId,
    this.linkedAuthorUsername,
    this.linkedCaption,
    this.linkedChannelId,
    required this.postType,
    this.parentPostId,
    required this.linkChain,
    required this.linkDepth,
    required this.isPublic,
    required this.allowComments,
    this.taggerName,
    this.taggerAvatar,
    this.sourceChannelName,
    this.sourceChannelAvatar,
    required this.tagsCount,
    this.metadata,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || authorId != null) {
      map['author_id'] = Variable<String>(authorId);
    }
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || userProfileImageUrl != null) {
      map['user_profile_image_url'] = Variable<String>(userProfileImageUrl);
    }
    if (!nullToAbsent || channelName != null) {
      map['channel_name'] = Variable<String>(channelName);
    }
    if (!nullToAbsent || channelId != null) {
      map['channel_id'] = Variable<String>(channelId);
    }
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    if (!nullToAbsent || videoUrl != null) {
      map['video_url'] = Variable<String>(videoUrl);
    }
    map['video_urls'] = Variable<String>(videoUrls);
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    if (!nullToAbsent || sdVideoUrl != null) {
      map['sd_video_url'] = Variable<String>(sdVideoUrl);
    }
    if (!nullToAbsent || imageUrls != null) {
      map['image_urls'] = Variable<String>(imageUrls);
    }
    if (!nullToAbsent || thumbnailUrls != null) {
      map['thumbnail_urls'] = Variable<String>(thumbnailUrls);
    }
    if (!nullToAbsent || isVideo != null) {
      map['is_video'] = Variable<int>(isVideo);
    }
    if (!nullToAbsent || isAudio != null) {
      map['is_audio'] = Variable<int>(isAudio);
    }
    map['folder_name'] = Variable<String>(folderName);
    if (!nullToAbsent || aspectRatio != null) {
      map['aspect_ratio'] = Variable<double>(aspectRatio);
    }
    if (!nullToAbsent || likes != null) {
      map['likes'] = Variable<int>(likes);
    }
    if (!nullToAbsent || comments != null) {
      map['comments'] = Variable<int>(comments);
    }
    if (!nullToAbsent || timeAgo != null) {
      map['time_ago'] = Variable<String>(timeAgo);
    }
    if (!nullToAbsent || createdAt != null) {
      map['createdAt'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || shares != null) {
      map['shares'] = Variable<int>(shares);
    }
    if (!nullToAbsent || isLiked != null) {
      map['is_liked'] = Variable<int>(isLiked);
    }
    if (!nullToAbsent || chartedCount != null) {
      map['charted_count'] = Variable<int>(chartedCount);
    }
    if (!nullToAbsent || localFileCache != null) {
      map['local_file_cache'] = Variable<String>(localFileCache);
    }
    map['is_pending'] = Variable<int>(isPending);
    if (!nullToAbsent || linkedPostId != null) {
      map['linked_post_id'] = Variable<String>(linkedPostId);
    }
    if (!nullToAbsent || linkedAuthorUsername != null) {
      map['linked_author_username'] = Variable<String>(linkedAuthorUsername);
    }
    if (!nullToAbsent || linkedCaption != null) {
      map['linked_caption'] = Variable<String>(linkedCaption);
    }
    if (!nullToAbsent || linkedChannelId != null) {
      map['linked_channel_id'] = Variable<String>(linkedChannelId);
    }
    map['post_type'] = Variable<String>(postType);
    if (!nullToAbsent || parentPostId != null) {
      map['parent_post_id'] = Variable<String>(parentPostId);
    }
    map['link_chain'] = Variable<String>(linkChain);
    map['link_depth'] = Variable<int>(linkDepth);
    map['is_public'] = Variable<int>(isPublic);
    map['allow_comments'] = Variable<int>(allowComments);
    if (!nullToAbsent || taggerName != null) {
      map['tagger_name'] = Variable<String>(taggerName);
    }
    if (!nullToAbsent || taggerAvatar != null) {
      map['tagger_avatar'] = Variable<String>(taggerAvatar);
    }
    if (!nullToAbsent || sourceChannelName != null) {
      map['source_channel_name'] = Variable<String>(sourceChannelName);
    }
    if (!nullToAbsent || sourceChannelAvatar != null) {
      map['source_channel_avatar'] = Variable<String>(sourceChannelAvatar);
    }
    map['tags_count'] = Variable<int>(tagsCount);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    return map;
  }

  PostsCompanion toCompanion(bool nullToAbsent) {
    return PostsCompanion(
      id: Value(id),
      authorId: authorId == null && nullToAbsent
          ? const Value.absent()
          : Value(authorId),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      userProfileImageUrl: userProfileImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(userProfileImageUrl),
      channelName: channelName == null && nullToAbsent
          ? const Value.absent()
          : Value(channelName),
      channelId: channelId == null && nullToAbsent
          ? const Value.absent()
          : Value(channelId),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      videoUrl: videoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(videoUrl),
      videoUrls: Value(videoUrls),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      sdVideoUrl: sdVideoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sdVideoUrl),
      imageUrls: imageUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrls),
      thumbnailUrls: thumbnailUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrls),
      isVideo: isVideo == null && nullToAbsent
          ? const Value.absent()
          : Value(isVideo),
      isAudio: isAudio == null && nullToAbsent
          ? const Value.absent()
          : Value(isAudio),
      folderName: Value(folderName),
      aspectRatio: aspectRatio == null && nullToAbsent
          ? const Value.absent()
          : Value(aspectRatio),
      likes: likes == null && nullToAbsent
          ? const Value.absent()
          : Value(likes),
      comments: comments == null && nullToAbsent
          ? const Value.absent()
          : Value(comments),
      timeAgo: timeAgo == null && nullToAbsent
          ? const Value.absent()
          : Value(timeAgo),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      shares: shares == null && nullToAbsent
          ? const Value.absent()
          : Value(shares),
      isLiked: isLiked == null && nullToAbsent
          ? const Value.absent()
          : Value(isLiked),
      chartedCount: chartedCount == null && nullToAbsent
          ? const Value.absent()
          : Value(chartedCount),
      localFileCache: localFileCache == null && nullToAbsent
          ? const Value.absent()
          : Value(localFileCache),
      isPending: Value(isPending),
      linkedPostId: linkedPostId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedPostId),
      linkedAuthorUsername: linkedAuthorUsername == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedAuthorUsername),
      linkedCaption: linkedCaption == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedCaption),
      linkedChannelId: linkedChannelId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedChannelId),
      postType: Value(postType),
      parentPostId: parentPostId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentPostId),
      linkChain: Value(linkChain),
      linkDepth: Value(linkDepth),
      isPublic: Value(isPublic),
      allowComments: Value(allowComments),
      taggerName: taggerName == null && nullToAbsent
          ? const Value.absent()
          : Value(taggerName),
      taggerAvatar: taggerAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(taggerAvatar),
      sourceChannelName: sourceChannelName == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceChannelName),
      sourceChannelAvatar: sourceChannelAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceChannelAvatar),
      tagsCount: Value(tagsCount),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory Post.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Post(
      id: serializer.fromJson<String>(json['id']),
      authorId: serializer.fromJson<String?>(json['authorId']),
      username: serializer.fromJson<String?>(json['username']),
      userProfileImageUrl: serializer.fromJson<String?>(
        json['userProfileImageUrl'],
      ),
      channelName: serializer.fromJson<String?>(json['channelName']),
      channelId: serializer.fromJson<String?>(json['channelId']),
      caption: serializer.fromJson<String?>(json['caption']),
      videoUrl: serializer.fromJson<String?>(json['videoUrl']),
      videoUrls: serializer.fromJson<String>(json['videoUrls']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      sdVideoUrl: serializer.fromJson<String?>(json['sdVideoUrl']),
      imageUrls: serializer.fromJson<String?>(json['imageUrls']),
      thumbnailUrls: serializer.fromJson<String?>(json['thumbnailUrls']),
      isVideo: serializer.fromJson<int?>(json['isVideo']),
      isAudio: serializer.fromJson<int?>(json['isAudio']),
      folderName: serializer.fromJson<String>(json['folderName']),
      aspectRatio: serializer.fromJson<double?>(json['aspectRatio']),
      likes: serializer.fromJson<int?>(json['likes']),
      comments: serializer.fromJson<int?>(json['comments']),
      timeAgo: serializer.fromJson<String?>(json['timeAgo']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      shares: serializer.fromJson<int?>(json['shares']),
      isLiked: serializer.fromJson<int?>(json['isLiked']),
      chartedCount: serializer.fromJson<int?>(json['chartedCount']),
      localFileCache: serializer.fromJson<String?>(json['localFileCache']),
      isPending: serializer.fromJson<int>(json['isPending']),
      linkedPostId: serializer.fromJson<String?>(json['linkedPostId']),
      linkedAuthorUsername: serializer.fromJson<String?>(
        json['linkedAuthorUsername'],
      ),
      linkedCaption: serializer.fromJson<String?>(json['linkedCaption']),
      linkedChannelId: serializer.fromJson<String?>(json['linkedChannelId']),
      postType: serializer.fromJson<String>(json['postType']),
      parentPostId: serializer.fromJson<String?>(json['parentPostId']),
      linkChain: serializer.fromJson<String>(json['linkChain']),
      linkDepth: serializer.fromJson<int>(json['linkDepth']),
      isPublic: serializer.fromJson<int>(json['isPublic']),
      allowComments: serializer.fromJson<int>(json['allowComments']),
      taggerName: serializer.fromJson<String?>(json['taggerName']),
      taggerAvatar: serializer.fromJson<String?>(json['taggerAvatar']),
      sourceChannelName: serializer.fromJson<String?>(
        json['sourceChannelName'],
      ),
      sourceChannelAvatar: serializer.fromJson<String?>(
        json['sourceChannelAvatar'],
      ),
      tagsCount: serializer.fromJson<int>(json['tagsCount']),
      metadata: serializer.fromJson<String?>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'authorId': serializer.toJson<String?>(authorId),
      'username': serializer.toJson<String?>(username),
      'userProfileImageUrl': serializer.toJson<String?>(userProfileImageUrl),
      'channelName': serializer.toJson<String?>(channelName),
      'channelId': serializer.toJson<String?>(channelId),
      'caption': serializer.toJson<String?>(caption),
      'videoUrl': serializer.toJson<String?>(videoUrl),
      'videoUrls': serializer.toJson<String>(videoUrls),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'sdVideoUrl': serializer.toJson<String?>(sdVideoUrl),
      'imageUrls': serializer.toJson<String?>(imageUrls),
      'thumbnailUrls': serializer.toJson<String?>(thumbnailUrls),
      'isVideo': serializer.toJson<int?>(isVideo),
      'isAudio': serializer.toJson<int?>(isAudio),
      'folderName': serializer.toJson<String>(folderName),
      'aspectRatio': serializer.toJson<double?>(aspectRatio),
      'likes': serializer.toJson<int?>(likes),
      'comments': serializer.toJson<int?>(comments),
      'timeAgo': serializer.toJson<String?>(timeAgo),
      'createdAt': serializer.toJson<String?>(createdAt),
      'shares': serializer.toJson<int?>(shares),
      'isLiked': serializer.toJson<int?>(isLiked),
      'chartedCount': serializer.toJson<int?>(chartedCount),
      'localFileCache': serializer.toJson<String?>(localFileCache),
      'isPending': serializer.toJson<int>(isPending),
      'linkedPostId': serializer.toJson<String?>(linkedPostId),
      'linkedAuthorUsername': serializer.toJson<String?>(linkedAuthorUsername),
      'linkedCaption': serializer.toJson<String?>(linkedCaption),
      'linkedChannelId': serializer.toJson<String?>(linkedChannelId),
      'postType': serializer.toJson<String>(postType),
      'parentPostId': serializer.toJson<String?>(parentPostId),
      'linkChain': serializer.toJson<String>(linkChain),
      'linkDepth': serializer.toJson<int>(linkDepth),
      'isPublic': serializer.toJson<int>(isPublic),
      'allowComments': serializer.toJson<int>(allowComments),
      'taggerName': serializer.toJson<String?>(taggerName),
      'taggerAvatar': serializer.toJson<String?>(taggerAvatar),
      'sourceChannelName': serializer.toJson<String?>(sourceChannelName),
      'sourceChannelAvatar': serializer.toJson<String?>(sourceChannelAvatar),
      'tagsCount': serializer.toJson<int>(tagsCount),
      'metadata': serializer.toJson<String?>(metadata),
    };
  }

  Post copyWith({
    String? id,
    Value<String?> authorId = const Value.absent(),
    Value<String?> username = const Value.absent(),
    Value<String?> userProfileImageUrl = const Value.absent(),
    Value<String?> channelName = const Value.absent(),
    Value<String?> channelId = const Value.absent(),
    Value<String?> caption = const Value.absent(),
    Value<String?> videoUrl = const Value.absent(),
    String? videoUrls,
    Value<String?> audioUrl = const Value.absent(),
    Value<String?> sdVideoUrl = const Value.absent(),
    Value<String?> imageUrls = const Value.absent(),
    Value<String?> thumbnailUrls = const Value.absent(),
    Value<int?> isVideo = const Value.absent(),
    Value<int?> isAudio = const Value.absent(),
    String? folderName,
    Value<double?> aspectRatio = const Value.absent(),
    Value<int?> likes = const Value.absent(),
    Value<int?> comments = const Value.absent(),
    Value<String?> timeAgo = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
    Value<int?> shares = const Value.absent(),
    Value<int?> isLiked = const Value.absent(),
    Value<int?> chartedCount = const Value.absent(),
    Value<String?> localFileCache = const Value.absent(),
    int? isPending,
    Value<String?> linkedPostId = const Value.absent(),
    Value<String?> linkedAuthorUsername = const Value.absent(),
    Value<String?> linkedCaption = const Value.absent(),
    Value<String?> linkedChannelId = const Value.absent(),
    String? postType,
    Value<String?> parentPostId = const Value.absent(),
    String? linkChain,
    int? linkDepth,
    int? isPublic,
    int? allowComments,
    Value<String?> taggerName = const Value.absent(),
    Value<String?> taggerAvatar = const Value.absent(),
    Value<String?> sourceChannelName = const Value.absent(),
    Value<String?> sourceChannelAvatar = const Value.absent(),
    int? tagsCount,
    Value<String?> metadata = const Value.absent(),
  }) => Post(
    id: id ?? this.id,
    authorId: authorId.present ? authorId.value : this.authorId,
    username: username.present ? username.value : this.username,
    userProfileImageUrl: userProfileImageUrl.present
        ? userProfileImageUrl.value
        : this.userProfileImageUrl,
    channelName: channelName.present ? channelName.value : this.channelName,
    channelId: channelId.present ? channelId.value : this.channelId,
    caption: caption.present ? caption.value : this.caption,
    videoUrl: videoUrl.present ? videoUrl.value : this.videoUrl,
    videoUrls: videoUrls ?? this.videoUrls,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
    sdVideoUrl: sdVideoUrl.present ? sdVideoUrl.value : this.sdVideoUrl,
    imageUrls: imageUrls.present ? imageUrls.value : this.imageUrls,
    thumbnailUrls: thumbnailUrls.present
        ? thumbnailUrls.value
        : this.thumbnailUrls,
    isVideo: isVideo.present ? isVideo.value : this.isVideo,
    isAudio: isAudio.present ? isAudio.value : this.isAudio,
    folderName: folderName ?? this.folderName,
    aspectRatio: aspectRatio.present ? aspectRatio.value : this.aspectRatio,
    likes: likes.present ? likes.value : this.likes,
    comments: comments.present ? comments.value : this.comments,
    timeAgo: timeAgo.present ? timeAgo.value : this.timeAgo,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    shares: shares.present ? shares.value : this.shares,
    isLiked: isLiked.present ? isLiked.value : this.isLiked,
    chartedCount: chartedCount.present ? chartedCount.value : this.chartedCount,
    localFileCache: localFileCache.present
        ? localFileCache.value
        : this.localFileCache,
    isPending: isPending ?? this.isPending,
    linkedPostId: linkedPostId.present ? linkedPostId.value : this.linkedPostId,
    linkedAuthorUsername: linkedAuthorUsername.present
        ? linkedAuthorUsername.value
        : this.linkedAuthorUsername,
    linkedCaption: linkedCaption.present
        ? linkedCaption.value
        : this.linkedCaption,
    linkedChannelId: linkedChannelId.present
        ? linkedChannelId.value
        : this.linkedChannelId,
    postType: postType ?? this.postType,
    parentPostId: parentPostId.present ? parentPostId.value : this.parentPostId,
    linkChain: linkChain ?? this.linkChain,
    linkDepth: linkDepth ?? this.linkDepth,
    isPublic: isPublic ?? this.isPublic,
    allowComments: allowComments ?? this.allowComments,
    taggerName: taggerName.present ? taggerName.value : this.taggerName,
    taggerAvatar: taggerAvatar.present ? taggerAvatar.value : this.taggerAvatar,
    sourceChannelName: sourceChannelName.present
        ? sourceChannelName.value
        : this.sourceChannelName,
    sourceChannelAvatar: sourceChannelAvatar.present
        ? sourceChannelAvatar.value
        : this.sourceChannelAvatar,
    tagsCount: tagsCount ?? this.tagsCount,
    metadata: metadata.present ? metadata.value : this.metadata,
  );
  Post copyWithCompanion(PostsCompanion data) {
    return Post(
      id: data.id.present ? data.id.value : this.id,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      username: data.username.present ? data.username.value : this.username,
      userProfileImageUrl: data.userProfileImageUrl.present
          ? data.userProfileImageUrl.value
          : this.userProfileImageUrl,
      channelName: data.channelName.present
          ? data.channelName.value
          : this.channelName,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      caption: data.caption.present ? data.caption.value : this.caption,
      videoUrl: data.videoUrl.present ? data.videoUrl.value : this.videoUrl,
      videoUrls: data.videoUrls.present ? data.videoUrls.value : this.videoUrls,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      sdVideoUrl: data.sdVideoUrl.present
          ? data.sdVideoUrl.value
          : this.sdVideoUrl,
      imageUrls: data.imageUrls.present ? data.imageUrls.value : this.imageUrls,
      thumbnailUrls: data.thumbnailUrls.present
          ? data.thumbnailUrls.value
          : this.thumbnailUrls,
      isVideo: data.isVideo.present ? data.isVideo.value : this.isVideo,
      isAudio: data.isAudio.present ? data.isAudio.value : this.isAudio,
      folderName: data.folderName.present
          ? data.folderName.value
          : this.folderName,
      aspectRatio: data.aspectRatio.present
          ? data.aspectRatio.value
          : this.aspectRatio,
      likes: data.likes.present ? data.likes.value : this.likes,
      comments: data.comments.present ? data.comments.value : this.comments,
      timeAgo: data.timeAgo.present ? data.timeAgo.value : this.timeAgo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      shares: data.shares.present ? data.shares.value : this.shares,
      isLiked: data.isLiked.present ? data.isLiked.value : this.isLiked,
      chartedCount: data.chartedCount.present
          ? data.chartedCount.value
          : this.chartedCount,
      localFileCache: data.localFileCache.present
          ? data.localFileCache.value
          : this.localFileCache,
      isPending: data.isPending.present ? data.isPending.value : this.isPending,
      linkedPostId: data.linkedPostId.present
          ? data.linkedPostId.value
          : this.linkedPostId,
      linkedAuthorUsername: data.linkedAuthorUsername.present
          ? data.linkedAuthorUsername.value
          : this.linkedAuthorUsername,
      linkedCaption: data.linkedCaption.present
          ? data.linkedCaption.value
          : this.linkedCaption,
      linkedChannelId: data.linkedChannelId.present
          ? data.linkedChannelId.value
          : this.linkedChannelId,
      postType: data.postType.present ? data.postType.value : this.postType,
      parentPostId: data.parentPostId.present
          ? data.parentPostId.value
          : this.parentPostId,
      linkChain: data.linkChain.present ? data.linkChain.value : this.linkChain,
      linkDepth: data.linkDepth.present ? data.linkDepth.value : this.linkDepth,
      isPublic: data.isPublic.present ? data.isPublic.value : this.isPublic,
      allowComments: data.allowComments.present
          ? data.allowComments.value
          : this.allowComments,
      taggerName: data.taggerName.present
          ? data.taggerName.value
          : this.taggerName,
      taggerAvatar: data.taggerAvatar.present
          ? data.taggerAvatar.value
          : this.taggerAvatar,
      sourceChannelName: data.sourceChannelName.present
          ? data.sourceChannelName.value
          : this.sourceChannelName,
      sourceChannelAvatar: data.sourceChannelAvatar.present
          ? data.sourceChannelAvatar.value
          : this.sourceChannelAvatar,
      tagsCount: data.tagsCount.present ? data.tagsCount.value : this.tagsCount,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Post(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('username: $username, ')
          ..write('userProfileImageUrl: $userProfileImageUrl, ')
          ..write('channelName: $channelName, ')
          ..write('channelId: $channelId, ')
          ..write('caption: $caption, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('videoUrls: $videoUrls, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('sdVideoUrl: $sdVideoUrl, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('thumbnailUrls: $thumbnailUrls, ')
          ..write('isVideo: $isVideo, ')
          ..write('isAudio: $isAudio, ')
          ..write('folderName: $folderName, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('likes: $likes, ')
          ..write('comments: $comments, ')
          ..write('timeAgo: $timeAgo, ')
          ..write('createdAt: $createdAt, ')
          ..write('shares: $shares, ')
          ..write('isLiked: $isLiked, ')
          ..write('chartedCount: $chartedCount, ')
          ..write('localFileCache: $localFileCache, ')
          ..write('isPending: $isPending, ')
          ..write('linkedPostId: $linkedPostId, ')
          ..write('linkedAuthorUsername: $linkedAuthorUsername, ')
          ..write('linkedCaption: $linkedCaption, ')
          ..write('linkedChannelId: $linkedChannelId, ')
          ..write('postType: $postType, ')
          ..write('parentPostId: $parentPostId, ')
          ..write('linkChain: $linkChain, ')
          ..write('linkDepth: $linkDepth, ')
          ..write('isPublic: $isPublic, ')
          ..write('allowComments: $allowComments, ')
          ..write('taggerName: $taggerName, ')
          ..write('taggerAvatar: $taggerAvatar, ')
          ..write('sourceChannelName: $sourceChannelName, ')
          ..write('sourceChannelAvatar: $sourceChannelAvatar, ')
          ..write('tagsCount: $tagsCount, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    authorId,
    username,
    userProfileImageUrl,
    channelName,
    channelId,
    caption,
    videoUrl,
    videoUrls,
    audioUrl,
    sdVideoUrl,
    imageUrls,
    thumbnailUrls,
    isVideo,
    isAudio,
    folderName,
    aspectRatio,
    likes,
    comments,
    timeAgo,
    createdAt,
    shares,
    isLiked,
    chartedCount,
    localFileCache,
    isPending,
    linkedPostId,
    linkedAuthorUsername,
    linkedCaption,
    linkedChannelId,
    postType,
    parentPostId,
    linkChain,
    linkDepth,
    isPublic,
    allowComments,
    taggerName,
    taggerAvatar,
    sourceChannelName,
    sourceChannelAvatar,
    tagsCount,
    metadata,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Post &&
          other.id == this.id &&
          other.authorId == this.authorId &&
          other.username == this.username &&
          other.userProfileImageUrl == this.userProfileImageUrl &&
          other.channelName == this.channelName &&
          other.channelId == this.channelId &&
          other.caption == this.caption &&
          other.videoUrl == this.videoUrl &&
          other.videoUrls == this.videoUrls &&
          other.audioUrl == this.audioUrl &&
          other.sdVideoUrl == this.sdVideoUrl &&
          other.imageUrls == this.imageUrls &&
          other.thumbnailUrls == this.thumbnailUrls &&
          other.isVideo == this.isVideo &&
          other.isAudio == this.isAudio &&
          other.folderName == this.folderName &&
          other.aspectRatio == this.aspectRatio &&
          other.likes == this.likes &&
          other.comments == this.comments &&
          other.timeAgo == this.timeAgo &&
          other.createdAt == this.createdAt &&
          other.shares == this.shares &&
          other.isLiked == this.isLiked &&
          other.chartedCount == this.chartedCount &&
          other.localFileCache == this.localFileCache &&
          other.isPending == this.isPending &&
          other.linkedPostId == this.linkedPostId &&
          other.linkedAuthorUsername == this.linkedAuthorUsername &&
          other.linkedCaption == this.linkedCaption &&
          other.linkedChannelId == this.linkedChannelId &&
          other.postType == this.postType &&
          other.parentPostId == this.parentPostId &&
          other.linkChain == this.linkChain &&
          other.linkDepth == this.linkDepth &&
          other.isPublic == this.isPublic &&
          other.allowComments == this.allowComments &&
          other.taggerName == this.taggerName &&
          other.taggerAvatar == this.taggerAvatar &&
          other.sourceChannelName == this.sourceChannelName &&
          other.sourceChannelAvatar == this.sourceChannelAvatar &&
          other.tagsCount == this.tagsCount &&
          other.metadata == this.metadata);
}

class PostsCompanion extends UpdateCompanion<Post> {
  final Value<String> id;
  final Value<String?> authorId;
  final Value<String?> username;
  final Value<String?> userProfileImageUrl;
  final Value<String?> channelName;
  final Value<String?> channelId;
  final Value<String?> caption;
  final Value<String?> videoUrl;
  final Value<String> videoUrls;
  final Value<String?> audioUrl;
  final Value<String?> sdVideoUrl;
  final Value<String?> imageUrls;
  final Value<String?> thumbnailUrls;
  final Value<int?> isVideo;
  final Value<int?> isAudio;
  final Value<String> folderName;
  final Value<double?> aspectRatio;
  final Value<int?> likes;
  final Value<int?> comments;
  final Value<String?> timeAgo;
  final Value<String?> createdAt;
  final Value<int?> shares;
  final Value<int?> isLiked;
  final Value<int?> chartedCount;
  final Value<String?> localFileCache;
  final Value<int> isPending;
  final Value<String?> linkedPostId;
  final Value<String?> linkedAuthorUsername;
  final Value<String?> linkedCaption;
  final Value<String?> linkedChannelId;
  final Value<String> postType;
  final Value<String?> parentPostId;
  final Value<String> linkChain;
  final Value<int> linkDepth;
  final Value<int> isPublic;
  final Value<int> allowComments;
  final Value<String?> taggerName;
  final Value<String?> taggerAvatar;
  final Value<String?> sourceChannelName;
  final Value<String?> sourceChannelAvatar;
  final Value<int> tagsCount;
  final Value<String?> metadata;
  final Value<int> rowid;
  const PostsCompanion({
    this.id = const Value.absent(),
    this.authorId = const Value.absent(),
    this.username = const Value.absent(),
    this.userProfileImageUrl = const Value.absent(),
    this.channelName = const Value.absent(),
    this.channelId = const Value.absent(),
    this.caption = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.videoUrls = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.sdVideoUrl = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.thumbnailUrls = const Value.absent(),
    this.isVideo = const Value.absent(),
    this.isAudio = const Value.absent(),
    this.folderName = const Value.absent(),
    this.aspectRatio = const Value.absent(),
    this.likes = const Value.absent(),
    this.comments = const Value.absent(),
    this.timeAgo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.shares = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.chartedCount = const Value.absent(),
    this.localFileCache = const Value.absent(),
    this.isPending = const Value.absent(),
    this.linkedPostId = const Value.absent(),
    this.linkedAuthorUsername = const Value.absent(),
    this.linkedCaption = const Value.absent(),
    this.linkedChannelId = const Value.absent(),
    this.postType = const Value.absent(),
    this.parentPostId = const Value.absent(),
    this.linkChain = const Value.absent(),
    this.linkDepth = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.allowComments = const Value.absent(),
    this.taggerName = const Value.absent(),
    this.taggerAvatar = const Value.absent(),
    this.sourceChannelName = const Value.absent(),
    this.sourceChannelAvatar = const Value.absent(),
    this.tagsCount = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostsCompanion.insert({
    required String id,
    this.authorId = const Value.absent(),
    this.username = const Value.absent(),
    this.userProfileImageUrl = const Value.absent(),
    this.channelName = const Value.absent(),
    this.channelId = const Value.absent(),
    this.caption = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.videoUrls = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.sdVideoUrl = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.thumbnailUrls = const Value.absent(),
    this.isVideo = const Value.absent(),
    this.isAudio = const Value.absent(),
    this.folderName = const Value.absent(),
    this.aspectRatio = const Value.absent(),
    this.likes = const Value.absent(),
    this.comments = const Value.absent(),
    this.timeAgo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.shares = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.chartedCount = const Value.absent(),
    this.localFileCache = const Value.absent(),
    this.isPending = const Value.absent(),
    this.linkedPostId = const Value.absent(),
    this.linkedAuthorUsername = const Value.absent(),
    this.linkedCaption = const Value.absent(),
    this.linkedChannelId = const Value.absent(),
    this.postType = const Value.absent(),
    this.parentPostId = const Value.absent(),
    this.linkChain = const Value.absent(),
    this.linkDepth = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.allowComments = const Value.absent(),
    this.taggerName = const Value.absent(),
    this.taggerAvatar = const Value.absent(),
    this.sourceChannelName = const Value.absent(),
    this.sourceChannelAvatar = const Value.absent(),
    this.tagsCount = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Post> custom({
    Expression<String>? id,
    Expression<String>? authorId,
    Expression<String>? username,
    Expression<String>? userProfileImageUrl,
    Expression<String>? channelName,
    Expression<String>? channelId,
    Expression<String>? caption,
    Expression<String>? videoUrl,
    Expression<String>? videoUrls,
    Expression<String>? audioUrl,
    Expression<String>? sdVideoUrl,
    Expression<String>? imageUrls,
    Expression<String>? thumbnailUrls,
    Expression<int>? isVideo,
    Expression<int>? isAudio,
    Expression<String>? folderName,
    Expression<double>? aspectRatio,
    Expression<int>? likes,
    Expression<int>? comments,
    Expression<String>? timeAgo,
    Expression<String>? createdAt,
    Expression<int>? shares,
    Expression<int>? isLiked,
    Expression<int>? chartedCount,
    Expression<String>? localFileCache,
    Expression<int>? isPending,
    Expression<String>? linkedPostId,
    Expression<String>? linkedAuthorUsername,
    Expression<String>? linkedCaption,
    Expression<String>? linkedChannelId,
    Expression<String>? postType,
    Expression<String>? parentPostId,
    Expression<String>? linkChain,
    Expression<int>? linkDepth,
    Expression<int>? isPublic,
    Expression<int>? allowComments,
    Expression<String>? taggerName,
    Expression<String>? taggerAvatar,
    Expression<String>? sourceChannelName,
    Expression<String>? sourceChannelAvatar,
    Expression<int>? tagsCount,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (authorId != null) 'author_id': authorId,
      if (username != null) 'username': username,
      if (userProfileImageUrl != null)
        'user_profile_image_url': userProfileImageUrl,
      if (channelName != null) 'channel_name': channelName,
      if (channelId != null) 'channel_id': channelId,
      if (caption != null) 'caption': caption,
      if (videoUrl != null) 'video_url': videoUrl,
      if (videoUrls != null) 'video_urls': videoUrls,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (sdVideoUrl != null) 'sd_video_url': sdVideoUrl,
      if (imageUrls != null) 'image_urls': imageUrls,
      if (thumbnailUrls != null) 'thumbnail_urls': thumbnailUrls,
      if (isVideo != null) 'is_video': isVideo,
      if (isAudio != null) 'is_audio': isAudio,
      if (folderName != null) 'folder_name': folderName,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (likes != null) 'likes': likes,
      if (comments != null) 'comments': comments,
      if (timeAgo != null) 'time_ago': timeAgo,
      if (createdAt != null) 'createdAt': createdAt,
      if (shares != null) 'shares': shares,
      if (isLiked != null) 'is_liked': isLiked,
      if (chartedCount != null) 'charted_count': chartedCount,
      if (localFileCache != null) 'local_file_cache': localFileCache,
      if (isPending != null) 'is_pending': isPending,
      if (linkedPostId != null) 'linked_post_id': linkedPostId,
      if (linkedAuthorUsername != null)
        'linked_author_username': linkedAuthorUsername,
      if (linkedCaption != null) 'linked_caption': linkedCaption,
      if (linkedChannelId != null) 'linked_channel_id': linkedChannelId,
      if (postType != null) 'post_type': postType,
      if (parentPostId != null) 'parent_post_id': parentPostId,
      if (linkChain != null) 'link_chain': linkChain,
      if (linkDepth != null) 'link_depth': linkDepth,
      if (isPublic != null) 'is_public': isPublic,
      if (allowComments != null) 'allow_comments': allowComments,
      if (taggerName != null) 'tagger_name': taggerName,
      if (taggerAvatar != null) 'tagger_avatar': taggerAvatar,
      if (sourceChannelName != null) 'source_channel_name': sourceChannelName,
      if (sourceChannelAvatar != null)
        'source_channel_avatar': sourceChannelAvatar,
      if (tagsCount != null) 'tags_count': tagsCount,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostsCompanion copyWith({
    Value<String>? id,
    Value<String?>? authorId,
    Value<String?>? username,
    Value<String?>? userProfileImageUrl,
    Value<String?>? channelName,
    Value<String?>? channelId,
    Value<String?>? caption,
    Value<String?>? videoUrl,
    Value<String>? videoUrls,
    Value<String?>? audioUrl,
    Value<String?>? sdVideoUrl,
    Value<String?>? imageUrls,
    Value<String?>? thumbnailUrls,
    Value<int?>? isVideo,
    Value<int?>? isAudio,
    Value<String>? folderName,
    Value<double?>? aspectRatio,
    Value<int?>? likes,
    Value<int?>? comments,
    Value<String?>? timeAgo,
    Value<String?>? createdAt,
    Value<int?>? shares,
    Value<int?>? isLiked,
    Value<int?>? chartedCount,
    Value<String?>? localFileCache,
    Value<int>? isPending,
    Value<String?>? linkedPostId,
    Value<String?>? linkedAuthorUsername,
    Value<String?>? linkedCaption,
    Value<String?>? linkedChannelId,
    Value<String>? postType,
    Value<String?>? parentPostId,
    Value<String>? linkChain,
    Value<int>? linkDepth,
    Value<int>? isPublic,
    Value<int>? allowComments,
    Value<String?>? taggerName,
    Value<String?>? taggerAvatar,
    Value<String?>? sourceChannelName,
    Value<String?>? sourceChannelAvatar,
    Value<int>? tagsCount,
    Value<String?>? metadata,
    Value<int>? rowid,
  }) {
    return PostsCompanion(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      username: username ?? this.username,
      userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
      channelName: channelName ?? this.channelName,
      channelId: channelId ?? this.channelId,
      caption: caption ?? this.caption,
      videoUrl: videoUrl ?? this.videoUrl,
      videoUrls: videoUrls ?? this.videoUrls,
      audioUrl: audioUrl ?? this.audioUrl,
      sdVideoUrl: sdVideoUrl ?? this.sdVideoUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      thumbnailUrls: thumbnailUrls ?? this.thumbnailUrls,
      isVideo: isVideo ?? this.isVideo,
      isAudio: isAudio ?? this.isAudio,
      folderName: folderName ?? this.folderName,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      timeAgo: timeAgo ?? this.timeAgo,
      createdAt: createdAt ?? this.createdAt,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
      chartedCount: chartedCount ?? this.chartedCount,
      localFileCache: localFileCache ?? this.localFileCache,
      isPending: isPending ?? this.isPending,
      linkedPostId: linkedPostId ?? this.linkedPostId,
      linkedAuthorUsername: linkedAuthorUsername ?? this.linkedAuthorUsername,
      linkedCaption: linkedCaption ?? this.linkedCaption,
      linkedChannelId: linkedChannelId ?? this.linkedChannelId,
      postType: postType ?? this.postType,
      parentPostId: parentPostId ?? this.parentPostId,
      linkChain: linkChain ?? this.linkChain,
      linkDepth: linkDepth ?? this.linkDepth,
      isPublic: isPublic ?? this.isPublic,
      allowComments: allowComments ?? this.allowComments,
      taggerName: taggerName ?? this.taggerName,
      taggerAvatar: taggerAvatar ?? this.taggerAvatar,
      sourceChannelName: sourceChannelName ?? this.sourceChannelName,
      sourceChannelAvatar: sourceChannelAvatar ?? this.sourceChannelAvatar,
      tagsCount: tagsCount ?? this.tagsCount,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (userProfileImageUrl.present) {
      map['user_profile_image_url'] = Variable<String>(
        userProfileImageUrl.value,
      );
    }
    if (channelName.present) {
      map['channel_name'] = Variable<String>(channelName.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (videoUrl.present) {
      map['video_url'] = Variable<String>(videoUrl.value);
    }
    if (videoUrls.present) {
      map['video_urls'] = Variable<String>(videoUrls.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (sdVideoUrl.present) {
      map['sd_video_url'] = Variable<String>(sdVideoUrl.value);
    }
    if (imageUrls.present) {
      map['image_urls'] = Variable<String>(imageUrls.value);
    }
    if (thumbnailUrls.present) {
      map['thumbnail_urls'] = Variable<String>(thumbnailUrls.value);
    }
    if (isVideo.present) {
      map['is_video'] = Variable<int>(isVideo.value);
    }
    if (isAudio.present) {
      map['is_audio'] = Variable<int>(isAudio.value);
    }
    if (folderName.present) {
      map['folder_name'] = Variable<String>(folderName.value);
    }
    if (aspectRatio.present) {
      map['aspect_ratio'] = Variable<double>(aspectRatio.value);
    }
    if (likes.present) {
      map['likes'] = Variable<int>(likes.value);
    }
    if (comments.present) {
      map['comments'] = Variable<int>(comments.value);
    }
    if (timeAgo.present) {
      map['time_ago'] = Variable<String>(timeAgo.value);
    }
    if (createdAt.present) {
      map['createdAt'] = Variable<String>(createdAt.value);
    }
    if (shares.present) {
      map['shares'] = Variable<int>(shares.value);
    }
    if (isLiked.present) {
      map['is_liked'] = Variable<int>(isLiked.value);
    }
    if (chartedCount.present) {
      map['charted_count'] = Variable<int>(chartedCount.value);
    }
    if (localFileCache.present) {
      map['local_file_cache'] = Variable<String>(localFileCache.value);
    }
    if (isPending.present) {
      map['is_pending'] = Variable<int>(isPending.value);
    }
    if (linkedPostId.present) {
      map['linked_post_id'] = Variable<String>(linkedPostId.value);
    }
    if (linkedAuthorUsername.present) {
      map['linked_author_username'] = Variable<String>(
        linkedAuthorUsername.value,
      );
    }
    if (linkedCaption.present) {
      map['linked_caption'] = Variable<String>(linkedCaption.value);
    }
    if (linkedChannelId.present) {
      map['linked_channel_id'] = Variable<String>(linkedChannelId.value);
    }
    if (postType.present) {
      map['post_type'] = Variable<String>(postType.value);
    }
    if (parentPostId.present) {
      map['parent_post_id'] = Variable<String>(parentPostId.value);
    }
    if (linkChain.present) {
      map['link_chain'] = Variable<String>(linkChain.value);
    }
    if (linkDepth.present) {
      map['link_depth'] = Variable<int>(linkDepth.value);
    }
    if (isPublic.present) {
      map['is_public'] = Variable<int>(isPublic.value);
    }
    if (allowComments.present) {
      map['allow_comments'] = Variable<int>(allowComments.value);
    }
    if (taggerName.present) {
      map['tagger_name'] = Variable<String>(taggerName.value);
    }
    if (taggerAvatar.present) {
      map['tagger_avatar'] = Variable<String>(taggerAvatar.value);
    }
    if (sourceChannelName.present) {
      map['source_channel_name'] = Variable<String>(sourceChannelName.value);
    }
    if (sourceChannelAvatar.present) {
      map['source_channel_avatar'] = Variable<String>(
        sourceChannelAvatar.value,
      );
    }
    if (tagsCount.present) {
      map['tags_count'] = Variable<int>(tagsCount.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostsCompanion(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('username: $username, ')
          ..write('userProfileImageUrl: $userProfileImageUrl, ')
          ..write('channelName: $channelName, ')
          ..write('channelId: $channelId, ')
          ..write('caption: $caption, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('videoUrls: $videoUrls, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('sdVideoUrl: $sdVideoUrl, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('thumbnailUrls: $thumbnailUrls, ')
          ..write('isVideo: $isVideo, ')
          ..write('isAudio: $isAudio, ')
          ..write('folderName: $folderName, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('likes: $likes, ')
          ..write('comments: $comments, ')
          ..write('timeAgo: $timeAgo, ')
          ..write('createdAt: $createdAt, ')
          ..write('shares: $shares, ')
          ..write('isLiked: $isLiked, ')
          ..write('chartedCount: $chartedCount, ')
          ..write('localFileCache: $localFileCache, ')
          ..write('isPending: $isPending, ')
          ..write('linkedPostId: $linkedPostId, ')
          ..write('linkedAuthorUsername: $linkedAuthorUsername, ')
          ..write('linkedCaption: $linkedCaption, ')
          ..write('linkedChannelId: $linkedChannelId, ')
          ..write('postType: $postType, ')
          ..write('parentPostId: $parentPostId, ')
          ..write('linkChain: $linkChain, ')
          ..write('linkDepth: $linkDepth, ')
          ..write('isPublic: $isPublic, ')
          ..write('allowComments: $allowComments, ')
          ..write('taggerName: $taggerName, ')
          ..write('taggerAvatar: $taggerAvatar, ')
          ..write('sourceChannelName: $sourceChannelName, ')
          ..write('sourceChannelAvatar: $sourceChannelAvatar, ')
          ..write('tagsCount: $tagsCount, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ManifestosTable extends Manifestos
    with TableInfo<$ManifestosTable, Manifesto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ManifestosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profileImageUrlMeta = const VerificationMeta(
    'profileImageUrl',
  );
  @override
  late final GeneratedColumn<String> profileImageUrl = GeneratedColumn<String>(
    'profile_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _videoUrlMeta = const VerificationMeta(
    'videoUrl',
  );
  @override
  late final GeneratedColumn<String> videoUrl = GeneratedColumn<String>(
    'video_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _videoUrlsMeta = const VerificationMeta(
    'videoUrls',
  );
  @override
  late final GeneratedColumn<String> videoUrls = GeneratedColumn<String>(
    'video_urls',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _imageUrlsMeta = const VerificationMeta(
    'imageUrls',
  );
  @override
  late final GeneratedColumn<String> imageUrls = GeneratedColumn<String>(
    'image_urls',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailUrlsMeta = const VerificationMeta(
    'thumbnailUrls',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrls = GeneratedColumn<String>(
    'thumbnail_urls',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _likesMeta = const VerificationMeta('likes');
  @override
  late final GeneratedColumn<int> likes = GeneratedColumn<int>(
    'likes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _commentsMeta = const VerificationMeta(
    'comments',
  );
  @override
  late final GeneratedColumn<int> comments = GeneratedColumn<int>(
    'comments',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPublicMeta = const VerificationMeta(
    'isPublic',
  );
  @override
  late final GeneratedColumn<int> isPublic = GeneratedColumn<int>(
    'is_public',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _allowCommentsMeta = const VerificationMeta(
    'allowComments',
  );
  @override
  late final GeneratedColumn<int> allowComments = GeneratedColumn<int>(
    'allow_comments',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isPendingMeta = const VerificationMeta(
    'isPending',
  );
  @override
  late final GeneratedColumn<int> isPending = GeneratedColumn<int>(
    'is_pending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isLikedMeta = const VerificationMeta(
    'isLiked',
  );
  @override
  late final GeneratedColumn<int> isLiked = GeneratedColumn<int>(
    'is_liked',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _aspectRatioMeta = const VerificationMeta(
    'aspectRatio',
  );
  @override
  late final GeneratedColumn<double> aspectRatio = GeneratedColumn<double>(
    'aspect_ratio',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _taggerNameMeta = const VerificationMeta(
    'taggerName',
  );
  @override
  late final GeneratedColumn<String> taggerName = GeneratedColumn<String>(
    'tagger_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taggerAvatarMeta = const VerificationMeta(
    'taggerAvatar',
  );
  @override
  late final GeneratedColumn<String> taggerAvatar = GeneratedColumn<String>(
    'tagger_avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceChannelNameMeta = const VerificationMeta(
    'sourceChannelName',
  );
  @override
  late final GeneratedColumn<String> sourceChannelName =
      GeneratedColumn<String>(
        'source_channel_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceChannelAvatarMeta =
      const VerificationMeta('sourceChannelAvatar');
  @override
  late final GeneratedColumn<String> sourceChannelAvatar =
      GeneratedColumn<String>(
        'source_channel_avatar',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _tagsCountMeta = const VerificationMeta(
    'tagsCount',
  );
  @override
  late final GeneratedColumn<int> tagsCount = GeneratedColumn<int>(
    'tags_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    authorId,
    username,
    profileImageUrl,
    channelId,
    caption,
    videoUrl,
    videoUrls,
    imageUrls,
    thumbnailUrls,
    likes,
    comments,
    isPublic,
    allowComments,
    isPending,
    isLiked,
    aspectRatio,
    createdAt,
    taggerName,
    taggerAvatar,
    sourceChannelName,
    sourceChannelAvatar,
    tagsCount,
    metadata,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manifestos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Manifesto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('profile_image_url')) {
      context.handle(
        _profileImageUrlMeta,
        profileImageUrl.isAcceptableOrUnknown(
          data['profile_image_url']!,
          _profileImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('video_url')) {
      context.handle(
        _videoUrlMeta,
        videoUrl.isAcceptableOrUnknown(data['video_url']!, _videoUrlMeta),
      );
    }
    if (data.containsKey('video_urls')) {
      context.handle(
        _videoUrlsMeta,
        videoUrls.isAcceptableOrUnknown(data['video_urls']!, _videoUrlsMeta),
      );
    }
    if (data.containsKey('image_urls')) {
      context.handle(
        _imageUrlsMeta,
        imageUrls.isAcceptableOrUnknown(data['image_urls']!, _imageUrlsMeta),
      );
    }
    if (data.containsKey('thumbnail_urls')) {
      context.handle(
        _thumbnailUrlsMeta,
        thumbnailUrls.isAcceptableOrUnknown(
          data['thumbnail_urls']!,
          _thumbnailUrlsMeta,
        ),
      );
    }
    if (data.containsKey('likes')) {
      context.handle(
        _likesMeta,
        likes.isAcceptableOrUnknown(data['likes']!, _likesMeta),
      );
    }
    if (data.containsKey('comments')) {
      context.handle(
        _commentsMeta,
        comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta),
      );
    }
    if (data.containsKey('is_public')) {
      context.handle(
        _isPublicMeta,
        isPublic.isAcceptableOrUnknown(data['is_public']!, _isPublicMeta),
      );
    }
    if (data.containsKey('allow_comments')) {
      context.handle(
        _allowCommentsMeta,
        allowComments.isAcceptableOrUnknown(
          data['allow_comments']!,
          _allowCommentsMeta,
        ),
      );
    }
    if (data.containsKey('is_pending')) {
      context.handle(
        _isPendingMeta,
        isPending.isAcceptableOrUnknown(data['is_pending']!, _isPendingMeta),
      );
    }
    if (data.containsKey('is_liked')) {
      context.handle(
        _isLikedMeta,
        isLiked.isAcceptableOrUnknown(data['is_liked']!, _isLikedMeta),
      );
    }
    if (data.containsKey('aspect_ratio')) {
      context.handle(
        _aspectRatioMeta,
        aspectRatio.isAcceptableOrUnknown(
          data['aspect_ratio']!,
          _aspectRatioMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('tagger_name')) {
      context.handle(
        _taggerNameMeta,
        taggerName.isAcceptableOrUnknown(data['tagger_name']!, _taggerNameMeta),
      );
    }
    if (data.containsKey('tagger_avatar')) {
      context.handle(
        _taggerAvatarMeta,
        taggerAvatar.isAcceptableOrUnknown(
          data['tagger_avatar']!,
          _taggerAvatarMeta,
        ),
      );
    }
    if (data.containsKey('source_channel_name')) {
      context.handle(
        _sourceChannelNameMeta,
        sourceChannelName.isAcceptableOrUnknown(
          data['source_channel_name']!,
          _sourceChannelNameMeta,
        ),
      );
    }
    if (data.containsKey('source_channel_avatar')) {
      context.handle(
        _sourceChannelAvatarMeta,
        sourceChannelAvatar.isAcceptableOrUnknown(
          data['source_channel_avatar']!,
          _sourceChannelAvatarMeta,
        ),
      );
    }
    if (data.containsKey('tags_count')) {
      context.handle(
        _tagsCountMeta,
        tagsCount.isAcceptableOrUnknown(data['tags_count']!, _tagsCountMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Manifesto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Manifesto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      profileImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_image_url'],
      ),
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      videoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_url'],
      ),
      videoUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_urls'],
      )!,
      imageUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_urls'],
      ),
      thumbnailUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_urls'],
      ),
      likes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}likes'],
      )!,
      comments: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}comments'],
      )!,
      isPublic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_public'],
      )!,
      allowComments: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allow_comments'],
      )!,
      isPending: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_pending'],
      )!,
      isLiked: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_liked'],
      )!,
      aspectRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}aspect_ratio'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      taggerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tagger_name'],
      ),
      taggerAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tagger_avatar'],
      ),
      sourceChannelName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_channel_name'],
      ),
      sourceChannelAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_channel_avatar'],
      ),
      tagsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tags_count'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
    );
  }

  @override
  $ManifestosTable createAlias(String alias) {
    return $ManifestosTable(attachedDatabase, alias);
  }
}

class Manifesto extends DataClass implements Insertable<Manifesto> {
  final String id;
  final String authorId;
  final String? username;
  final String? profileImageUrl;
  final String channelId;
  final String? caption;
  final String? videoUrl;
  final String videoUrls;
  final String? imageUrls;
  final String? thumbnailUrls;
  final int likes;
  final int comments;
  final int isPublic;
  final int allowComments;
  final int isPending;
  final int isLiked;
  final double? aspectRatio;
  final DateTime createdAt;
  final String? taggerName;
  final String? taggerAvatar;
  final String? sourceChannelName;
  final String? sourceChannelAvatar;
  final int tagsCount;
  final String? metadata;
  const Manifesto({
    required this.id,
    required this.authorId,
    this.username,
    this.profileImageUrl,
    required this.channelId,
    this.caption,
    this.videoUrl,
    required this.videoUrls,
    this.imageUrls,
    this.thumbnailUrls,
    required this.likes,
    required this.comments,
    required this.isPublic,
    required this.allowComments,
    required this.isPending,
    required this.isLiked,
    this.aspectRatio,
    required this.createdAt,
    this.taggerName,
    this.taggerAvatar,
    this.sourceChannelName,
    this.sourceChannelAvatar,
    required this.tagsCount,
    this.metadata,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['author_id'] = Variable<String>(authorId);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || profileImageUrl != null) {
      map['profile_image_url'] = Variable<String>(profileImageUrl);
    }
    map['channel_id'] = Variable<String>(channelId);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    if (!nullToAbsent || videoUrl != null) {
      map['video_url'] = Variable<String>(videoUrl);
    }
    map['video_urls'] = Variable<String>(videoUrls);
    if (!nullToAbsent || imageUrls != null) {
      map['image_urls'] = Variable<String>(imageUrls);
    }
    if (!nullToAbsent || thumbnailUrls != null) {
      map['thumbnail_urls'] = Variable<String>(thumbnailUrls);
    }
    map['likes'] = Variable<int>(likes);
    map['comments'] = Variable<int>(comments);
    map['is_public'] = Variable<int>(isPublic);
    map['allow_comments'] = Variable<int>(allowComments);
    map['is_pending'] = Variable<int>(isPending);
    map['is_liked'] = Variable<int>(isLiked);
    if (!nullToAbsent || aspectRatio != null) {
      map['aspect_ratio'] = Variable<double>(aspectRatio);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || taggerName != null) {
      map['tagger_name'] = Variable<String>(taggerName);
    }
    if (!nullToAbsent || taggerAvatar != null) {
      map['tagger_avatar'] = Variable<String>(taggerAvatar);
    }
    if (!nullToAbsent || sourceChannelName != null) {
      map['source_channel_name'] = Variable<String>(sourceChannelName);
    }
    if (!nullToAbsent || sourceChannelAvatar != null) {
      map['source_channel_avatar'] = Variable<String>(sourceChannelAvatar);
    }
    map['tags_count'] = Variable<int>(tagsCount);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    return map;
  }

  ManifestosCompanion toCompanion(bool nullToAbsent) {
    return ManifestosCompanion(
      id: Value(id),
      authorId: Value(authorId),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      profileImageUrl: profileImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImageUrl),
      channelId: Value(channelId),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      videoUrl: videoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(videoUrl),
      videoUrls: Value(videoUrls),
      imageUrls: imageUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrls),
      thumbnailUrls: thumbnailUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrls),
      likes: Value(likes),
      comments: Value(comments),
      isPublic: Value(isPublic),
      allowComments: Value(allowComments),
      isPending: Value(isPending),
      isLiked: Value(isLiked),
      aspectRatio: aspectRatio == null && nullToAbsent
          ? const Value.absent()
          : Value(aspectRatio),
      createdAt: Value(createdAt),
      taggerName: taggerName == null && nullToAbsent
          ? const Value.absent()
          : Value(taggerName),
      taggerAvatar: taggerAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(taggerAvatar),
      sourceChannelName: sourceChannelName == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceChannelName),
      sourceChannelAvatar: sourceChannelAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceChannelAvatar),
      tagsCount: Value(tagsCount),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory Manifesto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Manifesto(
      id: serializer.fromJson<String>(json['id']),
      authorId: serializer.fromJson<String>(json['authorId']),
      username: serializer.fromJson<String?>(json['username']),
      profileImageUrl: serializer.fromJson<String?>(json['profileImageUrl']),
      channelId: serializer.fromJson<String>(json['channelId']),
      caption: serializer.fromJson<String?>(json['caption']),
      videoUrl: serializer.fromJson<String?>(json['videoUrl']),
      videoUrls: serializer.fromJson<String>(json['videoUrls']),
      imageUrls: serializer.fromJson<String?>(json['imageUrls']),
      thumbnailUrls: serializer.fromJson<String?>(json['thumbnailUrls']),
      likes: serializer.fromJson<int>(json['likes']),
      comments: serializer.fromJson<int>(json['comments']),
      isPublic: serializer.fromJson<int>(json['isPublic']),
      allowComments: serializer.fromJson<int>(json['allowComments']),
      isPending: serializer.fromJson<int>(json['isPending']),
      isLiked: serializer.fromJson<int>(json['isLiked']),
      aspectRatio: serializer.fromJson<double?>(json['aspectRatio']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      taggerName: serializer.fromJson<String?>(json['taggerName']),
      taggerAvatar: serializer.fromJson<String?>(json['taggerAvatar']),
      sourceChannelName: serializer.fromJson<String?>(
        json['sourceChannelName'],
      ),
      sourceChannelAvatar: serializer.fromJson<String?>(
        json['sourceChannelAvatar'],
      ),
      tagsCount: serializer.fromJson<int>(json['tagsCount']),
      metadata: serializer.fromJson<String?>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'authorId': serializer.toJson<String>(authorId),
      'username': serializer.toJson<String?>(username),
      'profileImageUrl': serializer.toJson<String?>(profileImageUrl),
      'channelId': serializer.toJson<String>(channelId),
      'caption': serializer.toJson<String?>(caption),
      'videoUrl': serializer.toJson<String?>(videoUrl),
      'videoUrls': serializer.toJson<String>(videoUrls),
      'imageUrls': serializer.toJson<String?>(imageUrls),
      'thumbnailUrls': serializer.toJson<String?>(thumbnailUrls),
      'likes': serializer.toJson<int>(likes),
      'comments': serializer.toJson<int>(comments),
      'isPublic': serializer.toJson<int>(isPublic),
      'allowComments': serializer.toJson<int>(allowComments),
      'isPending': serializer.toJson<int>(isPending),
      'isLiked': serializer.toJson<int>(isLiked),
      'aspectRatio': serializer.toJson<double?>(aspectRatio),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'taggerName': serializer.toJson<String?>(taggerName),
      'taggerAvatar': serializer.toJson<String?>(taggerAvatar),
      'sourceChannelName': serializer.toJson<String?>(sourceChannelName),
      'sourceChannelAvatar': serializer.toJson<String?>(sourceChannelAvatar),
      'tagsCount': serializer.toJson<int>(tagsCount),
      'metadata': serializer.toJson<String?>(metadata),
    };
  }

  Manifesto copyWith({
    String? id,
    String? authorId,
    Value<String?> username = const Value.absent(),
    Value<String?> profileImageUrl = const Value.absent(),
    String? channelId,
    Value<String?> caption = const Value.absent(),
    Value<String?> videoUrl = const Value.absent(),
    String? videoUrls,
    Value<String?> imageUrls = const Value.absent(),
    Value<String?> thumbnailUrls = const Value.absent(),
    int? likes,
    int? comments,
    int? isPublic,
    int? allowComments,
    int? isPending,
    int? isLiked,
    Value<double?> aspectRatio = const Value.absent(),
    DateTime? createdAt,
    Value<String?> taggerName = const Value.absent(),
    Value<String?> taggerAvatar = const Value.absent(),
    Value<String?> sourceChannelName = const Value.absent(),
    Value<String?> sourceChannelAvatar = const Value.absent(),
    int? tagsCount,
    Value<String?> metadata = const Value.absent(),
  }) => Manifesto(
    id: id ?? this.id,
    authorId: authorId ?? this.authorId,
    username: username.present ? username.value : this.username,
    profileImageUrl: profileImageUrl.present
        ? profileImageUrl.value
        : this.profileImageUrl,
    channelId: channelId ?? this.channelId,
    caption: caption.present ? caption.value : this.caption,
    videoUrl: videoUrl.present ? videoUrl.value : this.videoUrl,
    videoUrls: videoUrls ?? this.videoUrls,
    imageUrls: imageUrls.present ? imageUrls.value : this.imageUrls,
    thumbnailUrls: thumbnailUrls.present
        ? thumbnailUrls.value
        : this.thumbnailUrls,
    likes: likes ?? this.likes,
    comments: comments ?? this.comments,
    isPublic: isPublic ?? this.isPublic,
    allowComments: allowComments ?? this.allowComments,
    isPending: isPending ?? this.isPending,
    isLiked: isLiked ?? this.isLiked,
    aspectRatio: aspectRatio.present ? aspectRatio.value : this.aspectRatio,
    createdAt: createdAt ?? this.createdAt,
    taggerName: taggerName.present ? taggerName.value : this.taggerName,
    taggerAvatar: taggerAvatar.present ? taggerAvatar.value : this.taggerAvatar,
    sourceChannelName: sourceChannelName.present
        ? sourceChannelName.value
        : this.sourceChannelName,
    sourceChannelAvatar: sourceChannelAvatar.present
        ? sourceChannelAvatar.value
        : this.sourceChannelAvatar,
    tagsCount: tagsCount ?? this.tagsCount,
    metadata: metadata.present ? metadata.value : this.metadata,
  );
  Manifesto copyWithCompanion(ManifestosCompanion data) {
    return Manifesto(
      id: data.id.present ? data.id.value : this.id,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      username: data.username.present ? data.username.value : this.username,
      profileImageUrl: data.profileImageUrl.present
          ? data.profileImageUrl.value
          : this.profileImageUrl,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      caption: data.caption.present ? data.caption.value : this.caption,
      videoUrl: data.videoUrl.present ? data.videoUrl.value : this.videoUrl,
      videoUrls: data.videoUrls.present ? data.videoUrls.value : this.videoUrls,
      imageUrls: data.imageUrls.present ? data.imageUrls.value : this.imageUrls,
      thumbnailUrls: data.thumbnailUrls.present
          ? data.thumbnailUrls.value
          : this.thumbnailUrls,
      likes: data.likes.present ? data.likes.value : this.likes,
      comments: data.comments.present ? data.comments.value : this.comments,
      isPublic: data.isPublic.present ? data.isPublic.value : this.isPublic,
      allowComments: data.allowComments.present
          ? data.allowComments.value
          : this.allowComments,
      isPending: data.isPending.present ? data.isPending.value : this.isPending,
      isLiked: data.isLiked.present ? data.isLiked.value : this.isLiked,
      aspectRatio: data.aspectRatio.present
          ? data.aspectRatio.value
          : this.aspectRatio,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      taggerName: data.taggerName.present
          ? data.taggerName.value
          : this.taggerName,
      taggerAvatar: data.taggerAvatar.present
          ? data.taggerAvatar.value
          : this.taggerAvatar,
      sourceChannelName: data.sourceChannelName.present
          ? data.sourceChannelName.value
          : this.sourceChannelName,
      sourceChannelAvatar: data.sourceChannelAvatar.present
          ? data.sourceChannelAvatar.value
          : this.sourceChannelAvatar,
      tagsCount: data.tagsCount.present ? data.tagsCount.value : this.tagsCount,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Manifesto(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('username: $username, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('channelId: $channelId, ')
          ..write('caption: $caption, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('videoUrls: $videoUrls, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('thumbnailUrls: $thumbnailUrls, ')
          ..write('likes: $likes, ')
          ..write('comments: $comments, ')
          ..write('isPublic: $isPublic, ')
          ..write('allowComments: $allowComments, ')
          ..write('isPending: $isPending, ')
          ..write('isLiked: $isLiked, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('createdAt: $createdAt, ')
          ..write('taggerName: $taggerName, ')
          ..write('taggerAvatar: $taggerAvatar, ')
          ..write('sourceChannelName: $sourceChannelName, ')
          ..write('sourceChannelAvatar: $sourceChannelAvatar, ')
          ..write('tagsCount: $tagsCount, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    authorId,
    username,
    profileImageUrl,
    channelId,
    caption,
    videoUrl,
    videoUrls,
    imageUrls,
    thumbnailUrls,
    likes,
    comments,
    isPublic,
    allowComments,
    isPending,
    isLiked,
    aspectRatio,
    createdAt,
    taggerName,
    taggerAvatar,
    sourceChannelName,
    sourceChannelAvatar,
    tagsCount,
    metadata,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Manifesto &&
          other.id == this.id &&
          other.authorId == this.authorId &&
          other.username == this.username &&
          other.profileImageUrl == this.profileImageUrl &&
          other.channelId == this.channelId &&
          other.caption == this.caption &&
          other.videoUrl == this.videoUrl &&
          other.videoUrls == this.videoUrls &&
          other.imageUrls == this.imageUrls &&
          other.thumbnailUrls == this.thumbnailUrls &&
          other.likes == this.likes &&
          other.comments == this.comments &&
          other.isPublic == this.isPublic &&
          other.allowComments == this.allowComments &&
          other.isPending == this.isPending &&
          other.isLiked == this.isLiked &&
          other.aspectRatio == this.aspectRatio &&
          other.createdAt == this.createdAt &&
          other.taggerName == this.taggerName &&
          other.taggerAvatar == this.taggerAvatar &&
          other.sourceChannelName == this.sourceChannelName &&
          other.sourceChannelAvatar == this.sourceChannelAvatar &&
          other.tagsCount == this.tagsCount &&
          other.metadata == this.metadata);
}

class ManifestosCompanion extends UpdateCompanion<Manifesto> {
  final Value<String> id;
  final Value<String> authorId;
  final Value<String?> username;
  final Value<String?> profileImageUrl;
  final Value<String> channelId;
  final Value<String?> caption;
  final Value<String?> videoUrl;
  final Value<String> videoUrls;
  final Value<String?> imageUrls;
  final Value<String?> thumbnailUrls;
  final Value<int> likes;
  final Value<int> comments;
  final Value<int> isPublic;
  final Value<int> allowComments;
  final Value<int> isPending;
  final Value<int> isLiked;
  final Value<double?> aspectRatio;
  final Value<DateTime> createdAt;
  final Value<String?> taggerName;
  final Value<String?> taggerAvatar;
  final Value<String?> sourceChannelName;
  final Value<String?> sourceChannelAvatar;
  final Value<int> tagsCount;
  final Value<String?> metadata;
  final Value<int> rowid;
  const ManifestosCompanion({
    this.id = const Value.absent(),
    this.authorId = const Value.absent(),
    this.username = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.channelId = const Value.absent(),
    this.caption = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.videoUrls = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.thumbnailUrls = const Value.absent(),
    this.likes = const Value.absent(),
    this.comments = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.allowComments = const Value.absent(),
    this.isPending = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.aspectRatio = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.taggerName = const Value.absent(),
    this.taggerAvatar = const Value.absent(),
    this.sourceChannelName = const Value.absent(),
    this.sourceChannelAvatar = const Value.absent(),
    this.tagsCount = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ManifestosCompanion.insert({
    required String id,
    required String authorId,
    this.username = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    required String channelId,
    this.caption = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.videoUrls = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.thumbnailUrls = const Value.absent(),
    this.likes = const Value.absent(),
    this.comments = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.allowComments = const Value.absent(),
    this.isPending = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.aspectRatio = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.taggerName = const Value.absent(),
    this.taggerAvatar = const Value.absent(),
    this.sourceChannelName = const Value.absent(),
    this.sourceChannelAvatar = const Value.absent(),
    this.tagsCount = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       authorId = Value(authorId),
       channelId = Value(channelId);
  static Insertable<Manifesto> custom({
    Expression<String>? id,
    Expression<String>? authorId,
    Expression<String>? username,
    Expression<String>? profileImageUrl,
    Expression<String>? channelId,
    Expression<String>? caption,
    Expression<String>? videoUrl,
    Expression<String>? videoUrls,
    Expression<String>? imageUrls,
    Expression<String>? thumbnailUrls,
    Expression<int>? likes,
    Expression<int>? comments,
    Expression<int>? isPublic,
    Expression<int>? allowComments,
    Expression<int>? isPending,
    Expression<int>? isLiked,
    Expression<double>? aspectRatio,
    Expression<DateTime>? createdAt,
    Expression<String>? taggerName,
    Expression<String>? taggerAvatar,
    Expression<String>? sourceChannelName,
    Expression<String>? sourceChannelAvatar,
    Expression<int>? tagsCount,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (authorId != null) 'author_id': authorId,
      if (username != null) 'username': username,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      if (channelId != null) 'channel_id': channelId,
      if (caption != null) 'caption': caption,
      if (videoUrl != null) 'video_url': videoUrl,
      if (videoUrls != null) 'video_urls': videoUrls,
      if (imageUrls != null) 'image_urls': imageUrls,
      if (thumbnailUrls != null) 'thumbnail_urls': thumbnailUrls,
      if (likes != null) 'likes': likes,
      if (comments != null) 'comments': comments,
      if (isPublic != null) 'is_public': isPublic,
      if (allowComments != null) 'allow_comments': allowComments,
      if (isPending != null) 'is_pending': isPending,
      if (isLiked != null) 'is_liked': isLiked,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (createdAt != null) 'created_at': createdAt,
      if (taggerName != null) 'tagger_name': taggerName,
      if (taggerAvatar != null) 'tagger_avatar': taggerAvatar,
      if (sourceChannelName != null) 'source_channel_name': sourceChannelName,
      if (sourceChannelAvatar != null)
        'source_channel_avatar': sourceChannelAvatar,
      if (tagsCount != null) 'tags_count': tagsCount,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ManifestosCompanion copyWith({
    Value<String>? id,
    Value<String>? authorId,
    Value<String?>? username,
    Value<String?>? profileImageUrl,
    Value<String>? channelId,
    Value<String?>? caption,
    Value<String?>? videoUrl,
    Value<String>? videoUrls,
    Value<String?>? imageUrls,
    Value<String?>? thumbnailUrls,
    Value<int>? likes,
    Value<int>? comments,
    Value<int>? isPublic,
    Value<int>? allowComments,
    Value<int>? isPending,
    Value<int>? isLiked,
    Value<double?>? aspectRatio,
    Value<DateTime>? createdAt,
    Value<String?>? taggerName,
    Value<String?>? taggerAvatar,
    Value<String?>? sourceChannelName,
    Value<String?>? sourceChannelAvatar,
    Value<int>? tagsCount,
    Value<String?>? metadata,
    Value<int>? rowid,
  }) {
    return ManifestosCompanion(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      channelId: channelId ?? this.channelId,
      caption: caption ?? this.caption,
      videoUrl: videoUrl ?? this.videoUrl,
      videoUrls: videoUrls ?? this.videoUrls,
      imageUrls: imageUrls ?? this.imageUrls,
      thumbnailUrls: thumbnailUrls ?? this.thumbnailUrls,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isPublic: isPublic ?? this.isPublic,
      allowComments: allowComments ?? this.allowComments,
      isPending: isPending ?? this.isPending,
      isLiked: isLiked ?? this.isLiked,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      createdAt: createdAt ?? this.createdAt,
      taggerName: taggerName ?? this.taggerName,
      taggerAvatar: taggerAvatar ?? this.taggerAvatar,
      sourceChannelName: sourceChannelName ?? this.sourceChannelName,
      sourceChannelAvatar: sourceChannelAvatar ?? this.sourceChannelAvatar,
      tagsCount: tagsCount ?? this.tagsCount,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (profileImageUrl.present) {
      map['profile_image_url'] = Variable<String>(profileImageUrl.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (videoUrl.present) {
      map['video_url'] = Variable<String>(videoUrl.value);
    }
    if (videoUrls.present) {
      map['video_urls'] = Variable<String>(videoUrls.value);
    }
    if (imageUrls.present) {
      map['image_urls'] = Variable<String>(imageUrls.value);
    }
    if (thumbnailUrls.present) {
      map['thumbnail_urls'] = Variable<String>(thumbnailUrls.value);
    }
    if (likes.present) {
      map['likes'] = Variable<int>(likes.value);
    }
    if (comments.present) {
      map['comments'] = Variable<int>(comments.value);
    }
    if (isPublic.present) {
      map['is_public'] = Variable<int>(isPublic.value);
    }
    if (allowComments.present) {
      map['allow_comments'] = Variable<int>(allowComments.value);
    }
    if (isPending.present) {
      map['is_pending'] = Variable<int>(isPending.value);
    }
    if (isLiked.present) {
      map['is_liked'] = Variable<int>(isLiked.value);
    }
    if (aspectRatio.present) {
      map['aspect_ratio'] = Variable<double>(aspectRatio.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (taggerName.present) {
      map['tagger_name'] = Variable<String>(taggerName.value);
    }
    if (taggerAvatar.present) {
      map['tagger_avatar'] = Variable<String>(taggerAvatar.value);
    }
    if (sourceChannelName.present) {
      map['source_channel_name'] = Variable<String>(sourceChannelName.value);
    }
    if (sourceChannelAvatar.present) {
      map['source_channel_avatar'] = Variable<String>(
        sourceChannelAvatar.value,
      );
    }
    if (tagsCount.present) {
      map['tags_count'] = Variable<int>(tagsCount.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ManifestosCompanion(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('username: $username, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('channelId: $channelId, ')
          ..write('caption: $caption, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('videoUrls: $videoUrls, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('thumbnailUrls: $thumbnailUrls, ')
          ..write('likes: $likes, ')
          ..write('comments: $comments, ')
          ..write('isPublic: $isPublic, ')
          ..write('allowComments: $allowComments, ')
          ..write('isPending: $isPending, ')
          ..write('isLiked: $isLiked, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('createdAt: $createdAt, ')
          ..write('taggerName: $taggerName, ')
          ..write('taggerAvatar: $taggerAvatar, ')
          ..write('sourceChannelName: $sourceChannelName, ')
          ..write('sourceChannelAvatar: $sourceChannelAvatar, ')
          ..write('tagsCount: $tagsCount, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ManifestoCommentsTable extends ManifestoComments
    with TableInfo<$ManifestoCommentsTable, ManifestoComment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ManifestoCommentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manifestoIdMeta = const VerificationMeta(
    'manifestoId',
  );
  @override
  late final GeneratedColumn<String> manifestoId = GeneratedColumn<String>(
    'manifesto_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlsMeta = const VerificationMeta(
    'imageUrls',
  );
  @override
  late final GeneratedColumn<String> imageUrls = GeneratedColumn<String>(
    'image_urls',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _likesMeta = const VerificationMeta('likes');
  @override
  late final GeneratedColumn<int> likes = GeneratedColumn<int>(
    'likes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPendingMeta = const VerificationMeta(
    'isPending',
  );
  @override
  late final GeneratedColumn<int> isPending = GeneratedColumn<int>(
    'is_pending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    authorId,
    channelId,
    manifestoId,
    message,
    imageUrls,
    likes,
    isPending,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manifesto_comments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ManifestoComment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('manifesto_id')) {
      context.handle(
        _manifestoIdMeta,
        manifestoId.isAcceptableOrUnknown(
          data['manifesto_id']!,
          _manifestoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_manifestoIdMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    }
    if (data.containsKey('image_urls')) {
      context.handle(
        _imageUrlsMeta,
        imageUrls.isAcceptableOrUnknown(data['image_urls']!, _imageUrlsMeta),
      );
    }
    if (data.containsKey('likes')) {
      context.handle(
        _likesMeta,
        likes.isAcceptableOrUnknown(data['likes']!, _likesMeta),
      );
    }
    if (data.containsKey('is_pending')) {
      context.handle(
        _isPendingMeta,
        isPending.isAcceptableOrUnknown(data['is_pending']!, _isPendingMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ManifestoComment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ManifestoComment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      manifestoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manifesto_id'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      ),
      imageUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_urls'],
      )!,
      likes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}likes'],
      )!,
      isPending: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_pending'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ManifestoCommentsTable createAlias(String alias) {
    return $ManifestoCommentsTable(attachedDatabase, alias);
  }
}

class ManifestoComment extends DataClass
    implements Insertable<ManifestoComment> {
  final String id;
  final String authorId;
  final String channelId;
  final String manifestoId;
  final String? message;
  final String imageUrls;
  final int likes;
  final int isPending;
  final DateTime createdAt;
  const ManifestoComment({
    required this.id,
    required this.authorId,
    required this.channelId,
    required this.manifestoId,
    this.message,
    required this.imageUrls,
    required this.likes,
    required this.isPending,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['author_id'] = Variable<String>(authorId);
    map['channel_id'] = Variable<String>(channelId);
    map['manifesto_id'] = Variable<String>(manifestoId);
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    map['image_urls'] = Variable<String>(imageUrls);
    map['likes'] = Variable<int>(likes);
    map['is_pending'] = Variable<int>(isPending);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ManifestoCommentsCompanion toCompanion(bool nullToAbsent) {
    return ManifestoCommentsCompanion(
      id: Value(id),
      authorId: Value(authorId),
      channelId: Value(channelId),
      manifestoId: Value(manifestoId),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      imageUrls: Value(imageUrls),
      likes: Value(likes),
      isPending: Value(isPending),
      createdAt: Value(createdAt),
    );
  }

  factory ManifestoComment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ManifestoComment(
      id: serializer.fromJson<String>(json['id']),
      authorId: serializer.fromJson<String>(json['authorId']),
      channelId: serializer.fromJson<String>(json['channelId']),
      manifestoId: serializer.fromJson<String>(json['manifestoId']),
      message: serializer.fromJson<String?>(json['message']),
      imageUrls: serializer.fromJson<String>(json['imageUrls']),
      likes: serializer.fromJson<int>(json['likes']),
      isPending: serializer.fromJson<int>(json['isPending']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'authorId': serializer.toJson<String>(authorId),
      'channelId': serializer.toJson<String>(channelId),
      'manifestoId': serializer.toJson<String>(manifestoId),
      'message': serializer.toJson<String?>(message),
      'imageUrls': serializer.toJson<String>(imageUrls),
      'likes': serializer.toJson<int>(likes),
      'isPending': serializer.toJson<int>(isPending),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ManifestoComment copyWith({
    String? id,
    String? authorId,
    String? channelId,
    String? manifestoId,
    Value<String?> message = const Value.absent(),
    String? imageUrls,
    int? likes,
    int? isPending,
    DateTime? createdAt,
  }) => ManifestoComment(
    id: id ?? this.id,
    authorId: authorId ?? this.authorId,
    channelId: channelId ?? this.channelId,
    manifestoId: manifestoId ?? this.manifestoId,
    message: message.present ? message.value : this.message,
    imageUrls: imageUrls ?? this.imageUrls,
    likes: likes ?? this.likes,
    isPending: isPending ?? this.isPending,
    createdAt: createdAt ?? this.createdAt,
  );
  ManifestoComment copyWithCompanion(ManifestoCommentsCompanion data) {
    return ManifestoComment(
      id: data.id.present ? data.id.value : this.id,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      manifestoId: data.manifestoId.present
          ? data.manifestoId.value
          : this.manifestoId,
      message: data.message.present ? data.message.value : this.message,
      imageUrls: data.imageUrls.present ? data.imageUrls.value : this.imageUrls,
      likes: data.likes.present ? data.likes.value : this.likes,
      isPending: data.isPending.present ? data.isPending.value : this.isPending,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ManifestoComment(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('channelId: $channelId, ')
          ..write('manifestoId: $manifestoId, ')
          ..write('message: $message, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('likes: $likes, ')
          ..write('isPending: $isPending, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    authorId,
    channelId,
    manifestoId,
    message,
    imageUrls,
    likes,
    isPending,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ManifestoComment &&
          other.id == this.id &&
          other.authorId == this.authorId &&
          other.channelId == this.channelId &&
          other.manifestoId == this.manifestoId &&
          other.message == this.message &&
          other.imageUrls == this.imageUrls &&
          other.likes == this.likes &&
          other.isPending == this.isPending &&
          other.createdAt == this.createdAt);
}

class ManifestoCommentsCompanion extends UpdateCompanion<ManifestoComment> {
  final Value<String> id;
  final Value<String> authorId;
  final Value<String> channelId;
  final Value<String> manifestoId;
  final Value<String?> message;
  final Value<String> imageUrls;
  final Value<int> likes;
  final Value<int> isPending;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ManifestoCommentsCompanion({
    this.id = const Value.absent(),
    this.authorId = const Value.absent(),
    this.channelId = const Value.absent(),
    this.manifestoId = const Value.absent(),
    this.message = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.likes = const Value.absent(),
    this.isPending = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ManifestoCommentsCompanion.insert({
    required String id,
    required String authorId,
    required String channelId,
    required String manifestoId,
    this.message = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.likes = const Value.absent(),
    this.isPending = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       authorId = Value(authorId),
       channelId = Value(channelId),
       manifestoId = Value(manifestoId);
  static Insertable<ManifestoComment> custom({
    Expression<String>? id,
    Expression<String>? authorId,
    Expression<String>? channelId,
    Expression<String>? manifestoId,
    Expression<String>? message,
    Expression<String>? imageUrls,
    Expression<int>? likes,
    Expression<int>? isPending,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (authorId != null) 'author_id': authorId,
      if (channelId != null) 'channel_id': channelId,
      if (manifestoId != null) 'manifesto_id': manifestoId,
      if (message != null) 'message': message,
      if (imageUrls != null) 'image_urls': imageUrls,
      if (likes != null) 'likes': likes,
      if (isPending != null) 'is_pending': isPending,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ManifestoCommentsCompanion copyWith({
    Value<String>? id,
    Value<String>? authorId,
    Value<String>? channelId,
    Value<String>? manifestoId,
    Value<String?>? message,
    Value<String>? imageUrls,
    Value<int>? likes,
    Value<int>? isPending,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ManifestoCommentsCompanion(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      channelId: channelId ?? this.channelId,
      manifestoId: manifestoId ?? this.manifestoId,
      message: message ?? this.message,
      imageUrls: imageUrls ?? this.imageUrls,
      likes: likes ?? this.likes,
      isPending: isPending ?? this.isPending,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (manifestoId.present) {
      map['manifesto_id'] = Variable<String>(manifestoId.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (imageUrls.present) {
      map['image_urls'] = Variable<String>(imageUrls.value);
    }
    if (likes.present) {
      map['likes'] = Variable<int>(likes.value);
    }
    if (isPending.present) {
      map['is_pending'] = Variable<int>(isPending.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ManifestoCommentsCompanion(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('channelId: $channelId, ')
          ..write('manifestoId: $manifestoId, ')
          ..write('message: $message, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('likes: $likes, ')
          ..write('isPending: $isPending, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelsTable extends Channels with TableInfo<$ChannelsTable, Channel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPrivateMeta = const VerificationMeta(
    'isPrivate',
  );
  @override
  late final GeneratedColumn<int> isPrivate = GeneratedColumn<int>(
    'is_private',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ageRestrictionMeta = const VerificationMeta(
    'ageRestriction',
  );
  @override
  late final GeneratedColumn<String> ageRestriction = GeneratedColumn<String>(
    'age_restriction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('All Ages'),
  );
  static const VerificationMeta _joinMethodMeta = const VerificationMeta(
    'joinMethod',
  );
  @override
  late final GeneratedColumn<String> joinMethod = GeneratedColumn<String>(
    'join_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('invite'),
  );
  static const VerificationMeta _preventLeavingMeta = const VerificationMeta(
    'preventLeaving',
  );
  @override
  late final GeneratedColumn<int> preventLeaving = GeneratedColumn<int>(
    'prevent_leaving',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _countryRestrictionsMeta =
      const VerificationMeta('countryRestrictions');
  @override
  late final GeneratedColumn<String> countryRestrictions =
      GeneratedColumn<String>(
        'country_restrictions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('["Global"]'),
      );
  static const VerificationMeta _allowCommentingByMeta = const VerificationMeta(
    'allowCommentingBy',
  );
  @override
  late final GeneratedColumn<String> allowCommentingBy =
      GeneratedColumn<String>(
        'allow_commenting_by',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('all'),
      );
  static const VerificationMeta _allowStatusPostingByMeta =
      const VerificationMeta('allowStatusPostingBy');
  @override
  late final GeneratedColumn<String> allowStatusPostingBy =
      GeneratedColumn<String>(
        'allow_status_posting_by',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('all'),
      );
  static const VerificationMeta _allowInvitationsByMeta =
      const VerificationMeta('allowInvitationsBy');
  @override
  late final GeneratedColumn<String> allowInvitationsBy =
      GeneratedColumn<String>(
        'allow_invitations_by',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('all'),
      );
  static const VerificationMeta _visibleToOtherChannelMembersMeta =
      const VerificationMeta('visibleToOtherChannelMembers');
  @override
  late final GeneratedColumn<int> visibleToOtherChannelMembers =
      GeneratedColumn<int>(
        'visible_to_other_channel_members',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _visibleToFollowedUsersMeta =
      const VerificationMeta('visibleToFollowedUsers');
  @override
  late final GeneratedColumn<int> visibleToFollowedUsers = GeneratedColumn<int>(
    'visible_to_followed_users',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDiscoverableMeta = const VerificationMeta(
    'isDiscoverable',
  );
  @override
  late final GeneratedColumn<int> isDiscoverable = GeneratedColumn<int>(
    'is_discoverable',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _membersCountMeta = const VerificationMeta(
    'membersCount',
  );
  @override
  late final GeneratedColumn<int> membersCount = GeneratedColumn<int>(
    'members_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _followersCountMeta = const VerificationMeta(
    'followersCount',
  );
  @override
  late final GeneratedColumn<int> followersCount = GeneratedColumn<int>(
    'followers_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tagsCountMeta = const VerificationMeta(
    'tagsCount',
  );
  @override
  late final GeneratedColumn<int> tagsCount = GeneratedColumn<int>(
    'tags_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _likesCountMeta = const VerificationMeta(
    'likesCount',
  );
  @override
  late final GeneratedColumn<int> likesCount = GeneratedColumn<int>(
    'likes_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    title,
    subtitle,
    imageUrl,
    isPrivate,
    ageRestriction,
    joinMethod,
    preventLeaving,
    countryRestrictions,
    allowCommentingBy,
    allowStatusPostingBy,
    allowInvitationsBy,
    visibleToOtherChannelMembers,
    visibleToFollowedUsers,
    isDiscoverable,
    membersCount,
    followersCount,
    tagsCount,
    likesCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channels';
  @override
  VerificationContext validateIntegrity(
    Insertable<Channel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['description']!, _subtitleMeta),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['avatar_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('is_private')) {
      context.handle(
        _isPrivateMeta,
        isPrivate.isAcceptableOrUnknown(data['is_private']!, _isPrivateMeta),
      );
    }
    if (data.containsKey('age_restriction')) {
      context.handle(
        _ageRestrictionMeta,
        ageRestriction.isAcceptableOrUnknown(
          data['age_restriction']!,
          _ageRestrictionMeta,
        ),
      );
    }
    if (data.containsKey('join_method')) {
      context.handle(
        _joinMethodMeta,
        joinMethod.isAcceptableOrUnknown(data['join_method']!, _joinMethodMeta),
      );
    }
    if (data.containsKey('prevent_leaving')) {
      context.handle(
        _preventLeavingMeta,
        preventLeaving.isAcceptableOrUnknown(
          data['prevent_leaving']!,
          _preventLeavingMeta,
        ),
      );
    }
    if (data.containsKey('country_restrictions')) {
      context.handle(
        _countryRestrictionsMeta,
        countryRestrictions.isAcceptableOrUnknown(
          data['country_restrictions']!,
          _countryRestrictionsMeta,
        ),
      );
    }
    if (data.containsKey('allow_commenting_by')) {
      context.handle(
        _allowCommentingByMeta,
        allowCommentingBy.isAcceptableOrUnknown(
          data['allow_commenting_by']!,
          _allowCommentingByMeta,
        ),
      );
    }
    if (data.containsKey('allow_status_posting_by')) {
      context.handle(
        _allowStatusPostingByMeta,
        allowStatusPostingBy.isAcceptableOrUnknown(
          data['allow_status_posting_by']!,
          _allowStatusPostingByMeta,
        ),
      );
    }
    if (data.containsKey('allow_invitations_by')) {
      context.handle(
        _allowInvitationsByMeta,
        allowInvitationsBy.isAcceptableOrUnknown(
          data['allow_invitations_by']!,
          _allowInvitationsByMeta,
        ),
      );
    }
    if (data.containsKey('visible_to_other_channel_members')) {
      context.handle(
        _visibleToOtherChannelMembersMeta,
        visibleToOtherChannelMembers.isAcceptableOrUnknown(
          data['visible_to_other_channel_members']!,
          _visibleToOtherChannelMembersMeta,
        ),
      );
    }
    if (data.containsKey('visible_to_followed_users')) {
      context.handle(
        _visibleToFollowedUsersMeta,
        visibleToFollowedUsers.isAcceptableOrUnknown(
          data['visible_to_followed_users']!,
          _visibleToFollowedUsersMeta,
        ),
      );
    }
    if (data.containsKey('is_discoverable')) {
      context.handle(
        _isDiscoverableMeta,
        isDiscoverable.isAcceptableOrUnknown(
          data['is_discoverable']!,
          _isDiscoverableMeta,
        ),
      );
    }
    if (data.containsKey('members_count')) {
      context.handle(
        _membersCountMeta,
        membersCount.isAcceptableOrUnknown(
          data['members_count']!,
          _membersCountMeta,
        ),
      );
    }
    if (data.containsKey('followers_count')) {
      context.handle(
        _followersCountMeta,
        followersCount.isAcceptableOrUnknown(
          data['followers_count']!,
          _followersCountMeta,
        ),
      );
    }
    if (data.containsKey('tags_count')) {
      context.handle(
        _tagsCountMeta,
        tagsCount.isAcceptableOrUnknown(data['tags_count']!, _tagsCountMeta),
      );
    }
    if (data.containsKey('likes_count')) {
      context.handle(
        _likesCountMeta,
        likesCount.isAcceptableOrUnknown(data['likes_count']!, _likesCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Channel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Channel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      isPrivate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_private'],
      )!,
      ageRestriction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}age_restriction'],
      )!,
      joinMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}join_method'],
      )!,
      preventLeaving: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prevent_leaving'],
      )!,
      countryRestrictions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_restrictions'],
      )!,
      allowCommentingBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allow_commenting_by'],
      )!,
      allowStatusPostingBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allow_status_posting_by'],
      )!,
      allowInvitationsBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allow_invitations_by'],
      )!,
      visibleToOtherChannelMembers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visible_to_other_channel_members'],
      )!,
      visibleToFollowedUsers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visible_to_followed_users'],
      )!,
      isDiscoverable: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_discoverable'],
      )!,
      membersCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}members_count'],
      )!,
      followersCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}followers_count'],
      )!,
      tagsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tags_count'],
      )!,
      likesCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}likes_count'],
      )!,
    );
  }

  @override
  $ChannelsTable createAlias(String alias) {
    return $ChannelsTable(attachedDatabase, alias);
  }
}

class Channel extends DataClass implements Insertable<Channel> {
  final String id;
  final String? name;
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final int isPrivate;
  final String ageRestriction;
  final String joinMethod;
  final int preventLeaving;
  final String countryRestrictions;
  final String allowCommentingBy;
  final String allowStatusPostingBy;
  final String allowInvitationsBy;
  final int visibleToOtherChannelMembers;
  final int visibleToFollowedUsers;
  final int isDiscoverable;
  final int membersCount;
  final int followersCount;
  final int tagsCount;
  final int likesCount;
  const Channel({
    required this.id,
    this.name,
    this.title,
    this.subtitle,
    this.imageUrl,
    required this.isPrivate,
    required this.ageRestriction,
    required this.joinMethod,
    required this.preventLeaving,
    required this.countryRestrictions,
    required this.allowCommentingBy,
    required this.allowStatusPostingBy,
    required this.allowInvitationsBy,
    required this.visibleToOtherChannelMembers,
    required this.visibleToFollowedUsers,
    required this.isDiscoverable,
    required this.membersCount,
    required this.followersCount,
    required this.tagsCount,
    required this.likesCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || subtitle != null) {
      map['description'] = Variable<String>(subtitle);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['avatar_url'] = Variable<String>(imageUrl);
    }
    map['is_private'] = Variable<int>(isPrivate);
    map['age_restriction'] = Variable<String>(ageRestriction);
    map['join_method'] = Variable<String>(joinMethod);
    map['prevent_leaving'] = Variable<int>(preventLeaving);
    map['country_restrictions'] = Variable<String>(countryRestrictions);
    map['allow_commenting_by'] = Variable<String>(allowCommentingBy);
    map['allow_status_posting_by'] = Variable<String>(allowStatusPostingBy);
    map['allow_invitations_by'] = Variable<String>(allowInvitationsBy);
    map['visible_to_other_channel_members'] = Variable<int>(
      visibleToOtherChannelMembers,
    );
    map['visible_to_followed_users'] = Variable<int>(visibleToFollowedUsers);
    map['is_discoverable'] = Variable<int>(isDiscoverable);
    map['members_count'] = Variable<int>(membersCount);
    map['followers_count'] = Variable<int>(followersCount);
    map['tags_count'] = Variable<int>(tagsCount);
    map['likes_count'] = Variable<int>(likesCount);
    return map;
  }

  ChannelsCompanion toCompanion(bool nullToAbsent) {
    return ChannelsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      isPrivate: Value(isPrivate),
      ageRestriction: Value(ageRestriction),
      joinMethod: Value(joinMethod),
      preventLeaving: Value(preventLeaving),
      countryRestrictions: Value(countryRestrictions),
      allowCommentingBy: Value(allowCommentingBy),
      allowStatusPostingBy: Value(allowStatusPostingBy),
      allowInvitationsBy: Value(allowInvitationsBy),
      visibleToOtherChannelMembers: Value(visibleToOtherChannelMembers),
      visibleToFollowedUsers: Value(visibleToFollowedUsers),
      isDiscoverable: Value(isDiscoverable),
      membersCount: Value(membersCount),
      followersCount: Value(followersCount),
      tagsCount: Value(tagsCount),
      likesCount: Value(likesCount),
    );
  }

  factory Channel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Channel(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      title: serializer.fromJson<String?>(json['title']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      isPrivate: serializer.fromJson<int>(json['isPrivate']),
      ageRestriction: serializer.fromJson<String>(json['ageRestriction']),
      joinMethod: serializer.fromJson<String>(json['joinMethod']),
      preventLeaving: serializer.fromJson<int>(json['preventLeaving']),
      countryRestrictions: serializer.fromJson<String>(
        json['countryRestrictions'],
      ),
      allowCommentingBy: serializer.fromJson<String>(json['allowCommentingBy']),
      allowStatusPostingBy: serializer.fromJson<String>(
        json['allowStatusPostingBy'],
      ),
      allowInvitationsBy: serializer.fromJson<String>(
        json['allowInvitationsBy'],
      ),
      visibleToOtherChannelMembers: serializer.fromJson<int>(
        json['visibleToOtherChannelMembers'],
      ),
      visibleToFollowedUsers: serializer.fromJson<int>(
        json['visibleToFollowedUsers'],
      ),
      isDiscoverable: serializer.fromJson<int>(json['isDiscoverable']),
      membersCount: serializer.fromJson<int>(json['membersCount']),
      followersCount: serializer.fromJson<int>(json['followersCount']),
      tagsCount: serializer.fromJson<int>(json['tagsCount']),
      likesCount: serializer.fromJson<int>(json['likesCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'title': serializer.toJson<String?>(title),
      'subtitle': serializer.toJson<String?>(subtitle),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'isPrivate': serializer.toJson<int>(isPrivate),
      'ageRestriction': serializer.toJson<String>(ageRestriction),
      'joinMethod': serializer.toJson<String>(joinMethod),
      'preventLeaving': serializer.toJson<int>(preventLeaving),
      'countryRestrictions': serializer.toJson<String>(countryRestrictions),
      'allowCommentingBy': serializer.toJson<String>(allowCommentingBy),
      'allowStatusPostingBy': serializer.toJson<String>(allowStatusPostingBy),
      'allowInvitationsBy': serializer.toJson<String>(allowInvitationsBy),
      'visibleToOtherChannelMembers': serializer.toJson<int>(
        visibleToOtherChannelMembers,
      ),
      'visibleToFollowedUsers': serializer.toJson<int>(visibleToFollowedUsers),
      'isDiscoverable': serializer.toJson<int>(isDiscoverable),
      'membersCount': serializer.toJson<int>(membersCount),
      'followersCount': serializer.toJson<int>(followersCount),
      'tagsCount': serializer.toJson<int>(tagsCount),
      'likesCount': serializer.toJson<int>(likesCount),
    };
  }

  Channel copyWith({
    String? id,
    Value<String?> name = const Value.absent(),
    Value<String?> title = const Value.absent(),
    Value<String?> subtitle = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    int? isPrivate,
    String? ageRestriction,
    String? joinMethod,
    int? preventLeaving,
    String? countryRestrictions,
    String? allowCommentingBy,
    String? allowStatusPostingBy,
    String? allowInvitationsBy,
    int? visibleToOtherChannelMembers,
    int? visibleToFollowedUsers,
    int? isDiscoverable,
    int? membersCount,
    int? followersCount,
    int? tagsCount,
    int? likesCount,
  }) => Channel(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    title: title.present ? title.value : this.title,
    subtitle: subtitle.present ? subtitle.value : this.subtitle,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    isPrivate: isPrivate ?? this.isPrivate,
    ageRestriction: ageRestriction ?? this.ageRestriction,
    joinMethod: joinMethod ?? this.joinMethod,
    preventLeaving: preventLeaving ?? this.preventLeaving,
    countryRestrictions: countryRestrictions ?? this.countryRestrictions,
    allowCommentingBy: allowCommentingBy ?? this.allowCommentingBy,
    allowStatusPostingBy: allowStatusPostingBy ?? this.allowStatusPostingBy,
    allowInvitationsBy: allowInvitationsBy ?? this.allowInvitationsBy,
    visibleToOtherChannelMembers:
        visibleToOtherChannelMembers ?? this.visibleToOtherChannelMembers,
    visibleToFollowedUsers:
        visibleToFollowedUsers ?? this.visibleToFollowedUsers,
    isDiscoverable: isDiscoverable ?? this.isDiscoverable,
    membersCount: membersCount ?? this.membersCount,
    followersCount: followersCount ?? this.followersCount,
    tagsCount: tagsCount ?? this.tagsCount,
    likesCount: likesCount ?? this.likesCount,
  );
  Channel copyWithCompanion(ChannelsCompanion data) {
    return Channel(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      isPrivate: data.isPrivate.present ? data.isPrivate.value : this.isPrivate,
      ageRestriction: data.ageRestriction.present
          ? data.ageRestriction.value
          : this.ageRestriction,
      joinMethod: data.joinMethod.present
          ? data.joinMethod.value
          : this.joinMethod,
      preventLeaving: data.preventLeaving.present
          ? data.preventLeaving.value
          : this.preventLeaving,
      countryRestrictions: data.countryRestrictions.present
          ? data.countryRestrictions.value
          : this.countryRestrictions,
      allowCommentingBy: data.allowCommentingBy.present
          ? data.allowCommentingBy.value
          : this.allowCommentingBy,
      allowStatusPostingBy: data.allowStatusPostingBy.present
          ? data.allowStatusPostingBy.value
          : this.allowStatusPostingBy,
      allowInvitationsBy: data.allowInvitationsBy.present
          ? data.allowInvitationsBy.value
          : this.allowInvitationsBy,
      visibleToOtherChannelMembers: data.visibleToOtherChannelMembers.present
          ? data.visibleToOtherChannelMembers.value
          : this.visibleToOtherChannelMembers,
      visibleToFollowedUsers: data.visibleToFollowedUsers.present
          ? data.visibleToFollowedUsers.value
          : this.visibleToFollowedUsers,
      isDiscoverable: data.isDiscoverable.present
          ? data.isDiscoverable.value
          : this.isDiscoverable,
      membersCount: data.membersCount.present
          ? data.membersCount.value
          : this.membersCount,
      followersCount: data.followersCount.present
          ? data.followersCount.value
          : this.followersCount,
      tagsCount: data.tagsCount.present ? data.tagsCount.value : this.tagsCount,
      likesCount: data.likesCount.present
          ? data.likesCount.value
          : this.likesCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Channel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('ageRestriction: $ageRestriction, ')
          ..write('joinMethod: $joinMethod, ')
          ..write('preventLeaving: $preventLeaving, ')
          ..write('countryRestrictions: $countryRestrictions, ')
          ..write('allowCommentingBy: $allowCommentingBy, ')
          ..write('allowStatusPostingBy: $allowStatusPostingBy, ')
          ..write('allowInvitationsBy: $allowInvitationsBy, ')
          ..write(
            'visibleToOtherChannelMembers: $visibleToOtherChannelMembers, ',
          )
          ..write('visibleToFollowedUsers: $visibleToFollowedUsers, ')
          ..write('isDiscoverable: $isDiscoverable, ')
          ..write('membersCount: $membersCount, ')
          ..write('followersCount: $followersCount, ')
          ..write('tagsCount: $tagsCount, ')
          ..write('likesCount: $likesCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    title,
    subtitle,
    imageUrl,
    isPrivate,
    ageRestriction,
    joinMethod,
    preventLeaving,
    countryRestrictions,
    allowCommentingBy,
    allowStatusPostingBy,
    allowInvitationsBy,
    visibleToOtherChannelMembers,
    visibleToFollowedUsers,
    isDiscoverable,
    membersCount,
    followersCount,
    tagsCount,
    likesCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Channel &&
          other.id == this.id &&
          other.name == this.name &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.imageUrl == this.imageUrl &&
          other.isPrivate == this.isPrivate &&
          other.ageRestriction == this.ageRestriction &&
          other.joinMethod == this.joinMethod &&
          other.preventLeaving == this.preventLeaving &&
          other.countryRestrictions == this.countryRestrictions &&
          other.allowCommentingBy == this.allowCommentingBy &&
          other.allowStatusPostingBy == this.allowStatusPostingBy &&
          other.allowInvitationsBy == this.allowInvitationsBy &&
          other.visibleToOtherChannelMembers ==
              this.visibleToOtherChannelMembers &&
          other.visibleToFollowedUsers == this.visibleToFollowedUsers &&
          other.isDiscoverable == this.isDiscoverable &&
          other.membersCount == this.membersCount &&
          other.followersCount == this.followersCount &&
          other.tagsCount == this.tagsCount &&
          other.likesCount == this.likesCount);
}

class ChannelsCompanion extends UpdateCompanion<Channel> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> title;
  final Value<String?> subtitle;
  final Value<String?> imageUrl;
  final Value<int> isPrivate;
  final Value<String> ageRestriction;
  final Value<String> joinMethod;
  final Value<int> preventLeaving;
  final Value<String> countryRestrictions;
  final Value<String> allowCommentingBy;
  final Value<String> allowStatusPostingBy;
  final Value<String> allowInvitationsBy;
  final Value<int> visibleToOtherChannelMembers;
  final Value<int> visibleToFollowedUsers;
  final Value<int> isDiscoverable;
  final Value<int> membersCount;
  final Value<int> followersCount;
  final Value<int> tagsCount;
  final Value<int> likesCount;
  final Value<int> rowid;
  const ChannelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.ageRestriction = const Value.absent(),
    this.joinMethod = const Value.absent(),
    this.preventLeaving = const Value.absent(),
    this.countryRestrictions = const Value.absent(),
    this.allowCommentingBy = const Value.absent(),
    this.allowStatusPostingBy = const Value.absent(),
    this.allowInvitationsBy = const Value.absent(),
    this.visibleToOtherChannelMembers = const Value.absent(),
    this.visibleToFollowedUsers = const Value.absent(),
    this.isDiscoverable = const Value.absent(),
    this.membersCount = const Value.absent(),
    this.followersCount = const Value.absent(),
    this.tagsCount = const Value.absent(),
    this.likesCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelsCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.ageRestriction = const Value.absent(),
    this.joinMethod = const Value.absent(),
    this.preventLeaving = const Value.absent(),
    this.countryRestrictions = const Value.absent(),
    this.allowCommentingBy = const Value.absent(),
    this.allowStatusPostingBy = const Value.absent(),
    this.allowInvitationsBy = const Value.absent(),
    this.visibleToOtherChannelMembers = const Value.absent(),
    this.visibleToFollowedUsers = const Value.absent(),
    this.isDiscoverable = const Value.absent(),
    this.membersCount = const Value.absent(),
    this.followersCount = const Value.absent(),
    this.tagsCount = const Value.absent(),
    this.likesCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Channel> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<String>? imageUrl,
    Expression<int>? isPrivate,
    Expression<String>? ageRestriction,
    Expression<String>? joinMethod,
    Expression<int>? preventLeaving,
    Expression<String>? countryRestrictions,
    Expression<String>? allowCommentingBy,
    Expression<String>? allowStatusPostingBy,
    Expression<String>? allowInvitationsBy,
    Expression<int>? visibleToOtherChannelMembers,
    Expression<int>? visibleToFollowedUsers,
    Expression<int>? isDiscoverable,
    Expression<int>? membersCount,
    Expression<int>? followersCount,
    Expression<int>? tagsCount,
    Expression<int>? likesCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (title != null) 'title': title,
      if (subtitle != null) 'description': subtitle,
      if (imageUrl != null) 'avatar_url': imageUrl,
      if (isPrivate != null) 'is_private': isPrivate,
      if (ageRestriction != null) 'age_restriction': ageRestriction,
      if (joinMethod != null) 'join_method': joinMethod,
      if (preventLeaving != null) 'prevent_leaving': preventLeaving,
      if (countryRestrictions != null)
        'country_restrictions': countryRestrictions,
      if (allowCommentingBy != null) 'allow_commenting_by': allowCommentingBy,
      if (allowStatusPostingBy != null)
        'allow_status_posting_by': allowStatusPostingBy,
      if (allowInvitationsBy != null)
        'allow_invitations_by': allowInvitationsBy,
      if (visibleToOtherChannelMembers != null)
        'visible_to_other_channel_members': visibleToOtherChannelMembers,
      if (visibleToFollowedUsers != null)
        'visible_to_followed_users': visibleToFollowedUsers,
      if (isDiscoverable != null) 'is_discoverable': isDiscoverable,
      if (membersCount != null) 'members_count': membersCount,
      if (followersCount != null) 'followers_count': followersCount,
      if (tagsCount != null) 'tags_count': tagsCount,
      if (likesCount != null) 'likes_count': likesCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelsCompanion copyWith({
    Value<String>? id,
    Value<String?>? name,
    Value<String?>? title,
    Value<String?>? subtitle,
    Value<String?>? imageUrl,
    Value<int>? isPrivate,
    Value<String>? ageRestriction,
    Value<String>? joinMethod,
    Value<int>? preventLeaving,
    Value<String>? countryRestrictions,
    Value<String>? allowCommentingBy,
    Value<String>? allowStatusPostingBy,
    Value<String>? allowInvitationsBy,
    Value<int>? visibleToOtherChannelMembers,
    Value<int>? visibleToFollowedUsers,
    Value<int>? isDiscoverable,
    Value<int>? membersCount,
    Value<int>? followersCount,
    Value<int>? tagsCount,
    Value<int>? likesCount,
    Value<int>? rowid,
  }) {
    return ChannelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      isPrivate: isPrivate ?? this.isPrivate,
      ageRestriction: ageRestriction ?? this.ageRestriction,
      joinMethod: joinMethod ?? this.joinMethod,
      preventLeaving: preventLeaving ?? this.preventLeaving,
      countryRestrictions: countryRestrictions ?? this.countryRestrictions,
      allowCommentingBy: allowCommentingBy ?? this.allowCommentingBy,
      allowStatusPostingBy: allowStatusPostingBy ?? this.allowStatusPostingBy,
      allowInvitationsBy: allowInvitationsBy ?? this.allowInvitationsBy,
      visibleToOtherChannelMembers:
          visibleToOtherChannelMembers ?? this.visibleToOtherChannelMembers,
      visibleToFollowedUsers:
          visibleToFollowedUsers ?? this.visibleToFollowedUsers,
      isDiscoverable: isDiscoverable ?? this.isDiscoverable,
      membersCount: membersCount ?? this.membersCount,
      followersCount: followersCount ?? this.followersCount,
      tagsCount: tagsCount ?? this.tagsCount,
      likesCount: likesCount ?? this.likesCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['description'] = Variable<String>(subtitle.value);
    }
    if (imageUrl.present) {
      map['avatar_url'] = Variable<String>(imageUrl.value);
    }
    if (isPrivate.present) {
      map['is_private'] = Variable<int>(isPrivate.value);
    }
    if (ageRestriction.present) {
      map['age_restriction'] = Variable<String>(ageRestriction.value);
    }
    if (joinMethod.present) {
      map['join_method'] = Variable<String>(joinMethod.value);
    }
    if (preventLeaving.present) {
      map['prevent_leaving'] = Variable<int>(preventLeaving.value);
    }
    if (countryRestrictions.present) {
      map['country_restrictions'] = Variable<String>(countryRestrictions.value);
    }
    if (allowCommentingBy.present) {
      map['allow_commenting_by'] = Variable<String>(allowCommentingBy.value);
    }
    if (allowStatusPostingBy.present) {
      map['allow_status_posting_by'] = Variable<String>(
        allowStatusPostingBy.value,
      );
    }
    if (allowInvitationsBy.present) {
      map['allow_invitations_by'] = Variable<String>(allowInvitationsBy.value);
    }
    if (visibleToOtherChannelMembers.present) {
      map['visible_to_other_channel_members'] = Variable<int>(
        visibleToOtherChannelMembers.value,
      );
    }
    if (visibleToFollowedUsers.present) {
      map['visible_to_followed_users'] = Variable<int>(
        visibleToFollowedUsers.value,
      );
    }
    if (isDiscoverable.present) {
      map['is_discoverable'] = Variable<int>(isDiscoverable.value);
    }
    if (membersCount.present) {
      map['members_count'] = Variable<int>(membersCount.value);
    }
    if (followersCount.present) {
      map['followers_count'] = Variable<int>(followersCount.value);
    }
    if (tagsCount.present) {
      map['tags_count'] = Variable<int>(tagsCount.value);
    }
    if (likesCount.present) {
      map['likes_count'] = Variable<int>(likesCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('ageRestriction: $ageRestriction, ')
          ..write('joinMethod: $joinMethod, ')
          ..write('preventLeaving: $preventLeaving, ')
          ..write('countryRestrictions: $countryRestrictions, ')
          ..write('allowCommentingBy: $allowCommentingBy, ')
          ..write('allowStatusPostingBy: $allowStatusPostingBy, ')
          ..write('allowInvitationsBy: $allowInvitationsBy, ')
          ..write(
            'visibleToOtherChannelMembers: $visibleToOtherChannelMembers, ',
          )
          ..write('visibleToFollowedUsers: $visibleToFollowedUsers, ')
          ..write('isDiscoverable: $isDiscoverable, ')
          ..write('membersCount: $membersCount, ')
          ..write('followersCount: $followersCount, ')
          ..write('tagsCount: $tagsCount, ')
          ..write('likesCount: $likesCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelMetadataTable extends ChannelMetadata
    with TableInfo<$ChannelMetadataTable, ChannelMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberCountMeta = const VerificationMeta(
    'memberCount',
  );
  @override
  late final GeneratedColumn<int> memberCount = GeneratedColumn<int>(
    'member_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _unreadCountMeta = const VerificationMeta(
    'unreadCount',
  );
  @override
  late final GeneratedColumn<int> unreadCount = GeneratedColumn<int>(
    'unread_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _postsBadgeCountMeta = const VerificationMeta(
    'postsBadgeCount',
  );
  @override
  late final GeneratedColumn<int> postsBadgeCount = GeneratedColumn<int>(
    'posts_badge_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _membersBadgeCountMeta = const VerificationMeta(
    'membersBadgeCount',
  );
  @override
  late final GeneratedColumn<int> membersBadgeCount = GeneratedColumn<int>(
    'members_badge_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _messagesBadgeCountMeta =
      const VerificationMeta('messagesBadgeCount');
  @override
  late final GeneratedColumn<int> messagesBadgeCount = GeneratedColumn<int>(
    'messages_badge_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isChartedMeta = const VerificationMeta(
    'isCharted',
  );
  @override
  late final GeneratedColumn<int> isCharted = GeneratedColumn<int>(
    'is_charted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPendingMeta = const VerificationMeta(
    'isPending',
  );
  @override
  late final GeneratedColumn<int> isPending = GeneratedColumn<int>(
    'is_pending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastMessageAtMeta = const VerificationMeta(
    'lastMessageAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastMessageAt =
      GeneratedColumn<DateTime>(
        'last_message_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    channelId,
    memberCount,
    unreadCount,
    postsBadgeCount,
    membersBadgeCount,
    messagesBadgeCount,
    isCharted,
    isPending,
    createdAt,
    lastMessageAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('member_count')) {
      context.handle(
        _memberCountMeta,
        memberCount.isAcceptableOrUnknown(
          data['member_count']!,
          _memberCountMeta,
        ),
      );
    }
    if (data.containsKey('unread_count')) {
      context.handle(
        _unreadCountMeta,
        unreadCount.isAcceptableOrUnknown(
          data['unread_count']!,
          _unreadCountMeta,
        ),
      );
    }
    if (data.containsKey('posts_badge_count')) {
      context.handle(
        _postsBadgeCountMeta,
        postsBadgeCount.isAcceptableOrUnknown(
          data['posts_badge_count']!,
          _postsBadgeCountMeta,
        ),
      );
    }
    if (data.containsKey('members_badge_count')) {
      context.handle(
        _membersBadgeCountMeta,
        membersBadgeCount.isAcceptableOrUnknown(
          data['members_badge_count']!,
          _membersBadgeCountMeta,
        ),
      );
    }
    if (data.containsKey('messages_badge_count')) {
      context.handle(
        _messagesBadgeCountMeta,
        messagesBadgeCount.isAcceptableOrUnknown(
          data['messages_badge_count']!,
          _messagesBadgeCountMeta,
        ),
      );
    }
    if (data.containsKey('is_charted')) {
      context.handle(
        _isChartedMeta,
        isCharted.isAcceptableOrUnknown(data['is_charted']!, _isChartedMeta),
      );
    }
    if (data.containsKey('is_pending')) {
      context.handle(
        _isPendingMeta,
        isPending.isAcceptableOrUnknown(data['is_pending']!, _isPendingMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
        _lastMessageAtMeta,
        lastMessageAt.isAcceptableOrUnknown(
          data['last_message_at']!,
          _lastMessageAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {channelId};
  @override
  ChannelMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelMetadataData(
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      memberCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_count'],
      ),
      unreadCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unread_count'],
      )!,
      postsBadgeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}posts_badge_count'],
      )!,
      membersBadgeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}members_badge_count'],
      )!,
      messagesBadgeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}messages_badge_count'],
      )!,
      isCharted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_charted'],
      )!,
      isPending: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_pending'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      lastMessageAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_message_at'],
      ),
    );
  }

  @override
  $ChannelMetadataTable createAlias(String alias) {
    return $ChannelMetadataTable(attachedDatabase, alias);
  }
}

class ChannelMetadataData extends DataClass
    implements Insertable<ChannelMetadataData> {
  final String channelId;
  final int? memberCount;
  final int unreadCount;
  final int postsBadgeCount;
  final int membersBadgeCount;
  final int messagesBadgeCount;
  final int isCharted;
  final int isPending;
  final DateTime? createdAt;
  final DateTime? lastMessageAt;
  const ChannelMetadataData({
    required this.channelId,
    this.memberCount,
    required this.unreadCount,
    required this.postsBadgeCount,
    required this.membersBadgeCount,
    required this.messagesBadgeCount,
    required this.isCharted,
    required this.isPending,
    this.createdAt,
    this.lastMessageAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['channel_id'] = Variable<String>(channelId);
    if (!nullToAbsent || memberCount != null) {
      map['member_count'] = Variable<int>(memberCount);
    }
    map['unread_count'] = Variable<int>(unreadCount);
    map['posts_badge_count'] = Variable<int>(postsBadgeCount);
    map['members_badge_count'] = Variable<int>(membersBadgeCount);
    map['messages_badge_count'] = Variable<int>(messagesBadgeCount);
    map['is_charted'] = Variable<int>(isCharted);
    map['is_pending'] = Variable<int>(isPending);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || lastMessageAt != null) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt);
    }
    return map;
  }

  ChannelMetadataCompanion toCompanion(bool nullToAbsent) {
    return ChannelMetadataCompanion(
      channelId: Value(channelId),
      memberCount: memberCount == null && nullToAbsent
          ? const Value.absent()
          : Value(memberCount),
      unreadCount: Value(unreadCount),
      postsBadgeCount: Value(postsBadgeCount),
      membersBadgeCount: Value(membersBadgeCount),
      messagesBadgeCount: Value(messagesBadgeCount),
      isCharted: Value(isCharted),
      isPending: Value(isPending),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      lastMessageAt: lastMessageAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageAt),
    );
  }

  factory ChannelMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelMetadataData(
      channelId: serializer.fromJson<String>(json['channelId']),
      memberCount: serializer.fromJson<int?>(json['memberCount']),
      unreadCount: serializer.fromJson<int>(json['unreadCount']),
      postsBadgeCount: serializer.fromJson<int>(json['postsBadgeCount']),
      membersBadgeCount: serializer.fromJson<int>(json['membersBadgeCount']),
      messagesBadgeCount: serializer.fromJson<int>(json['messagesBadgeCount']),
      isCharted: serializer.fromJson<int>(json['isCharted']),
      isPending: serializer.fromJson<int>(json['isPending']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      lastMessageAt: serializer.fromJson<DateTime?>(json['lastMessageAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'channelId': serializer.toJson<String>(channelId),
      'memberCount': serializer.toJson<int?>(memberCount),
      'unreadCount': serializer.toJson<int>(unreadCount),
      'postsBadgeCount': serializer.toJson<int>(postsBadgeCount),
      'membersBadgeCount': serializer.toJson<int>(membersBadgeCount),
      'messagesBadgeCount': serializer.toJson<int>(messagesBadgeCount),
      'isCharted': serializer.toJson<int>(isCharted),
      'isPending': serializer.toJson<int>(isPending),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'lastMessageAt': serializer.toJson<DateTime?>(lastMessageAt),
    };
  }

  ChannelMetadataData copyWith({
    String? channelId,
    Value<int?> memberCount = const Value.absent(),
    int? unreadCount,
    int? postsBadgeCount,
    int? membersBadgeCount,
    int? messagesBadgeCount,
    int? isCharted,
    int? isPending,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> lastMessageAt = const Value.absent(),
  }) => ChannelMetadataData(
    channelId: channelId ?? this.channelId,
    memberCount: memberCount.present ? memberCount.value : this.memberCount,
    unreadCount: unreadCount ?? this.unreadCount,
    postsBadgeCount: postsBadgeCount ?? this.postsBadgeCount,
    membersBadgeCount: membersBadgeCount ?? this.membersBadgeCount,
    messagesBadgeCount: messagesBadgeCount ?? this.messagesBadgeCount,
    isCharted: isCharted ?? this.isCharted,
    isPending: isPending ?? this.isPending,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    lastMessageAt: lastMessageAt.present
        ? lastMessageAt.value
        : this.lastMessageAt,
  );
  ChannelMetadataData copyWithCompanion(ChannelMetadataCompanion data) {
    return ChannelMetadataData(
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      memberCount: data.memberCount.present
          ? data.memberCount.value
          : this.memberCount,
      unreadCount: data.unreadCount.present
          ? data.unreadCount.value
          : this.unreadCount,
      postsBadgeCount: data.postsBadgeCount.present
          ? data.postsBadgeCount.value
          : this.postsBadgeCount,
      membersBadgeCount: data.membersBadgeCount.present
          ? data.membersBadgeCount.value
          : this.membersBadgeCount,
      messagesBadgeCount: data.messagesBadgeCount.present
          ? data.messagesBadgeCount.value
          : this.messagesBadgeCount,
      isCharted: data.isCharted.present ? data.isCharted.value : this.isCharted,
      isPending: data.isPending.present ? data.isPending.value : this.isPending,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastMessageAt: data.lastMessageAt.present
          ? data.lastMessageAt.value
          : this.lastMessageAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelMetadataData(')
          ..write('channelId: $channelId, ')
          ..write('memberCount: $memberCount, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('postsBadgeCount: $postsBadgeCount, ')
          ..write('membersBadgeCount: $membersBadgeCount, ')
          ..write('messagesBadgeCount: $messagesBadgeCount, ')
          ..write('isCharted: $isCharted, ')
          ..write('isPending: $isPending, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastMessageAt: $lastMessageAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    channelId,
    memberCount,
    unreadCount,
    postsBadgeCount,
    membersBadgeCount,
    messagesBadgeCount,
    isCharted,
    isPending,
    createdAt,
    lastMessageAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelMetadataData &&
          other.channelId == this.channelId &&
          other.memberCount == this.memberCount &&
          other.unreadCount == this.unreadCount &&
          other.postsBadgeCount == this.postsBadgeCount &&
          other.membersBadgeCount == this.membersBadgeCount &&
          other.messagesBadgeCount == this.messagesBadgeCount &&
          other.isCharted == this.isCharted &&
          other.isPending == this.isPending &&
          other.createdAt == this.createdAt &&
          other.lastMessageAt == this.lastMessageAt);
}

class ChannelMetadataCompanion extends UpdateCompanion<ChannelMetadataData> {
  final Value<String> channelId;
  final Value<int?> memberCount;
  final Value<int> unreadCount;
  final Value<int> postsBadgeCount;
  final Value<int> membersBadgeCount;
  final Value<int> messagesBadgeCount;
  final Value<int> isCharted;
  final Value<int> isPending;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> lastMessageAt;
  final Value<int> rowid;
  const ChannelMetadataCompanion({
    this.channelId = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.postsBadgeCount = const Value.absent(),
    this.membersBadgeCount = const Value.absent(),
    this.messagesBadgeCount = const Value.absent(),
    this.isCharted = const Value.absent(),
    this.isPending = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelMetadataCompanion.insert({
    required String channelId,
    this.memberCount = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.postsBadgeCount = const Value.absent(),
    this.membersBadgeCount = const Value.absent(),
    this.messagesBadgeCount = const Value.absent(),
    this.isCharted = const Value.absent(),
    this.isPending = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : channelId = Value(channelId);
  static Insertable<ChannelMetadataData> custom({
    Expression<String>? channelId,
    Expression<int>? memberCount,
    Expression<int>? unreadCount,
    Expression<int>? postsBadgeCount,
    Expression<int>? membersBadgeCount,
    Expression<int>? messagesBadgeCount,
    Expression<int>? isCharted,
    Expression<int>? isPending,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastMessageAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (channelId != null) 'channel_id': channelId,
      if (memberCount != null) 'member_count': memberCount,
      if (unreadCount != null) 'unread_count': unreadCount,
      if (postsBadgeCount != null) 'posts_badge_count': postsBadgeCount,
      if (membersBadgeCount != null) 'members_badge_count': membersBadgeCount,
      if (messagesBadgeCount != null)
        'messages_badge_count': messagesBadgeCount,
      if (isCharted != null) 'is_charted': isCharted,
      if (isPending != null) 'is_pending': isPending,
      if (createdAt != null) 'created_at': createdAt,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelMetadataCompanion copyWith({
    Value<String>? channelId,
    Value<int?>? memberCount,
    Value<int>? unreadCount,
    Value<int>? postsBadgeCount,
    Value<int>? membersBadgeCount,
    Value<int>? messagesBadgeCount,
    Value<int>? isCharted,
    Value<int>? isPending,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? lastMessageAt,
    Value<int>? rowid,
  }) {
    return ChannelMetadataCompanion(
      channelId: channelId ?? this.channelId,
      memberCount: memberCount ?? this.memberCount,
      unreadCount: unreadCount ?? this.unreadCount,
      postsBadgeCount: postsBadgeCount ?? this.postsBadgeCount,
      membersBadgeCount: membersBadgeCount ?? this.membersBadgeCount,
      messagesBadgeCount: messagesBadgeCount ?? this.messagesBadgeCount,
      isCharted: isCharted ?? this.isCharted,
      isPending: isPending ?? this.isPending,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (memberCount.present) {
      map['member_count'] = Variable<int>(memberCount.value);
    }
    if (unreadCount.present) {
      map['unread_count'] = Variable<int>(unreadCount.value);
    }
    if (postsBadgeCount.present) {
      map['posts_badge_count'] = Variable<int>(postsBadgeCount.value);
    }
    if (membersBadgeCount.present) {
      map['members_badge_count'] = Variable<int>(membersBadgeCount.value);
    }
    if (messagesBadgeCount.present) {
      map['messages_badge_count'] = Variable<int>(messagesBadgeCount.value);
    }
    if (isCharted.present) {
      map['is_charted'] = Variable<int>(isCharted.value);
    }
    if (isPending.present) {
      map['is_pending'] = Variable<int>(isPending.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelMetadataCompanion(')
          ..write('channelId: $channelId, ')
          ..write('memberCount: $memberCount, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('postsBadgeCount: $postsBadgeCount, ')
          ..write('membersBadgeCount: $membersBadgeCount, ')
          ..write('messagesBadgeCount: $messagesBadgeCount, ')
          ..write('isCharted: $isCharted, ')
          ..write('isPending: $isPending, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelBrandingTable extends ChannelBranding
    with TableInfo<$ChannelBrandingTable, ChannelBrandingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelBrandingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leaderAvatarUrlMeta = const VerificationMeta(
    'leaderAvatarUrl',
  );
  @override
  late final GeneratedColumn<String> leaderAvatarUrl = GeneratedColumn<String>(
    'leader_avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creatorAvatarUrlMeta = const VerificationMeta(
    'creatorAvatarUrl',
  );
  @override
  late final GeneratedColumn<String> creatorAvatarUrl = GeneratedColumn<String>(
    'creator_avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creatorIdMeta = const VerificationMeta(
    'creatorId',
  );
  @override
  late final GeneratedColumn<String> creatorId = GeneratedColumn<String>(
    'creator_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeColorMeta = const VerificationMeta(
    'themeColor',
  );
  @override
  late final GeneratedColumn<String> themeColor = GeneratedColumn<String>(
    'theme_color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    channelId,
    leaderAvatarUrl,
    creatorAvatarUrl,
    creatorId,
    themeColor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_branding';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelBrandingData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('leader_avatar_url')) {
      context.handle(
        _leaderAvatarUrlMeta,
        leaderAvatarUrl.isAcceptableOrUnknown(
          data['leader_avatar_url']!,
          _leaderAvatarUrlMeta,
        ),
      );
    }
    if (data.containsKey('creator_avatar_url')) {
      context.handle(
        _creatorAvatarUrlMeta,
        creatorAvatarUrl.isAcceptableOrUnknown(
          data['creator_avatar_url']!,
          _creatorAvatarUrlMeta,
        ),
      );
    }
    if (data.containsKey('creator_id')) {
      context.handle(
        _creatorIdMeta,
        creatorId.isAcceptableOrUnknown(data['creator_id']!, _creatorIdMeta),
      );
    }
    if (data.containsKey('theme_color')) {
      context.handle(
        _themeColorMeta,
        themeColor.isAcceptableOrUnknown(data['theme_color']!, _themeColorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {channelId};
  @override
  ChannelBrandingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelBrandingData(
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      leaderAvatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leader_avatar_url'],
      ),
      creatorAvatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator_avatar_url'],
      ),
      creatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator_id'],
      ),
      themeColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_color'],
      ),
    );
  }

  @override
  $ChannelBrandingTable createAlias(String alias) {
    return $ChannelBrandingTable(attachedDatabase, alias);
  }
}

class ChannelBrandingData extends DataClass
    implements Insertable<ChannelBrandingData> {
  final String channelId;
  final String? leaderAvatarUrl;
  final String? creatorAvatarUrl;
  final String? creatorId;
  final String? themeColor;
  const ChannelBrandingData({
    required this.channelId,
    this.leaderAvatarUrl,
    this.creatorAvatarUrl,
    this.creatorId,
    this.themeColor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['channel_id'] = Variable<String>(channelId);
    if (!nullToAbsent || leaderAvatarUrl != null) {
      map['leader_avatar_url'] = Variable<String>(leaderAvatarUrl);
    }
    if (!nullToAbsent || creatorAvatarUrl != null) {
      map['creator_avatar_url'] = Variable<String>(creatorAvatarUrl);
    }
    if (!nullToAbsent || creatorId != null) {
      map['creator_id'] = Variable<String>(creatorId);
    }
    if (!nullToAbsent || themeColor != null) {
      map['theme_color'] = Variable<String>(themeColor);
    }
    return map;
  }

  ChannelBrandingCompanion toCompanion(bool nullToAbsent) {
    return ChannelBrandingCompanion(
      channelId: Value(channelId),
      leaderAvatarUrl: leaderAvatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(leaderAvatarUrl),
      creatorAvatarUrl: creatorAvatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(creatorAvatarUrl),
      creatorId: creatorId == null && nullToAbsent
          ? const Value.absent()
          : Value(creatorId),
      themeColor: themeColor == null && nullToAbsent
          ? const Value.absent()
          : Value(themeColor),
    );
  }

  factory ChannelBrandingData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelBrandingData(
      channelId: serializer.fromJson<String>(json['channelId']),
      leaderAvatarUrl: serializer.fromJson<String?>(json['leaderAvatarUrl']),
      creatorAvatarUrl: serializer.fromJson<String?>(json['creatorAvatarUrl']),
      creatorId: serializer.fromJson<String?>(json['creatorId']),
      themeColor: serializer.fromJson<String?>(json['themeColor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'channelId': serializer.toJson<String>(channelId),
      'leaderAvatarUrl': serializer.toJson<String?>(leaderAvatarUrl),
      'creatorAvatarUrl': serializer.toJson<String?>(creatorAvatarUrl),
      'creatorId': serializer.toJson<String?>(creatorId),
      'themeColor': serializer.toJson<String?>(themeColor),
    };
  }

  ChannelBrandingData copyWith({
    String? channelId,
    Value<String?> leaderAvatarUrl = const Value.absent(),
    Value<String?> creatorAvatarUrl = const Value.absent(),
    Value<String?> creatorId = const Value.absent(),
    Value<String?> themeColor = const Value.absent(),
  }) => ChannelBrandingData(
    channelId: channelId ?? this.channelId,
    leaderAvatarUrl: leaderAvatarUrl.present
        ? leaderAvatarUrl.value
        : this.leaderAvatarUrl,
    creatorAvatarUrl: creatorAvatarUrl.present
        ? creatorAvatarUrl.value
        : this.creatorAvatarUrl,
    creatorId: creatorId.present ? creatorId.value : this.creatorId,
    themeColor: themeColor.present ? themeColor.value : this.themeColor,
  );
  ChannelBrandingData copyWithCompanion(ChannelBrandingCompanion data) {
    return ChannelBrandingData(
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      leaderAvatarUrl: data.leaderAvatarUrl.present
          ? data.leaderAvatarUrl.value
          : this.leaderAvatarUrl,
      creatorAvatarUrl: data.creatorAvatarUrl.present
          ? data.creatorAvatarUrl.value
          : this.creatorAvatarUrl,
      creatorId: data.creatorId.present ? data.creatorId.value : this.creatorId,
      themeColor: data.themeColor.present
          ? data.themeColor.value
          : this.themeColor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelBrandingData(')
          ..write('channelId: $channelId, ')
          ..write('leaderAvatarUrl: $leaderAvatarUrl, ')
          ..write('creatorAvatarUrl: $creatorAvatarUrl, ')
          ..write('creatorId: $creatorId, ')
          ..write('themeColor: $themeColor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    channelId,
    leaderAvatarUrl,
    creatorAvatarUrl,
    creatorId,
    themeColor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelBrandingData &&
          other.channelId == this.channelId &&
          other.leaderAvatarUrl == this.leaderAvatarUrl &&
          other.creatorAvatarUrl == this.creatorAvatarUrl &&
          other.creatorId == this.creatorId &&
          other.themeColor == this.themeColor);
}

class ChannelBrandingCompanion extends UpdateCompanion<ChannelBrandingData> {
  final Value<String> channelId;
  final Value<String?> leaderAvatarUrl;
  final Value<String?> creatorAvatarUrl;
  final Value<String?> creatorId;
  final Value<String?> themeColor;
  final Value<int> rowid;
  const ChannelBrandingCompanion({
    this.channelId = const Value.absent(),
    this.leaderAvatarUrl = const Value.absent(),
    this.creatorAvatarUrl = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.themeColor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelBrandingCompanion.insert({
    required String channelId,
    this.leaderAvatarUrl = const Value.absent(),
    this.creatorAvatarUrl = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.themeColor = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : channelId = Value(channelId);
  static Insertable<ChannelBrandingData> custom({
    Expression<String>? channelId,
    Expression<String>? leaderAvatarUrl,
    Expression<String>? creatorAvatarUrl,
    Expression<String>? creatorId,
    Expression<String>? themeColor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (channelId != null) 'channel_id': channelId,
      if (leaderAvatarUrl != null) 'leader_avatar_url': leaderAvatarUrl,
      if (creatorAvatarUrl != null) 'creator_avatar_url': creatorAvatarUrl,
      if (creatorId != null) 'creator_id': creatorId,
      if (themeColor != null) 'theme_color': themeColor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelBrandingCompanion copyWith({
    Value<String>? channelId,
    Value<String?>? leaderAvatarUrl,
    Value<String?>? creatorAvatarUrl,
    Value<String?>? creatorId,
    Value<String?>? themeColor,
    Value<int>? rowid,
  }) {
    return ChannelBrandingCompanion(
      channelId: channelId ?? this.channelId,
      leaderAvatarUrl: leaderAvatarUrl ?? this.leaderAvatarUrl,
      creatorAvatarUrl: creatorAvatarUrl ?? this.creatorAvatarUrl,
      creatorId: creatorId ?? this.creatorId,
      themeColor: themeColor ?? this.themeColor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (leaderAvatarUrl.present) {
      map['leader_avatar_url'] = Variable<String>(leaderAvatarUrl.value);
    }
    if (creatorAvatarUrl.present) {
      map['creator_avatar_url'] = Variable<String>(creatorAvatarUrl.value);
    }
    if (creatorId.present) {
      map['creator_id'] = Variable<String>(creatorId.value);
    }
    if (themeColor.present) {
      map['theme_color'] = Variable<String>(themeColor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelBrandingCompanion(')
          ..write('channelId: $channelId, ')
          ..write('leaderAvatarUrl: $leaderAvatarUrl, ')
          ..write('creatorAvatarUrl: $creatorAvatarUrl, ')
          ..write('creatorId: $creatorId, ')
          ..write('themeColor: $themeColor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelMembersTable extends ChannelMembers
    with TableInfo<$ChannelMembersTable, ChannelMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('member'),
  );
  static const VerificationMeta _joinedAtMeta = const VerificationMeta(
    'joinedAt',
  );
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
    'joined_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unreadCountMeta = const VerificationMeta(
    'unreadCount',
  );
  @override
  late final GeneratedColumn<int> unreadCount = GeneratedColumn<int>(
    'unread_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _unreadMomentsCountMeta =
      const VerificationMeta('unreadMomentsCount');
  @override
  late final GeneratedColumn<int> unreadMomentsCount = GeneratedColumn<int>(
    'unread_moments_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    channelId,
    userId,
    role,
    joinedAt,
    unreadCount,
    unreadMomentsCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('joined_at')) {
      context.handle(
        _joinedAtMeta,
        joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta),
      );
    }
    if (data.containsKey('unread_count')) {
      context.handle(
        _unreadCountMeta,
        unreadCount.isAcceptableOrUnknown(
          data['unread_count']!,
          _unreadCountMeta,
        ),
      );
    }
    if (data.containsKey('unread_moments_count')) {
      context.handle(
        _unreadMomentsCountMeta,
        unreadMomentsCount.isAcceptableOrUnknown(
          data['unread_moments_count']!,
          _unreadMomentsCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {channelId, userId};
  @override
  ChannelMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelMember(
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      joinedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joined_at'],
      ),
      unreadCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unread_count'],
      )!,
      unreadMomentsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unread_moments_count'],
      )!,
    );
  }

  @override
  $ChannelMembersTable createAlias(String alias) {
    return $ChannelMembersTable(attachedDatabase, alias);
  }
}

class ChannelMember extends DataClass implements Insertable<ChannelMember> {
  final String channelId;
  final String userId;
  final String role;
  final DateTime? joinedAt;
  final int unreadCount;
  final int unreadMomentsCount;
  const ChannelMember({
    required this.channelId,
    required this.userId,
    required this.role,
    this.joinedAt,
    required this.unreadCount,
    required this.unreadMomentsCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['channel_id'] = Variable<String>(channelId);
    map['user_id'] = Variable<String>(userId);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || joinedAt != null) {
      map['joined_at'] = Variable<DateTime>(joinedAt);
    }
    map['unread_count'] = Variable<int>(unreadCount);
    map['unread_moments_count'] = Variable<int>(unreadMomentsCount);
    return map;
  }

  ChannelMembersCompanion toCompanion(bool nullToAbsent) {
    return ChannelMembersCompanion(
      channelId: Value(channelId),
      userId: Value(userId),
      role: Value(role),
      joinedAt: joinedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(joinedAt),
      unreadCount: Value(unreadCount),
      unreadMomentsCount: Value(unreadMomentsCount),
    );
  }

  factory ChannelMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelMember(
      channelId: serializer.fromJson<String>(json['channelId']),
      userId: serializer.fromJson<String>(json['userId']),
      role: serializer.fromJson<String>(json['role']),
      joinedAt: serializer.fromJson<DateTime?>(json['joinedAt']),
      unreadCount: serializer.fromJson<int>(json['unreadCount']),
      unreadMomentsCount: serializer.fromJson<int>(json['unreadMomentsCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'channelId': serializer.toJson<String>(channelId),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<String>(role),
      'joinedAt': serializer.toJson<DateTime?>(joinedAt),
      'unreadCount': serializer.toJson<int>(unreadCount),
      'unreadMomentsCount': serializer.toJson<int>(unreadMomentsCount),
    };
  }

  ChannelMember copyWith({
    String? channelId,
    String? userId,
    String? role,
    Value<DateTime?> joinedAt = const Value.absent(),
    int? unreadCount,
    int? unreadMomentsCount,
  }) => ChannelMember(
    channelId: channelId ?? this.channelId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    joinedAt: joinedAt.present ? joinedAt.value : this.joinedAt,
    unreadCount: unreadCount ?? this.unreadCount,
    unreadMomentsCount: unreadMomentsCount ?? this.unreadMomentsCount,
  );
  ChannelMember copyWithCompanion(ChannelMembersCompanion data) {
    return ChannelMember(
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      unreadCount: data.unreadCount.present
          ? data.unreadCount.value
          : this.unreadCount,
      unreadMomentsCount: data.unreadMomentsCount.present
          ? data.unreadMomentsCount.value
          : this.unreadMomentsCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelMember(')
          ..write('channelId: $channelId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('unreadMomentsCount: $unreadMomentsCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    channelId,
    userId,
    role,
    joinedAt,
    unreadCount,
    unreadMomentsCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelMember &&
          other.channelId == this.channelId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.joinedAt == this.joinedAt &&
          other.unreadCount == this.unreadCount &&
          other.unreadMomentsCount == this.unreadMomentsCount);
}

class ChannelMembersCompanion extends UpdateCompanion<ChannelMember> {
  final Value<String> channelId;
  final Value<String> userId;
  final Value<String> role;
  final Value<DateTime?> joinedAt;
  final Value<int> unreadCount;
  final Value<int> unreadMomentsCount;
  final Value<int> rowid;
  const ChannelMembersCompanion({
    this.channelId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.unreadMomentsCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelMembersCompanion.insert({
    required String channelId,
    required String userId,
    this.role = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.unreadMomentsCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : channelId = Value(channelId),
       userId = Value(userId);
  static Insertable<ChannelMember> custom({
    Expression<String>? channelId,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<DateTime>? joinedAt,
    Expression<int>? unreadCount,
    Expression<int>? unreadMomentsCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (channelId != null) 'channel_id': channelId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (unreadCount != null) 'unread_count': unreadCount,
      if (unreadMomentsCount != null)
        'unread_moments_count': unreadMomentsCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelMembersCompanion copyWith({
    Value<String>? channelId,
    Value<String>? userId,
    Value<String>? role,
    Value<DateTime?>? joinedAt,
    Value<int>? unreadCount,
    Value<int>? unreadMomentsCount,
    Value<int>? rowid,
  }) {
    return ChannelMembersCompanion(
      channelId: channelId ?? this.channelId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      unreadCount: unreadCount ?? this.unreadCount,
      unreadMomentsCount: unreadMomentsCount ?? this.unreadMomentsCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (unreadCount.present) {
      map['unread_count'] = Variable<int>(unreadCount.value);
    }
    if (unreadMomentsCount.present) {
      map['unread_moments_count'] = Variable<int>(unreadMomentsCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelMembersCompanion(')
          ..write('channelId: $channelId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('unreadMomentsCount: $unreadMomentsCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelStatusesTable extends ChannelStatuses
    with TableInfo<$ChannelStatusesTable, ChannelStatuse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelStatusesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlsMeta = const VerificationMeta(
    'imageUrls',
  );
  @override
  late final GeneratedColumn<String> imageUrls = GeneratedColumn<String>(
    'image_urls',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _videoUrlMeta = const VerificationMeta(
    'videoUrl',
  );
  @override
  late final GeneratedColumn<String> videoUrl = GeneratedColumn<String>(
    'video_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isVideoMeta = const VerificationMeta(
    'isVideo',
  );
  @override
  late final GeneratedColumn<int> isVideo = GeneratedColumn<int>(
    'is_video',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isAudioMeta = const VerificationMeta(
    'isAudio',
  );
  @override
  late final GeneratedColumn<int> isAudio = GeneratedColumn<int>(
    'is_audio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _viewsCountMeta = const VerificationMeta(
    'viewsCount',
  );
  @override
  late final GeneratedColumn<int> viewsCount = GeneratedColumn<int>(
    'views_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _likesCountMeta = const VerificationMeta(
    'likesCount',
  );
  @override
  late final GeneratedColumn<int> likesCount = GeneratedColumn<int>(
    'likes_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _commentsCountMeta = const VerificationMeta(
    'commentsCount',
  );
  @override
  late final GeneratedColumn<int> commentsCount = GeneratedColumn<int>(
    'comments_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<String> expiresAt = GeneratedColumn<String>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profileImageUrlMeta = const VerificationMeta(
    'profileImageUrl',
  );
  @override
  late final GeneratedColumn<String> profileImageUrl = GeneratedColumn<String>(
    'profile_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    channelId,
    authorId,
    caption,
    imageUrls,
    videoUrl,
    thumbnailUrl,
    audioUrl,
    isVideo,
    isAudio,
    viewsCount,
    likesCount,
    commentsCount,
    createdAt,
    expiresAt,
    username,
    profileImageUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_statuses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelStatuse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('image_urls')) {
      context.handle(
        _imageUrlsMeta,
        imageUrls.isAcceptableOrUnknown(data['image_urls']!, _imageUrlsMeta),
      );
    }
    if (data.containsKey('video_url')) {
      context.handle(
        _videoUrlMeta,
        videoUrl.isAcceptableOrUnknown(data['video_url']!, _videoUrlMeta),
      );
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('is_video')) {
      context.handle(
        _isVideoMeta,
        isVideo.isAcceptableOrUnknown(data['is_video']!, _isVideoMeta),
      );
    }
    if (data.containsKey('is_audio')) {
      context.handle(
        _isAudioMeta,
        isAudio.isAcceptableOrUnknown(data['is_audio']!, _isAudioMeta),
      );
    }
    if (data.containsKey('views_count')) {
      context.handle(
        _viewsCountMeta,
        viewsCount.isAcceptableOrUnknown(data['views_count']!, _viewsCountMeta),
      );
    }
    if (data.containsKey('likes_count')) {
      context.handle(
        _likesCountMeta,
        likesCount.isAcceptableOrUnknown(data['likes_count']!, _likesCountMeta),
      );
    }
    if (data.containsKey('comments_count')) {
      context.handle(
        _commentsCountMeta,
        commentsCount.isAcceptableOrUnknown(
          data['comments_count']!,
          _commentsCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('profile_image_url')) {
      context.handle(
        _profileImageUrlMeta,
        profileImageUrl.isAcceptableOrUnknown(
          data['profile_image_url']!,
          _profileImageUrlMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChannelStatuse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelStatuse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      imageUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_urls'],
      ),
      videoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_url'],
      ),
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      ),
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
      isVideo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_video'],
      )!,
      isAudio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_audio'],
      )!,
      viewsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}views_count'],
      )!,
      likesCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}likes_count'],
      )!,
      commentsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}comments_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expires_at'],
      ),
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      profileImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_image_url'],
      ),
    );
  }

  @override
  $ChannelStatusesTable createAlias(String alias) {
    return $ChannelStatusesTable(attachedDatabase, alias);
  }
}

class ChannelStatuse extends DataClass implements Insertable<ChannelStatuse> {
  final String id;
  final String channelId;
  final String authorId;
  final String? caption;
  final String? imageUrls;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? audioUrl;
  final int isVideo;
  final int isAudio;
  final int viewsCount;
  final int likesCount;
  final int commentsCount;
  final String? createdAt;
  final String? expiresAt;
  final String? username;
  final String? profileImageUrl;
  const ChannelStatuse({
    required this.id,
    required this.channelId,
    required this.authorId,
    this.caption,
    this.imageUrls,
    this.videoUrl,
    this.thumbnailUrl,
    this.audioUrl,
    required this.isVideo,
    required this.isAudio,
    required this.viewsCount,
    required this.likesCount,
    required this.commentsCount,
    this.createdAt,
    this.expiresAt,
    this.username,
    this.profileImageUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['channel_id'] = Variable<String>(channelId);
    map['author_id'] = Variable<String>(authorId);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    if (!nullToAbsent || imageUrls != null) {
      map['image_urls'] = Variable<String>(imageUrls);
    }
    if (!nullToAbsent || videoUrl != null) {
      map['video_url'] = Variable<String>(videoUrl);
    }
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    map['is_video'] = Variable<int>(isVideo);
    map['is_audio'] = Variable<int>(isAudio);
    map['views_count'] = Variable<int>(viewsCount);
    map['likes_count'] = Variable<int>(likesCount);
    map['comments_count'] = Variable<int>(commentsCount);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<String>(expiresAt);
    }
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || profileImageUrl != null) {
      map['profile_image_url'] = Variable<String>(profileImageUrl);
    }
    return map;
  }

  ChannelStatusesCompanion toCompanion(bool nullToAbsent) {
    return ChannelStatusesCompanion(
      id: Value(id),
      channelId: Value(channelId),
      authorId: Value(authorId),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      imageUrls: imageUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrls),
      videoUrl: videoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(videoUrl),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      isVideo: Value(isVideo),
      isAudio: Value(isAudio),
      viewsCount: Value(viewsCount),
      likesCount: Value(likesCount),
      commentsCount: Value(commentsCount),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      profileImageUrl: profileImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImageUrl),
    );
  }

  factory ChannelStatuse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelStatuse(
      id: serializer.fromJson<String>(json['id']),
      channelId: serializer.fromJson<String>(json['channelId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      caption: serializer.fromJson<String?>(json['caption']),
      imageUrls: serializer.fromJson<String?>(json['imageUrls']),
      videoUrl: serializer.fromJson<String?>(json['videoUrl']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      isVideo: serializer.fromJson<int>(json['isVideo']),
      isAudio: serializer.fromJson<int>(json['isAudio']),
      viewsCount: serializer.fromJson<int>(json['viewsCount']),
      likesCount: serializer.fromJson<int>(json['likesCount']),
      commentsCount: serializer.fromJson<int>(json['commentsCount']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      expiresAt: serializer.fromJson<String?>(json['expiresAt']),
      username: serializer.fromJson<String?>(json['username']),
      profileImageUrl: serializer.fromJson<String?>(json['profileImageUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'channelId': serializer.toJson<String>(channelId),
      'authorId': serializer.toJson<String>(authorId),
      'caption': serializer.toJson<String?>(caption),
      'imageUrls': serializer.toJson<String?>(imageUrls),
      'videoUrl': serializer.toJson<String?>(videoUrl),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'isVideo': serializer.toJson<int>(isVideo),
      'isAudio': serializer.toJson<int>(isAudio),
      'viewsCount': serializer.toJson<int>(viewsCount),
      'likesCount': serializer.toJson<int>(likesCount),
      'commentsCount': serializer.toJson<int>(commentsCount),
      'createdAt': serializer.toJson<String?>(createdAt),
      'expiresAt': serializer.toJson<String?>(expiresAt),
      'username': serializer.toJson<String?>(username),
      'profileImageUrl': serializer.toJson<String?>(profileImageUrl),
    };
  }

  ChannelStatuse copyWith({
    String? id,
    String? channelId,
    String? authorId,
    Value<String?> caption = const Value.absent(),
    Value<String?> imageUrls = const Value.absent(),
    Value<String?> videoUrl = const Value.absent(),
    Value<String?> thumbnailUrl = const Value.absent(),
    Value<String?> audioUrl = const Value.absent(),
    int? isVideo,
    int? isAudio,
    int? viewsCount,
    int? likesCount,
    int? commentsCount,
    Value<String?> createdAt = const Value.absent(),
    Value<String?> expiresAt = const Value.absent(),
    Value<String?> username = const Value.absent(),
    Value<String?> profileImageUrl = const Value.absent(),
  }) => ChannelStatuse(
    id: id ?? this.id,
    channelId: channelId ?? this.channelId,
    authorId: authorId ?? this.authorId,
    caption: caption.present ? caption.value : this.caption,
    imageUrls: imageUrls.present ? imageUrls.value : this.imageUrls,
    videoUrl: videoUrl.present ? videoUrl.value : this.videoUrl,
    thumbnailUrl: thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
    isVideo: isVideo ?? this.isVideo,
    isAudio: isAudio ?? this.isAudio,
    viewsCount: viewsCount ?? this.viewsCount,
    likesCount: likesCount ?? this.likesCount,
    commentsCount: commentsCount ?? this.commentsCount,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    username: username.present ? username.value : this.username,
    profileImageUrl: profileImageUrl.present
        ? profileImageUrl.value
        : this.profileImageUrl,
  );
  ChannelStatuse copyWithCompanion(ChannelStatusesCompanion data) {
    return ChannelStatuse(
      id: data.id.present ? data.id.value : this.id,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      caption: data.caption.present ? data.caption.value : this.caption,
      imageUrls: data.imageUrls.present ? data.imageUrls.value : this.imageUrls,
      videoUrl: data.videoUrl.present ? data.videoUrl.value : this.videoUrl,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      isVideo: data.isVideo.present ? data.isVideo.value : this.isVideo,
      isAudio: data.isAudio.present ? data.isAudio.value : this.isAudio,
      viewsCount: data.viewsCount.present
          ? data.viewsCount.value
          : this.viewsCount,
      likesCount: data.likesCount.present
          ? data.likesCount.value
          : this.likesCount,
      commentsCount: data.commentsCount.present
          ? data.commentsCount.value
          : this.commentsCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      username: data.username.present ? data.username.value : this.username,
      profileImageUrl: data.profileImageUrl.present
          ? data.profileImageUrl.value
          : this.profileImageUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelStatuse(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('authorId: $authorId, ')
          ..write('caption: $caption, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('isVideo: $isVideo, ')
          ..write('isAudio: $isAudio, ')
          ..write('viewsCount: $viewsCount, ')
          ..write('likesCount: $likesCount, ')
          ..write('commentsCount: $commentsCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('username: $username, ')
          ..write('profileImageUrl: $profileImageUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    channelId,
    authorId,
    caption,
    imageUrls,
    videoUrl,
    thumbnailUrl,
    audioUrl,
    isVideo,
    isAudio,
    viewsCount,
    likesCount,
    commentsCount,
    createdAt,
    expiresAt,
    username,
    profileImageUrl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelStatuse &&
          other.id == this.id &&
          other.channelId == this.channelId &&
          other.authorId == this.authorId &&
          other.caption == this.caption &&
          other.imageUrls == this.imageUrls &&
          other.videoUrl == this.videoUrl &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.audioUrl == this.audioUrl &&
          other.isVideo == this.isVideo &&
          other.isAudio == this.isAudio &&
          other.viewsCount == this.viewsCount &&
          other.likesCount == this.likesCount &&
          other.commentsCount == this.commentsCount &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt &&
          other.username == this.username &&
          other.profileImageUrl == this.profileImageUrl);
}

class ChannelStatusesCompanion extends UpdateCompanion<ChannelStatuse> {
  final Value<String> id;
  final Value<String> channelId;
  final Value<String> authorId;
  final Value<String?> caption;
  final Value<String?> imageUrls;
  final Value<String?> videoUrl;
  final Value<String?> thumbnailUrl;
  final Value<String?> audioUrl;
  final Value<int> isVideo;
  final Value<int> isAudio;
  final Value<int> viewsCount;
  final Value<int> likesCount;
  final Value<int> commentsCount;
  final Value<String?> createdAt;
  final Value<String?> expiresAt;
  final Value<String?> username;
  final Value<String?> profileImageUrl;
  final Value<int> rowid;
  const ChannelStatusesCompanion({
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.caption = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.isVideo = const Value.absent(),
    this.isAudio = const Value.absent(),
    this.viewsCount = const Value.absent(),
    this.likesCount = const Value.absent(),
    this.commentsCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.username = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelStatusesCompanion.insert({
    required String id,
    required String channelId,
    required String authorId,
    this.caption = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.isVideo = const Value.absent(),
    this.isAudio = const Value.absent(),
    this.viewsCount = const Value.absent(),
    this.likesCount = const Value.absent(),
    this.commentsCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.username = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       channelId = Value(channelId),
       authorId = Value(authorId);
  static Insertable<ChannelStatuse> custom({
    Expression<String>? id,
    Expression<String>? channelId,
    Expression<String>? authorId,
    Expression<String>? caption,
    Expression<String>? imageUrls,
    Expression<String>? videoUrl,
    Expression<String>? thumbnailUrl,
    Expression<String>? audioUrl,
    Expression<int>? isVideo,
    Expression<int>? isAudio,
    Expression<int>? viewsCount,
    Expression<int>? likesCount,
    Expression<int>? commentsCount,
    Expression<String>? createdAt,
    Expression<String>? expiresAt,
    Expression<String>? username,
    Expression<String>? profileImageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (channelId != null) 'channel_id': channelId,
      if (authorId != null) 'author_id': authorId,
      if (caption != null) 'caption': caption,
      if (imageUrls != null) 'image_urls': imageUrls,
      if (videoUrl != null) 'video_url': videoUrl,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (isVideo != null) 'is_video': isVideo,
      if (isAudio != null) 'is_audio': isAudio,
      if (viewsCount != null) 'views_count': viewsCount,
      if (likesCount != null) 'likes_count': likesCount,
      if (commentsCount != null) 'comments_count': commentsCount,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (username != null) 'username': username,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelStatusesCompanion copyWith({
    Value<String>? id,
    Value<String>? channelId,
    Value<String>? authorId,
    Value<String?>? caption,
    Value<String?>? imageUrls,
    Value<String?>? videoUrl,
    Value<String?>? thumbnailUrl,
    Value<String?>? audioUrl,
    Value<int>? isVideo,
    Value<int>? isAudio,
    Value<int>? viewsCount,
    Value<int>? likesCount,
    Value<int>? commentsCount,
    Value<String?>? createdAt,
    Value<String?>? expiresAt,
    Value<String?>? username,
    Value<String?>? profileImageUrl,
    Value<int>? rowid,
  }) {
    return ChannelStatusesCompanion(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      authorId: authorId ?? this.authorId,
      caption: caption ?? this.caption,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      isVideo: isVideo ?? this.isVideo,
      isAudio: isAudio ?? this.isAudio,
      viewsCount: viewsCount ?? this.viewsCount,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (imageUrls.present) {
      map['image_urls'] = Variable<String>(imageUrls.value);
    }
    if (videoUrl.present) {
      map['video_url'] = Variable<String>(videoUrl.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (isVideo.present) {
      map['is_video'] = Variable<int>(isVideo.value);
    }
    if (isAudio.present) {
      map['is_audio'] = Variable<int>(isAudio.value);
    }
    if (viewsCount.present) {
      map['views_count'] = Variable<int>(viewsCount.value);
    }
    if (likesCount.present) {
      map['likes_count'] = Variable<int>(likesCount.value);
    }
    if (commentsCount.present) {
      map['comments_count'] = Variable<int>(commentsCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<String>(expiresAt.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (profileImageUrl.present) {
      map['profile_image_url'] = Variable<String>(profileImageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelStatusesCompanion(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('authorId: $authorId, ')
          ..write('caption: $caption, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('isVideo: $isVideo, ')
          ..write('isAudio: $isAudio, ')
          ..write('viewsCount: $viewsCount, ')
          ..write('likesCount: $likesCount, ')
          ..write('commentsCount: $commentsCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('username: $username, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelPresenceTable extends ChannelPresence
    with TableInfo<$ChannelPresenceTable, ChannelPresenceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelPresenceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isOnlineMeta = const VerificationMeta(
    'isOnline',
  );
  @override
  late final GeneratedColumn<int> isOnline = GeneratedColumn<int>(
    'is_online',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isTypingMeta = const VerificationMeta(
    'isTyping',
  );
  @override
  late final GeneratedColumn<int> isTyping = GeneratedColumn<int>(
    'is_typing',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSeenMeta = const VerificationMeta(
    'lastSeen',
  );
  @override
  late final GeneratedColumn<String> lastSeen = GeneratedColumn<String>(
    'last_seen',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastKnownNameMeta = const VerificationMeta(
    'lastKnownName',
  );
  @override
  late final GeneratedColumn<String> lastKnownName = GeneratedColumn<String>(
    'last_known_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastKnownAvatarMeta = const VerificationMeta(
    'lastKnownAvatar',
  );
  @override
  late final GeneratedColumn<String> lastKnownAvatar = GeneratedColumn<String>(
    'last_known_avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    channelId,
    userId,
    isOnline,
    isTyping,
    lastSeen,
    lastKnownName,
    lastKnownAvatar,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_presence';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelPresenceData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('is_online')) {
      context.handle(
        _isOnlineMeta,
        isOnline.isAcceptableOrUnknown(data['is_online']!, _isOnlineMeta),
      );
    }
    if (data.containsKey('is_typing')) {
      context.handle(
        _isTypingMeta,
        isTyping.isAcceptableOrUnknown(data['is_typing']!, _isTypingMeta),
      );
    }
    if (data.containsKey('last_seen')) {
      context.handle(
        _lastSeenMeta,
        lastSeen.isAcceptableOrUnknown(data['last_seen']!, _lastSeenMeta),
      );
    }
    if (data.containsKey('last_known_name')) {
      context.handle(
        _lastKnownNameMeta,
        lastKnownName.isAcceptableOrUnknown(
          data['last_known_name']!,
          _lastKnownNameMeta,
        ),
      );
    }
    if (data.containsKey('last_known_avatar')) {
      context.handle(
        _lastKnownAvatarMeta,
        lastKnownAvatar.isAcceptableOrUnknown(
          data['last_known_avatar']!,
          _lastKnownAvatarMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {channelId, userId};
  @override
  ChannelPresenceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelPresenceData(
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      isOnline: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_online'],
      )!,
      isTyping: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_typing'],
      )!,
      lastSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_seen'],
      ),
      lastKnownName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_known_name'],
      ),
      lastKnownAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_known_avatar'],
      ),
    );
  }

  @override
  $ChannelPresenceTable createAlias(String alias) {
    return $ChannelPresenceTable(attachedDatabase, alias);
  }
}

class ChannelPresenceData extends DataClass
    implements Insertable<ChannelPresenceData> {
  final String channelId;
  final String userId;
  final int isOnline;
  final int isTyping;
  final String? lastSeen;
  final String? lastKnownName;
  final String? lastKnownAvatar;
  const ChannelPresenceData({
    required this.channelId,
    required this.userId,
    required this.isOnline,
    required this.isTyping,
    this.lastSeen,
    this.lastKnownName,
    this.lastKnownAvatar,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['channel_id'] = Variable<String>(channelId);
    map['user_id'] = Variable<String>(userId);
    map['is_online'] = Variable<int>(isOnline);
    map['is_typing'] = Variable<int>(isTyping);
    if (!nullToAbsent || lastSeen != null) {
      map['last_seen'] = Variable<String>(lastSeen);
    }
    if (!nullToAbsent || lastKnownName != null) {
      map['last_known_name'] = Variable<String>(lastKnownName);
    }
    if (!nullToAbsent || lastKnownAvatar != null) {
      map['last_known_avatar'] = Variable<String>(lastKnownAvatar);
    }
    return map;
  }

  ChannelPresenceCompanion toCompanion(bool nullToAbsent) {
    return ChannelPresenceCompanion(
      channelId: Value(channelId),
      userId: Value(userId),
      isOnline: Value(isOnline),
      isTyping: Value(isTyping),
      lastSeen: lastSeen == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeen),
      lastKnownName: lastKnownName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastKnownName),
      lastKnownAvatar: lastKnownAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(lastKnownAvatar),
    );
  }

  factory ChannelPresenceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelPresenceData(
      channelId: serializer.fromJson<String>(json['channelId']),
      userId: serializer.fromJson<String>(json['userId']),
      isOnline: serializer.fromJson<int>(json['isOnline']),
      isTyping: serializer.fromJson<int>(json['isTyping']),
      lastSeen: serializer.fromJson<String?>(json['lastSeen']),
      lastKnownName: serializer.fromJson<String?>(json['lastKnownName']),
      lastKnownAvatar: serializer.fromJson<String?>(json['lastKnownAvatar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'channelId': serializer.toJson<String>(channelId),
      'userId': serializer.toJson<String>(userId),
      'isOnline': serializer.toJson<int>(isOnline),
      'isTyping': serializer.toJson<int>(isTyping),
      'lastSeen': serializer.toJson<String?>(lastSeen),
      'lastKnownName': serializer.toJson<String?>(lastKnownName),
      'lastKnownAvatar': serializer.toJson<String?>(lastKnownAvatar),
    };
  }

  ChannelPresenceData copyWith({
    String? channelId,
    String? userId,
    int? isOnline,
    int? isTyping,
    Value<String?> lastSeen = const Value.absent(),
    Value<String?> lastKnownName = const Value.absent(),
    Value<String?> lastKnownAvatar = const Value.absent(),
  }) => ChannelPresenceData(
    channelId: channelId ?? this.channelId,
    userId: userId ?? this.userId,
    isOnline: isOnline ?? this.isOnline,
    isTyping: isTyping ?? this.isTyping,
    lastSeen: lastSeen.present ? lastSeen.value : this.lastSeen,
    lastKnownName: lastKnownName.present
        ? lastKnownName.value
        : this.lastKnownName,
    lastKnownAvatar: lastKnownAvatar.present
        ? lastKnownAvatar.value
        : this.lastKnownAvatar,
  );
  ChannelPresenceData copyWithCompanion(ChannelPresenceCompanion data) {
    return ChannelPresenceData(
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      userId: data.userId.present ? data.userId.value : this.userId,
      isOnline: data.isOnline.present ? data.isOnline.value : this.isOnline,
      isTyping: data.isTyping.present ? data.isTyping.value : this.isTyping,
      lastSeen: data.lastSeen.present ? data.lastSeen.value : this.lastSeen,
      lastKnownName: data.lastKnownName.present
          ? data.lastKnownName.value
          : this.lastKnownName,
      lastKnownAvatar: data.lastKnownAvatar.present
          ? data.lastKnownAvatar.value
          : this.lastKnownAvatar,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelPresenceData(')
          ..write('channelId: $channelId, ')
          ..write('userId: $userId, ')
          ..write('isOnline: $isOnline, ')
          ..write('isTyping: $isTyping, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('lastKnownName: $lastKnownName, ')
          ..write('lastKnownAvatar: $lastKnownAvatar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    channelId,
    userId,
    isOnline,
    isTyping,
    lastSeen,
    lastKnownName,
    lastKnownAvatar,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelPresenceData &&
          other.channelId == this.channelId &&
          other.userId == this.userId &&
          other.isOnline == this.isOnline &&
          other.isTyping == this.isTyping &&
          other.lastSeen == this.lastSeen &&
          other.lastKnownName == this.lastKnownName &&
          other.lastKnownAvatar == this.lastKnownAvatar);
}

class ChannelPresenceCompanion extends UpdateCompanion<ChannelPresenceData> {
  final Value<String> channelId;
  final Value<String> userId;
  final Value<int> isOnline;
  final Value<int> isTyping;
  final Value<String?> lastSeen;
  final Value<String?> lastKnownName;
  final Value<String?> lastKnownAvatar;
  final Value<int> rowid;
  const ChannelPresenceCompanion({
    this.channelId = const Value.absent(),
    this.userId = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.isTyping = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.lastKnownName = const Value.absent(),
    this.lastKnownAvatar = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelPresenceCompanion.insert({
    required String channelId,
    required String userId,
    this.isOnline = const Value.absent(),
    this.isTyping = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.lastKnownName = const Value.absent(),
    this.lastKnownAvatar = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : channelId = Value(channelId),
       userId = Value(userId);
  static Insertable<ChannelPresenceData> custom({
    Expression<String>? channelId,
    Expression<String>? userId,
    Expression<int>? isOnline,
    Expression<int>? isTyping,
    Expression<String>? lastSeen,
    Expression<String>? lastKnownName,
    Expression<String>? lastKnownAvatar,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (channelId != null) 'channel_id': channelId,
      if (userId != null) 'user_id': userId,
      if (isOnline != null) 'is_online': isOnline,
      if (isTyping != null) 'is_typing': isTyping,
      if (lastSeen != null) 'last_seen': lastSeen,
      if (lastKnownName != null) 'last_known_name': lastKnownName,
      if (lastKnownAvatar != null) 'last_known_avatar': lastKnownAvatar,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelPresenceCompanion copyWith({
    Value<String>? channelId,
    Value<String>? userId,
    Value<int>? isOnline,
    Value<int>? isTyping,
    Value<String?>? lastSeen,
    Value<String?>? lastKnownName,
    Value<String?>? lastKnownAvatar,
    Value<int>? rowid,
  }) {
    return ChannelPresenceCompanion(
      channelId: channelId ?? this.channelId,
      userId: userId ?? this.userId,
      isOnline: isOnline ?? this.isOnline,
      isTyping: isTyping ?? this.isTyping,
      lastSeen: lastSeen ?? this.lastSeen,
      lastKnownName: lastKnownName ?? this.lastKnownName,
      lastKnownAvatar: lastKnownAvatar ?? this.lastKnownAvatar,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (isOnline.present) {
      map['is_online'] = Variable<int>(isOnline.value);
    }
    if (isTyping.present) {
      map['is_typing'] = Variable<int>(isTyping.value);
    }
    if (lastSeen.present) {
      map['last_seen'] = Variable<String>(lastSeen.value);
    }
    if (lastKnownName.present) {
      map['last_known_name'] = Variable<String>(lastKnownName.value);
    }
    if (lastKnownAvatar.present) {
      map['last_known_avatar'] = Variable<String>(lastKnownAvatar.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelPresenceCompanion(')
          ..write('channelId: $channelId, ')
          ..write('userId: $userId, ')
          ..write('isOnline: $isOnline, ')
          ..write('isTyping: $isTyping, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('lastKnownName: $lastKnownName, ')
          ..write('lastKnownAvatar: $lastKnownAvatar, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelCreatorTable extends ChannelCreator
    with TableInfo<$ChannelCreatorTable, ChannelCreatorData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelCreatorTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creatorIdMeta = const VerificationMeta(
    'creatorId',
  );
  @override
  late final GeneratedColumn<String> creatorId = GeneratedColumn<String>(
    'creator_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta(
    'isVerified',
  );
  @override
  late final GeneratedColumn<int> isVerified = GeneratedColumn<int>(
    'is_verified',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFollowingMeta = const VerificationMeta(
    'isFollowing',
  );
  @override
  late final GeneratedColumn<int> isFollowing = GeneratedColumn<int>(
    'is_following',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _roleTitleMeta = const VerificationMeta(
    'roleTitle',
  );
  @override
  late final GeneratedColumn<String> roleTitle = GeneratedColumn<String>(
    'role_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Channel Creator'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    channelId,
    creatorId,
    name,
    avatarUrl,
    isVerified,
    isFollowing,
    roleTitle,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_creator';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelCreatorData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('creator_id')) {
      context.handle(
        _creatorIdMeta,
        creatorId.isAcceptableOrUnknown(data['creator_id']!, _creatorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creatorIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('is_verified')) {
      context.handle(
        _isVerifiedMeta,
        isVerified.isAcceptableOrUnknown(data['is_verified']!, _isVerifiedMeta),
      );
    }
    if (data.containsKey('is_following')) {
      context.handle(
        _isFollowingMeta,
        isFollowing.isAcceptableOrUnknown(
          data['is_following']!,
          _isFollowingMeta,
        ),
      );
    }
    if (data.containsKey('role_title')) {
      context.handle(
        _roleTitleMeta,
        roleTitle.isAcceptableOrUnknown(data['role_title']!, _roleTitleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {channelId};
  @override
  ChannelCreatorData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelCreatorData(
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      creatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      isVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_verified'],
      )!,
      isFollowing: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_following'],
      )!,
      roleTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_title'],
      )!,
    );
  }

  @override
  $ChannelCreatorTable createAlias(String alias) {
    return $ChannelCreatorTable(attachedDatabase, alias);
  }
}

class ChannelCreatorData extends DataClass
    implements Insertable<ChannelCreatorData> {
  final String channelId;
  final String creatorId;
  final String? name;
  final String? avatarUrl;
  final int isVerified;
  final int isFollowing;
  final String roleTitle;
  const ChannelCreatorData({
    required this.channelId,
    required this.creatorId,
    this.name,
    this.avatarUrl,
    required this.isVerified,
    required this.isFollowing,
    required this.roleTitle,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['channel_id'] = Variable<String>(channelId);
    map['creator_id'] = Variable<String>(creatorId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['is_verified'] = Variable<int>(isVerified);
    map['is_following'] = Variable<int>(isFollowing);
    map['role_title'] = Variable<String>(roleTitle);
    return map;
  }

  ChannelCreatorCompanion toCompanion(bool nullToAbsent) {
    return ChannelCreatorCompanion(
      channelId: Value(channelId),
      creatorId: Value(creatorId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      isVerified: Value(isVerified),
      isFollowing: Value(isFollowing),
      roleTitle: Value(roleTitle),
    );
  }

  factory ChannelCreatorData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelCreatorData(
      channelId: serializer.fromJson<String>(json['channelId']),
      creatorId: serializer.fromJson<String>(json['creatorId']),
      name: serializer.fromJson<String?>(json['name']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      isVerified: serializer.fromJson<int>(json['isVerified']),
      isFollowing: serializer.fromJson<int>(json['isFollowing']),
      roleTitle: serializer.fromJson<String>(json['roleTitle']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'channelId': serializer.toJson<String>(channelId),
      'creatorId': serializer.toJson<String>(creatorId),
      'name': serializer.toJson<String?>(name),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'isVerified': serializer.toJson<int>(isVerified),
      'isFollowing': serializer.toJson<int>(isFollowing),
      'roleTitle': serializer.toJson<String>(roleTitle),
    };
  }

  ChannelCreatorData copyWith({
    String? channelId,
    String? creatorId,
    Value<String?> name = const Value.absent(),
    Value<String?> avatarUrl = const Value.absent(),
    int? isVerified,
    int? isFollowing,
    String? roleTitle,
  }) => ChannelCreatorData(
    channelId: channelId ?? this.channelId,
    creatorId: creatorId ?? this.creatorId,
    name: name.present ? name.value : this.name,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    isVerified: isVerified ?? this.isVerified,
    isFollowing: isFollowing ?? this.isFollowing,
    roleTitle: roleTitle ?? this.roleTitle,
  );
  ChannelCreatorData copyWithCompanion(ChannelCreatorCompanion data) {
    return ChannelCreatorData(
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      creatorId: data.creatorId.present ? data.creatorId.value : this.creatorId,
      name: data.name.present ? data.name.value : this.name,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      isVerified: data.isVerified.present
          ? data.isVerified.value
          : this.isVerified,
      isFollowing: data.isFollowing.present
          ? data.isFollowing.value
          : this.isFollowing,
      roleTitle: data.roleTitle.present ? data.roleTitle.value : this.roleTitle,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelCreatorData(')
          ..write('channelId: $channelId, ')
          ..write('creatorId: $creatorId, ')
          ..write('name: $name, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('isVerified: $isVerified, ')
          ..write('isFollowing: $isFollowing, ')
          ..write('roleTitle: $roleTitle')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    channelId,
    creatorId,
    name,
    avatarUrl,
    isVerified,
    isFollowing,
    roleTitle,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelCreatorData &&
          other.channelId == this.channelId &&
          other.creatorId == this.creatorId &&
          other.name == this.name &&
          other.avatarUrl == this.avatarUrl &&
          other.isVerified == this.isVerified &&
          other.isFollowing == this.isFollowing &&
          other.roleTitle == this.roleTitle);
}

class ChannelCreatorCompanion extends UpdateCompanion<ChannelCreatorData> {
  final Value<String> channelId;
  final Value<String> creatorId;
  final Value<String?> name;
  final Value<String?> avatarUrl;
  final Value<int> isVerified;
  final Value<int> isFollowing;
  final Value<String> roleTitle;
  final Value<int> rowid;
  const ChannelCreatorCompanion({
    this.channelId = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.isFollowing = const Value.absent(),
    this.roleTitle = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelCreatorCompanion.insert({
    required String channelId,
    required String creatorId,
    this.name = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.isFollowing = const Value.absent(),
    this.roleTitle = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : channelId = Value(channelId),
       creatorId = Value(creatorId);
  static Insertable<ChannelCreatorData> custom({
    Expression<String>? channelId,
    Expression<String>? creatorId,
    Expression<String>? name,
    Expression<String>? avatarUrl,
    Expression<int>? isVerified,
    Expression<int>? isFollowing,
    Expression<String>? roleTitle,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (channelId != null) 'channel_id': channelId,
      if (creatorId != null) 'creator_id': creatorId,
      if (name != null) 'name': name,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (isVerified != null) 'is_verified': isVerified,
      if (isFollowing != null) 'is_following': isFollowing,
      if (roleTitle != null) 'role_title': roleTitle,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelCreatorCompanion copyWith({
    Value<String>? channelId,
    Value<String>? creatorId,
    Value<String?>? name,
    Value<String?>? avatarUrl,
    Value<int>? isVerified,
    Value<int>? isFollowing,
    Value<String>? roleTitle,
    Value<int>? rowid,
  }) {
    return ChannelCreatorCompanion(
      channelId: channelId ?? this.channelId,
      creatorId: creatorId ?? this.creatorId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      isFollowing: isFollowing ?? this.isFollowing,
      roleTitle: roleTitle ?? this.roleTitle,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (creatorId.present) {
      map['creator_id'] = Variable<String>(creatorId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<int>(isVerified.value);
    }
    if (isFollowing.present) {
      map['is_following'] = Variable<int>(isFollowing.value);
    }
    if (roleTitle.present) {
      map['role_title'] = Variable<String>(roleTitle.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelCreatorCompanion(')
          ..write('channelId: $channelId, ')
          ..write('creatorId: $creatorId, ')
          ..write('name: $name, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('isVerified: $isVerified, ')
          ..write('isFollowing: $isFollowing, ')
          ..write('roleTitle: $roleTitle, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelPostsTable extends ChannelPosts
    with TableInfo<$ChannelPostsTable, ChannelPost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelPostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profileImageUrlMeta = const VerificationMeta(
    'profileImageUrl',
  );
  @override
  late final GeneratedColumn<String> profileImageUrl = GeneratedColumn<String>(
    'profile_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlsMeta = const VerificationMeta(
    'imageUrls',
  );
  @override
  late final GeneratedColumn<String> imageUrls = GeneratedColumn<String>(
    'image_urls',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _videoUrlMeta = const VerificationMeta(
    'videoUrl',
  );
  @override
  late final GeneratedColumn<String> videoUrl = GeneratedColumn<String>(
    'video_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _videoUrlsMeta = const VerificationMeta(
    'videoUrls',
  );
  @override
  late final GeneratedColumn<String> videoUrls = GeneratedColumn<String>(
    'video_urls',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailUrlsMeta = const VerificationMeta(
    'thumbnailUrls',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrls = GeneratedColumn<String>(
    'thumbnail_urls',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isVideoMeta = const VerificationMeta(
    'isVideo',
  );
  @override
  late final GeneratedColumn<int> isVideo = GeneratedColumn<int>(
    'is_video',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isSponsoredMeta = const VerificationMeta(
    'isSponsored',
  );
  @override
  late final GeneratedColumn<int> isSponsored = GeneratedColumn<int>(
    'is_sponsored',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _aspectRatioMeta = const VerificationMeta(
    'aspectRatio',
  );
  @override
  late final GeneratedColumn<double> aspectRatio = GeneratedColumn<double>(
    'aspect_ratio',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _likesMeta = const VerificationMeta('likes');
  @override
  late final GeneratedColumn<int> likes = GeneratedColumn<int>(
    'likes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _commentsMeta = const VerificationMeta(
    'comments',
  );
  @override
  late final GeneratedColumn<int> comments = GeneratedColumn<int>(
    'comments',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sharesMeta = const VerificationMeta('shares');
  @override
  late final GeneratedColumn<int> shares = GeneratedColumn<int>(
    'shares',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPublicMeta = const VerificationMeta(
    'isPublic',
  );
  @override
  late final GeneratedColumn<int> isPublic = GeneratedColumn<int>(
    'is_public',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _allowCommentsMeta = const VerificationMeta(
    'allowComments',
  );
  @override
  late final GeneratedColumn<int> allowComments = GeneratedColumn<int>(
    'allow_comments',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isPendingMeta = const VerificationMeta(
    'isPending',
  );
  @override
  late final GeneratedColumn<int> isPending = GeneratedColumn<int>(
    'is_pending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isLikedMeta = const VerificationMeta(
    'isLiked',
  );
  @override
  late final GeneratedColumn<int> isLiked = GeneratedColumn<int>(
    'is_liked',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taggerNameMeta = const VerificationMeta(
    'taggerName',
  );
  @override
  late final GeneratedColumn<String> taggerName = GeneratedColumn<String>(
    'tagger_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taggerAvatarMeta = const VerificationMeta(
    'taggerAvatar',
  );
  @override
  late final GeneratedColumn<String> taggerAvatar = GeneratedColumn<String>(
    'tagger_avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceChannelNameMeta = const VerificationMeta(
    'sourceChannelName',
  );
  @override
  late final GeneratedColumn<String> sourceChannelName =
      GeneratedColumn<String>(
        'source_channel_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceChannelAvatarMeta =
      const VerificationMeta('sourceChannelAvatar');
  @override
  late final GeneratedColumn<String> sourceChannelAvatar =
      GeneratedColumn<String>(
        'source_channel_avatar',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _tagsCountMeta = const VerificationMeta(
    'tagsCount',
  );
  @override
  late final GeneratedColumn<int> tagsCount = GeneratedColumn<int>(
    'tags_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _postTypeMeta = const VerificationMeta(
    'postType',
  );
  @override
  late final GeneratedColumn<String> postType = GeneratedColumn<String>(
    'post_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('post'),
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    channelId,
    authorId,
    username,
    profileImageUrl,
    caption,
    imageUrls,
    videoUrl,
    videoUrls,
    thumbnailUrls,
    isVideo,
    isSponsored,
    aspectRatio,
    likes,
    comments,
    shares,
    isPublic,
    allowComments,
    isPending,
    isLiked,
    taggerName,
    taggerAvatar,
    sourceChannelName,
    sourceChannelAvatar,
    tagsCount,
    createdAt,
    postType,
    metadata,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_posts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelPost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('profile_image_url')) {
      context.handle(
        _profileImageUrlMeta,
        profileImageUrl.isAcceptableOrUnknown(
          data['profile_image_url']!,
          _profileImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('image_urls')) {
      context.handle(
        _imageUrlsMeta,
        imageUrls.isAcceptableOrUnknown(data['image_urls']!, _imageUrlsMeta),
      );
    }
    if (data.containsKey('video_url')) {
      context.handle(
        _videoUrlMeta,
        videoUrl.isAcceptableOrUnknown(data['video_url']!, _videoUrlMeta),
      );
    }
    if (data.containsKey('video_urls')) {
      context.handle(
        _videoUrlsMeta,
        videoUrls.isAcceptableOrUnknown(data['video_urls']!, _videoUrlsMeta),
      );
    }
    if (data.containsKey('thumbnail_urls')) {
      context.handle(
        _thumbnailUrlsMeta,
        thumbnailUrls.isAcceptableOrUnknown(
          data['thumbnail_urls']!,
          _thumbnailUrlsMeta,
        ),
      );
    }
    if (data.containsKey('is_video')) {
      context.handle(
        _isVideoMeta,
        isVideo.isAcceptableOrUnknown(data['is_video']!, _isVideoMeta),
      );
    }
    if (data.containsKey('is_sponsored')) {
      context.handle(
        _isSponsoredMeta,
        isSponsored.isAcceptableOrUnknown(
          data['is_sponsored']!,
          _isSponsoredMeta,
        ),
      );
    }
    if (data.containsKey('aspect_ratio')) {
      context.handle(
        _aspectRatioMeta,
        aspectRatio.isAcceptableOrUnknown(
          data['aspect_ratio']!,
          _aspectRatioMeta,
        ),
      );
    }
    if (data.containsKey('likes')) {
      context.handle(
        _likesMeta,
        likes.isAcceptableOrUnknown(data['likes']!, _likesMeta),
      );
    }
    if (data.containsKey('comments')) {
      context.handle(
        _commentsMeta,
        comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta),
      );
    }
    if (data.containsKey('shares')) {
      context.handle(
        _sharesMeta,
        shares.isAcceptableOrUnknown(data['shares']!, _sharesMeta),
      );
    }
    if (data.containsKey('is_public')) {
      context.handle(
        _isPublicMeta,
        isPublic.isAcceptableOrUnknown(data['is_public']!, _isPublicMeta),
      );
    }
    if (data.containsKey('allow_comments')) {
      context.handle(
        _allowCommentsMeta,
        allowComments.isAcceptableOrUnknown(
          data['allow_comments']!,
          _allowCommentsMeta,
        ),
      );
    }
    if (data.containsKey('is_pending')) {
      context.handle(
        _isPendingMeta,
        isPending.isAcceptableOrUnknown(data['is_pending']!, _isPendingMeta),
      );
    }
    if (data.containsKey('is_liked')) {
      context.handle(
        _isLikedMeta,
        isLiked.isAcceptableOrUnknown(data['is_liked']!, _isLikedMeta),
      );
    }
    if (data.containsKey('tagger_name')) {
      context.handle(
        _taggerNameMeta,
        taggerName.isAcceptableOrUnknown(data['tagger_name']!, _taggerNameMeta),
      );
    }
    if (data.containsKey('tagger_avatar')) {
      context.handle(
        _taggerAvatarMeta,
        taggerAvatar.isAcceptableOrUnknown(
          data['tagger_avatar']!,
          _taggerAvatarMeta,
        ),
      );
    }
    if (data.containsKey('source_channel_name')) {
      context.handle(
        _sourceChannelNameMeta,
        sourceChannelName.isAcceptableOrUnknown(
          data['source_channel_name']!,
          _sourceChannelNameMeta,
        ),
      );
    }
    if (data.containsKey('source_channel_avatar')) {
      context.handle(
        _sourceChannelAvatarMeta,
        sourceChannelAvatar.isAcceptableOrUnknown(
          data['source_channel_avatar']!,
          _sourceChannelAvatarMeta,
        ),
      );
    }
    if (data.containsKey('tags_count')) {
      context.handle(
        _tagsCountMeta,
        tagsCount.isAcceptableOrUnknown(data['tags_count']!, _tagsCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('post_type')) {
      context.handle(
        _postTypeMeta,
        postType.isAcceptableOrUnknown(data['post_type']!, _postTypeMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChannelPost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelPost(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      profileImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_image_url'],
      ),
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      imageUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_urls'],
      ),
      videoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_url'],
      ),
      videoUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_urls'],
      ),
      thumbnailUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_urls'],
      ),
      isVideo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_video'],
      )!,
      isSponsored: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_sponsored'],
      )!,
      aspectRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}aspect_ratio'],
      ),
      likes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}likes'],
      )!,
      comments: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}comments'],
      )!,
      shares: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shares'],
      )!,
      isPublic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_public'],
      )!,
      allowComments: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allow_comments'],
      )!,
      isPending: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_pending'],
      )!,
      isLiked: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_liked'],
      )!,
      taggerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tagger_name'],
      ),
      taggerAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tagger_avatar'],
      ),
      sourceChannelName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_channel_name'],
      ),
      sourceChannelAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_channel_avatar'],
      ),
      tagsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tags_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      postType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}post_type'],
      ),
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
    );
  }

  @override
  $ChannelPostsTable createAlias(String alias) {
    return $ChannelPostsTable(attachedDatabase, alias);
  }
}

class ChannelPost extends DataClass implements Insertable<ChannelPost> {
  final String id;
  final String channelId;
  final String authorId;
  final String? username;
  final String? profileImageUrl;
  final String? caption;
  final String? imageUrls;
  final String? videoUrl;
  final String? videoUrls;
  final String? thumbnailUrls;
  final int isVideo;
  final int isSponsored;
  final double? aspectRatio;
  final int likes;
  final int comments;
  final int shares;
  final int isPublic;
  final int allowComments;
  final int isPending;
  final int isLiked;
  final String? taggerName;
  final String? taggerAvatar;
  final String? sourceChannelName;
  final String? sourceChannelAvatar;
  final int tagsCount;
  final DateTime createdAt;
  final String? postType;
  final String? metadata;
  const ChannelPost({
    required this.id,
    required this.channelId,
    required this.authorId,
    this.username,
    this.profileImageUrl,
    this.caption,
    this.imageUrls,
    this.videoUrl,
    this.videoUrls,
    this.thumbnailUrls,
    required this.isVideo,
    required this.isSponsored,
    this.aspectRatio,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isPublic,
    required this.allowComments,
    required this.isPending,
    required this.isLiked,
    this.taggerName,
    this.taggerAvatar,
    this.sourceChannelName,
    this.sourceChannelAvatar,
    required this.tagsCount,
    required this.createdAt,
    this.postType,
    this.metadata,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['channel_id'] = Variable<String>(channelId);
    map['author_id'] = Variable<String>(authorId);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || profileImageUrl != null) {
      map['profile_image_url'] = Variable<String>(profileImageUrl);
    }
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    if (!nullToAbsent || imageUrls != null) {
      map['image_urls'] = Variable<String>(imageUrls);
    }
    if (!nullToAbsent || videoUrl != null) {
      map['video_url'] = Variable<String>(videoUrl);
    }
    if (!nullToAbsent || videoUrls != null) {
      map['video_urls'] = Variable<String>(videoUrls);
    }
    if (!nullToAbsent || thumbnailUrls != null) {
      map['thumbnail_urls'] = Variable<String>(thumbnailUrls);
    }
    map['is_video'] = Variable<int>(isVideo);
    map['is_sponsored'] = Variable<int>(isSponsored);
    if (!nullToAbsent || aspectRatio != null) {
      map['aspect_ratio'] = Variable<double>(aspectRatio);
    }
    map['likes'] = Variable<int>(likes);
    map['comments'] = Variable<int>(comments);
    map['shares'] = Variable<int>(shares);
    map['is_public'] = Variable<int>(isPublic);
    map['allow_comments'] = Variable<int>(allowComments);
    map['is_pending'] = Variable<int>(isPending);
    map['is_liked'] = Variable<int>(isLiked);
    if (!nullToAbsent || taggerName != null) {
      map['tagger_name'] = Variable<String>(taggerName);
    }
    if (!nullToAbsent || taggerAvatar != null) {
      map['tagger_avatar'] = Variable<String>(taggerAvatar);
    }
    if (!nullToAbsent || sourceChannelName != null) {
      map['source_channel_name'] = Variable<String>(sourceChannelName);
    }
    if (!nullToAbsent || sourceChannelAvatar != null) {
      map['source_channel_avatar'] = Variable<String>(sourceChannelAvatar);
    }
    map['tags_count'] = Variable<int>(tagsCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || postType != null) {
      map['post_type'] = Variable<String>(postType);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    return map;
  }

  ChannelPostsCompanion toCompanion(bool nullToAbsent) {
    return ChannelPostsCompanion(
      id: Value(id),
      channelId: Value(channelId),
      authorId: Value(authorId),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      profileImageUrl: profileImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImageUrl),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      imageUrls: imageUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrls),
      videoUrl: videoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(videoUrl),
      videoUrls: videoUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(videoUrls),
      thumbnailUrls: thumbnailUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrls),
      isVideo: Value(isVideo),
      isSponsored: Value(isSponsored),
      aspectRatio: aspectRatio == null && nullToAbsent
          ? const Value.absent()
          : Value(aspectRatio),
      likes: Value(likes),
      comments: Value(comments),
      shares: Value(shares),
      isPublic: Value(isPublic),
      allowComments: Value(allowComments),
      isPending: Value(isPending),
      isLiked: Value(isLiked),
      taggerName: taggerName == null && nullToAbsent
          ? const Value.absent()
          : Value(taggerName),
      taggerAvatar: taggerAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(taggerAvatar),
      sourceChannelName: sourceChannelName == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceChannelName),
      sourceChannelAvatar: sourceChannelAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceChannelAvatar),
      tagsCount: Value(tagsCount),
      createdAt: Value(createdAt),
      postType: postType == null && nullToAbsent
          ? const Value.absent()
          : Value(postType),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory ChannelPost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelPost(
      id: serializer.fromJson<String>(json['id']),
      channelId: serializer.fromJson<String>(json['channelId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      username: serializer.fromJson<String?>(json['username']),
      profileImageUrl: serializer.fromJson<String?>(json['profileImageUrl']),
      caption: serializer.fromJson<String?>(json['caption']),
      imageUrls: serializer.fromJson<String?>(json['imageUrls']),
      videoUrl: serializer.fromJson<String?>(json['videoUrl']),
      videoUrls: serializer.fromJson<String?>(json['videoUrls']),
      thumbnailUrls: serializer.fromJson<String?>(json['thumbnailUrls']),
      isVideo: serializer.fromJson<int>(json['isVideo']),
      isSponsored: serializer.fromJson<int>(json['isSponsored']),
      aspectRatio: serializer.fromJson<double?>(json['aspectRatio']),
      likes: serializer.fromJson<int>(json['likes']),
      comments: serializer.fromJson<int>(json['comments']),
      shares: serializer.fromJson<int>(json['shares']),
      isPublic: serializer.fromJson<int>(json['isPublic']),
      allowComments: serializer.fromJson<int>(json['allowComments']),
      isPending: serializer.fromJson<int>(json['isPending']),
      isLiked: serializer.fromJson<int>(json['isLiked']),
      taggerName: serializer.fromJson<String?>(json['taggerName']),
      taggerAvatar: serializer.fromJson<String?>(json['taggerAvatar']),
      sourceChannelName: serializer.fromJson<String?>(
        json['sourceChannelName'],
      ),
      sourceChannelAvatar: serializer.fromJson<String?>(
        json['sourceChannelAvatar'],
      ),
      tagsCount: serializer.fromJson<int>(json['tagsCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      postType: serializer.fromJson<String?>(json['postType']),
      metadata: serializer.fromJson<String?>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'channelId': serializer.toJson<String>(channelId),
      'authorId': serializer.toJson<String>(authorId),
      'username': serializer.toJson<String?>(username),
      'profileImageUrl': serializer.toJson<String?>(profileImageUrl),
      'caption': serializer.toJson<String?>(caption),
      'imageUrls': serializer.toJson<String?>(imageUrls),
      'videoUrl': serializer.toJson<String?>(videoUrl),
      'videoUrls': serializer.toJson<String?>(videoUrls),
      'thumbnailUrls': serializer.toJson<String?>(thumbnailUrls),
      'isVideo': serializer.toJson<int>(isVideo),
      'isSponsored': serializer.toJson<int>(isSponsored),
      'aspectRatio': serializer.toJson<double?>(aspectRatio),
      'likes': serializer.toJson<int>(likes),
      'comments': serializer.toJson<int>(comments),
      'shares': serializer.toJson<int>(shares),
      'isPublic': serializer.toJson<int>(isPublic),
      'allowComments': serializer.toJson<int>(allowComments),
      'isPending': serializer.toJson<int>(isPending),
      'isLiked': serializer.toJson<int>(isLiked),
      'taggerName': serializer.toJson<String?>(taggerName),
      'taggerAvatar': serializer.toJson<String?>(taggerAvatar),
      'sourceChannelName': serializer.toJson<String?>(sourceChannelName),
      'sourceChannelAvatar': serializer.toJson<String?>(sourceChannelAvatar),
      'tagsCount': serializer.toJson<int>(tagsCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'postType': serializer.toJson<String?>(postType),
      'metadata': serializer.toJson<String?>(metadata),
    };
  }

  ChannelPost copyWith({
    String? id,
    String? channelId,
    String? authorId,
    Value<String?> username = const Value.absent(),
    Value<String?> profileImageUrl = const Value.absent(),
    Value<String?> caption = const Value.absent(),
    Value<String?> imageUrls = const Value.absent(),
    Value<String?> videoUrl = const Value.absent(),
    Value<String?> videoUrls = const Value.absent(),
    Value<String?> thumbnailUrls = const Value.absent(),
    int? isVideo,
    int? isSponsored,
    Value<double?> aspectRatio = const Value.absent(),
    int? likes,
    int? comments,
    int? shares,
    int? isPublic,
    int? allowComments,
    int? isPending,
    int? isLiked,
    Value<String?> taggerName = const Value.absent(),
    Value<String?> taggerAvatar = const Value.absent(),
    Value<String?> sourceChannelName = const Value.absent(),
    Value<String?> sourceChannelAvatar = const Value.absent(),
    int? tagsCount,
    DateTime? createdAt,
    Value<String?> postType = const Value.absent(),
    Value<String?> metadata = const Value.absent(),
  }) => ChannelPost(
    id: id ?? this.id,
    channelId: channelId ?? this.channelId,
    authorId: authorId ?? this.authorId,
    username: username.present ? username.value : this.username,
    profileImageUrl: profileImageUrl.present
        ? profileImageUrl.value
        : this.profileImageUrl,
    caption: caption.present ? caption.value : this.caption,
    imageUrls: imageUrls.present ? imageUrls.value : this.imageUrls,
    videoUrl: videoUrl.present ? videoUrl.value : this.videoUrl,
    videoUrls: videoUrls.present ? videoUrls.value : this.videoUrls,
    thumbnailUrls: thumbnailUrls.present
        ? thumbnailUrls.value
        : this.thumbnailUrls,
    isVideo: isVideo ?? this.isVideo,
    isSponsored: isSponsored ?? this.isSponsored,
    aspectRatio: aspectRatio.present ? aspectRatio.value : this.aspectRatio,
    likes: likes ?? this.likes,
    comments: comments ?? this.comments,
    shares: shares ?? this.shares,
    isPublic: isPublic ?? this.isPublic,
    allowComments: allowComments ?? this.allowComments,
    isPending: isPending ?? this.isPending,
    isLiked: isLiked ?? this.isLiked,
    taggerName: taggerName.present ? taggerName.value : this.taggerName,
    taggerAvatar: taggerAvatar.present ? taggerAvatar.value : this.taggerAvatar,
    sourceChannelName: sourceChannelName.present
        ? sourceChannelName.value
        : this.sourceChannelName,
    sourceChannelAvatar: sourceChannelAvatar.present
        ? sourceChannelAvatar.value
        : this.sourceChannelAvatar,
    tagsCount: tagsCount ?? this.tagsCount,
    createdAt: createdAt ?? this.createdAt,
    postType: postType.present ? postType.value : this.postType,
    metadata: metadata.present ? metadata.value : this.metadata,
  );
  ChannelPost copyWithCompanion(ChannelPostsCompanion data) {
    return ChannelPost(
      id: data.id.present ? data.id.value : this.id,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      username: data.username.present ? data.username.value : this.username,
      profileImageUrl: data.profileImageUrl.present
          ? data.profileImageUrl.value
          : this.profileImageUrl,
      caption: data.caption.present ? data.caption.value : this.caption,
      imageUrls: data.imageUrls.present ? data.imageUrls.value : this.imageUrls,
      videoUrl: data.videoUrl.present ? data.videoUrl.value : this.videoUrl,
      videoUrls: data.videoUrls.present ? data.videoUrls.value : this.videoUrls,
      thumbnailUrls: data.thumbnailUrls.present
          ? data.thumbnailUrls.value
          : this.thumbnailUrls,
      isVideo: data.isVideo.present ? data.isVideo.value : this.isVideo,
      isSponsored: data.isSponsored.present
          ? data.isSponsored.value
          : this.isSponsored,
      aspectRatio: data.aspectRatio.present
          ? data.aspectRatio.value
          : this.aspectRatio,
      likes: data.likes.present ? data.likes.value : this.likes,
      comments: data.comments.present ? data.comments.value : this.comments,
      shares: data.shares.present ? data.shares.value : this.shares,
      isPublic: data.isPublic.present ? data.isPublic.value : this.isPublic,
      allowComments: data.allowComments.present
          ? data.allowComments.value
          : this.allowComments,
      isPending: data.isPending.present ? data.isPending.value : this.isPending,
      isLiked: data.isLiked.present ? data.isLiked.value : this.isLiked,
      taggerName: data.taggerName.present
          ? data.taggerName.value
          : this.taggerName,
      taggerAvatar: data.taggerAvatar.present
          ? data.taggerAvatar.value
          : this.taggerAvatar,
      sourceChannelName: data.sourceChannelName.present
          ? data.sourceChannelName.value
          : this.sourceChannelName,
      sourceChannelAvatar: data.sourceChannelAvatar.present
          ? data.sourceChannelAvatar.value
          : this.sourceChannelAvatar,
      tagsCount: data.tagsCount.present ? data.tagsCount.value : this.tagsCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      postType: data.postType.present ? data.postType.value : this.postType,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelPost(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('authorId: $authorId, ')
          ..write('username: $username, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('caption: $caption, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('videoUrls: $videoUrls, ')
          ..write('thumbnailUrls: $thumbnailUrls, ')
          ..write('isVideo: $isVideo, ')
          ..write('isSponsored: $isSponsored, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('likes: $likes, ')
          ..write('comments: $comments, ')
          ..write('shares: $shares, ')
          ..write('isPublic: $isPublic, ')
          ..write('allowComments: $allowComments, ')
          ..write('isPending: $isPending, ')
          ..write('isLiked: $isLiked, ')
          ..write('taggerName: $taggerName, ')
          ..write('taggerAvatar: $taggerAvatar, ')
          ..write('sourceChannelName: $sourceChannelName, ')
          ..write('sourceChannelAvatar: $sourceChannelAvatar, ')
          ..write('tagsCount: $tagsCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('postType: $postType, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    channelId,
    authorId,
    username,
    profileImageUrl,
    caption,
    imageUrls,
    videoUrl,
    videoUrls,
    thumbnailUrls,
    isVideo,
    isSponsored,
    aspectRatio,
    likes,
    comments,
    shares,
    isPublic,
    allowComments,
    isPending,
    isLiked,
    taggerName,
    taggerAvatar,
    sourceChannelName,
    sourceChannelAvatar,
    tagsCount,
    createdAt,
    postType,
    metadata,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelPost &&
          other.id == this.id &&
          other.channelId == this.channelId &&
          other.authorId == this.authorId &&
          other.username == this.username &&
          other.profileImageUrl == this.profileImageUrl &&
          other.caption == this.caption &&
          other.imageUrls == this.imageUrls &&
          other.videoUrl == this.videoUrl &&
          other.videoUrls == this.videoUrls &&
          other.thumbnailUrls == this.thumbnailUrls &&
          other.isVideo == this.isVideo &&
          other.isSponsored == this.isSponsored &&
          other.aspectRatio == this.aspectRatio &&
          other.likes == this.likes &&
          other.comments == this.comments &&
          other.shares == this.shares &&
          other.isPublic == this.isPublic &&
          other.allowComments == this.allowComments &&
          other.isPending == this.isPending &&
          other.isLiked == this.isLiked &&
          other.taggerName == this.taggerName &&
          other.taggerAvatar == this.taggerAvatar &&
          other.sourceChannelName == this.sourceChannelName &&
          other.sourceChannelAvatar == this.sourceChannelAvatar &&
          other.tagsCount == this.tagsCount &&
          other.createdAt == this.createdAt &&
          other.postType == this.postType &&
          other.metadata == this.metadata);
}

class ChannelPostsCompanion extends UpdateCompanion<ChannelPost> {
  final Value<String> id;
  final Value<String> channelId;
  final Value<String> authorId;
  final Value<String?> username;
  final Value<String?> profileImageUrl;
  final Value<String?> caption;
  final Value<String?> imageUrls;
  final Value<String?> videoUrl;
  final Value<String?> videoUrls;
  final Value<String?> thumbnailUrls;
  final Value<int> isVideo;
  final Value<int> isSponsored;
  final Value<double?> aspectRatio;
  final Value<int> likes;
  final Value<int> comments;
  final Value<int> shares;
  final Value<int> isPublic;
  final Value<int> allowComments;
  final Value<int> isPending;
  final Value<int> isLiked;
  final Value<String?> taggerName;
  final Value<String?> taggerAvatar;
  final Value<String?> sourceChannelName;
  final Value<String?> sourceChannelAvatar;
  final Value<int> tagsCount;
  final Value<DateTime> createdAt;
  final Value<String?> postType;
  final Value<String?> metadata;
  final Value<int> rowid;
  const ChannelPostsCompanion({
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.username = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.caption = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.videoUrls = const Value.absent(),
    this.thumbnailUrls = const Value.absent(),
    this.isVideo = const Value.absent(),
    this.isSponsored = const Value.absent(),
    this.aspectRatio = const Value.absent(),
    this.likes = const Value.absent(),
    this.comments = const Value.absent(),
    this.shares = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.allowComments = const Value.absent(),
    this.isPending = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.taggerName = const Value.absent(),
    this.taggerAvatar = const Value.absent(),
    this.sourceChannelName = const Value.absent(),
    this.sourceChannelAvatar = const Value.absent(),
    this.tagsCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.postType = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelPostsCompanion.insert({
    required String id,
    required String channelId,
    required String authorId,
    this.username = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.caption = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.videoUrls = const Value.absent(),
    this.thumbnailUrls = const Value.absent(),
    this.isVideo = const Value.absent(),
    this.isSponsored = const Value.absent(),
    this.aspectRatio = const Value.absent(),
    this.likes = const Value.absent(),
    this.comments = const Value.absent(),
    this.shares = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.allowComments = const Value.absent(),
    this.isPending = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.taggerName = const Value.absent(),
    this.taggerAvatar = const Value.absent(),
    this.sourceChannelName = const Value.absent(),
    this.sourceChannelAvatar = const Value.absent(),
    this.tagsCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.postType = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       channelId = Value(channelId),
       authorId = Value(authorId);
  static Insertable<ChannelPost> custom({
    Expression<String>? id,
    Expression<String>? channelId,
    Expression<String>? authorId,
    Expression<String>? username,
    Expression<String>? profileImageUrl,
    Expression<String>? caption,
    Expression<String>? imageUrls,
    Expression<String>? videoUrl,
    Expression<String>? videoUrls,
    Expression<String>? thumbnailUrls,
    Expression<int>? isVideo,
    Expression<int>? isSponsored,
    Expression<double>? aspectRatio,
    Expression<int>? likes,
    Expression<int>? comments,
    Expression<int>? shares,
    Expression<int>? isPublic,
    Expression<int>? allowComments,
    Expression<int>? isPending,
    Expression<int>? isLiked,
    Expression<String>? taggerName,
    Expression<String>? taggerAvatar,
    Expression<String>? sourceChannelName,
    Expression<String>? sourceChannelAvatar,
    Expression<int>? tagsCount,
    Expression<DateTime>? createdAt,
    Expression<String>? postType,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (channelId != null) 'channel_id': channelId,
      if (authorId != null) 'author_id': authorId,
      if (username != null) 'username': username,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      if (caption != null) 'caption': caption,
      if (imageUrls != null) 'image_urls': imageUrls,
      if (videoUrl != null) 'video_url': videoUrl,
      if (videoUrls != null) 'video_urls': videoUrls,
      if (thumbnailUrls != null) 'thumbnail_urls': thumbnailUrls,
      if (isVideo != null) 'is_video': isVideo,
      if (isSponsored != null) 'is_sponsored': isSponsored,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (likes != null) 'likes': likes,
      if (comments != null) 'comments': comments,
      if (shares != null) 'shares': shares,
      if (isPublic != null) 'is_public': isPublic,
      if (allowComments != null) 'allow_comments': allowComments,
      if (isPending != null) 'is_pending': isPending,
      if (isLiked != null) 'is_liked': isLiked,
      if (taggerName != null) 'tagger_name': taggerName,
      if (taggerAvatar != null) 'tagger_avatar': taggerAvatar,
      if (sourceChannelName != null) 'source_channel_name': sourceChannelName,
      if (sourceChannelAvatar != null)
        'source_channel_avatar': sourceChannelAvatar,
      if (tagsCount != null) 'tags_count': tagsCount,
      if (createdAt != null) 'created_at': createdAt,
      if (postType != null) 'post_type': postType,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelPostsCompanion copyWith({
    Value<String>? id,
    Value<String>? channelId,
    Value<String>? authorId,
    Value<String?>? username,
    Value<String?>? profileImageUrl,
    Value<String?>? caption,
    Value<String?>? imageUrls,
    Value<String?>? videoUrl,
    Value<String?>? videoUrls,
    Value<String?>? thumbnailUrls,
    Value<int>? isVideo,
    Value<int>? isSponsored,
    Value<double?>? aspectRatio,
    Value<int>? likes,
    Value<int>? comments,
    Value<int>? shares,
    Value<int>? isPublic,
    Value<int>? allowComments,
    Value<int>? isPending,
    Value<int>? isLiked,
    Value<String?>? taggerName,
    Value<String?>? taggerAvatar,
    Value<String?>? sourceChannelName,
    Value<String?>? sourceChannelAvatar,
    Value<int>? tagsCount,
    Value<DateTime>? createdAt,
    Value<String?>? postType,
    Value<String?>? metadata,
    Value<int>? rowid,
  }) {
    return ChannelPostsCompanion(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      authorId: authorId ?? this.authorId,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      caption: caption ?? this.caption,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      videoUrls: videoUrls ?? this.videoUrls,
      thumbnailUrls: thumbnailUrls ?? this.thumbnailUrls,
      isVideo: isVideo ?? this.isVideo,
      isSponsored: isSponsored ?? this.isSponsored,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isPublic: isPublic ?? this.isPublic,
      allowComments: allowComments ?? this.allowComments,
      isPending: isPending ?? this.isPending,
      isLiked: isLiked ?? this.isLiked,
      taggerName: taggerName ?? this.taggerName,
      taggerAvatar: taggerAvatar ?? this.taggerAvatar,
      sourceChannelName: sourceChannelName ?? this.sourceChannelName,
      sourceChannelAvatar: sourceChannelAvatar ?? this.sourceChannelAvatar,
      tagsCount: tagsCount ?? this.tagsCount,
      createdAt: createdAt ?? this.createdAt,
      postType: postType ?? this.postType,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (profileImageUrl.present) {
      map['profile_image_url'] = Variable<String>(profileImageUrl.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (imageUrls.present) {
      map['image_urls'] = Variable<String>(imageUrls.value);
    }
    if (videoUrl.present) {
      map['video_url'] = Variable<String>(videoUrl.value);
    }
    if (videoUrls.present) {
      map['video_urls'] = Variable<String>(videoUrls.value);
    }
    if (thumbnailUrls.present) {
      map['thumbnail_urls'] = Variable<String>(thumbnailUrls.value);
    }
    if (isVideo.present) {
      map['is_video'] = Variable<int>(isVideo.value);
    }
    if (isSponsored.present) {
      map['is_sponsored'] = Variable<int>(isSponsored.value);
    }
    if (aspectRatio.present) {
      map['aspect_ratio'] = Variable<double>(aspectRatio.value);
    }
    if (likes.present) {
      map['likes'] = Variable<int>(likes.value);
    }
    if (comments.present) {
      map['comments'] = Variable<int>(comments.value);
    }
    if (shares.present) {
      map['shares'] = Variable<int>(shares.value);
    }
    if (isPublic.present) {
      map['is_public'] = Variable<int>(isPublic.value);
    }
    if (allowComments.present) {
      map['allow_comments'] = Variable<int>(allowComments.value);
    }
    if (isPending.present) {
      map['is_pending'] = Variable<int>(isPending.value);
    }
    if (isLiked.present) {
      map['is_liked'] = Variable<int>(isLiked.value);
    }
    if (taggerName.present) {
      map['tagger_name'] = Variable<String>(taggerName.value);
    }
    if (taggerAvatar.present) {
      map['tagger_avatar'] = Variable<String>(taggerAvatar.value);
    }
    if (sourceChannelName.present) {
      map['source_channel_name'] = Variable<String>(sourceChannelName.value);
    }
    if (sourceChannelAvatar.present) {
      map['source_channel_avatar'] = Variable<String>(
        sourceChannelAvatar.value,
      );
    }
    if (tagsCount.present) {
      map['tags_count'] = Variable<int>(tagsCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (postType.present) {
      map['post_type'] = Variable<String>(postType.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelPostsCompanion(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('authorId: $authorId, ')
          ..write('username: $username, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('caption: $caption, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('videoUrls: $videoUrls, ')
          ..write('thumbnailUrls: $thumbnailUrls, ')
          ..write('isVideo: $isVideo, ')
          ..write('isSponsored: $isSponsored, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('likes: $likes, ')
          ..write('comments: $comments, ')
          ..write('shares: $shares, ')
          ..write('isPublic: $isPublic, ')
          ..write('allowComments: $allowComments, ')
          ..write('isPending: $isPending, ')
          ..write('isLiked: $isLiked, ')
          ..write('taggerName: $taggerName, ')
          ..write('taggerAvatar: $taggerAvatar, ')
          ..write('sourceChannelName: $sourceChannelName, ')
          ..write('sourceChannelAvatar: $sourceChannelAvatar, ')
          ..write('tagsCount: $tagsCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('postType: $postType, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelPostTagsTable extends ChannelPostTags
    with TableInfo<$ChannelPostTagsTable, ChannelPostTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelPostTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<String> postId = GeneratedColumn<String>(
    'post_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagNameMeta = const VerificationMeta(
    'tagName',
  );
  @override
  late final GeneratedColumn<String> tagName = GeneratedColumn<String>(
    'tag_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagValueMeta = const VerificationMeta(
    'tagValue',
  );
  @override
  late final GeneratedColumn<String> tagValue = GeneratedColumn<String>(
    'tag_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagColorMeta = const VerificationMeta(
    'tagColor',
  );
  @override
  late final GeneratedColumn<String> tagColor = GeneratedColumn<String>(
    'tag_color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    postId,
    tagName,
    tagValue,
    tagColor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_post_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelPostTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('tag_name')) {
      context.handle(
        _tagNameMeta,
        tagName.isAcceptableOrUnknown(data['tag_name']!, _tagNameMeta),
      );
    } else if (isInserting) {
      context.missing(_tagNameMeta);
    }
    if (data.containsKey('tag_value')) {
      context.handle(
        _tagValueMeta,
        tagValue.isAcceptableOrUnknown(data['tag_value']!, _tagValueMeta),
      );
    }
    if (data.containsKey('tag_color')) {
      context.handle(
        _tagColorMeta,
        tagColor.isAcceptableOrUnknown(data['tag_color']!, _tagColorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChannelPostTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelPostTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      postId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}post_id'],
      )!,
      tagName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_name'],
      )!,
      tagValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_value'],
      ),
      tagColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_color'],
      ),
    );
  }

  @override
  $ChannelPostTagsTable createAlias(String alias) {
    return $ChannelPostTagsTable(attachedDatabase, alias);
  }
}

class ChannelPostTag extends DataClass implements Insertable<ChannelPostTag> {
  final int id;
  final String postId;
  final String tagName;
  final String? tagValue;
  final String? tagColor;
  const ChannelPostTag({
    required this.id,
    required this.postId,
    required this.tagName,
    this.tagValue,
    this.tagColor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['post_id'] = Variable<String>(postId);
    map['tag_name'] = Variable<String>(tagName);
    if (!nullToAbsent || tagValue != null) {
      map['tag_value'] = Variable<String>(tagValue);
    }
    if (!nullToAbsent || tagColor != null) {
      map['tag_color'] = Variable<String>(tagColor);
    }
    return map;
  }

  ChannelPostTagsCompanion toCompanion(bool nullToAbsent) {
    return ChannelPostTagsCompanion(
      id: Value(id),
      postId: Value(postId),
      tagName: Value(tagName),
      tagValue: tagValue == null && nullToAbsent
          ? const Value.absent()
          : Value(tagValue),
      tagColor: tagColor == null && nullToAbsent
          ? const Value.absent()
          : Value(tagColor),
    );
  }

  factory ChannelPostTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelPostTag(
      id: serializer.fromJson<int>(json['id']),
      postId: serializer.fromJson<String>(json['postId']),
      tagName: serializer.fromJson<String>(json['tagName']),
      tagValue: serializer.fromJson<String?>(json['tagValue']),
      tagColor: serializer.fromJson<String?>(json['tagColor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'postId': serializer.toJson<String>(postId),
      'tagName': serializer.toJson<String>(tagName),
      'tagValue': serializer.toJson<String?>(tagValue),
      'tagColor': serializer.toJson<String?>(tagColor),
    };
  }

  ChannelPostTag copyWith({
    int? id,
    String? postId,
    String? tagName,
    Value<String?> tagValue = const Value.absent(),
    Value<String?> tagColor = const Value.absent(),
  }) => ChannelPostTag(
    id: id ?? this.id,
    postId: postId ?? this.postId,
    tagName: tagName ?? this.tagName,
    tagValue: tagValue.present ? tagValue.value : this.tagValue,
    tagColor: tagColor.present ? tagColor.value : this.tagColor,
  );
  ChannelPostTag copyWithCompanion(ChannelPostTagsCompanion data) {
    return ChannelPostTag(
      id: data.id.present ? data.id.value : this.id,
      postId: data.postId.present ? data.postId.value : this.postId,
      tagName: data.tagName.present ? data.tagName.value : this.tagName,
      tagValue: data.tagValue.present ? data.tagValue.value : this.tagValue,
      tagColor: data.tagColor.present ? data.tagColor.value : this.tagColor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelPostTag(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('tagName: $tagName, ')
          ..write('tagValue: $tagValue, ')
          ..write('tagColor: $tagColor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, postId, tagName, tagValue, tagColor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelPostTag &&
          other.id == this.id &&
          other.postId == this.postId &&
          other.tagName == this.tagName &&
          other.tagValue == this.tagValue &&
          other.tagColor == this.tagColor);
}

class ChannelPostTagsCompanion extends UpdateCompanion<ChannelPostTag> {
  final Value<int> id;
  final Value<String> postId;
  final Value<String> tagName;
  final Value<String?> tagValue;
  final Value<String?> tagColor;
  const ChannelPostTagsCompanion({
    this.id = const Value.absent(),
    this.postId = const Value.absent(),
    this.tagName = const Value.absent(),
    this.tagValue = const Value.absent(),
    this.tagColor = const Value.absent(),
  });
  ChannelPostTagsCompanion.insert({
    this.id = const Value.absent(),
    required String postId,
    required String tagName,
    this.tagValue = const Value.absent(),
    this.tagColor = const Value.absent(),
  }) : postId = Value(postId),
       tagName = Value(tagName);
  static Insertable<ChannelPostTag> custom({
    Expression<int>? id,
    Expression<String>? postId,
    Expression<String>? tagName,
    Expression<String>? tagValue,
    Expression<String>? tagColor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (postId != null) 'post_id': postId,
      if (tagName != null) 'tag_name': tagName,
      if (tagValue != null) 'tag_value': tagValue,
      if (tagColor != null) 'tag_color': tagColor,
    });
  }

  ChannelPostTagsCompanion copyWith({
    Value<int>? id,
    Value<String>? postId,
    Value<String>? tagName,
    Value<String?>? tagValue,
    Value<String?>? tagColor,
  }) {
    return ChannelPostTagsCompanion(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      tagName: tagName ?? this.tagName,
      tagValue: tagValue ?? this.tagValue,
      tagColor: tagColor ?? this.tagColor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
    }
    if (tagName.present) {
      map['tag_name'] = Variable<String>(tagName.value);
    }
    if (tagValue.present) {
      map['tag_value'] = Variable<String>(tagValue.value);
    }
    if (tagColor.present) {
      map['tag_color'] = Variable<String>(tagColor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelPostTagsCompanion(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('tagName: $tagName, ')
          ..write('tagValue: $tagValue, ')
          ..write('tagColor: $tagColor')
          ..write(')'))
        .toString();
  }
}

class $ChannelContentTagsTable extends ChannelContentTags
    with TableInfo<$ChannelContentTagsTable, ChannelContentTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelContentTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<String> postId = GeneratedColumn<String>(
    'post_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceChannelIdMeta = const VerificationMeta(
    'sourceChannelId',
  );
  @override
  late final GeneratedColumn<String> sourceChannelId = GeneratedColumn<String>(
    'source_channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetChannelIdMeta = const VerificationMeta(
    'targetChannelId',
  );
  @override
  late final GeneratedColumn<String> targetChannelId = GeneratedColumn<String>(
    'target_channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linkChainMeta = const VerificationMeta(
    'linkChain',
  );
  @override
  late final GeneratedColumn<String> linkChain = GeneratedColumn<String>(
    'link_chain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    postId,
    userId,
    sourceChannelId,
    targetChannelId,
    linkChain,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_content_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelContentTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('source_channel_id')) {
      context.handle(
        _sourceChannelIdMeta,
        sourceChannelId.isAcceptableOrUnknown(
          data['source_channel_id']!,
          _sourceChannelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceChannelIdMeta);
    }
    if (data.containsKey('target_channel_id')) {
      context.handle(
        _targetChannelIdMeta,
        targetChannelId.isAcceptableOrUnknown(
          data['target_channel_id']!,
          _targetChannelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetChannelIdMeta);
    }
    if (data.containsKey('link_chain')) {
      context.handle(
        _linkChainMeta,
        linkChain.isAcceptableOrUnknown(data['link_chain']!, _linkChainMeta),
      );
    } else if (isInserting) {
      context.missing(_linkChainMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChannelContentTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelContentTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      postId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}post_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      sourceChannelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_channel_id'],
      )!,
      targetChannelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_channel_id'],
      )!,
      linkChain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link_chain'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ChannelContentTagsTable createAlias(String alias) {
    return $ChannelContentTagsTable(attachedDatabase, alias);
  }
}

class ChannelContentTag extends DataClass
    implements Insertable<ChannelContentTag> {
  final String id;
  final String postId;
  final String userId;
  final String sourceChannelId;
  final String targetChannelId;

  /// Stores the link chain as a JSON-encoded list of channel IDs
  final String linkChain;
  final DateTime createdAt;
  const ChannelContentTag({
    required this.id,
    required this.postId,
    required this.userId,
    required this.sourceChannelId,
    required this.targetChannelId,
    required this.linkChain,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['post_id'] = Variable<String>(postId);
    map['user_id'] = Variable<String>(userId);
    map['source_channel_id'] = Variable<String>(sourceChannelId);
    map['target_channel_id'] = Variable<String>(targetChannelId);
    map['link_chain'] = Variable<String>(linkChain);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChannelContentTagsCompanion toCompanion(bool nullToAbsent) {
    return ChannelContentTagsCompanion(
      id: Value(id),
      postId: Value(postId),
      userId: Value(userId),
      sourceChannelId: Value(sourceChannelId),
      targetChannelId: Value(targetChannelId),
      linkChain: Value(linkChain),
      createdAt: Value(createdAt),
    );
  }

  factory ChannelContentTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelContentTag(
      id: serializer.fromJson<String>(json['id']),
      postId: serializer.fromJson<String>(json['postId']),
      userId: serializer.fromJson<String>(json['userId']),
      sourceChannelId: serializer.fromJson<String>(json['sourceChannelId']),
      targetChannelId: serializer.fromJson<String>(json['targetChannelId']),
      linkChain: serializer.fromJson<String>(json['linkChain']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'postId': serializer.toJson<String>(postId),
      'userId': serializer.toJson<String>(userId),
      'sourceChannelId': serializer.toJson<String>(sourceChannelId),
      'targetChannelId': serializer.toJson<String>(targetChannelId),
      'linkChain': serializer.toJson<String>(linkChain),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChannelContentTag copyWith({
    String? id,
    String? postId,
    String? userId,
    String? sourceChannelId,
    String? targetChannelId,
    String? linkChain,
    DateTime? createdAt,
  }) => ChannelContentTag(
    id: id ?? this.id,
    postId: postId ?? this.postId,
    userId: userId ?? this.userId,
    sourceChannelId: sourceChannelId ?? this.sourceChannelId,
    targetChannelId: targetChannelId ?? this.targetChannelId,
    linkChain: linkChain ?? this.linkChain,
    createdAt: createdAt ?? this.createdAt,
  );
  ChannelContentTag copyWithCompanion(ChannelContentTagsCompanion data) {
    return ChannelContentTag(
      id: data.id.present ? data.id.value : this.id,
      postId: data.postId.present ? data.postId.value : this.postId,
      userId: data.userId.present ? data.userId.value : this.userId,
      sourceChannelId: data.sourceChannelId.present
          ? data.sourceChannelId.value
          : this.sourceChannelId,
      targetChannelId: data.targetChannelId.present
          ? data.targetChannelId.value
          : this.targetChannelId,
      linkChain: data.linkChain.present ? data.linkChain.value : this.linkChain,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelContentTag(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('userId: $userId, ')
          ..write('sourceChannelId: $sourceChannelId, ')
          ..write('targetChannelId: $targetChannelId, ')
          ..write('linkChain: $linkChain, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    postId,
    userId,
    sourceChannelId,
    targetChannelId,
    linkChain,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelContentTag &&
          other.id == this.id &&
          other.postId == this.postId &&
          other.userId == this.userId &&
          other.sourceChannelId == this.sourceChannelId &&
          other.targetChannelId == this.targetChannelId &&
          other.linkChain == this.linkChain &&
          other.createdAt == this.createdAt);
}

class ChannelContentTagsCompanion extends UpdateCompanion<ChannelContentTag> {
  final Value<String> id;
  final Value<String> postId;
  final Value<String> userId;
  final Value<String> sourceChannelId;
  final Value<String> targetChannelId;
  final Value<String> linkChain;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ChannelContentTagsCompanion({
    this.id = const Value.absent(),
    this.postId = const Value.absent(),
    this.userId = const Value.absent(),
    this.sourceChannelId = const Value.absent(),
    this.targetChannelId = const Value.absent(),
    this.linkChain = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelContentTagsCompanion.insert({
    required String id,
    required String postId,
    required String userId,
    required String sourceChannelId,
    required String targetChannelId,
    required String linkChain,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       postId = Value(postId),
       userId = Value(userId),
       sourceChannelId = Value(sourceChannelId),
       targetChannelId = Value(targetChannelId),
       linkChain = Value(linkChain);
  static Insertable<ChannelContentTag> custom({
    Expression<String>? id,
    Expression<String>? postId,
    Expression<String>? userId,
    Expression<String>? sourceChannelId,
    Expression<String>? targetChannelId,
    Expression<String>? linkChain,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (postId != null) 'post_id': postId,
      if (userId != null) 'user_id': userId,
      if (sourceChannelId != null) 'source_channel_id': sourceChannelId,
      if (targetChannelId != null) 'target_channel_id': targetChannelId,
      if (linkChain != null) 'link_chain': linkChain,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelContentTagsCompanion copyWith({
    Value<String>? id,
    Value<String>? postId,
    Value<String>? userId,
    Value<String>? sourceChannelId,
    Value<String>? targetChannelId,
    Value<String>? linkChain,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ChannelContentTagsCompanion(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      sourceChannelId: sourceChannelId ?? this.sourceChannelId,
      targetChannelId: targetChannelId ?? this.targetChannelId,
      linkChain: linkChain ?? this.linkChain,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sourceChannelId.present) {
      map['source_channel_id'] = Variable<String>(sourceChannelId.value);
    }
    if (targetChannelId.present) {
      map['target_channel_id'] = Variable<String>(targetChannelId.value);
    }
    if (linkChain.present) {
      map['link_chain'] = Variable<String>(linkChain.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelContentTagsCompanion(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('userId: $userId, ')
          ..write('sourceChannelId: $sourceChannelId, ')
          ..write('targetChannelId: $targetChannelId, ')
          ..write('linkChain: $linkChain, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelPostCommentsTable extends ChannelPostComments
    with TableInfo<$ChannelPostCommentsTable, ChannelPostComment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelPostCommentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<String> postId = GeneratedColumn<String>(
    'post_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profileImageUrlMeta = const VerificationMeta(
    'profileImageUrl',
  );
  @override
  late final GeneratedColumn<String> profileImageUrl = GeneratedColumn<String>(
    'profile_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlsMeta = const VerificationMeta(
    'imageUrls',
  );
  @override
  late final GeneratedColumn<String> imageUrls = GeneratedColumn<String>(
    'image_urls',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _likesMeta = const VerificationMeta('likes');
  @override
  late final GeneratedColumn<int> likes = GeneratedColumn<int>(
    'likes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPendingMeta = const VerificationMeta(
    'isPending',
  );
  @override
  late final GeneratedColumn<int> isPending = GeneratedColumn<int>(
    'is_pending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isLikedMeta = const VerificationMeta(
    'isLiked',
  );
  @override
  late final GeneratedColumn<int> isLiked = GeneratedColumn<int>(
    'is_liked',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    postId,
    channelId,
    authorId,
    username,
    profileImageUrl,
    message,
    imageUrls,
    likes,
    isPending,
    isLiked,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_post_comments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelPostComment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('profile_image_url')) {
      context.handle(
        _profileImageUrlMeta,
        profileImageUrl.isAcceptableOrUnknown(
          data['profile_image_url']!,
          _profileImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('image_urls')) {
      context.handle(
        _imageUrlsMeta,
        imageUrls.isAcceptableOrUnknown(data['image_urls']!, _imageUrlsMeta),
      );
    }
    if (data.containsKey('likes')) {
      context.handle(
        _likesMeta,
        likes.isAcceptableOrUnknown(data['likes']!, _likesMeta),
      );
    }
    if (data.containsKey('is_pending')) {
      context.handle(
        _isPendingMeta,
        isPending.isAcceptableOrUnknown(data['is_pending']!, _isPendingMeta),
      );
    }
    if (data.containsKey('is_liked')) {
      context.handle(
        _isLikedMeta,
        isLiked.isAcceptableOrUnknown(data['is_liked']!, _isLikedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChannelPostComment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelPostComment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      postId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}post_id'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      profileImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_image_url'],
      ),
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      imageUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_urls'],
      ),
      likes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}likes'],
      )!,
      isPending: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_pending'],
      )!,
      isLiked: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_liked'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ChannelPostCommentsTable createAlias(String alias) {
    return $ChannelPostCommentsTable(attachedDatabase, alias);
  }
}

class ChannelPostComment extends DataClass
    implements Insertable<ChannelPostComment> {
  final String id;
  final String postId;
  final String channelId;
  final String authorId;
  final String? username;
  final String? profileImageUrl;
  final String message;
  final String? imageUrls;
  final int likes;
  final int isPending;
  final int isLiked;
  final DateTime createdAt;
  const ChannelPostComment({
    required this.id,
    required this.postId,
    required this.channelId,
    required this.authorId,
    this.username,
    this.profileImageUrl,
    required this.message,
    this.imageUrls,
    required this.likes,
    required this.isPending,
    required this.isLiked,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['post_id'] = Variable<String>(postId);
    map['channel_id'] = Variable<String>(channelId);
    map['author_id'] = Variable<String>(authorId);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || profileImageUrl != null) {
      map['profile_image_url'] = Variable<String>(profileImageUrl);
    }
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || imageUrls != null) {
      map['image_urls'] = Variable<String>(imageUrls);
    }
    map['likes'] = Variable<int>(likes);
    map['is_pending'] = Variable<int>(isPending);
    map['is_liked'] = Variable<int>(isLiked);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChannelPostCommentsCompanion toCompanion(bool nullToAbsent) {
    return ChannelPostCommentsCompanion(
      id: Value(id),
      postId: Value(postId),
      channelId: Value(channelId),
      authorId: Value(authorId),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      profileImageUrl: profileImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImageUrl),
      message: Value(message),
      imageUrls: imageUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrls),
      likes: Value(likes),
      isPending: Value(isPending),
      isLiked: Value(isLiked),
      createdAt: Value(createdAt),
    );
  }

  factory ChannelPostComment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelPostComment(
      id: serializer.fromJson<String>(json['id']),
      postId: serializer.fromJson<String>(json['postId']),
      channelId: serializer.fromJson<String>(json['channelId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      username: serializer.fromJson<String?>(json['username']),
      profileImageUrl: serializer.fromJson<String?>(json['profileImageUrl']),
      message: serializer.fromJson<String>(json['message']),
      imageUrls: serializer.fromJson<String?>(json['imageUrls']),
      likes: serializer.fromJson<int>(json['likes']),
      isPending: serializer.fromJson<int>(json['isPending']),
      isLiked: serializer.fromJson<int>(json['isLiked']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'postId': serializer.toJson<String>(postId),
      'channelId': serializer.toJson<String>(channelId),
      'authorId': serializer.toJson<String>(authorId),
      'username': serializer.toJson<String?>(username),
      'profileImageUrl': serializer.toJson<String?>(profileImageUrl),
      'message': serializer.toJson<String>(message),
      'imageUrls': serializer.toJson<String?>(imageUrls),
      'likes': serializer.toJson<int>(likes),
      'isPending': serializer.toJson<int>(isPending),
      'isLiked': serializer.toJson<int>(isLiked),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChannelPostComment copyWith({
    String? id,
    String? postId,
    String? channelId,
    String? authorId,
    Value<String?> username = const Value.absent(),
    Value<String?> profileImageUrl = const Value.absent(),
    String? message,
    Value<String?> imageUrls = const Value.absent(),
    int? likes,
    int? isPending,
    int? isLiked,
    DateTime? createdAt,
  }) => ChannelPostComment(
    id: id ?? this.id,
    postId: postId ?? this.postId,
    channelId: channelId ?? this.channelId,
    authorId: authorId ?? this.authorId,
    username: username.present ? username.value : this.username,
    profileImageUrl: profileImageUrl.present
        ? profileImageUrl.value
        : this.profileImageUrl,
    message: message ?? this.message,
    imageUrls: imageUrls.present ? imageUrls.value : this.imageUrls,
    likes: likes ?? this.likes,
    isPending: isPending ?? this.isPending,
    isLiked: isLiked ?? this.isLiked,
    createdAt: createdAt ?? this.createdAt,
  );
  ChannelPostComment copyWithCompanion(ChannelPostCommentsCompanion data) {
    return ChannelPostComment(
      id: data.id.present ? data.id.value : this.id,
      postId: data.postId.present ? data.postId.value : this.postId,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      username: data.username.present ? data.username.value : this.username,
      profileImageUrl: data.profileImageUrl.present
          ? data.profileImageUrl.value
          : this.profileImageUrl,
      message: data.message.present ? data.message.value : this.message,
      imageUrls: data.imageUrls.present ? data.imageUrls.value : this.imageUrls,
      likes: data.likes.present ? data.likes.value : this.likes,
      isPending: data.isPending.present ? data.isPending.value : this.isPending,
      isLiked: data.isLiked.present ? data.isLiked.value : this.isLiked,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelPostComment(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('channelId: $channelId, ')
          ..write('authorId: $authorId, ')
          ..write('username: $username, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('message: $message, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('likes: $likes, ')
          ..write('isPending: $isPending, ')
          ..write('isLiked: $isLiked, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    postId,
    channelId,
    authorId,
    username,
    profileImageUrl,
    message,
    imageUrls,
    likes,
    isPending,
    isLiked,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelPostComment &&
          other.id == this.id &&
          other.postId == this.postId &&
          other.channelId == this.channelId &&
          other.authorId == this.authorId &&
          other.username == this.username &&
          other.profileImageUrl == this.profileImageUrl &&
          other.message == this.message &&
          other.imageUrls == this.imageUrls &&
          other.likes == this.likes &&
          other.isPending == this.isPending &&
          other.isLiked == this.isLiked &&
          other.createdAt == this.createdAt);
}

class ChannelPostCommentsCompanion extends UpdateCompanion<ChannelPostComment> {
  final Value<String> id;
  final Value<String> postId;
  final Value<String> channelId;
  final Value<String> authorId;
  final Value<String?> username;
  final Value<String?> profileImageUrl;
  final Value<String> message;
  final Value<String?> imageUrls;
  final Value<int> likes;
  final Value<int> isPending;
  final Value<int> isLiked;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ChannelPostCommentsCompanion({
    this.id = const Value.absent(),
    this.postId = const Value.absent(),
    this.channelId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.username = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.message = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.likes = const Value.absent(),
    this.isPending = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelPostCommentsCompanion.insert({
    required String id,
    required String postId,
    required String channelId,
    required String authorId,
    this.username = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    required String message,
    this.imageUrls = const Value.absent(),
    this.likes = const Value.absent(),
    this.isPending = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       postId = Value(postId),
       channelId = Value(channelId),
       authorId = Value(authorId),
       message = Value(message);
  static Insertable<ChannelPostComment> custom({
    Expression<String>? id,
    Expression<String>? postId,
    Expression<String>? channelId,
    Expression<String>? authorId,
    Expression<String>? username,
    Expression<String>? profileImageUrl,
    Expression<String>? message,
    Expression<String>? imageUrls,
    Expression<int>? likes,
    Expression<int>? isPending,
    Expression<int>? isLiked,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (postId != null) 'post_id': postId,
      if (channelId != null) 'channel_id': channelId,
      if (authorId != null) 'author_id': authorId,
      if (username != null) 'username': username,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      if (message != null) 'message': message,
      if (imageUrls != null) 'image_urls': imageUrls,
      if (likes != null) 'likes': likes,
      if (isPending != null) 'is_pending': isPending,
      if (isLiked != null) 'is_liked': isLiked,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelPostCommentsCompanion copyWith({
    Value<String>? id,
    Value<String>? postId,
    Value<String>? channelId,
    Value<String>? authorId,
    Value<String?>? username,
    Value<String?>? profileImageUrl,
    Value<String>? message,
    Value<String?>? imageUrls,
    Value<int>? likes,
    Value<int>? isPending,
    Value<int>? isLiked,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ChannelPostCommentsCompanion(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      channelId: channelId ?? this.channelId,
      authorId: authorId ?? this.authorId,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      message: message ?? this.message,
      imageUrls: imageUrls ?? this.imageUrls,
      likes: likes ?? this.likes,
      isPending: isPending ?? this.isPending,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (profileImageUrl.present) {
      map['profile_image_url'] = Variable<String>(profileImageUrl.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (imageUrls.present) {
      map['image_urls'] = Variable<String>(imageUrls.value);
    }
    if (likes.present) {
      map['likes'] = Variable<int>(likes.value);
    }
    if (isPending.present) {
      map['is_pending'] = Variable<int>(isPending.value);
    }
    if (isLiked.present) {
      map['is_liked'] = Variable<int>(isLiked.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelPostCommentsCompanion(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('channelId: $channelId, ')
          ..write('authorId: $authorId, ')
          ..write('username: $username, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('message: $message, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('likes: $likes, ')
          ..write('isPending: $isPending, ')
          ..write('isLiked: $isLiked, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelMessagesTable extends ChannelMessages
    with TableInfo<$ChannelMessagesTable, ChannelMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textContentMeta = const VerificationMeta(
    'textContent',
  );
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
    'text_content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaUrlMeta = const VerificationMeta(
    'mediaUrl',
  );
  @override
  late final GeneratedColumn<String> mediaUrl = GeneratedColumn<String>(
    'media_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voiceNoteUrlMeta = const VerificationMeta(
    'voiceNoteUrl',
  );
  @override
  late final GeneratedColumn<String> voiceNoteUrl = GeneratedColumn<String>(
    'voice_note_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replyToIdMeta = const VerificationMeta(
    'replyToId',
  );
  @override
  late final GeneratedColumn<String> replyToId = GeneratedColumn<String>(
    'reply_to_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<int> isRead = GeneratedColumn<int>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPendingMeta = const VerificationMeta(
    'isPending',
  );
  @override
  late final GeneratedColumn<int> isPending = GeneratedColumn<int>(
    'is_pending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _messageTypeMeta = const VerificationMeta(
    'messageType',
  );
  @override
  late final GeneratedColumn<String> messageType = GeneratedColumn<String>(
    'message_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('text'),
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    channelId,
    senderId,
    textContent,
    mediaUrl,
    thumbnailUrl,
    mediaType,
    voiceNoteUrl,
    replyToId,
    isRead,
    isPending,
    messageType,
    metadata,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('text_content')) {
      context.handle(
        _textContentMeta,
        textContent.isAcceptableOrUnknown(
          data['text_content']!,
          _textContentMeta,
        ),
      );
    }
    if (data.containsKey('media_url')) {
      context.handle(
        _mediaUrlMeta,
        mediaUrl.isAcceptableOrUnknown(data['media_url']!, _mediaUrlMeta),
      );
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    }
    if (data.containsKey('voice_note_url')) {
      context.handle(
        _voiceNoteUrlMeta,
        voiceNoteUrl.isAcceptableOrUnknown(
          data['voice_note_url']!,
          _voiceNoteUrlMeta,
        ),
      );
    }
    if (data.containsKey('reply_to_id')) {
      context.handle(
        _replyToIdMeta,
        replyToId.isAcceptableOrUnknown(data['reply_to_id']!, _replyToIdMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('is_pending')) {
      context.handle(
        _isPendingMeta,
        isPending.isAcceptableOrUnknown(data['is_pending']!, _isPendingMeta),
      );
    }
    if (data.containsKey('message_type')) {
      context.handle(
        _messageTypeMeta,
        messageType.isAcceptableOrUnknown(
          data['message_type']!,
          _messageTypeMeta,
        ),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChannelMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      textContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_content'],
      ),
      mediaUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_url'],
      ),
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      ),
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      ),
      voiceNoteUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voice_note_url'],
      ),
      replyToId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_to_id'],
      ),
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_read'],
      )!,
      isPending: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_pending'],
      )!,
      messageType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_type'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $ChannelMessagesTable createAlias(String alias) {
    return $ChannelMessagesTable(attachedDatabase, alias);
  }
}

class ChannelMessage extends DataClass implements Insertable<ChannelMessage> {
  final String id;
  final String channelId;
  final String senderId;
  final String? textContent;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String? mediaType;
  final String? voiceNoteUrl;
  final String? replyToId;
  final int isRead;
  final int isPending;
  final String messageType;
  final String? metadata;
  final String? createdAt;
  const ChannelMessage({
    required this.id,
    required this.channelId,
    required this.senderId,
    this.textContent,
    this.mediaUrl,
    this.thumbnailUrl,
    this.mediaType,
    this.voiceNoteUrl,
    this.replyToId,
    required this.isRead,
    required this.isPending,
    required this.messageType,
    this.metadata,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['channel_id'] = Variable<String>(channelId);
    map['sender_id'] = Variable<String>(senderId);
    if (!nullToAbsent || textContent != null) {
      map['text_content'] = Variable<String>(textContent);
    }
    if (!nullToAbsent || mediaUrl != null) {
      map['media_url'] = Variable<String>(mediaUrl);
    }
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    if (!nullToAbsent || mediaType != null) {
      map['media_type'] = Variable<String>(mediaType);
    }
    if (!nullToAbsent || voiceNoteUrl != null) {
      map['voice_note_url'] = Variable<String>(voiceNoteUrl);
    }
    if (!nullToAbsent || replyToId != null) {
      map['reply_to_id'] = Variable<String>(replyToId);
    }
    map['is_read'] = Variable<int>(isRead);
    map['is_pending'] = Variable<int>(isPending);
    map['message_type'] = Variable<String>(messageType);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    return map;
  }

  ChannelMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChannelMessagesCompanion(
      id: Value(id),
      channelId: Value(channelId),
      senderId: Value(senderId),
      textContent: textContent == null && nullToAbsent
          ? const Value.absent()
          : Value(textContent),
      mediaUrl: mediaUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaUrl),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      mediaType: mediaType == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaType),
      voiceNoteUrl: voiceNoteUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(voiceNoteUrl),
      replyToId: replyToId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToId),
      isRead: Value(isRead),
      isPending: Value(isPending),
      messageType: Value(messageType),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory ChannelMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelMessage(
      id: serializer.fromJson<String>(json['id']),
      channelId: serializer.fromJson<String>(json['channelId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      textContent: serializer.fromJson<String?>(json['textContent']),
      mediaUrl: serializer.fromJson<String?>(json['mediaUrl']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      mediaType: serializer.fromJson<String?>(json['mediaType']),
      voiceNoteUrl: serializer.fromJson<String?>(json['voiceNoteUrl']),
      replyToId: serializer.fromJson<String?>(json['replyToId']),
      isRead: serializer.fromJson<int>(json['isRead']),
      isPending: serializer.fromJson<int>(json['isPending']),
      messageType: serializer.fromJson<String>(json['messageType']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'channelId': serializer.toJson<String>(channelId),
      'senderId': serializer.toJson<String>(senderId),
      'textContent': serializer.toJson<String?>(textContent),
      'mediaUrl': serializer.toJson<String?>(mediaUrl),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'mediaType': serializer.toJson<String?>(mediaType),
      'voiceNoteUrl': serializer.toJson<String?>(voiceNoteUrl),
      'replyToId': serializer.toJson<String?>(replyToId),
      'isRead': serializer.toJson<int>(isRead),
      'isPending': serializer.toJson<int>(isPending),
      'messageType': serializer.toJson<String>(messageType),
      'metadata': serializer.toJson<String?>(metadata),
      'createdAt': serializer.toJson<String?>(createdAt),
    };
  }

  ChannelMessage copyWith({
    String? id,
    String? channelId,
    String? senderId,
    Value<String?> textContent = const Value.absent(),
    Value<String?> mediaUrl = const Value.absent(),
    Value<String?> thumbnailUrl = const Value.absent(),
    Value<String?> mediaType = const Value.absent(),
    Value<String?> voiceNoteUrl = const Value.absent(),
    Value<String?> replyToId = const Value.absent(),
    int? isRead,
    int? isPending,
    String? messageType,
    Value<String?> metadata = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
  }) => ChannelMessage(
    id: id ?? this.id,
    channelId: channelId ?? this.channelId,
    senderId: senderId ?? this.senderId,
    textContent: textContent.present ? textContent.value : this.textContent,
    mediaUrl: mediaUrl.present ? mediaUrl.value : this.mediaUrl,
    thumbnailUrl: thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
    mediaType: mediaType.present ? mediaType.value : this.mediaType,
    voiceNoteUrl: voiceNoteUrl.present ? voiceNoteUrl.value : this.voiceNoteUrl,
    replyToId: replyToId.present ? replyToId.value : this.replyToId,
    isRead: isRead ?? this.isRead,
    isPending: isPending ?? this.isPending,
    messageType: messageType ?? this.messageType,
    metadata: metadata.present ? metadata.value : this.metadata,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  ChannelMessage copyWithCompanion(ChannelMessagesCompanion data) {
    return ChannelMessage(
      id: data.id.present ? data.id.value : this.id,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      textContent: data.textContent.present
          ? data.textContent.value
          : this.textContent,
      mediaUrl: data.mediaUrl.present ? data.mediaUrl.value : this.mediaUrl,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      voiceNoteUrl: data.voiceNoteUrl.present
          ? data.voiceNoteUrl.value
          : this.voiceNoteUrl,
      replyToId: data.replyToId.present ? data.replyToId.value : this.replyToId,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      isPending: data.isPending.present ? data.isPending.value : this.isPending,
      messageType: data.messageType.present
          ? data.messageType.value
          : this.messageType,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelMessage(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('senderId: $senderId, ')
          ..write('textContent: $textContent, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('mediaType: $mediaType, ')
          ..write('voiceNoteUrl: $voiceNoteUrl, ')
          ..write('replyToId: $replyToId, ')
          ..write('isRead: $isRead, ')
          ..write('isPending: $isPending, ')
          ..write('messageType: $messageType, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    channelId,
    senderId,
    textContent,
    mediaUrl,
    thumbnailUrl,
    mediaType,
    voiceNoteUrl,
    replyToId,
    isRead,
    isPending,
    messageType,
    metadata,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelMessage &&
          other.id == this.id &&
          other.channelId == this.channelId &&
          other.senderId == this.senderId &&
          other.textContent == this.textContent &&
          other.mediaUrl == this.mediaUrl &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.mediaType == this.mediaType &&
          other.voiceNoteUrl == this.voiceNoteUrl &&
          other.replyToId == this.replyToId &&
          other.isRead == this.isRead &&
          other.isPending == this.isPending &&
          other.messageType == this.messageType &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt);
}

class ChannelMessagesCompanion extends UpdateCompanion<ChannelMessage> {
  final Value<String> id;
  final Value<String> channelId;
  final Value<String> senderId;
  final Value<String?> textContent;
  final Value<String?> mediaUrl;
  final Value<String?> thumbnailUrl;
  final Value<String?> mediaType;
  final Value<String?> voiceNoteUrl;
  final Value<String?> replyToId;
  final Value<int> isRead;
  final Value<int> isPending;
  final Value<String> messageType;
  final Value<String?> metadata;
  final Value<String?> createdAt;
  final Value<int> rowid;
  const ChannelMessagesCompanion({
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.textContent = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.voiceNoteUrl = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isPending = const Value.absent(),
    this.messageType = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelMessagesCompanion.insert({
    required String id,
    required String channelId,
    required String senderId,
    this.textContent = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.voiceNoteUrl = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isPending = const Value.absent(),
    this.messageType = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       channelId = Value(channelId),
       senderId = Value(senderId);
  static Insertable<ChannelMessage> custom({
    Expression<String>? id,
    Expression<String>? channelId,
    Expression<String>? senderId,
    Expression<String>? textContent,
    Expression<String>? mediaUrl,
    Expression<String>? thumbnailUrl,
    Expression<String>? mediaType,
    Expression<String>? voiceNoteUrl,
    Expression<String>? replyToId,
    Expression<int>? isRead,
    Expression<int>? isPending,
    Expression<String>? messageType,
    Expression<String>? metadata,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (channelId != null) 'channel_id': channelId,
      if (senderId != null) 'sender_id': senderId,
      if (textContent != null) 'text_content': textContent,
      if (mediaUrl != null) 'media_url': mediaUrl,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (mediaType != null) 'media_type': mediaType,
      if (voiceNoteUrl != null) 'voice_note_url': voiceNoteUrl,
      if (replyToId != null) 'reply_to_id': replyToId,
      if (isRead != null) 'is_read': isRead,
      if (isPending != null) 'is_pending': isPending,
      if (messageType != null) 'message_type': messageType,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? channelId,
    Value<String>? senderId,
    Value<String?>? textContent,
    Value<String?>? mediaUrl,
    Value<String?>? thumbnailUrl,
    Value<String?>? mediaType,
    Value<String?>? voiceNoteUrl,
    Value<String?>? replyToId,
    Value<int>? isRead,
    Value<int>? isPending,
    Value<String>? messageType,
    Value<String?>? metadata,
    Value<String?>? createdAt,
    Value<int>? rowid,
  }) {
    return ChannelMessagesCompanion(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      senderId: senderId ?? this.senderId,
      textContent: textContent ?? this.textContent,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      mediaType: mediaType ?? this.mediaType,
      voiceNoteUrl: voiceNoteUrl ?? this.voiceNoteUrl,
      replyToId: replyToId ?? this.replyToId,
      isRead: isRead ?? this.isRead,
      isPending: isPending ?? this.isPending,
      messageType: messageType ?? this.messageType,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (textContent.present) {
      map['text_content'] = Variable<String>(textContent.value);
    }
    if (mediaUrl.present) {
      map['media_url'] = Variable<String>(mediaUrl.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (voiceNoteUrl.present) {
      map['voice_note_url'] = Variable<String>(voiceNoteUrl.value);
    }
    if (replyToId.present) {
      map['reply_to_id'] = Variable<String>(replyToId.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<int>(isRead.value);
    }
    if (isPending.present) {
      map['is_pending'] = Variable<int>(isPending.value);
    }
    if (messageType.present) {
      map['message_type'] = Variable<String>(messageType.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelMessagesCompanion(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('senderId: $senderId, ')
          ..write('textContent: $textContent, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('mediaType: $mediaType, ')
          ..write('voiceNoteUrl: $voiceNoteUrl, ')
          ..write('replyToId: $replyToId, ')
          ..write('isRead: $isRead, ')
          ..write('isPending: $isPending, ')
          ..write('messageType: $messageType, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommonChannelsTable extends CommonChannels
    with TableInfo<$CommonChannelsTable, CommonChannel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommonChannelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _otherUserIdMeta = const VerificationMeta(
    'otherUserId',
  );
  @override
  late final GeneratedColumn<String> otherUserId = GeneratedColumn<String>(
    'other_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, otherUserId, channelId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'common_channels';
  @override
  VerificationContext validateIntegrity(
    Insertable<CommonChannel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('other_user_id')) {
      context.handle(
        _otherUserIdMeta,
        otherUserId.isAcceptableOrUnknown(
          data['other_user_id']!,
          _otherUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_otherUserIdMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, otherUserId, channelId};
  @override
  CommonChannel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommonChannel(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      otherUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_user_id'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
    );
  }

  @override
  $CommonChannelsTable createAlias(String alias) {
    return $CommonChannelsTable(attachedDatabase, alias);
  }
}

class CommonChannel extends DataClass implements Insertable<CommonChannel> {
  final String userId;
  final String otherUserId;
  final String channelId;
  const CommonChannel({
    required this.userId,
    required this.otherUserId,
    required this.channelId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['other_user_id'] = Variable<String>(otherUserId);
    map['channel_id'] = Variable<String>(channelId);
    return map;
  }

  CommonChannelsCompanion toCompanion(bool nullToAbsent) {
    return CommonChannelsCompanion(
      userId: Value(userId),
      otherUserId: Value(otherUserId),
      channelId: Value(channelId),
    );
  }

  factory CommonChannel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommonChannel(
      userId: serializer.fromJson<String>(json['userId']),
      otherUserId: serializer.fromJson<String>(json['otherUserId']),
      channelId: serializer.fromJson<String>(json['channelId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'otherUserId': serializer.toJson<String>(otherUserId),
      'channelId': serializer.toJson<String>(channelId),
    };
  }

  CommonChannel copyWith({
    String? userId,
    String? otherUserId,
    String? channelId,
  }) => CommonChannel(
    userId: userId ?? this.userId,
    otherUserId: otherUserId ?? this.otherUserId,
    channelId: channelId ?? this.channelId,
  );
  CommonChannel copyWithCompanion(CommonChannelsCompanion data) {
    return CommonChannel(
      userId: data.userId.present ? data.userId.value : this.userId,
      otherUserId: data.otherUserId.present
          ? data.otherUserId.value
          : this.otherUserId,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommonChannel(')
          ..write('userId: $userId, ')
          ..write('otherUserId: $otherUserId, ')
          ..write('channelId: $channelId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, otherUserId, channelId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommonChannel &&
          other.userId == this.userId &&
          other.otherUserId == this.otherUserId &&
          other.channelId == this.channelId);
}

class CommonChannelsCompanion extends UpdateCompanion<CommonChannel> {
  final Value<String> userId;
  final Value<String> otherUserId;
  final Value<String> channelId;
  final Value<int> rowid;
  const CommonChannelsCompanion({
    this.userId = const Value.absent(),
    this.otherUserId = const Value.absent(),
    this.channelId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommonChannelsCompanion.insert({
    required String userId,
    required String otherUserId,
    required String channelId,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       otherUserId = Value(otherUserId),
       channelId = Value(channelId);
  static Insertable<CommonChannel> custom({
    Expression<String>? userId,
    Expression<String>? otherUserId,
    Expression<String>? channelId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (otherUserId != null) 'other_user_id': otherUserId,
      if (channelId != null) 'channel_id': channelId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommonChannelsCompanion copyWith({
    Value<String>? userId,
    Value<String>? otherUserId,
    Value<String>? channelId,
    Value<int>? rowid,
  }) {
    return CommonChannelsCompanion(
      userId: userId ?? this.userId,
      otherUserId: otherUserId ?? this.otherUserId,
      channelId: channelId ?? this.channelId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (otherUserId.present) {
      map['other_user_id'] = Variable<String>(otherUserId.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommonChannelsCompanion(')
          ..write('userId: $userId, ')
          ..write('otherUserId: $otherUserId, ')
          ..write('channelId: $channelId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelMomentsTable extends ChannelMoments
    with TableInfo<$ChannelMomentsTable, ChannelMoment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelMomentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorNameMeta = const VerificationMeta(
    'authorName',
  );
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
    'author_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorAvatarUrlMeta = const VerificationMeta(
    'authorAvatarUrl',
  );
  @override
  late final GeneratedColumn<String> authorAvatarUrl = GeneratedColumn<String>(
    'author_avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaUrlMeta = const VerificationMeta(
    'mediaUrl',
  );
  @override
  late final GeneratedColumn<String> mediaUrl = GeneratedColumn<String>(
    'media_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('photo'),
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    channelId,
    authorId,
    authorName,
    authorAvatarUrl,
    mediaUrl,
    mediaType,
    thumbnailUrl,
    caption,
    createdAt,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_moments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelMoment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('author_name')) {
      context.handle(
        _authorNameMeta,
        authorName.isAcceptableOrUnknown(data['author_name']!, _authorNameMeta),
      );
    }
    if (data.containsKey('author_avatar_url')) {
      context.handle(
        _authorAvatarUrlMeta,
        authorAvatarUrl.isAcceptableOrUnknown(
          data['author_avatar_url']!,
          _authorAvatarUrlMeta,
        ),
      );
    }
    if (data.containsKey('media_url')) {
      context.handle(
        _mediaUrlMeta,
        mediaUrl.isAcceptableOrUnknown(data['media_url']!, _mediaUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaUrlMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChannelMoment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelMoment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      authorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_name'],
      ),
      authorAvatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_avatar_url'],
      ),
      mediaUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_url'],
      )!,
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      ),
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  $ChannelMomentsTable createAlias(String alias) {
    return $ChannelMomentsTable(attachedDatabase, alias);
  }
}

class ChannelMoment extends DataClass implements Insertable<ChannelMoment> {
  final String id;
  final String channelId;
  final String authorId;
  final String? authorName;
  final String? authorAvatarUrl;
  final String mediaUrl;
  final String mediaType;
  final String? thumbnailUrl;
  final String? caption;
  final DateTime createdAt;
  final DateTime? expiresAt;
  const ChannelMoment({
    required this.id,
    required this.channelId,
    required this.authorId,
    this.authorName,
    this.authorAvatarUrl,
    required this.mediaUrl,
    required this.mediaType,
    this.thumbnailUrl,
    this.caption,
    required this.createdAt,
    this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['channel_id'] = Variable<String>(channelId);
    map['author_id'] = Variable<String>(authorId);
    if (!nullToAbsent || authorName != null) {
      map['author_name'] = Variable<String>(authorName);
    }
    if (!nullToAbsent || authorAvatarUrl != null) {
      map['author_avatar_url'] = Variable<String>(authorAvatarUrl);
    }
    map['media_url'] = Variable<String>(mediaUrl);
    map['media_type'] = Variable<String>(mediaType);
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  ChannelMomentsCompanion toCompanion(bool nullToAbsent) {
    return ChannelMomentsCompanion(
      id: Value(id),
      channelId: Value(channelId),
      authorId: Value(authorId),
      authorName: authorName == null && nullToAbsent
          ? const Value.absent()
          : Value(authorName),
      authorAvatarUrl: authorAvatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(authorAvatarUrl),
      mediaUrl: Value(mediaUrl),
      mediaType: Value(mediaType),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      createdAt: Value(createdAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory ChannelMoment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelMoment(
      id: serializer.fromJson<String>(json['id']),
      channelId: serializer.fromJson<String>(json['channelId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      authorName: serializer.fromJson<String?>(json['authorName']),
      authorAvatarUrl: serializer.fromJson<String?>(json['authorAvatarUrl']),
      mediaUrl: serializer.fromJson<String>(json['mediaUrl']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      caption: serializer.fromJson<String?>(json['caption']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'channelId': serializer.toJson<String>(channelId),
      'authorId': serializer.toJson<String>(authorId),
      'authorName': serializer.toJson<String?>(authorName),
      'authorAvatarUrl': serializer.toJson<String?>(authorAvatarUrl),
      'mediaUrl': serializer.toJson<String>(mediaUrl),
      'mediaType': serializer.toJson<String>(mediaType),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'caption': serializer.toJson<String?>(caption),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  ChannelMoment copyWith({
    String? id,
    String? channelId,
    String? authorId,
    Value<String?> authorName = const Value.absent(),
    Value<String?> authorAvatarUrl = const Value.absent(),
    String? mediaUrl,
    String? mediaType,
    Value<String?> thumbnailUrl = const Value.absent(),
    Value<String?> caption = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> expiresAt = const Value.absent(),
  }) => ChannelMoment(
    id: id ?? this.id,
    channelId: channelId ?? this.channelId,
    authorId: authorId ?? this.authorId,
    authorName: authorName.present ? authorName.value : this.authorName,
    authorAvatarUrl: authorAvatarUrl.present
        ? authorAvatarUrl.value
        : this.authorAvatarUrl,
    mediaUrl: mediaUrl ?? this.mediaUrl,
    mediaType: mediaType ?? this.mediaType,
    thumbnailUrl: thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
    caption: caption.present ? caption.value : this.caption,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  ChannelMoment copyWithCompanion(ChannelMomentsCompanion data) {
    return ChannelMoment(
      id: data.id.present ? data.id.value : this.id,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorName: data.authorName.present
          ? data.authorName.value
          : this.authorName,
      authorAvatarUrl: data.authorAvatarUrl.present
          ? data.authorAvatarUrl.value
          : this.authorAvatarUrl,
      mediaUrl: data.mediaUrl.present ? data.mediaUrl.value : this.mediaUrl,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      caption: data.caption.present ? data.caption.value : this.caption,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelMoment(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('authorId: $authorId, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatarUrl: $authorAvatarUrl, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('mediaType: $mediaType, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('caption: $caption, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    channelId,
    authorId,
    authorName,
    authorAvatarUrl,
    mediaUrl,
    mediaType,
    thumbnailUrl,
    caption,
    createdAt,
    expiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelMoment &&
          other.id == this.id &&
          other.channelId == this.channelId &&
          other.authorId == this.authorId &&
          other.authorName == this.authorName &&
          other.authorAvatarUrl == this.authorAvatarUrl &&
          other.mediaUrl == this.mediaUrl &&
          other.mediaType == this.mediaType &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.caption == this.caption &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt);
}

class ChannelMomentsCompanion extends UpdateCompanion<ChannelMoment> {
  final Value<String> id;
  final Value<String> channelId;
  final Value<String> authorId;
  final Value<String?> authorName;
  final Value<String?> authorAvatarUrl;
  final Value<String> mediaUrl;
  final Value<String> mediaType;
  final Value<String?> thumbnailUrl;
  final Value<String?> caption;
  final Value<DateTime> createdAt;
  final Value<DateTime?> expiresAt;
  final Value<int> rowid;
  const ChannelMomentsCompanion({
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorAvatarUrl = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.caption = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelMomentsCompanion.insert({
    required String id,
    required String channelId,
    required String authorId,
    this.authorName = const Value.absent(),
    this.authorAvatarUrl = const Value.absent(),
    required String mediaUrl,
    this.mediaType = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.caption = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       channelId = Value(channelId),
       authorId = Value(authorId),
       mediaUrl = Value(mediaUrl);
  static Insertable<ChannelMoment> custom({
    Expression<String>? id,
    Expression<String>? channelId,
    Expression<String>? authorId,
    Expression<String>? authorName,
    Expression<String>? authorAvatarUrl,
    Expression<String>? mediaUrl,
    Expression<String>? mediaType,
    Expression<String>? thumbnailUrl,
    Expression<String>? caption,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (channelId != null) 'channel_id': channelId,
      if (authorId != null) 'author_id': authorId,
      if (authorName != null) 'author_name': authorName,
      if (authorAvatarUrl != null) 'author_avatar_url': authorAvatarUrl,
      if (mediaUrl != null) 'media_url': mediaUrl,
      if (mediaType != null) 'media_type': mediaType,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (caption != null) 'caption': caption,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelMomentsCompanion copyWith({
    Value<String>? id,
    Value<String>? channelId,
    Value<String>? authorId,
    Value<String?>? authorName,
    Value<String?>? authorAvatarUrl,
    Value<String>? mediaUrl,
    Value<String>? mediaType,
    Value<String?>? thumbnailUrl,
    Value<String?>? caption,
    Value<DateTime>? createdAt,
    Value<DateTime?>? expiresAt,
    Value<int>? rowid,
  }) {
    return ChannelMomentsCompanion(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (authorAvatarUrl.present) {
      map['author_avatar_url'] = Variable<String>(authorAvatarUrl.value);
    }
    if (mediaUrl.present) {
      map['media_url'] = Variable<String>(mediaUrl.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelMomentsCompanion(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('authorId: $authorId, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatarUrl: $authorAvatarUrl, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('mediaType: $mediaType, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('caption: $caption, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelInvitationsTable extends ChannelInvitations
    with TableInfo<$ChannelInvitationsTable, ChannelInvitation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelInvitationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _sourceChannelIdMeta = const VerificationMeta(
    'sourceChannelId',
  );
  @override
  late final GeneratedColumn<String> sourceChannelId = GeneratedColumn<String>(
    'source_channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES channels (id)',
    ),
  );
  static const VerificationMeta _targetChannelIdMeta = const VerificationMeta(
    'targetChannelId',
  );
  @override
  late final GeneratedColumn<String> targetChannelId = GeneratedColumn<String>(
    'target_channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES channels (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPendingMeta = const VerificationMeta(
    'isPending',
  );
  @override
  late final GeneratedColumn<int> isPending = GeneratedColumn<int>(
    'is_pending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    senderId,
    sourceChannelId,
    targetChannelId,
    createdAt,
    isPending,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_invitations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelInvitation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('source_channel_id')) {
      context.handle(
        _sourceChannelIdMeta,
        sourceChannelId.isAcceptableOrUnknown(
          data['source_channel_id']!,
          _sourceChannelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceChannelIdMeta);
    }
    if (data.containsKey('target_channel_id')) {
      context.handle(
        _targetChannelIdMeta,
        targetChannelId.isAcceptableOrUnknown(
          data['target_channel_id']!,
          _targetChannelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetChannelIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_pending')) {
      context.handle(
        _isPendingMeta,
        isPending.isAcceptableOrUnknown(data['is_pending']!, _isPendingMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChannelInvitation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelInvitation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      sourceChannelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_channel_id'],
      )!,
      targetChannelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_channel_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      isPending: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_pending'],
      )!,
    );
  }

  @override
  $ChannelInvitationsTable createAlias(String alias) {
    return $ChannelInvitationsTable(attachedDatabase, alias);
  }
}

class ChannelInvitation extends DataClass
    implements Insertable<ChannelInvitation> {
  final String id;
  final String senderId;
  final String sourceChannelId;
  final String targetChannelId;
  final String? createdAt;
  final int isPending;
  const ChannelInvitation({
    required this.id,
    required this.senderId,
    required this.sourceChannelId,
    required this.targetChannelId,
    this.createdAt,
    required this.isPending,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sender_id'] = Variable<String>(senderId);
    map['source_channel_id'] = Variable<String>(sourceChannelId);
    map['target_channel_id'] = Variable<String>(targetChannelId);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    map['is_pending'] = Variable<int>(isPending);
    return map;
  }

  ChannelInvitationsCompanion toCompanion(bool nullToAbsent) {
    return ChannelInvitationsCompanion(
      id: Value(id),
      senderId: Value(senderId),
      sourceChannelId: Value(sourceChannelId),
      targetChannelId: Value(targetChannelId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      isPending: Value(isPending),
    );
  }

  factory ChannelInvitation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelInvitation(
      id: serializer.fromJson<String>(json['id']),
      senderId: serializer.fromJson<String>(json['senderId']),
      sourceChannelId: serializer.fromJson<String>(json['sourceChannelId']),
      targetChannelId: serializer.fromJson<String>(json['targetChannelId']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      isPending: serializer.fromJson<int>(json['isPending']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'senderId': serializer.toJson<String>(senderId),
      'sourceChannelId': serializer.toJson<String>(sourceChannelId),
      'targetChannelId': serializer.toJson<String>(targetChannelId),
      'createdAt': serializer.toJson<String?>(createdAt),
      'isPending': serializer.toJson<int>(isPending),
    };
  }

  ChannelInvitation copyWith({
    String? id,
    String? senderId,
    String? sourceChannelId,
    String? targetChannelId,
    Value<String?> createdAt = const Value.absent(),
    int? isPending,
  }) => ChannelInvitation(
    id: id ?? this.id,
    senderId: senderId ?? this.senderId,
    sourceChannelId: sourceChannelId ?? this.sourceChannelId,
    targetChannelId: targetChannelId ?? this.targetChannelId,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    isPending: isPending ?? this.isPending,
  );
  ChannelInvitation copyWithCompanion(ChannelInvitationsCompanion data) {
    return ChannelInvitation(
      id: data.id.present ? data.id.value : this.id,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      sourceChannelId: data.sourceChannelId.present
          ? data.sourceChannelId.value
          : this.sourceChannelId,
      targetChannelId: data.targetChannelId.present
          ? data.targetChannelId.value
          : this.targetChannelId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isPending: data.isPending.present ? data.isPending.value : this.isPending,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelInvitation(')
          ..write('id: $id, ')
          ..write('senderId: $senderId, ')
          ..write('sourceChannelId: $sourceChannelId, ')
          ..write('targetChannelId: $targetChannelId, ')
          ..write('createdAt: $createdAt, ')
          ..write('isPending: $isPending')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    senderId,
    sourceChannelId,
    targetChannelId,
    createdAt,
    isPending,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelInvitation &&
          other.id == this.id &&
          other.senderId == this.senderId &&
          other.sourceChannelId == this.sourceChannelId &&
          other.targetChannelId == this.targetChannelId &&
          other.createdAt == this.createdAt &&
          other.isPending == this.isPending);
}

class ChannelInvitationsCompanion extends UpdateCompanion<ChannelInvitation> {
  final Value<String> id;
  final Value<String> senderId;
  final Value<String> sourceChannelId;
  final Value<String> targetChannelId;
  final Value<String?> createdAt;
  final Value<int> isPending;
  final Value<int> rowid;
  const ChannelInvitationsCompanion({
    this.id = const Value.absent(),
    this.senderId = const Value.absent(),
    this.sourceChannelId = const Value.absent(),
    this.targetChannelId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isPending = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelInvitationsCompanion.insert({
    required String id,
    required String senderId,
    required String sourceChannelId,
    required String targetChannelId,
    this.createdAt = const Value.absent(),
    this.isPending = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       senderId = Value(senderId),
       sourceChannelId = Value(sourceChannelId),
       targetChannelId = Value(targetChannelId);
  static Insertable<ChannelInvitation> custom({
    Expression<String>? id,
    Expression<String>? senderId,
    Expression<String>? sourceChannelId,
    Expression<String>? targetChannelId,
    Expression<String>? createdAt,
    Expression<int>? isPending,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (senderId != null) 'sender_id': senderId,
      if (sourceChannelId != null) 'source_channel_id': sourceChannelId,
      if (targetChannelId != null) 'target_channel_id': targetChannelId,
      if (createdAt != null) 'created_at': createdAt,
      if (isPending != null) 'is_pending': isPending,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelInvitationsCompanion copyWith({
    Value<String>? id,
    Value<String>? senderId,
    Value<String>? sourceChannelId,
    Value<String>? targetChannelId,
    Value<String?>? createdAt,
    Value<int>? isPending,
    Value<int>? rowid,
  }) {
    return ChannelInvitationsCompanion(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      sourceChannelId: sourceChannelId ?? this.sourceChannelId,
      targetChannelId: targetChannelId ?? this.targetChannelId,
      createdAt: createdAt ?? this.createdAt,
      isPending: isPending ?? this.isPending,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (sourceChannelId.present) {
      map['source_channel_id'] = Variable<String>(sourceChannelId.value);
    }
    if (targetChannelId.present) {
      map['target_channel_id'] = Variable<String>(targetChannelId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (isPending.present) {
      map['is_pending'] = Variable<int>(isPending.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelInvitationsCompanion(')
          ..write('id: $id, ')
          ..write('senderId: $senderId, ')
          ..write('sourceChannelId: $sourceChannelId, ')
          ..write('targetChannelId: $targetChannelId, ')
          ..write('createdAt: $createdAt, ')
          ..write('isPending: $isPending, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelPollsTable extends ChannelPolls
    with TableInfo<$ChannelPollsTable, ChannelPoll> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelPollsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPointsMeta = const VerificationMeta(
    'totalPoints',
  );
  @override
  late final GeneratedColumn<int> totalPoints = GeneratedColumn<int>(
    'total_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isClosedMeta = const VerificationMeta(
    'isClosed',
  );
  @override
  late final GeneratedColumn<int> isClosed = GeneratedColumn<int>(
    'is_closed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    messageId,
    title,
    totalPoints,
    isClosed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_polls';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelPoll> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('total_points')) {
      context.handle(
        _totalPointsMeta,
        totalPoints.isAcceptableOrUnknown(
          data['total_points']!,
          _totalPointsMeta,
        ),
      );
    }
    if (data.containsKey('is_closed')) {
      context.handle(
        _isClosedMeta,
        isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChannelPoll map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelPoll(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      totalPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_points'],
      )!,
      isClosed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_closed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ChannelPollsTable createAlias(String alias) {
    return $ChannelPollsTable(attachedDatabase, alias);
  }
}

class ChannelPoll extends DataClass implements Insertable<ChannelPoll> {
  final String id;
  final String messageId;
  final String title;
  final int totalPoints;
  final int isClosed;
  final DateTime createdAt;
  const ChannelPoll({
    required this.id,
    required this.messageId,
    required this.title,
    required this.totalPoints,
    required this.isClosed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['message_id'] = Variable<String>(messageId);
    map['title'] = Variable<String>(title);
    map['total_points'] = Variable<int>(totalPoints);
    map['is_closed'] = Variable<int>(isClosed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChannelPollsCompanion toCompanion(bool nullToAbsent) {
    return ChannelPollsCompanion(
      id: Value(id),
      messageId: Value(messageId),
      title: Value(title),
      totalPoints: Value(totalPoints),
      isClosed: Value(isClosed),
      createdAt: Value(createdAt),
    );
  }

  factory ChannelPoll.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelPoll(
      id: serializer.fromJson<String>(json['id']),
      messageId: serializer.fromJson<String>(json['messageId']),
      title: serializer.fromJson<String>(json['title']),
      totalPoints: serializer.fromJson<int>(json['totalPoints']),
      isClosed: serializer.fromJson<int>(json['isClosed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageId': serializer.toJson<String>(messageId),
      'title': serializer.toJson<String>(title),
      'totalPoints': serializer.toJson<int>(totalPoints),
      'isClosed': serializer.toJson<int>(isClosed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChannelPoll copyWith({
    String? id,
    String? messageId,
    String? title,
    int? totalPoints,
    int? isClosed,
    DateTime? createdAt,
  }) => ChannelPoll(
    id: id ?? this.id,
    messageId: messageId ?? this.messageId,
    title: title ?? this.title,
    totalPoints: totalPoints ?? this.totalPoints,
    isClosed: isClosed ?? this.isClosed,
    createdAt: createdAt ?? this.createdAt,
  );
  ChannelPoll copyWithCompanion(ChannelPollsCompanion data) {
    return ChannelPoll(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      title: data.title.present ? data.title.value : this.title,
      totalPoints: data.totalPoints.present
          ? data.totalPoints.value
          : this.totalPoints,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelPoll(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('title: $title, ')
          ..write('totalPoints: $totalPoints, ')
          ..write('isClosed: $isClosed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, messageId, title, totalPoints, isClosed, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelPoll &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.title == this.title &&
          other.totalPoints == this.totalPoints &&
          other.isClosed == this.isClosed &&
          other.createdAt == this.createdAt);
}

class ChannelPollsCompanion extends UpdateCompanion<ChannelPoll> {
  final Value<String> id;
  final Value<String> messageId;
  final Value<String> title;
  final Value<int> totalPoints;
  final Value<int> isClosed;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ChannelPollsCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.title = const Value.absent(),
    this.totalPoints = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelPollsCompanion.insert({
    required String id,
    required String messageId,
    required String title,
    this.totalPoints = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       messageId = Value(messageId),
       title = Value(title);
  static Insertable<ChannelPoll> custom({
    Expression<String>? id,
    Expression<String>? messageId,
    Expression<String>? title,
    Expression<int>? totalPoints,
    Expression<int>? isClosed,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (title != null) 'title': title,
      if (totalPoints != null) 'total_points': totalPoints,
      if (isClosed != null) 'is_closed': isClosed,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelPollsCompanion copyWith({
    Value<String>? id,
    Value<String>? messageId,
    Value<String>? title,
    Value<int>? totalPoints,
    Value<int>? isClosed,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ChannelPollsCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      title: title ?? this.title,
      totalPoints: totalPoints ?? this.totalPoints,
      isClosed: isClosed ?? this.isClosed,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (totalPoints.present) {
      map['total_points'] = Variable<int>(totalPoints.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<int>(isClosed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelPollsCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('title: $title, ')
          ..write('totalPoints: $totalPoints, ')
          ..write('isClosed: $isClosed, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelPollOptionsTable extends ChannelPollOptions
    with TableInfo<$ChannelPollOptionsTable, ChannelPollOption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelPollOptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pollIdMeta = const VerificationMeta('pollId');
  @override
  late final GeneratedColumn<String> pollId = GeneratedColumn<String>(
    'poll_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaUrlMeta = const VerificationMeta(
    'mediaUrl',
  );
  @override
  late final GeneratedColumn<String> mediaUrl = GeneratedColumn<String>(
    'media_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('image'),
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _suggestedByMeta = const VerificationMeta(
    'suggestedBy',
  );
  @override
  late final GeneratedColumn<String> suggestedBy = GeneratedColumn<String>(
    'suggested_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pollId,
    title,
    mediaUrl,
    mediaType,
    points,
    suggestedBy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_poll_options';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelPollOption> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('poll_id')) {
      context.handle(
        _pollIdMeta,
        pollId.isAcceptableOrUnknown(data['poll_id']!, _pollIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pollIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('media_url')) {
      context.handle(
        _mediaUrlMeta,
        mediaUrl.isAcceptableOrUnknown(data['media_url']!, _mediaUrlMeta),
      );
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    }
    if (data.containsKey('suggested_by')) {
      context.handle(
        _suggestedByMeta,
        suggestedBy.isAcceptableOrUnknown(
          data['suggested_by']!,
          _suggestedByMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChannelPollOption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelPollOption(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      pollId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poll_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      mediaUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_url'],
      ),
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      ),
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      suggestedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_by'],
      ),
    );
  }

  @override
  $ChannelPollOptionsTable createAlias(String alias) {
    return $ChannelPollOptionsTable(attachedDatabase, alias);
  }
}

class ChannelPollOption extends DataClass
    implements Insertable<ChannelPollOption> {
  final String id;
  final String pollId;
  final String title;
  final String? mediaUrl;
  final String? mediaType;
  final int points;
  final String? suggestedBy;
  const ChannelPollOption({
    required this.id,
    required this.pollId,
    required this.title,
    this.mediaUrl,
    this.mediaType,
    required this.points,
    this.suggestedBy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['poll_id'] = Variable<String>(pollId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || mediaUrl != null) {
      map['media_url'] = Variable<String>(mediaUrl);
    }
    if (!nullToAbsent || mediaType != null) {
      map['media_type'] = Variable<String>(mediaType);
    }
    map['points'] = Variable<int>(points);
    if (!nullToAbsent || suggestedBy != null) {
      map['suggested_by'] = Variable<String>(suggestedBy);
    }
    return map;
  }

  ChannelPollOptionsCompanion toCompanion(bool nullToAbsent) {
    return ChannelPollOptionsCompanion(
      id: Value(id),
      pollId: Value(pollId),
      title: Value(title),
      mediaUrl: mediaUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaUrl),
      mediaType: mediaType == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaType),
      points: Value(points),
      suggestedBy: suggestedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedBy),
    );
  }

  factory ChannelPollOption.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelPollOption(
      id: serializer.fromJson<String>(json['id']),
      pollId: serializer.fromJson<String>(json['pollId']),
      title: serializer.fromJson<String>(json['title']),
      mediaUrl: serializer.fromJson<String?>(json['mediaUrl']),
      mediaType: serializer.fromJson<String?>(json['mediaType']),
      points: serializer.fromJson<int>(json['points']),
      suggestedBy: serializer.fromJson<String?>(json['suggestedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pollId': serializer.toJson<String>(pollId),
      'title': serializer.toJson<String>(title),
      'mediaUrl': serializer.toJson<String?>(mediaUrl),
      'mediaType': serializer.toJson<String?>(mediaType),
      'points': serializer.toJson<int>(points),
      'suggestedBy': serializer.toJson<String?>(suggestedBy),
    };
  }

  ChannelPollOption copyWith({
    String? id,
    String? pollId,
    String? title,
    Value<String?> mediaUrl = const Value.absent(),
    Value<String?> mediaType = const Value.absent(),
    int? points,
    Value<String?> suggestedBy = const Value.absent(),
  }) => ChannelPollOption(
    id: id ?? this.id,
    pollId: pollId ?? this.pollId,
    title: title ?? this.title,
    mediaUrl: mediaUrl.present ? mediaUrl.value : this.mediaUrl,
    mediaType: mediaType.present ? mediaType.value : this.mediaType,
    points: points ?? this.points,
    suggestedBy: suggestedBy.present ? suggestedBy.value : this.suggestedBy,
  );
  ChannelPollOption copyWithCompanion(ChannelPollOptionsCompanion data) {
    return ChannelPollOption(
      id: data.id.present ? data.id.value : this.id,
      pollId: data.pollId.present ? data.pollId.value : this.pollId,
      title: data.title.present ? data.title.value : this.title,
      mediaUrl: data.mediaUrl.present ? data.mediaUrl.value : this.mediaUrl,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      points: data.points.present ? data.points.value : this.points,
      suggestedBy: data.suggestedBy.present
          ? data.suggestedBy.value
          : this.suggestedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelPollOption(')
          ..write('id: $id, ')
          ..write('pollId: $pollId, ')
          ..write('title: $title, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('mediaType: $mediaType, ')
          ..write('points: $points, ')
          ..write('suggestedBy: $suggestedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, pollId, title, mediaUrl, mediaType, points, suggestedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelPollOption &&
          other.id == this.id &&
          other.pollId == this.pollId &&
          other.title == this.title &&
          other.mediaUrl == this.mediaUrl &&
          other.mediaType == this.mediaType &&
          other.points == this.points &&
          other.suggestedBy == this.suggestedBy);
}

class ChannelPollOptionsCompanion extends UpdateCompanion<ChannelPollOption> {
  final Value<String> id;
  final Value<String> pollId;
  final Value<String> title;
  final Value<String?> mediaUrl;
  final Value<String?> mediaType;
  final Value<int> points;
  final Value<String?> suggestedBy;
  final Value<int> rowid;
  const ChannelPollOptionsCompanion({
    this.id = const Value.absent(),
    this.pollId = const Value.absent(),
    this.title = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.points = const Value.absent(),
    this.suggestedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelPollOptionsCompanion.insert({
    required String id,
    required String pollId,
    required String title,
    this.mediaUrl = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.points = const Value.absent(),
    this.suggestedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       pollId = Value(pollId),
       title = Value(title);
  static Insertable<ChannelPollOption> custom({
    Expression<String>? id,
    Expression<String>? pollId,
    Expression<String>? title,
    Expression<String>? mediaUrl,
    Expression<String>? mediaType,
    Expression<int>? points,
    Expression<String>? suggestedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pollId != null) 'poll_id': pollId,
      if (title != null) 'title': title,
      if (mediaUrl != null) 'media_url': mediaUrl,
      if (mediaType != null) 'media_type': mediaType,
      if (points != null) 'points': points,
      if (suggestedBy != null) 'suggested_by': suggestedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelPollOptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? pollId,
    Value<String>? title,
    Value<String?>? mediaUrl,
    Value<String?>? mediaType,
    Value<int>? points,
    Value<String?>? suggestedBy,
    Value<int>? rowid,
  }) {
    return ChannelPollOptionsCompanion(
      id: id ?? this.id,
      pollId: pollId ?? this.pollId,
      title: title ?? this.title,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      points: points ?? this.points,
      suggestedBy: suggestedBy ?? this.suggestedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pollId.present) {
      map['poll_id'] = Variable<String>(pollId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (mediaUrl.present) {
      map['media_url'] = Variable<String>(mediaUrl.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (suggestedBy.present) {
      map['suggested_by'] = Variable<String>(suggestedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelPollOptionsCompanion(')
          ..write('id: $id, ')
          ..write('pollId: $pollId, ')
          ..write('title: $title, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('mediaType: $mediaType, ')
          ..write('points: $points, ')
          ..write('suggestedBy: $suggestedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelGiftsTable extends ChannelGifts
    with TableInfo<$ChannelGiftsTable, ChannelGift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelGiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _giverIdMeta = const VerificationMeta(
    'giverId',
  );
  @override
  late final GeneratedColumn<String> giverId = GeneratedColumn<String>(
    'giver_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiverIdMeta = const VerificationMeta(
    'receiverId',
  );
  @override
  late final GeneratedColumn<String> receiverId = GeneratedColumn<String>(
    'receiver_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _giftIdMeta = const VerificationMeta('giftId');
  @override
  late final GeneratedColumn<String> giftId = GeneratedColumn<String>(
    'gift_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coinValueMeta = const VerificationMeta(
    'coinValue',
  );
  @override
  late final GeneratedColumn<int> coinValue = GeneratedColumn<int>(
    'coin_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    channelId,
    giverId,
    receiverId,
    giftId,
    coinValue,
    receivedAt,
    messageId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_gifts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelGift> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('giver_id')) {
      context.handle(
        _giverIdMeta,
        giverId.isAcceptableOrUnknown(data['giver_id']!, _giverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_giverIdMeta);
    }
    if (data.containsKey('receiver_id')) {
      context.handle(
        _receiverIdMeta,
        receiverId.isAcceptableOrUnknown(data['receiver_id']!, _receiverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_receiverIdMeta);
    }
    if (data.containsKey('gift_id')) {
      context.handle(
        _giftIdMeta,
        giftId.isAcceptableOrUnknown(data['gift_id']!, _giftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_giftIdMeta);
    }
    if (data.containsKey('coin_value')) {
      context.handle(
        _coinValueMeta,
        coinValue.isAcceptableOrUnknown(data['coin_value']!, _coinValueMeta),
      );
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChannelGift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelGift(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      giverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}giver_id'],
      )!,
      receiverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receiver_id'],
      )!,
      giftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gift_id'],
      )!,
      coinValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coin_value'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      ),
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      ),
    );
  }

  @override
  $ChannelGiftsTable createAlias(String alias) {
    return $ChannelGiftsTable(attachedDatabase, alias);
  }
}

class ChannelGift extends DataClass implements Insertable<ChannelGift> {
  final String id;
  final String channelId;
  final String giverId;
  final String receiverId;
  final String giftId;
  final int coinValue;
  final DateTime? receivedAt;
  final String? messageId;
  const ChannelGift({
    required this.id,
    required this.channelId,
    required this.giverId,
    required this.receiverId,
    required this.giftId,
    required this.coinValue,
    this.receivedAt,
    this.messageId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['channel_id'] = Variable<String>(channelId);
    map['giver_id'] = Variable<String>(giverId);
    map['receiver_id'] = Variable<String>(receiverId);
    map['gift_id'] = Variable<String>(giftId);
    map['coin_value'] = Variable<int>(coinValue);
    if (!nullToAbsent || receivedAt != null) {
      map['received_at'] = Variable<DateTime>(receivedAt);
    }
    if (!nullToAbsent || messageId != null) {
      map['message_id'] = Variable<String>(messageId);
    }
    return map;
  }

  ChannelGiftsCompanion toCompanion(bool nullToAbsent) {
    return ChannelGiftsCompanion(
      id: Value(id),
      channelId: Value(channelId),
      giverId: Value(giverId),
      receiverId: Value(receiverId),
      giftId: Value(giftId),
      coinValue: Value(coinValue),
      receivedAt: receivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(receivedAt),
      messageId: messageId == null && nullToAbsent
          ? const Value.absent()
          : Value(messageId),
    );
  }

  factory ChannelGift.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelGift(
      id: serializer.fromJson<String>(json['id']),
      channelId: serializer.fromJson<String>(json['channelId']),
      giverId: serializer.fromJson<String>(json['giverId']),
      receiverId: serializer.fromJson<String>(json['receiverId']),
      giftId: serializer.fromJson<String>(json['giftId']),
      coinValue: serializer.fromJson<int>(json['coinValue']),
      receivedAt: serializer.fromJson<DateTime?>(json['receivedAt']),
      messageId: serializer.fromJson<String?>(json['messageId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'channelId': serializer.toJson<String>(channelId),
      'giverId': serializer.toJson<String>(giverId),
      'receiverId': serializer.toJson<String>(receiverId),
      'giftId': serializer.toJson<String>(giftId),
      'coinValue': serializer.toJson<int>(coinValue),
      'receivedAt': serializer.toJson<DateTime?>(receivedAt),
      'messageId': serializer.toJson<String?>(messageId),
    };
  }

  ChannelGift copyWith({
    String? id,
    String? channelId,
    String? giverId,
    String? receiverId,
    String? giftId,
    int? coinValue,
    Value<DateTime?> receivedAt = const Value.absent(),
    Value<String?> messageId = const Value.absent(),
  }) => ChannelGift(
    id: id ?? this.id,
    channelId: channelId ?? this.channelId,
    giverId: giverId ?? this.giverId,
    receiverId: receiverId ?? this.receiverId,
    giftId: giftId ?? this.giftId,
    coinValue: coinValue ?? this.coinValue,
    receivedAt: receivedAt.present ? receivedAt.value : this.receivedAt,
    messageId: messageId.present ? messageId.value : this.messageId,
  );
  ChannelGift copyWithCompanion(ChannelGiftsCompanion data) {
    return ChannelGift(
      id: data.id.present ? data.id.value : this.id,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      giverId: data.giverId.present ? data.giverId.value : this.giverId,
      receiverId: data.receiverId.present
          ? data.receiverId.value
          : this.receiverId,
      giftId: data.giftId.present ? data.giftId.value : this.giftId,
      coinValue: data.coinValue.present ? data.coinValue.value : this.coinValue,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelGift(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('giverId: $giverId, ')
          ..write('receiverId: $receiverId, ')
          ..write('giftId: $giftId, ')
          ..write('coinValue: $coinValue, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('messageId: $messageId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    channelId,
    giverId,
    receiverId,
    giftId,
    coinValue,
    receivedAt,
    messageId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelGift &&
          other.id == this.id &&
          other.channelId == this.channelId &&
          other.giverId == this.giverId &&
          other.receiverId == this.receiverId &&
          other.giftId == this.giftId &&
          other.coinValue == this.coinValue &&
          other.receivedAt == this.receivedAt &&
          other.messageId == this.messageId);
}

class ChannelGiftsCompanion extends UpdateCompanion<ChannelGift> {
  final Value<String> id;
  final Value<String> channelId;
  final Value<String> giverId;
  final Value<String> receiverId;
  final Value<String> giftId;
  final Value<int> coinValue;
  final Value<DateTime?> receivedAt;
  final Value<String?> messageId;
  final Value<int> rowid;
  const ChannelGiftsCompanion({
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    this.giverId = const Value.absent(),
    this.receiverId = const Value.absent(),
    this.giftId = const Value.absent(),
    this.coinValue = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.messageId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelGiftsCompanion.insert({
    required String id,
    required String channelId,
    required String giverId,
    required String receiverId,
    required String giftId,
    this.coinValue = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.messageId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       channelId = Value(channelId),
       giverId = Value(giverId),
       receiverId = Value(receiverId),
       giftId = Value(giftId);
  static Insertable<ChannelGift> custom({
    Expression<String>? id,
    Expression<String>? channelId,
    Expression<String>? giverId,
    Expression<String>? receiverId,
    Expression<String>? giftId,
    Expression<int>? coinValue,
    Expression<DateTime>? receivedAt,
    Expression<String>? messageId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (channelId != null) 'channel_id': channelId,
      if (giverId != null) 'giver_id': giverId,
      if (receiverId != null) 'receiver_id': receiverId,
      if (giftId != null) 'gift_id': giftId,
      if (coinValue != null) 'coin_value': coinValue,
      if (receivedAt != null) 'received_at': receivedAt,
      if (messageId != null) 'message_id': messageId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelGiftsCompanion copyWith({
    Value<String>? id,
    Value<String>? channelId,
    Value<String>? giverId,
    Value<String>? receiverId,
    Value<String>? giftId,
    Value<int>? coinValue,
    Value<DateTime?>? receivedAt,
    Value<String?>? messageId,
    Value<int>? rowid,
  }) {
    return ChannelGiftsCompanion(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      giverId: giverId ?? this.giverId,
      receiverId: receiverId ?? this.receiverId,
      giftId: giftId ?? this.giftId,
      coinValue: coinValue ?? this.coinValue,
      receivedAt: receivedAt ?? this.receivedAt,
      messageId: messageId ?? this.messageId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (giverId.present) {
      map['giver_id'] = Variable<String>(giverId.value);
    }
    if (receiverId.present) {
      map['receiver_id'] = Variable<String>(receiverId.value);
    }
    if (giftId.present) {
      map['gift_id'] = Variable<String>(giftId.value);
    }
    if (coinValue.present) {
      map['coin_value'] = Variable<int>(coinValue.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelGiftsCompanion(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('giverId: $giverId, ')
          ..write('receiverId: $receiverId, ')
          ..write('giftId: $giftId, ')
          ..write('coinValue: $coinValue, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('messageId: $messageId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ChartDatabase extends GeneratedDatabase {
  _$ChartDatabase(QueryExecutor e) : super(e);
  $ChartDatabaseManager get managers => $ChartDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $PostsTable posts = $PostsTable(this);
  late final $ManifestosTable manifestos = $ManifestosTable(this);
  late final $ManifestoCommentsTable manifestoComments =
      $ManifestoCommentsTable(this);
  late final $ChannelsTable channels = $ChannelsTable(this);
  late final $ChannelMetadataTable channelMetadata = $ChannelMetadataTable(
    this,
  );
  late final $ChannelBrandingTable channelBranding = $ChannelBrandingTable(
    this,
  );
  late final $ChannelMembersTable channelMembers = $ChannelMembersTable(this);
  late final $ChannelStatusesTable channelStatuses = $ChannelStatusesTable(
    this,
  );
  late final $ChannelPresenceTable channelPresence = $ChannelPresenceTable(
    this,
  );
  late final $ChannelCreatorTable channelCreator = $ChannelCreatorTable(this);
  late final $ChannelPostsTable channelPosts = $ChannelPostsTable(this);
  late final $ChannelPostTagsTable channelPostTags = $ChannelPostTagsTable(
    this,
  );
  late final $ChannelContentTagsTable channelContentTags =
      $ChannelContentTagsTable(this);
  late final $ChannelPostCommentsTable channelPostComments =
      $ChannelPostCommentsTable(this);
  late final $ChannelMessagesTable channelMessages = $ChannelMessagesTable(
    this,
  );
  late final $CommonChannelsTable commonChannels = $CommonChannelsTable(this);
  late final $ChannelMomentsTable channelMoments = $ChannelMomentsTable(this);
  late final $ChannelInvitationsTable channelInvitations =
      $ChannelInvitationsTable(this);
  late final $ChannelPollsTable channelPolls = $ChannelPollsTable(this);
  late final $ChannelPollOptionsTable channelPollOptions =
      $ChannelPollOptionsTable(this);
  late final $ChannelGiftsTable channelGifts = $ChannelGiftsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    posts,
    manifestos,
    manifestoComments,
    channels,
    channelMetadata,
    channelBranding,
    channelMembers,
    channelStatuses,
    channelPresence,
    channelCreator,
    channelPosts,
    channelPostTags,
    channelContentTags,
    channelPostComments,
    channelMessages,
    commonChannels,
    channelMoments,
    channelInvitations,
    channelPolls,
    channelPollOptions,
    channelGifts,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      Value<String?> username,
      Value<String?> displayName,
      Value<String?> profileImageUrl,
      Value<String?> bio,
      Value<String?> title,
      Value<int?> isVerified,
      Value<int?> followersCount,
      Value<int?> followingCount,
      Value<int?> postsCount,
      Value<int?> chartsCount,
      Value<int?> channelsCount,
      Value<String?> chartTitle,
      Value<String?> birthday,
      Value<String?> gender,
      Value<String?> createdAt,
      Value<String?> accessToken,
      Value<String?> refreshToken,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String?> username,
      Value<String?> displayName,
      Value<String?> profileImageUrl,
      Value<String?> bio,
      Value<String?> title,
      Value<int?> isVerified,
      Value<int?> followersCount,
      Value<int?> followingCount,
      Value<int?> postsCount,
      Value<int?> chartsCount,
      Value<int?> channelsCount,
      Value<String?> chartTitle,
      Value<String?> birthday,
      Value<String?> gender,
      Value<String?> createdAt,
      Value<String?> accessToken,
      Value<String?> refreshToken,
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$ChartDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChannelInvitationsTable, List<ChannelInvitation>>
  _channelInvitationsRefsTable(_$ChartDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.channelInvitations,
        aliasName: $_aliasNameGenerator(
          db.users.id,
          db.channelInvitations.senderId,
        ),
      );

  $$ChannelInvitationsTableProcessedTableManager get channelInvitationsRefs {
    final manager = $$ChannelInvitationsTableTableManager(
      $_db,
      $_db.channelInvitations,
    ).filter((f) => f.senderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _channelInvitationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer
    extends Composer<_$ChartDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followersCount => $composableBuilder(
    column: $table.followersCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followingCount => $composableBuilder(
    column: $table.followingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get postsCount => $composableBuilder(
    column: $table.postsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chartsCount => $composableBuilder(
    column: $table.chartsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get channelsCount => $composableBuilder(
    column: $table.channelsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chartTitle => $composableBuilder(
    column: $table.chartTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> channelInvitationsRefs(
    Expression<bool> Function($$ChannelInvitationsTableFilterComposer f) f,
  ) {
    final $$ChannelInvitationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.channelInvitations,
      getReferencedColumn: (t) => t.senderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelInvitationsTableFilterComposer(
            $db: $db,
            $table: $db.channelInvitations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$ChartDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followersCount => $composableBuilder(
    column: $table.followersCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followingCount => $composableBuilder(
    column: $table.followingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get postsCount => $composableBuilder(
    column: $table.postsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chartsCount => $composableBuilder(
    column: $table.chartsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get channelsCount => $composableBuilder(
    column: $table.channelsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chartTitle => $composableBuilder(
    column: $table.chartTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$ChartDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );

  GeneratedColumn<int> get followersCount => $composableBuilder(
    column: $table.followersCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get followingCount => $composableBuilder(
    column: $table.followingCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get postsCount => $composableBuilder(
    column: $table.postsCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chartsCount => $composableBuilder(
    column: $table.chartsCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get channelsCount => $composableBuilder(
    column: $table.channelsCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chartTitle => $composableBuilder(
    column: $table.chartTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get birthday =>
      $composableBuilder(column: $table.birthday, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => column,
  );

  Expression<T> channelInvitationsRefs<T extends Object>(
    Expression<T> Function($$ChannelInvitationsTableAnnotationComposer a) f,
  ) {
    final $$ChannelInvitationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.channelInvitations,
          getReferencedColumn: (t) => t.senderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ChannelInvitationsTableAnnotationComposer(
                $db: $db,
                $table: $db.channelInvitations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({bool channelInvitationsRefs})
        > {
  $$UsersTableTableManager(_$ChartDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<int?> isVerified = const Value.absent(),
                Value<int?> followersCount = const Value.absent(),
                Value<int?> followingCount = const Value.absent(),
                Value<int?> postsCount = const Value.absent(),
                Value<int?> chartsCount = const Value.absent(),
                Value<int?> channelsCount = const Value.absent(),
                Value<String?> chartTitle = const Value.absent(),
                Value<String?> birthday = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String?> refreshToken = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                username: username,
                displayName: displayName,
                profileImageUrl: profileImageUrl,
                bio: bio,
                title: title,
                isVerified: isVerified,
                followersCount: followersCount,
                followingCount: followingCount,
                postsCount: postsCount,
                chartsCount: chartsCount,
                channelsCount: channelsCount,
                chartTitle: chartTitle,
                birthday: birthday,
                gender: gender,
                createdAt: createdAt,
                accessToken: accessToken,
                refreshToken: refreshToken,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> username = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<int?> isVerified = const Value.absent(),
                Value<int?> followersCount = const Value.absent(),
                Value<int?> followingCount = const Value.absent(),
                Value<int?> postsCount = const Value.absent(),
                Value<int?> chartsCount = const Value.absent(),
                Value<int?> channelsCount = const Value.absent(),
                Value<String?> chartTitle = const Value.absent(),
                Value<String?> birthday = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String?> refreshToken = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                username: username,
                displayName: displayName,
                profileImageUrl: profileImageUrl,
                bio: bio,
                title: title,
                isVerified: isVerified,
                followersCount: followersCount,
                followingCount: followingCount,
                postsCount: postsCount,
                chartsCount: chartsCount,
                channelsCount: channelsCount,
                chartTitle: chartTitle,
                birthday: birthday,
                gender: gender,
                createdAt: createdAt,
                accessToken: accessToken,
                refreshToken: refreshToken,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({channelInvitationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (channelInvitationsRefs) db.channelInvitations,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (channelInvitationsRefs)
                    await $_getPrefetchedData<
                      User,
                      $UsersTable,
                      ChannelInvitation
                    >(
                      currentTable: table,
                      referencedTable: $$UsersTableReferences
                          ._channelInvitationsRefsTable(db),
                      managerFromTypedResult: (p0) => $$UsersTableReferences(
                        db,
                        table,
                        p0,
                      ).channelInvitationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.senderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({bool channelInvitationsRefs})
    >;
typedef $$PostsTableCreateCompanionBuilder =
    PostsCompanion Function({
      required String id,
      Value<String?> authorId,
      Value<String?> username,
      Value<String?> userProfileImageUrl,
      Value<String?> channelName,
      Value<String?> channelId,
      Value<String?> caption,
      Value<String?> videoUrl,
      Value<String> videoUrls,
      Value<String?> audioUrl,
      Value<String?> sdVideoUrl,
      Value<String?> imageUrls,
      Value<String?> thumbnailUrls,
      Value<int?> isVideo,
      Value<int?> isAudio,
      Value<String> folderName,
      Value<double?> aspectRatio,
      Value<int?> likes,
      Value<int?> comments,
      Value<String?> timeAgo,
      Value<String?> createdAt,
      Value<int?> shares,
      Value<int?> isLiked,
      Value<int?> chartedCount,
      Value<String?> localFileCache,
      Value<int> isPending,
      Value<String?> linkedPostId,
      Value<String?> linkedAuthorUsername,
      Value<String?> linkedCaption,
      Value<String?> linkedChannelId,
      Value<String> postType,
      Value<String?> parentPostId,
      Value<String> linkChain,
      Value<int> linkDepth,
      Value<int> isPublic,
      Value<int> allowComments,
      Value<String?> taggerName,
      Value<String?> taggerAvatar,
      Value<String?> sourceChannelName,
      Value<String?> sourceChannelAvatar,
      Value<int> tagsCount,
      Value<String?> metadata,
      Value<int> rowid,
    });
typedef $$PostsTableUpdateCompanionBuilder =
    PostsCompanion Function({
      Value<String> id,
      Value<String?> authorId,
      Value<String?> username,
      Value<String?> userProfileImageUrl,
      Value<String?> channelName,
      Value<String?> channelId,
      Value<String?> caption,
      Value<String?> videoUrl,
      Value<String> videoUrls,
      Value<String?> audioUrl,
      Value<String?> sdVideoUrl,
      Value<String?> imageUrls,
      Value<String?> thumbnailUrls,
      Value<int?> isVideo,
      Value<int?> isAudio,
      Value<String> folderName,
      Value<double?> aspectRatio,
      Value<int?> likes,
      Value<int?> comments,
      Value<String?> timeAgo,
      Value<String?> createdAt,
      Value<int?> shares,
      Value<int?> isLiked,
      Value<int?> chartedCount,
      Value<String?> localFileCache,
      Value<int> isPending,
      Value<String?> linkedPostId,
      Value<String?> linkedAuthorUsername,
      Value<String?> linkedCaption,
      Value<String?> linkedChannelId,
      Value<String> postType,
      Value<String?> parentPostId,
      Value<String> linkChain,
      Value<int> linkDepth,
      Value<int> isPublic,
      Value<int> allowComments,
      Value<String?> taggerName,
      Value<String?> taggerAvatar,
      Value<String?> sourceChannelName,
      Value<String?> sourceChannelAvatar,
      Value<int> tagsCount,
      Value<String?> metadata,
      Value<int> rowid,
    });

class $$PostsTableFilterComposer
    extends Composer<_$ChartDatabase, $PostsTable> {
  $$PostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userProfileImageUrl => $composableBuilder(
    column: $table.userProfileImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelName => $composableBuilder(
    column: $table.channelName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get videoUrl => $composableBuilder(
    column: $table.videoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get videoUrls => $composableBuilder(
    column: $table.videoUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sdVideoUrl => $composableBuilder(
    column: $table.sdVideoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrls => $composableBuilder(
    column: $table.thumbnailUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isVideo => $composableBuilder(
    column: $table.isVideo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isAudio => $composableBuilder(
    column: $table.isAudio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folderName => $composableBuilder(
    column: $table.folderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeAgo => $composableBuilder(
    column: $table.timeAgo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chartedCount => $composableBuilder(
    column: $table.chartedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localFileCache => $composableBuilder(
    column: $table.localFileCache,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedPostId => $composableBuilder(
    column: $table.linkedPostId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedAuthorUsername => $composableBuilder(
    column: $table.linkedAuthorUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedCaption => $composableBuilder(
    column: $table.linkedCaption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedChannelId => $composableBuilder(
    column: $table.linkedChannelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postType => $composableBuilder(
    column: $table.postType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentPostId => $composableBuilder(
    column: $table.parentPostId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkChain => $composableBuilder(
    column: $table.linkChain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get linkDepth => $composableBuilder(
    column: $table.linkDepth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allowComments => $composableBuilder(
    column: $table.allowComments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taggerName => $composableBuilder(
    column: $table.taggerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taggerAvatar => $composableBuilder(
    column: $table.taggerAvatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceChannelName => $composableBuilder(
    column: $table.sourceChannelName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceChannelAvatar => $composableBuilder(
    column: $table.sourceChannelAvatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tagsCount => $composableBuilder(
    column: $table.tagsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PostsTableOrderingComposer
    extends Composer<_$ChartDatabase, $PostsTable> {
  $$PostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userProfileImageUrl => $composableBuilder(
    column: $table.userProfileImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelName => $composableBuilder(
    column: $table.channelName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get videoUrl => $composableBuilder(
    column: $table.videoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get videoUrls => $composableBuilder(
    column: $table.videoUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sdVideoUrl => $composableBuilder(
    column: $table.sdVideoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrls => $composableBuilder(
    column: $table.thumbnailUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isVideo => $composableBuilder(
    column: $table.isVideo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isAudio => $composableBuilder(
    column: $table.isAudio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folderName => $composableBuilder(
    column: $table.folderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeAgo => $composableBuilder(
    column: $table.timeAgo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chartedCount => $composableBuilder(
    column: $table.chartedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFileCache => $composableBuilder(
    column: $table.localFileCache,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedPostId => $composableBuilder(
    column: $table.linkedPostId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedAuthorUsername => $composableBuilder(
    column: $table.linkedAuthorUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedCaption => $composableBuilder(
    column: $table.linkedCaption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedChannelId => $composableBuilder(
    column: $table.linkedChannelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postType => $composableBuilder(
    column: $table.postType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentPostId => $composableBuilder(
    column: $table.parentPostId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkChain => $composableBuilder(
    column: $table.linkChain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get linkDepth => $composableBuilder(
    column: $table.linkDepth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allowComments => $composableBuilder(
    column: $table.allowComments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taggerName => $composableBuilder(
    column: $table.taggerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taggerAvatar => $composableBuilder(
    column: $table.taggerAvatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceChannelName => $composableBuilder(
    column: $table.sourceChannelName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceChannelAvatar => $composableBuilder(
    column: $table.sourceChannelAvatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tagsCount => $composableBuilder(
    column: $table.tagsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PostsTableAnnotationComposer
    extends Composer<_$ChartDatabase, $PostsTable> {
  $$PostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get userProfileImageUrl => $composableBuilder(
    column: $table.userProfileImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get channelName => $composableBuilder(
    column: $table.channelName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => column);

  GeneratedColumn<String> get videoUrls =>
      $composableBuilder(column: $table.videoUrls, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get sdVideoUrl => $composableBuilder(
    column: $table.sdVideoUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrls =>
      $composableBuilder(column: $table.imageUrls, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrls => $composableBuilder(
    column: $table.thumbnailUrls,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isVideo =>
      $composableBuilder(column: $table.isVideo, builder: (column) => column);

  GeneratedColumn<int> get isAudio =>
      $composableBuilder(column: $table.isAudio, builder: (column) => column);

  GeneratedColumn<String> get folderName => $composableBuilder(
    column: $table.folderName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => column,
  );

  GeneratedColumn<int> get likes =>
      $composableBuilder(column: $table.likes, builder: (column) => column);

  GeneratedColumn<int> get comments =>
      $composableBuilder(column: $table.comments, builder: (column) => column);

  GeneratedColumn<String> get timeAgo =>
      $composableBuilder(column: $table.timeAgo, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get shares =>
      $composableBuilder(column: $table.shares, builder: (column) => column);

  GeneratedColumn<int> get isLiked =>
      $composableBuilder(column: $table.isLiked, builder: (column) => column);

  GeneratedColumn<int> get chartedCount => $composableBuilder(
    column: $table.chartedCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localFileCache => $composableBuilder(
    column: $table.localFileCache,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isPending =>
      $composableBuilder(column: $table.isPending, builder: (column) => column);

  GeneratedColumn<String> get linkedPostId => $composableBuilder(
    column: $table.linkedPostId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedAuthorUsername => $composableBuilder(
    column: $table.linkedAuthorUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedCaption => $composableBuilder(
    column: $table.linkedCaption,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedChannelId => $composableBuilder(
    column: $table.linkedChannelId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get postType =>
      $composableBuilder(column: $table.postType, builder: (column) => column);

  GeneratedColumn<String> get parentPostId => $composableBuilder(
    column: $table.parentPostId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkChain =>
      $composableBuilder(column: $table.linkChain, builder: (column) => column);

  GeneratedColumn<int> get linkDepth =>
      $composableBuilder(column: $table.linkDepth, builder: (column) => column);

  GeneratedColumn<int> get isPublic =>
      $composableBuilder(column: $table.isPublic, builder: (column) => column);

  GeneratedColumn<int> get allowComments => $composableBuilder(
    column: $table.allowComments,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taggerName => $composableBuilder(
    column: $table.taggerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taggerAvatar => $composableBuilder(
    column: $table.taggerAvatar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceChannelName => $composableBuilder(
    column: $table.sourceChannelName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceChannelAvatar => $composableBuilder(
    column: $table.sourceChannelAvatar,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tagsCount =>
      $composableBuilder(column: $table.tagsCount, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$PostsTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $PostsTable,
          Post,
          $$PostsTableFilterComposer,
          $$PostsTableOrderingComposer,
          $$PostsTableAnnotationComposer,
          $$PostsTableCreateCompanionBuilder,
          $$PostsTableUpdateCompanionBuilder,
          (Post, BaseReferences<_$ChartDatabase, $PostsTable, Post>),
          Post,
          PrefetchHooks Function()
        > {
  $$PostsTableTableManager(_$ChartDatabase db, $PostsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> authorId = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> userProfileImageUrl = const Value.absent(),
                Value<String?> channelName = const Value.absent(),
                Value<String?> channelId = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<String?> videoUrl = const Value.absent(),
                Value<String> videoUrls = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<String?> sdVideoUrl = const Value.absent(),
                Value<String?> imageUrls = const Value.absent(),
                Value<String?> thumbnailUrls = const Value.absent(),
                Value<int?> isVideo = const Value.absent(),
                Value<int?> isAudio = const Value.absent(),
                Value<String> folderName = const Value.absent(),
                Value<double?> aspectRatio = const Value.absent(),
                Value<int?> likes = const Value.absent(),
                Value<int?> comments = const Value.absent(),
                Value<String?> timeAgo = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<int?> shares = const Value.absent(),
                Value<int?> isLiked = const Value.absent(),
                Value<int?> chartedCount = const Value.absent(),
                Value<String?> localFileCache = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<String?> linkedPostId = const Value.absent(),
                Value<String?> linkedAuthorUsername = const Value.absent(),
                Value<String?> linkedCaption = const Value.absent(),
                Value<String?> linkedChannelId = const Value.absent(),
                Value<String> postType = const Value.absent(),
                Value<String?> parentPostId = const Value.absent(),
                Value<String> linkChain = const Value.absent(),
                Value<int> linkDepth = const Value.absent(),
                Value<int> isPublic = const Value.absent(),
                Value<int> allowComments = const Value.absent(),
                Value<String?> taggerName = const Value.absent(),
                Value<String?> taggerAvatar = const Value.absent(),
                Value<String?> sourceChannelName = const Value.absent(),
                Value<String?> sourceChannelAvatar = const Value.absent(),
                Value<int> tagsCount = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostsCompanion(
                id: id,
                authorId: authorId,
                username: username,
                userProfileImageUrl: userProfileImageUrl,
                channelName: channelName,
                channelId: channelId,
                caption: caption,
                videoUrl: videoUrl,
                videoUrls: videoUrls,
                audioUrl: audioUrl,
                sdVideoUrl: sdVideoUrl,
                imageUrls: imageUrls,
                thumbnailUrls: thumbnailUrls,
                isVideo: isVideo,
                isAudio: isAudio,
                folderName: folderName,
                aspectRatio: aspectRatio,
                likes: likes,
                comments: comments,
                timeAgo: timeAgo,
                createdAt: createdAt,
                shares: shares,
                isLiked: isLiked,
                chartedCount: chartedCount,
                localFileCache: localFileCache,
                isPending: isPending,
                linkedPostId: linkedPostId,
                linkedAuthorUsername: linkedAuthorUsername,
                linkedCaption: linkedCaption,
                linkedChannelId: linkedChannelId,
                postType: postType,
                parentPostId: parentPostId,
                linkChain: linkChain,
                linkDepth: linkDepth,
                isPublic: isPublic,
                allowComments: allowComments,
                taggerName: taggerName,
                taggerAvatar: taggerAvatar,
                sourceChannelName: sourceChannelName,
                sourceChannelAvatar: sourceChannelAvatar,
                tagsCount: tagsCount,
                metadata: metadata,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> authorId = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> userProfileImageUrl = const Value.absent(),
                Value<String?> channelName = const Value.absent(),
                Value<String?> channelId = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<String?> videoUrl = const Value.absent(),
                Value<String> videoUrls = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<String?> sdVideoUrl = const Value.absent(),
                Value<String?> imageUrls = const Value.absent(),
                Value<String?> thumbnailUrls = const Value.absent(),
                Value<int?> isVideo = const Value.absent(),
                Value<int?> isAudio = const Value.absent(),
                Value<String> folderName = const Value.absent(),
                Value<double?> aspectRatio = const Value.absent(),
                Value<int?> likes = const Value.absent(),
                Value<int?> comments = const Value.absent(),
                Value<String?> timeAgo = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<int?> shares = const Value.absent(),
                Value<int?> isLiked = const Value.absent(),
                Value<int?> chartedCount = const Value.absent(),
                Value<String?> localFileCache = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<String?> linkedPostId = const Value.absent(),
                Value<String?> linkedAuthorUsername = const Value.absent(),
                Value<String?> linkedCaption = const Value.absent(),
                Value<String?> linkedChannelId = const Value.absent(),
                Value<String> postType = const Value.absent(),
                Value<String?> parentPostId = const Value.absent(),
                Value<String> linkChain = const Value.absent(),
                Value<int> linkDepth = const Value.absent(),
                Value<int> isPublic = const Value.absent(),
                Value<int> allowComments = const Value.absent(),
                Value<String?> taggerName = const Value.absent(),
                Value<String?> taggerAvatar = const Value.absent(),
                Value<String?> sourceChannelName = const Value.absent(),
                Value<String?> sourceChannelAvatar = const Value.absent(),
                Value<int> tagsCount = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostsCompanion.insert(
                id: id,
                authorId: authorId,
                username: username,
                userProfileImageUrl: userProfileImageUrl,
                channelName: channelName,
                channelId: channelId,
                caption: caption,
                videoUrl: videoUrl,
                videoUrls: videoUrls,
                audioUrl: audioUrl,
                sdVideoUrl: sdVideoUrl,
                imageUrls: imageUrls,
                thumbnailUrls: thumbnailUrls,
                isVideo: isVideo,
                isAudio: isAudio,
                folderName: folderName,
                aspectRatio: aspectRatio,
                likes: likes,
                comments: comments,
                timeAgo: timeAgo,
                createdAt: createdAt,
                shares: shares,
                isLiked: isLiked,
                chartedCount: chartedCount,
                localFileCache: localFileCache,
                isPending: isPending,
                linkedPostId: linkedPostId,
                linkedAuthorUsername: linkedAuthorUsername,
                linkedCaption: linkedCaption,
                linkedChannelId: linkedChannelId,
                postType: postType,
                parentPostId: parentPostId,
                linkChain: linkChain,
                linkDepth: linkDepth,
                isPublic: isPublic,
                allowComments: allowComments,
                taggerName: taggerName,
                taggerAvatar: taggerAvatar,
                sourceChannelName: sourceChannelName,
                sourceChannelAvatar: sourceChannelAvatar,
                tagsCount: tagsCount,
                metadata: metadata,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PostsTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $PostsTable,
      Post,
      $$PostsTableFilterComposer,
      $$PostsTableOrderingComposer,
      $$PostsTableAnnotationComposer,
      $$PostsTableCreateCompanionBuilder,
      $$PostsTableUpdateCompanionBuilder,
      (Post, BaseReferences<_$ChartDatabase, $PostsTable, Post>),
      Post,
      PrefetchHooks Function()
    >;
typedef $$ManifestosTableCreateCompanionBuilder =
    ManifestosCompanion Function({
      required String id,
      required String authorId,
      Value<String?> username,
      Value<String?> profileImageUrl,
      required String channelId,
      Value<String?> caption,
      Value<String?> videoUrl,
      Value<String> videoUrls,
      Value<String?> imageUrls,
      Value<String?> thumbnailUrls,
      Value<int> likes,
      Value<int> comments,
      Value<int> isPublic,
      Value<int> allowComments,
      Value<int> isPending,
      Value<int> isLiked,
      Value<double?> aspectRatio,
      Value<DateTime> createdAt,
      Value<String?> taggerName,
      Value<String?> taggerAvatar,
      Value<String?> sourceChannelName,
      Value<String?> sourceChannelAvatar,
      Value<int> tagsCount,
      Value<String?> metadata,
      Value<int> rowid,
    });
typedef $$ManifestosTableUpdateCompanionBuilder =
    ManifestosCompanion Function({
      Value<String> id,
      Value<String> authorId,
      Value<String?> username,
      Value<String?> profileImageUrl,
      Value<String> channelId,
      Value<String?> caption,
      Value<String?> videoUrl,
      Value<String> videoUrls,
      Value<String?> imageUrls,
      Value<String?> thumbnailUrls,
      Value<int> likes,
      Value<int> comments,
      Value<int> isPublic,
      Value<int> allowComments,
      Value<int> isPending,
      Value<int> isLiked,
      Value<double?> aspectRatio,
      Value<DateTime> createdAt,
      Value<String?> taggerName,
      Value<String?> taggerAvatar,
      Value<String?> sourceChannelName,
      Value<String?> sourceChannelAvatar,
      Value<int> tagsCount,
      Value<String?> metadata,
      Value<int> rowid,
    });

class $$ManifestosTableFilterComposer
    extends Composer<_$ChartDatabase, $ManifestosTable> {
  $$ManifestosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get videoUrl => $composableBuilder(
    column: $table.videoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get videoUrls => $composableBuilder(
    column: $table.videoUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrls => $composableBuilder(
    column: $table.thumbnailUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allowComments => $composableBuilder(
    column: $table.allowComments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taggerName => $composableBuilder(
    column: $table.taggerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taggerAvatar => $composableBuilder(
    column: $table.taggerAvatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceChannelName => $composableBuilder(
    column: $table.sourceChannelName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceChannelAvatar => $composableBuilder(
    column: $table.sourceChannelAvatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tagsCount => $composableBuilder(
    column: $table.tagsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ManifestosTableOrderingComposer
    extends Composer<_$ChartDatabase, $ManifestosTable> {
  $$ManifestosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get videoUrl => $composableBuilder(
    column: $table.videoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get videoUrls => $composableBuilder(
    column: $table.videoUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrls => $composableBuilder(
    column: $table.thumbnailUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allowComments => $composableBuilder(
    column: $table.allowComments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taggerName => $composableBuilder(
    column: $table.taggerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taggerAvatar => $composableBuilder(
    column: $table.taggerAvatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceChannelName => $composableBuilder(
    column: $table.sourceChannelName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceChannelAvatar => $composableBuilder(
    column: $table.sourceChannelAvatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tagsCount => $composableBuilder(
    column: $table.tagsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ManifestosTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ManifestosTable> {
  $$ManifestosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => column);

  GeneratedColumn<String> get videoUrls =>
      $composableBuilder(column: $table.videoUrls, builder: (column) => column);

  GeneratedColumn<String> get imageUrls =>
      $composableBuilder(column: $table.imageUrls, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrls => $composableBuilder(
    column: $table.thumbnailUrls,
    builder: (column) => column,
  );

  GeneratedColumn<int> get likes =>
      $composableBuilder(column: $table.likes, builder: (column) => column);

  GeneratedColumn<int> get comments =>
      $composableBuilder(column: $table.comments, builder: (column) => column);

  GeneratedColumn<int> get isPublic =>
      $composableBuilder(column: $table.isPublic, builder: (column) => column);

  GeneratedColumn<int> get allowComments => $composableBuilder(
    column: $table.allowComments,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isPending =>
      $composableBuilder(column: $table.isPending, builder: (column) => column);

  GeneratedColumn<int> get isLiked =>
      $composableBuilder(column: $table.isLiked, builder: (column) => column);

  GeneratedColumn<double> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get taggerName => $composableBuilder(
    column: $table.taggerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taggerAvatar => $composableBuilder(
    column: $table.taggerAvatar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceChannelName => $composableBuilder(
    column: $table.sourceChannelName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceChannelAvatar => $composableBuilder(
    column: $table.sourceChannelAvatar,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tagsCount =>
      $composableBuilder(column: $table.tagsCount, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$ManifestosTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ManifestosTable,
          Manifesto,
          $$ManifestosTableFilterComposer,
          $$ManifestosTableOrderingComposer,
          $$ManifestosTableAnnotationComposer,
          $$ManifestosTableCreateCompanionBuilder,
          $$ManifestosTableUpdateCompanionBuilder,
          (
            Manifesto,
            BaseReferences<_$ChartDatabase, $ManifestosTable, Manifesto>,
          ),
          Manifesto,
          PrefetchHooks Function()
        > {
  $$ManifestosTableTableManager(_$ChartDatabase db, $ManifestosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ManifestosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ManifestosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ManifestosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                Value<String> channelId = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<String?> videoUrl = const Value.absent(),
                Value<String> videoUrls = const Value.absent(),
                Value<String?> imageUrls = const Value.absent(),
                Value<String?> thumbnailUrls = const Value.absent(),
                Value<int> likes = const Value.absent(),
                Value<int> comments = const Value.absent(),
                Value<int> isPublic = const Value.absent(),
                Value<int> allowComments = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<int> isLiked = const Value.absent(),
                Value<double?> aspectRatio = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> taggerName = const Value.absent(),
                Value<String?> taggerAvatar = const Value.absent(),
                Value<String?> sourceChannelName = const Value.absent(),
                Value<String?> sourceChannelAvatar = const Value.absent(),
                Value<int> tagsCount = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ManifestosCompanion(
                id: id,
                authorId: authorId,
                username: username,
                profileImageUrl: profileImageUrl,
                channelId: channelId,
                caption: caption,
                videoUrl: videoUrl,
                videoUrls: videoUrls,
                imageUrls: imageUrls,
                thumbnailUrls: thumbnailUrls,
                likes: likes,
                comments: comments,
                isPublic: isPublic,
                allowComments: allowComments,
                isPending: isPending,
                isLiked: isLiked,
                aspectRatio: aspectRatio,
                createdAt: createdAt,
                taggerName: taggerName,
                taggerAvatar: taggerAvatar,
                sourceChannelName: sourceChannelName,
                sourceChannelAvatar: sourceChannelAvatar,
                tagsCount: tagsCount,
                metadata: metadata,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String authorId,
                Value<String?> username = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                required String channelId,
                Value<String?> caption = const Value.absent(),
                Value<String?> videoUrl = const Value.absent(),
                Value<String> videoUrls = const Value.absent(),
                Value<String?> imageUrls = const Value.absent(),
                Value<String?> thumbnailUrls = const Value.absent(),
                Value<int> likes = const Value.absent(),
                Value<int> comments = const Value.absent(),
                Value<int> isPublic = const Value.absent(),
                Value<int> allowComments = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<int> isLiked = const Value.absent(),
                Value<double?> aspectRatio = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> taggerName = const Value.absent(),
                Value<String?> taggerAvatar = const Value.absent(),
                Value<String?> sourceChannelName = const Value.absent(),
                Value<String?> sourceChannelAvatar = const Value.absent(),
                Value<int> tagsCount = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ManifestosCompanion.insert(
                id: id,
                authorId: authorId,
                username: username,
                profileImageUrl: profileImageUrl,
                channelId: channelId,
                caption: caption,
                videoUrl: videoUrl,
                videoUrls: videoUrls,
                imageUrls: imageUrls,
                thumbnailUrls: thumbnailUrls,
                likes: likes,
                comments: comments,
                isPublic: isPublic,
                allowComments: allowComments,
                isPending: isPending,
                isLiked: isLiked,
                aspectRatio: aspectRatio,
                createdAt: createdAt,
                taggerName: taggerName,
                taggerAvatar: taggerAvatar,
                sourceChannelName: sourceChannelName,
                sourceChannelAvatar: sourceChannelAvatar,
                tagsCount: tagsCount,
                metadata: metadata,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ManifestosTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ManifestosTable,
      Manifesto,
      $$ManifestosTableFilterComposer,
      $$ManifestosTableOrderingComposer,
      $$ManifestosTableAnnotationComposer,
      $$ManifestosTableCreateCompanionBuilder,
      $$ManifestosTableUpdateCompanionBuilder,
      (Manifesto, BaseReferences<_$ChartDatabase, $ManifestosTable, Manifesto>),
      Manifesto,
      PrefetchHooks Function()
    >;
typedef $$ManifestoCommentsTableCreateCompanionBuilder =
    ManifestoCommentsCompanion Function({
      required String id,
      required String authorId,
      required String channelId,
      required String manifestoId,
      Value<String?> message,
      Value<String> imageUrls,
      Value<int> likes,
      Value<int> isPending,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ManifestoCommentsTableUpdateCompanionBuilder =
    ManifestoCommentsCompanion Function({
      Value<String> id,
      Value<String> authorId,
      Value<String> channelId,
      Value<String> manifestoId,
      Value<String?> message,
      Value<String> imageUrls,
      Value<int> likes,
      Value<int> isPending,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ManifestoCommentsTableFilterComposer
    extends Composer<_$ChartDatabase, $ManifestoCommentsTable> {
  $$ManifestoCommentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manifestoId => $composableBuilder(
    column: $table.manifestoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ManifestoCommentsTableOrderingComposer
    extends Composer<_$ChartDatabase, $ManifestoCommentsTable> {
  $$ManifestoCommentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manifestoId => $composableBuilder(
    column: $table.manifestoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ManifestoCommentsTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ManifestoCommentsTable> {
  $$ManifestoCommentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get manifestoId => $composableBuilder(
    column: $table.manifestoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get imageUrls =>
      $composableBuilder(column: $table.imageUrls, builder: (column) => column);

  GeneratedColumn<int> get likes =>
      $composableBuilder(column: $table.likes, builder: (column) => column);

  GeneratedColumn<int> get isPending =>
      $composableBuilder(column: $table.isPending, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ManifestoCommentsTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ManifestoCommentsTable,
          ManifestoComment,
          $$ManifestoCommentsTableFilterComposer,
          $$ManifestoCommentsTableOrderingComposer,
          $$ManifestoCommentsTableAnnotationComposer,
          $$ManifestoCommentsTableCreateCompanionBuilder,
          $$ManifestoCommentsTableUpdateCompanionBuilder,
          (
            ManifestoComment,
            BaseReferences<
              _$ChartDatabase,
              $ManifestoCommentsTable,
              ManifestoComment
            >,
          ),
          ManifestoComment,
          PrefetchHooks Function()
        > {
  $$ManifestoCommentsTableTableManager(
    _$ChartDatabase db,
    $ManifestoCommentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ManifestoCommentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ManifestoCommentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ManifestoCommentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String> channelId = const Value.absent(),
                Value<String> manifestoId = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<String> imageUrls = const Value.absent(),
                Value<int> likes = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ManifestoCommentsCompanion(
                id: id,
                authorId: authorId,
                channelId: channelId,
                manifestoId: manifestoId,
                message: message,
                imageUrls: imageUrls,
                likes: likes,
                isPending: isPending,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String authorId,
                required String channelId,
                required String manifestoId,
                Value<String?> message = const Value.absent(),
                Value<String> imageUrls = const Value.absent(),
                Value<int> likes = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ManifestoCommentsCompanion.insert(
                id: id,
                authorId: authorId,
                channelId: channelId,
                manifestoId: manifestoId,
                message: message,
                imageUrls: imageUrls,
                likes: likes,
                isPending: isPending,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ManifestoCommentsTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ManifestoCommentsTable,
      ManifestoComment,
      $$ManifestoCommentsTableFilterComposer,
      $$ManifestoCommentsTableOrderingComposer,
      $$ManifestoCommentsTableAnnotationComposer,
      $$ManifestoCommentsTableCreateCompanionBuilder,
      $$ManifestoCommentsTableUpdateCompanionBuilder,
      (
        ManifestoComment,
        BaseReferences<
          _$ChartDatabase,
          $ManifestoCommentsTable,
          ManifestoComment
        >,
      ),
      ManifestoComment,
      PrefetchHooks Function()
    >;
typedef $$ChannelsTableCreateCompanionBuilder =
    ChannelsCompanion Function({
      required String id,
      Value<String?> name,
      Value<String?> title,
      Value<String?> subtitle,
      Value<String?> imageUrl,
      Value<int> isPrivate,
      Value<String> ageRestriction,
      Value<String> joinMethod,
      Value<int> preventLeaving,
      Value<String> countryRestrictions,
      Value<String> allowCommentingBy,
      Value<String> allowStatusPostingBy,
      Value<String> allowInvitationsBy,
      Value<int> visibleToOtherChannelMembers,
      Value<int> visibleToFollowedUsers,
      Value<int> isDiscoverable,
      Value<int> membersCount,
      Value<int> followersCount,
      Value<int> tagsCount,
      Value<int> likesCount,
      Value<int> rowid,
    });
typedef $$ChannelsTableUpdateCompanionBuilder =
    ChannelsCompanion Function({
      Value<String> id,
      Value<String?> name,
      Value<String?> title,
      Value<String?> subtitle,
      Value<String?> imageUrl,
      Value<int> isPrivate,
      Value<String> ageRestriction,
      Value<String> joinMethod,
      Value<int> preventLeaving,
      Value<String> countryRestrictions,
      Value<String> allowCommentingBy,
      Value<String> allowStatusPostingBy,
      Value<String> allowInvitationsBy,
      Value<int> visibleToOtherChannelMembers,
      Value<int> visibleToFollowedUsers,
      Value<int> isDiscoverable,
      Value<int> membersCount,
      Value<int> followersCount,
      Value<int> tagsCount,
      Value<int> likesCount,
      Value<int> rowid,
    });

class $$ChannelsTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelsTable> {
  $$ChannelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPrivate => $composableBuilder(
    column: $table.isPrivate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ageRestriction => $composableBuilder(
    column: $table.ageRestriction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get joinMethod => $composableBuilder(
    column: $table.joinMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preventLeaving => $composableBuilder(
    column: $table.preventLeaving,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryRestrictions => $composableBuilder(
    column: $table.countryRestrictions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allowCommentingBy => $composableBuilder(
    column: $table.allowCommentingBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allowStatusPostingBy => $composableBuilder(
    column: $table.allowStatusPostingBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allowInvitationsBy => $composableBuilder(
    column: $table.allowInvitationsBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get visibleToOtherChannelMembers => $composableBuilder(
    column: $table.visibleToOtherChannelMembers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get visibleToFollowedUsers => $composableBuilder(
    column: $table.visibleToFollowedUsers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDiscoverable => $composableBuilder(
    column: $table.isDiscoverable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get membersCount => $composableBuilder(
    column: $table.membersCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followersCount => $composableBuilder(
    column: $table.followersCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tagsCount => $composableBuilder(
    column: $table.tagsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get likesCount => $composableBuilder(
    column: $table.likesCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelsTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelsTable> {
  $$ChannelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPrivate => $composableBuilder(
    column: $table.isPrivate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ageRestriction => $composableBuilder(
    column: $table.ageRestriction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get joinMethod => $composableBuilder(
    column: $table.joinMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preventLeaving => $composableBuilder(
    column: $table.preventLeaving,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryRestrictions => $composableBuilder(
    column: $table.countryRestrictions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allowCommentingBy => $composableBuilder(
    column: $table.allowCommentingBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allowStatusPostingBy => $composableBuilder(
    column: $table.allowStatusPostingBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allowInvitationsBy => $composableBuilder(
    column: $table.allowInvitationsBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get visibleToOtherChannelMembers => $composableBuilder(
    column: $table.visibleToOtherChannelMembers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get visibleToFollowedUsers => $composableBuilder(
    column: $table.visibleToFollowedUsers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDiscoverable => $composableBuilder(
    column: $table.isDiscoverable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get membersCount => $composableBuilder(
    column: $table.membersCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followersCount => $composableBuilder(
    column: $table.followersCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tagsCount => $composableBuilder(
    column: $table.tagsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get likesCount => $composableBuilder(
    column: $table.likesCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelsTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelsTable> {
  $$ChannelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get isPrivate =>
      $composableBuilder(column: $table.isPrivate, builder: (column) => column);

  GeneratedColumn<String> get ageRestriction => $composableBuilder(
    column: $table.ageRestriction,
    builder: (column) => column,
  );

  GeneratedColumn<String> get joinMethod => $composableBuilder(
    column: $table.joinMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preventLeaving => $composableBuilder(
    column: $table.preventLeaving,
    builder: (column) => column,
  );

  GeneratedColumn<String> get countryRestrictions => $composableBuilder(
    column: $table.countryRestrictions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allowCommentingBy => $composableBuilder(
    column: $table.allowCommentingBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allowStatusPostingBy => $composableBuilder(
    column: $table.allowStatusPostingBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allowInvitationsBy => $composableBuilder(
    column: $table.allowInvitationsBy,
    builder: (column) => column,
  );

  GeneratedColumn<int> get visibleToOtherChannelMembers => $composableBuilder(
    column: $table.visibleToOtherChannelMembers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get visibleToFollowedUsers => $composableBuilder(
    column: $table.visibleToFollowedUsers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isDiscoverable => $composableBuilder(
    column: $table.isDiscoverable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get membersCount => $composableBuilder(
    column: $table.membersCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get followersCount => $composableBuilder(
    column: $table.followersCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tagsCount =>
      $composableBuilder(column: $table.tagsCount, builder: (column) => column);

  GeneratedColumn<int> get likesCount => $composableBuilder(
    column: $table.likesCount,
    builder: (column) => column,
  );
}

class $$ChannelsTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelsTable,
          Channel,
          $$ChannelsTableFilterComposer,
          $$ChannelsTableOrderingComposer,
          $$ChannelsTableAnnotationComposer,
          $$ChannelsTableCreateCompanionBuilder,
          $$ChannelsTableUpdateCompanionBuilder,
          (Channel, BaseReferences<_$ChartDatabase, $ChannelsTable, Channel>),
          Channel,
          PrefetchHooks Function()
        > {
  $$ChannelsTableTableManager(_$ChartDatabase db, $ChannelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> isPrivate = const Value.absent(),
                Value<String> ageRestriction = const Value.absent(),
                Value<String> joinMethod = const Value.absent(),
                Value<int> preventLeaving = const Value.absent(),
                Value<String> countryRestrictions = const Value.absent(),
                Value<String> allowCommentingBy = const Value.absent(),
                Value<String> allowStatusPostingBy = const Value.absent(),
                Value<String> allowInvitationsBy = const Value.absent(),
                Value<int> visibleToOtherChannelMembers = const Value.absent(),
                Value<int> visibleToFollowedUsers = const Value.absent(),
                Value<int> isDiscoverable = const Value.absent(),
                Value<int> membersCount = const Value.absent(),
                Value<int> followersCount = const Value.absent(),
                Value<int> tagsCount = const Value.absent(),
                Value<int> likesCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelsCompanion(
                id: id,
                name: name,
                title: title,
                subtitle: subtitle,
                imageUrl: imageUrl,
                isPrivate: isPrivate,
                ageRestriction: ageRestriction,
                joinMethod: joinMethod,
                preventLeaving: preventLeaving,
                countryRestrictions: countryRestrictions,
                allowCommentingBy: allowCommentingBy,
                allowStatusPostingBy: allowStatusPostingBy,
                allowInvitationsBy: allowInvitationsBy,
                visibleToOtherChannelMembers: visibleToOtherChannelMembers,
                visibleToFollowedUsers: visibleToFollowedUsers,
                isDiscoverable: isDiscoverable,
                membersCount: membersCount,
                followersCount: followersCount,
                tagsCount: tagsCount,
                likesCount: likesCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> name = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> isPrivate = const Value.absent(),
                Value<String> ageRestriction = const Value.absent(),
                Value<String> joinMethod = const Value.absent(),
                Value<int> preventLeaving = const Value.absent(),
                Value<String> countryRestrictions = const Value.absent(),
                Value<String> allowCommentingBy = const Value.absent(),
                Value<String> allowStatusPostingBy = const Value.absent(),
                Value<String> allowInvitationsBy = const Value.absent(),
                Value<int> visibleToOtherChannelMembers = const Value.absent(),
                Value<int> visibleToFollowedUsers = const Value.absent(),
                Value<int> isDiscoverable = const Value.absent(),
                Value<int> membersCount = const Value.absent(),
                Value<int> followersCount = const Value.absent(),
                Value<int> tagsCount = const Value.absent(),
                Value<int> likesCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelsCompanion.insert(
                id: id,
                name: name,
                title: title,
                subtitle: subtitle,
                imageUrl: imageUrl,
                isPrivate: isPrivate,
                ageRestriction: ageRestriction,
                joinMethod: joinMethod,
                preventLeaving: preventLeaving,
                countryRestrictions: countryRestrictions,
                allowCommentingBy: allowCommentingBy,
                allowStatusPostingBy: allowStatusPostingBy,
                allowInvitationsBy: allowInvitationsBy,
                visibleToOtherChannelMembers: visibleToOtherChannelMembers,
                visibleToFollowedUsers: visibleToFollowedUsers,
                isDiscoverable: isDiscoverable,
                membersCount: membersCount,
                followersCount: followersCount,
                tagsCount: tagsCount,
                likesCount: likesCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelsTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelsTable,
      Channel,
      $$ChannelsTableFilterComposer,
      $$ChannelsTableOrderingComposer,
      $$ChannelsTableAnnotationComposer,
      $$ChannelsTableCreateCompanionBuilder,
      $$ChannelsTableUpdateCompanionBuilder,
      (Channel, BaseReferences<_$ChartDatabase, $ChannelsTable, Channel>),
      Channel,
      PrefetchHooks Function()
    >;
typedef $$ChannelMetadataTableCreateCompanionBuilder =
    ChannelMetadataCompanion Function({
      required String channelId,
      Value<int?> memberCount,
      Value<int> unreadCount,
      Value<int> postsBadgeCount,
      Value<int> membersBadgeCount,
      Value<int> messagesBadgeCount,
      Value<int> isCharted,
      Value<int> isPending,
      Value<DateTime?> createdAt,
      Value<DateTime?> lastMessageAt,
      Value<int> rowid,
    });
typedef $$ChannelMetadataTableUpdateCompanionBuilder =
    ChannelMetadataCompanion Function({
      Value<String> channelId,
      Value<int?> memberCount,
      Value<int> unreadCount,
      Value<int> postsBadgeCount,
      Value<int> membersBadgeCount,
      Value<int> messagesBadgeCount,
      Value<int> isCharted,
      Value<int> isPending,
      Value<DateTime?> createdAt,
      Value<DateTime?> lastMessageAt,
      Value<int> rowid,
    });

class $$ChannelMetadataTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelMetadataTable> {
  $$ChannelMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memberCount => $composableBuilder(
    column: $table.memberCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get postsBadgeCount => $composableBuilder(
    column: $table.postsBadgeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get membersBadgeCount => $composableBuilder(
    column: $table.membersBadgeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get messagesBadgeCount => $composableBuilder(
    column: $table.messagesBadgeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isCharted => $composableBuilder(
    column: $table.isCharted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelMetadataTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelMetadataTable> {
  $$ChannelMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memberCount => $composableBuilder(
    column: $table.memberCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get postsBadgeCount => $composableBuilder(
    column: $table.postsBadgeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get membersBadgeCount => $composableBuilder(
    column: $table.membersBadgeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get messagesBadgeCount => $composableBuilder(
    column: $table.messagesBadgeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isCharted => $composableBuilder(
    column: $table.isCharted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelMetadataTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelMetadataTable> {
  $$ChannelMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<int> get memberCount => $composableBuilder(
    column: $table.memberCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get postsBadgeCount => $composableBuilder(
    column: $table.postsBadgeCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get membersBadgeCount => $composableBuilder(
    column: $table.membersBadgeCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get messagesBadgeCount => $composableBuilder(
    column: $table.messagesBadgeCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isCharted =>
      $composableBuilder(column: $table.isCharted, builder: (column) => column);

  GeneratedColumn<int> get isPending =>
      $composableBuilder(column: $table.isPending, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => column,
  );
}

class $$ChannelMetadataTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelMetadataTable,
          ChannelMetadataData,
          $$ChannelMetadataTableFilterComposer,
          $$ChannelMetadataTableOrderingComposer,
          $$ChannelMetadataTableAnnotationComposer,
          $$ChannelMetadataTableCreateCompanionBuilder,
          $$ChannelMetadataTableUpdateCompanionBuilder,
          (
            ChannelMetadataData,
            BaseReferences<
              _$ChartDatabase,
              $ChannelMetadataTable,
              ChannelMetadataData
            >,
          ),
          ChannelMetadataData,
          PrefetchHooks Function()
        > {
  $$ChannelMetadataTableTableManager(
    _$ChartDatabase db,
    $ChannelMetadataTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> channelId = const Value.absent(),
                Value<int?> memberCount = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<int> postsBadgeCount = const Value.absent(),
                Value<int> membersBadgeCount = const Value.absent(),
                Value<int> messagesBadgeCount = const Value.absent(),
                Value<int> isCharted = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> lastMessageAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelMetadataCompanion(
                channelId: channelId,
                memberCount: memberCount,
                unreadCount: unreadCount,
                postsBadgeCount: postsBadgeCount,
                membersBadgeCount: membersBadgeCount,
                messagesBadgeCount: messagesBadgeCount,
                isCharted: isCharted,
                isPending: isPending,
                createdAt: createdAt,
                lastMessageAt: lastMessageAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String channelId,
                Value<int?> memberCount = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<int> postsBadgeCount = const Value.absent(),
                Value<int> membersBadgeCount = const Value.absent(),
                Value<int> messagesBadgeCount = const Value.absent(),
                Value<int> isCharted = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> lastMessageAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelMetadataCompanion.insert(
                channelId: channelId,
                memberCount: memberCount,
                unreadCount: unreadCount,
                postsBadgeCount: postsBadgeCount,
                membersBadgeCount: membersBadgeCount,
                messagesBadgeCount: messagesBadgeCount,
                isCharted: isCharted,
                isPending: isPending,
                createdAt: createdAt,
                lastMessageAt: lastMessageAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelMetadataTable,
      ChannelMetadataData,
      $$ChannelMetadataTableFilterComposer,
      $$ChannelMetadataTableOrderingComposer,
      $$ChannelMetadataTableAnnotationComposer,
      $$ChannelMetadataTableCreateCompanionBuilder,
      $$ChannelMetadataTableUpdateCompanionBuilder,
      (
        ChannelMetadataData,
        BaseReferences<
          _$ChartDatabase,
          $ChannelMetadataTable,
          ChannelMetadataData
        >,
      ),
      ChannelMetadataData,
      PrefetchHooks Function()
    >;
typedef $$ChannelBrandingTableCreateCompanionBuilder =
    ChannelBrandingCompanion Function({
      required String channelId,
      Value<String?> leaderAvatarUrl,
      Value<String?> creatorAvatarUrl,
      Value<String?> creatorId,
      Value<String?> themeColor,
      Value<int> rowid,
    });
typedef $$ChannelBrandingTableUpdateCompanionBuilder =
    ChannelBrandingCompanion Function({
      Value<String> channelId,
      Value<String?> leaderAvatarUrl,
      Value<String?> creatorAvatarUrl,
      Value<String?> creatorId,
      Value<String?> themeColor,
      Value<int> rowid,
    });

class $$ChannelBrandingTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelBrandingTable> {
  $$ChannelBrandingTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaderAvatarUrl => $composableBuilder(
    column: $table.leaderAvatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creatorAvatarUrl => $composableBuilder(
    column: $table.creatorAvatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeColor => $composableBuilder(
    column: $table.themeColor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelBrandingTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelBrandingTable> {
  $$ChannelBrandingTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaderAvatarUrl => $composableBuilder(
    column: $table.leaderAvatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creatorAvatarUrl => $composableBuilder(
    column: $table.creatorAvatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeColor => $composableBuilder(
    column: $table.themeColor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelBrandingTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelBrandingTable> {
  $$ChannelBrandingTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get leaderAvatarUrl => $composableBuilder(
    column: $table.leaderAvatarUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get creatorAvatarUrl => $composableBuilder(
    column: $table.creatorAvatarUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get creatorId =>
      $composableBuilder(column: $table.creatorId, builder: (column) => column);

  GeneratedColumn<String> get themeColor => $composableBuilder(
    column: $table.themeColor,
    builder: (column) => column,
  );
}

class $$ChannelBrandingTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelBrandingTable,
          ChannelBrandingData,
          $$ChannelBrandingTableFilterComposer,
          $$ChannelBrandingTableOrderingComposer,
          $$ChannelBrandingTableAnnotationComposer,
          $$ChannelBrandingTableCreateCompanionBuilder,
          $$ChannelBrandingTableUpdateCompanionBuilder,
          (
            ChannelBrandingData,
            BaseReferences<
              _$ChartDatabase,
              $ChannelBrandingTable,
              ChannelBrandingData
            >,
          ),
          ChannelBrandingData,
          PrefetchHooks Function()
        > {
  $$ChannelBrandingTableTableManager(
    _$ChartDatabase db,
    $ChannelBrandingTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelBrandingTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelBrandingTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelBrandingTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> channelId = const Value.absent(),
                Value<String?> leaderAvatarUrl = const Value.absent(),
                Value<String?> creatorAvatarUrl = const Value.absent(),
                Value<String?> creatorId = const Value.absent(),
                Value<String?> themeColor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelBrandingCompanion(
                channelId: channelId,
                leaderAvatarUrl: leaderAvatarUrl,
                creatorAvatarUrl: creatorAvatarUrl,
                creatorId: creatorId,
                themeColor: themeColor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String channelId,
                Value<String?> leaderAvatarUrl = const Value.absent(),
                Value<String?> creatorAvatarUrl = const Value.absent(),
                Value<String?> creatorId = const Value.absent(),
                Value<String?> themeColor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelBrandingCompanion.insert(
                channelId: channelId,
                leaderAvatarUrl: leaderAvatarUrl,
                creatorAvatarUrl: creatorAvatarUrl,
                creatorId: creatorId,
                themeColor: themeColor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelBrandingTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelBrandingTable,
      ChannelBrandingData,
      $$ChannelBrandingTableFilterComposer,
      $$ChannelBrandingTableOrderingComposer,
      $$ChannelBrandingTableAnnotationComposer,
      $$ChannelBrandingTableCreateCompanionBuilder,
      $$ChannelBrandingTableUpdateCompanionBuilder,
      (
        ChannelBrandingData,
        BaseReferences<
          _$ChartDatabase,
          $ChannelBrandingTable,
          ChannelBrandingData
        >,
      ),
      ChannelBrandingData,
      PrefetchHooks Function()
    >;
typedef $$ChannelMembersTableCreateCompanionBuilder =
    ChannelMembersCompanion Function({
      required String channelId,
      required String userId,
      Value<String> role,
      Value<DateTime?> joinedAt,
      Value<int> unreadCount,
      Value<int> unreadMomentsCount,
      Value<int> rowid,
    });
typedef $$ChannelMembersTableUpdateCompanionBuilder =
    ChannelMembersCompanion Function({
      Value<String> channelId,
      Value<String> userId,
      Value<String> role,
      Value<DateTime?> joinedAt,
      Value<int> unreadCount,
      Value<int> unreadMomentsCount,
      Value<int> rowid,
    });

class $$ChannelMembersTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelMembersTable> {
  $$ChannelMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unreadMomentsCount => $composableBuilder(
    column: $table.unreadMomentsCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelMembersTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelMembersTable> {
  $$ChannelMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unreadMomentsCount => $composableBuilder(
    column: $table.unreadMomentsCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelMembersTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelMembersTable> {
  $$ChannelMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  GeneratedColumn<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unreadMomentsCount => $composableBuilder(
    column: $table.unreadMomentsCount,
    builder: (column) => column,
  );
}

class $$ChannelMembersTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelMembersTable,
          ChannelMember,
          $$ChannelMembersTableFilterComposer,
          $$ChannelMembersTableOrderingComposer,
          $$ChannelMembersTableAnnotationComposer,
          $$ChannelMembersTableCreateCompanionBuilder,
          $$ChannelMembersTableUpdateCompanionBuilder,
          (
            ChannelMember,
            BaseReferences<
              _$ChartDatabase,
              $ChannelMembersTable,
              ChannelMember
            >,
          ),
          ChannelMember,
          PrefetchHooks Function()
        > {
  $$ChannelMembersTableTableManager(
    _$ChartDatabase db,
    $ChannelMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> channelId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<DateTime?> joinedAt = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<int> unreadMomentsCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelMembersCompanion(
                channelId: channelId,
                userId: userId,
                role: role,
                joinedAt: joinedAt,
                unreadCount: unreadCount,
                unreadMomentsCount: unreadMomentsCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String channelId,
                required String userId,
                Value<String> role = const Value.absent(),
                Value<DateTime?> joinedAt = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<int> unreadMomentsCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelMembersCompanion.insert(
                channelId: channelId,
                userId: userId,
                role: role,
                joinedAt: joinedAt,
                unreadCount: unreadCount,
                unreadMomentsCount: unreadMomentsCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelMembersTable,
      ChannelMember,
      $$ChannelMembersTableFilterComposer,
      $$ChannelMembersTableOrderingComposer,
      $$ChannelMembersTableAnnotationComposer,
      $$ChannelMembersTableCreateCompanionBuilder,
      $$ChannelMembersTableUpdateCompanionBuilder,
      (
        ChannelMember,
        BaseReferences<_$ChartDatabase, $ChannelMembersTable, ChannelMember>,
      ),
      ChannelMember,
      PrefetchHooks Function()
    >;
typedef $$ChannelStatusesTableCreateCompanionBuilder =
    ChannelStatusesCompanion Function({
      required String id,
      required String channelId,
      required String authorId,
      Value<String?> caption,
      Value<String?> imageUrls,
      Value<String?> videoUrl,
      Value<String?> thumbnailUrl,
      Value<String?> audioUrl,
      Value<int> isVideo,
      Value<int> isAudio,
      Value<int> viewsCount,
      Value<int> likesCount,
      Value<int> commentsCount,
      Value<String?> createdAt,
      Value<String?> expiresAt,
      Value<String?> username,
      Value<String?> profileImageUrl,
      Value<int> rowid,
    });
typedef $$ChannelStatusesTableUpdateCompanionBuilder =
    ChannelStatusesCompanion Function({
      Value<String> id,
      Value<String> channelId,
      Value<String> authorId,
      Value<String?> caption,
      Value<String?> imageUrls,
      Value<String?> videoUrl,
      Value<String?> thumbnailUrl,
      Value<String?> audioUrl,
      Value<int> isVideo,
      Value<int> isAudio,
      Value<int> viewsCount,
      Value<int> likesCount,
      Value<int> commentsCount,
      Value<String?> createdAt,
      Value<String?> expiresAt,
      Value<String?> username,
      Value<String?> profileImageUrl,
      Value<int> rowid,
    });

class $$ChannelStatusesTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelStatusesTable> {
  $$ChannelStatusesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get videoUrl => $composableBuilder(
    column: $table.videoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isVideo => $composableBuilder(
    column: $table.isVideo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isAudio => $composableBuilder(
    column: $table.isAudio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get viewsCount => $composableBuilder(
    column: $table.viewsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get likesCount => $composableBuilder(
    column: $table.likesCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get commentsCount => $composableBuilder(
    column: $table.commentsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelStatusesTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelStatusesTable> {
  $$ChannelStatusesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get videoUrl => $composableBuilder(
    column: $table.videoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isVideo => $composableBuilder(
    column: $table.isVideo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isAudio => $composableBuilder(
    column: $table.isAudio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get viewsCount => $composableBuilder(
    column: $table.viewsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get likesCount => $composableBuilder(
    column: $table.likesCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get commentsCount => $composableBuilder(
    column: $table.commentsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelStatusesTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelStatusesTable> {
  $$ChannelStatusesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<String> get imageUrls =>
      $composableBuilder(column: $table.imageUrls, builder: (column) => column);

  GeneratedColumn<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<int> get isVideo =>
      $composableBuilder(column: $table.isVideo, builder: (column) => column);

  GeneratedColumn<int> get isAudio =>
      $composableBuilder(column: $table.isAudio, builder: (column) => column);

  GeneratedColumn<int> get viewsCount => $composableBuilder(
    column: $table.viewsCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get likesCount => $composableBuilder(
    column: $table.likesCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get commentsCount => $composableBuilder(
    column: $table.commentsCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => column,
  );
}

class $$ChannelStatusesTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelStatusesTable,
          ChannelStatuse,
          $$ChannelStatusesTableFilterComposer,
          $$ChannelStatusesTableOrderingComposer,
          $$ChannelStatusesTableAnnotationComposer,
          $$ChannelStatusesTableCreateCompanionBuilder,
          $$ChannelStatusesTableUpdateCompanionBuilder,
          (
            ChannelStatuse,
            BaseReferences<
              _$ChartDatabase,
              $ChannelStatusesTable,
              ChannelStatuse
            >,
          ),
          ChannelStatuse,
          PrefetchHooks Function()
        > {
  $$ChannelStatusesTableTableManager(
    _$ChartDatabase db,
    $ChannelStatusesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelStatusesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelStatusesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelStatusesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> channelId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<String?> imageUrls = const Value.absent(),
                Value<String?> videoUrl = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int> isVideo = const Value.absent(),
                Value<int> isAudio = const Value.absent(),
                Value<int> viewsCount = const Value.absent(),
                Value<int> likesCount = const Value.absent(),
                Value<int> commentsCount = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> expiresAt = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelStatusesCompanion(
                id: id,
                channelId: channelId,
                authorId: authorId,
                caption: caption,
                imageUrls: imageUrls,
                videoUrl: videoUrl,
                thumbnailUrl: thumbnailUrl,
                audioUrl: audioUrl,
                isVideo: isVideo,
                isAudio: isAudio,
                viewsCount: viewsCount,
                likesCount: likesCount,
                commentsCount: commentsCount,
                createdAt: createdAt,
                expiresAt: expiresAt,
                username: username,
                profileImageUrl: profileImageUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String channelId,
                required String authorId,
                Value<String?> caption = const Value.absent(),
                Value<String?> imageUrls = const Value.absent(),
                Value<String?> videoUrl = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int> isVideo = const Value.absent(),
                Value<int> isAudio = const Value.absent(),
                Value<int> viewsCount = const Value.absent(),
                Value<int> likesCount = const Value.absent(),
                Value<int> commentsCount = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> expiresAt = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelStatusesCompanion.insert(
                id: id,
                channelId: channelId,
                authorId: authorId,
                caption: caption,
                imageUrls: imageUrls,
                videoUrl: videoUrl,
                thumbnailUrl: thumbnailUrl,
                audioUrl: audioUrl,
                isVideo: isVideo,
                isAudio: isAudio,
                viewsCount: viewsCount,
                likesCount: likesCount,
                commentsCount: commentsCount,
                createdAt: createdAt,
                expiresAt: expiresAt,
                username: username,
                profileImageUrl: profileImageUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelStatusesTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelStatusesTable,
      ChannelStatuse,
      $$ChannelStatusesTableFilterComposer,
      $$ChannelStatusesTableOrderingComposer,
      $$ChannelStatusesTableAnnotationComposer,
      $$ChannelStatusesTableCreateCompanionBuilder,
      $$ChannelStatusesTableUpdateCompanionBuilder,
      (
        ChannelStatuse,
        BaseReferences<_$ChartDatabase, $ChannelStatusesTable, ChannelStatuse>,
      ),
      ChannelStatuse,
      PrefetchHooks Function()
    >;
typedef $$ChannelPresenceTableCreateCompanionBuilder =
    ChannelPresenceCompanion Function({
      required String channelId,
      required String userId,
      Value<int> isOnline,
      Value<int> isTyping,
      Value<String?> lastSeen,
      Value<String?> lastKnownName,
      Value<String?> lastKnownAvatar,
      Value<int> rowid,
    });
typedef $$ChannelPresenceTableUpdateCompanionBuilder =
    ChannelPresenceCompanion Function({
      Value<String> channelId,
      Value<String> userId,
      Value<int> isOnline,
      Value<int> isTyping,
      Value<String?> lastSeen,
      Value<String?> lastKnownName,
      Value<String?> lastKnownAvatar,
      Value<int> rowid,
    });

class $$ChannelPresenceTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelPresenceTable> {
  $$ChannelPresenceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isTyping => $composableBuilder(
    column: $table.isTyping,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastKnownName => $composableBuilder(
    column: $table.lastKnownName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastKnownAvatar => $composableBuilder(
    column: $table.lastKnownAvatar,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelPresenceTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelPresenceTable> {
  $$ChannelPresenceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isTyping => $composableBuilder(
    column: $table.isTyping,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastKnownName => $composableBuilder(
    column: $table.lastKnownName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastKnownAvatar => $composableBuilder(
    column: $table.lastKnownAvatar,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelPresenceTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelPresenceTable> {
  $$ChannelPresenceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get isOnline =>
      $composableBuilder(column: $table.isOnline, builder: (column) => column);

  GeneratedColumn<int> get isTyping =>
      $composableBuilder(column: $table.isTyping, builder: (column) => column);

  GeneratedColumn<String> get lastSeen =>
      $composableBuilder(column: $table.lastSeen, builder: (column) => column);

  GeneratedColumn<String> get lastKnownName => $composableBuilder(
    column: $table.lastKnownName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastKnownAvatar => $composableBuilder(
    column: $table.lastKnownAvatar,
    builder: (column) => column,
  );
}

class $$ChannelPresenceTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelPresenceTable,
          ChannelPresenceData,
          $$ChannelPresenceTableFilterComposer,
          $$ChannelPresenceTableOrderingComposer,
          $$ChannelPresenceTableAnnotationComposer,
          $$ChannelPresenceTableCreateCompanionBuilder,
          $$ChannelPresenceTableUpdateCompanionBuilder,
          (
            ChannelPresenceData,
            BaseReferences<
              _$ChartDatabase,
              $ChannelPresenceTable,
              ChannelPresenceData
            >,
          ),
          ChannelPresenceData,
          PrefetchHooks Function()
        > {
  $$ChannelPresenceTableTableManager(
    _$ChartDatabase db,
    $ChannelPresenceTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelPresenceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelPresenceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelPresenceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> channelId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> isOnline = const Value.absent(),
                Value<int> isTyping = const Value.absent(),
                Value<String?> lastSeen = const Value.absent(),
                Value<String?> lastKnownName = const Value.absent(),
                Value<String?> lastKnownAvatar = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelPresenceCompanion(
                channelId: channelId,
                userId: userId,
                isOnline: isOnline,
                isTyping: isTyping,
                lastSeen: lastSeen,
                lastKnownName: lastKnownName,
                lastKnownAvatar: lastKnownAvatar,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String channelId,
                required String userId,
                Value<int> isOnline = const Value.absent(),
                Value<int> isTyping = const Value.absent(),
                Value<String?> lastSeen = const Value.absent(),
                Value<String?> lastKnownName = const Value.absent(),
                Value<String?> lastKnownAvatar = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelPresenceCompanion.insert(
                channelId: channelId,
                userId: userId,
                isOnline: isOnline,
                isTyping: isTyping,
                lastSeen: lastSeen,
                lastKnownName: lastKnownName,
                lastKnownAvatar: lastKnownAvatar,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelPresenceTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelPresenceTable,
      ChannelPresenceData,
      $$ChannelPresenceTableFilterComposer,
      $$ChannelPresenceTableOrderingComposer,
      $$ChannelPresenceTableAnnotationComposer,
      $$ChannelPresenceTableCreateCompanionBuilder,
      $$ChannelPresenceTableUpdateCompanionBuilder,
      (
        ChannelPresenceData,
        BaseReferences<
          _$ChartDatabase,
          $ChannelPresenceTable,
          ChannelPresenceData
        >,
      ),
      ChannelPresenceData,
      PrefetchHooks Function()
    >;
typedef $$ChannelCreatorTableCreateCompanionBuilder =
    ChannelCreatorCompanion Function({
      required String channelId,
      required String creatorId,
      Value<String?> name,
      Value<String?> avatarUrl,
      Value<int> isVerified,
      Value<int> isFollowing,
      Value<String> roleTitle,
      Value<int> rowid,
    });
typedef $$ChannelCreatorTableUpdateCompanionBuilder =
    ChannelCreatorCompanion Function({
      Value<String> channelId,
      Value<String> creatorId,
      Value<String?> name,
      Value<String?> avatarUrl,
      Value<int> isVerified,
      Value<int> isFollowing,
      Value<String> roleTitle,
      Value<int> rowid,
    });

class $$ChannelCreatorTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelCreatorTable> {
  $$ChannelCreatorTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isFollowing => $composableBuilder(
    column: $table.isFollowing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roleTitle => $composableBuilder(
    column: $table.roleTitle,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelCreatorTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelCreatorTable> {
  $$ChannelCreatorTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isFollowing => $composableBuilder(
    column: $table.isFollowing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roleTitle => $composableBuilder(
    column: $table.roleTitle,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelCreatorTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelCreatorTable> {
  $$ChannelCreatorTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get creatorId =>
      $composableBuilder(column: $table.creatorId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<int> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isFollowing => $composableBuilder(
    column: $table.isFollowing,
    builder: (column) => column,
  );

  GeneratedColumn<String> get roleTitle =>
      $composableBuilder(column: $table.roleTitle, builder: (column) => column);
}

class $$ChannelCreatorTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelCreatorTable,
          ChannelCreatorData,
          $$ChannelCreatorTableFilterComposer,
          $$ChannelCreatorTableOrderingComposer,
          $$ChannelCreatorTableAnnotationComposer,
          $$ChannelCreatorTableCreateCompanionBuilder,
          $$ChannelCreatorTableUpdateCompanionBuilder,
          (
            ChannelCreatorData,
            BaseReferences<
              _$ChartDatabase,
              $ChannelCreatorTable,
              ChannelCreatorData
            >,
          ),
          ChannelCreatorData,
          PrefetchHooks Function()
        > {
  $$ChannelCreatorTableTableManager(
    _$ChartDatabase db,
    $ChannelCreatorTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelCreatorTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelCreatorTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelCreatorTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> channelId = const Value.absent(),
                Value<String> creatorId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<int> isVerified = const Value.absent(),
                Value<int> isFollowing = const Value.absent(),
                Value<String> roleTitle = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelCreatorCompanion(
                channelId: channelId,
                creatorId: creatorId,
                name: name,
                avatarUrl: avatarUrl,
                isVerified: isVerified,
                isFollowing: isFollowing,
                roleTitle: roleTitle,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String channelId,
                required String creatorId,
                Value<String?> name = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<int> isVerified = const Value.absent(),
                Value<int> isFollowing = const Value.absent(),
                Value<String> roleTitle = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelCreatorCompanion.insert(
                channelId: channelId,
                creatorId: creatorId,
                name: name,
                avatarUrl: avatarUrl,
                isVerified: isVerified,
                isFollowing: isFollowing,
                roleTitle: roleTitle,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelCreatorTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelCreatorTable,
      ChannelCreatorData,
      $$ChannelCreatorTableFilterComposer,
      $$ChannelCreatorTableOrderingComposer,
      $$ChannelCreatorTableAnnotationComposer,
      $$ChannelCreatorTableCreateCompanionBuilder,
      $$ChannelCreatorTableUpdateCompanionBuilder,
      (
        ChannelCreatorData,
        BaseReferences<
          _$ChartDatabase,
          $ChannelCreatorTable,
          ChannelCreatorData
        >,
      ),
      ChannelCreatorData,
      PrefetchHooks Function()
    >;
typedef $$ChannelPostsTableCreateCompanionBuilder =
    ChannelPostsCompanion Function({
      required String id,
      required String channelId,
      required String authorId,
      Value<String?> username,
      Value<String?> profileImageUrl,
      Value<String?> caption,
      Value<String?> imageUrls,
      Value<String?> videoUrl,
      Value<String?> videoUrls,
      Value<String?> thumbnailUrls,
      Value<int> isVideo,
      Value<int> isSponsored,
      Value<double?> aspectRatio,
      Value<int> likes,
      Value<int> comments,
      Value<int> shares,
      Value<int> isPublic,
      Value<int> allowComments,
      Value<int> isPending,
      Value<int> isLiked,
      Value<String?> taggerName,
      Value<String?> taggerAvatar,
      Value<String?> sourceChannelName,
      Value<String?> sourceChannelAvatar,
      Value<int> tagsCount,
      Value<DateTime> createdAt,
      Value<String?> postType,
      Value<String?> metadata,
      Value<int> rowid,
    });
typedef $$ChannelPostsTableUpdateCompanionBuilder =
    ChannelPostsCompanion Function({
      Value<String> id,
      Value<String> channelId,
      Value<String> authorId,
      Value<String?> username,
      Value<String?> profileImageUrl,
      Value<String?> caption,
      Value<String?> imageUrls,
      Value<String?> videoUrl,
      Value<String?> videoUrls,
      Value<String?> thumbnailUrls,
      Value<int> isVideo,
      Value<int> isSponsored,
      Value<double?> aspectRatio,
      Value<int> likes,
      Value<int> comments,
      Value<int> shares,
      Value<int> isPublic,
      Value<int> allowComments,
      Value<int> isPending,
      Value<int> isLiked,
      Value<String?> taggerName,
      Value<String?> taggerAvatar,
      Value<String?> sourceChannelName,
      Value<String?> sourceChannelAvatar,
      Value<int> tagsCount,
      Value<DateTime> createdAt,
      Value<String?> postType,
      Value<String?> metadata,
      Value<int> rowid,
    });

class $$ChannelPostsTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelPostsTable> {
  $$ChannelPostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get videoUrl => $composableBuilder(
    column: $table.videoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get videoUrls => $composableBuilder(
    column: $table.videoUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrls => $composableBuilder(
    column: $table.thumbnailUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isVideo => $composableBuilder(
    column: $table.isVideo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isSponsored => $composableBuilder(
    column: $table.isSponsored,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allowComments => $composableBuilder(
    column: $table.allowComments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taggerName => $composableBuilder(
    column: $table.taggerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taggerAvatar => $composableBuilder(
    column: $table.taggerAvatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceChannelName => $composableBuilder(
    column: $table.sourceChannelName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceChannelAvatar => $composableBuilder(
    column: $table.sourceChannelAvatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tagsCount => $composableBuilder(
    column: $table.tagsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postType => $composableBuilder(
    column: $table.postType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelPostsTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelPostsTable> {
  $$ChannelPostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get videoUrl => $composableBuilder(
    column: $table.videoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get videoUrls => $composableBuilder(
    column: $table.videoUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrls => $composableBuilder(
    column: $table.thumbnailUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isVideo => $composableBuilder(
    column: $table.isVideo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isSponsored => $composableBuilder(
    column: $table.isSponsored,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allowComments => $composableBuilder(
    column: $table.allowComments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taggerName => $composableBuilder(
    column: $table.taggerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taggerAvatar => $composableBuilder(
    column: $table.taggerAvatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceChannelName => $composableBuilder(
    column: $table.sourceChannelName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceChannelAvatar => $composableBuilder(
    column: $table.sourceChannelAvatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tagsCount => $composableBuilder(
    column: $table.tagsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postType => $composableBuilder(
    column: $table.postType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelPostsTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelPostsTable> {
  $$ChannelPostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<String> get imageUrls =>
      $composableBuilder(column: $table.imageUrls, builder: (column) => column);

  GeneratedColumn<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => column);

  GeneratedColumn<String> get videoUrls =>
      $composableBuilder(column: $table.videoUrls, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrls => $composableBuilder(
    column: $table.thumbnailUrls,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isVideo =>
      $composableBuilder(column: $table.isVideo, builder: (column) => column);

  GeneratedColumn<int> get isSponsored => $composableBuilder(
    column: $table.isSponsored,
    builder: (column) => column,
  );

  GeneratedColumn<double> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => column,
  );

  GeneratedColumn<int> get likes =>
      $composableBuilder(column: $table.likes, builder: (column) => column);

  GeneratedColumn<int> get comments =>
      $composableBuilder(column: $table.comments, builder: (column) => column);

  GeneratedColumn<int> get shares =>
      $composableBuilder(column: $table.shares, builder: (column) => column);

  GeneratedColumn<int> get isPublic =>
      $composableBuilder(column: $table.isPublic, builder: (column) => column);

  GeneratedColumn<int> get allowComments => $composableBuilder(
    column: $table.allowComments,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isPending =>
      $composableBuilder(column: $table.isPending, builder: (column) => column);

  GeneratedColumn<int> get isLiked =>
      $composableBuilder(column: $table.isLiked, builder: (column) => column);

  GeneratedColumn<String> get taggerName => $composableBuilder(
    column: $table.taggerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taggerAvatar => $composableBuilder(
    column: $table.taggerAvatar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceChannelName => $composableBuilder(
    column: $table.sourceChannelName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceChannelAvatar => $composableBuilder(
    column: $table.sourceChannelAvatar,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tagsCount =>
      $composableBuilder(column: $table.tagsCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get postType =>
      $composableBuilder(column: $table.postType, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$ChannelPostsTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelPostsTable,
          ChannelPost,
          $$ChannelPostsTableFilterComposer,
          $$ChannelPostsTableOrderingComposer,
          $$ChannelPostsTableAnnotationComposer,
          $$ChannelPostsTableCreateCompanionBuilder,
          $$ChannelPostsTableUpdateCompanionBuilder,
          (
            ChannelPost,
            BaseReferences<_$ChartDatabase, $ChannelPostsTable, ChannelPost>,
          ),
          ChannelPost,
          PrefetchHooks Function()
        > {
  $$ChannelPostsTableTableManager(_$ChartDatabase db, $ChannelPostsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelPostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelPostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelPostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> channelId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<String?> imageUrls = const Value.absent(),
                Value<String?> videoUrl = const Value.absent(),
                Value<String?> videoUrls = const Value.absent(),
                Value<String?> thumbnailUrls = const Value.absent(),
                Value<int> isVideo = const Value.absent(),
                Value<int> isSponsored = const Value.absent(),
                Value<double?> aspectRatio = const Value.absent(),
                Value<int> likes = const Value.absent(),
                Value<int> comments = const Value.absent(),
                Value<int> shares = const Value.absent(),
                Value<int> isPublic = const Value.absent(),
                Value<int> allowComments = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<int> isLiked = const Value.absent(),
                Value<String?> taggerName = const Value.absent(),
                Value<String?> taggerAvatar = const Value.absent(),
                Value<String?> sourceChannelName = const Value.absent(),
                Value<String?> sourceChannelAvatar = const Value.absent(),
                Value<int> tagsCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> postType = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelPostsCompanion(
                id: id,
                channelId: channelId,
                authorId: authorId,
                username: username,
                profileImageUrl: profileImageUrl,
                caption: caption,
                imageUrls: imageUrls,
                videoUrl: videoUrl,
                videoUrls: videoUrls,
                thumbnailUrls: thumbnailUrls,
                isVideo: isVideo,
                isSponsored: isSponsored,
                aspectRatio: aspectRatio,
                likes: likes,
                comments: comments,
                shares: shares,
                isPublic: isPublic,
                allowComments: allowComments,
                isPending: isPending,
                isLiked: isLiked,
                taggerName: taggerName,
                taggerAvatar: taggerAvatar,
                sourceChannelName: sourceChannelName,
                sourceChannelAvatar: sourceChannelAvatar,
                tagsCount: tagsCount,
                createdAt: createdAt,
                postType: postType,
                metadata: metadata,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String channelId,
                required String authorId,
                Value<String?> username = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<String?> imageUrls = const Value.absent(),
                Value<String?> videoUrl = const Value.absent(),
                Value<String?> videoUrls = const Value.absent(),
                Value<String?> thumbnailUrls = const Value.absent(),
                Value<int> isVideo = const Value.absent(),
                Value<int> isSponsored = const Value.absent(),
                Value<double?> aspectRatio = const Value.absent(),
                Value<int> likes = const Value.absent(),
                Value<int> comments = const Value.absent(),
                Value<int> shares = const Value.absent(),
                Value<int> isPublic = const Value.absent(),
                Value<int> allowComments = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<int> isLiked = const Value.absent(),
                Value<String?> taggerName = const Value.absent(),
                Value<String?> taggerAvatar = const Value.absent(),
                Value<String?> sourceChannelName = const Value.absent(),
                Value<String?> sourceChannelAvatar = const Value.absent(),
                Value<int> tagsCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> postType = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelPostsCompanion.insert(
                id: id,
                channelId: channelId,
                authorId: authorId,
                username: username,
                profileImageUrl: profileImageUrl,
                caption: caption,
                imageUrls: imageUrls,
                videoUrl: videoUrl,
                videoUrls: videoUrls,
                thumbnailUrls: thumbnailUrls,
                isVideo: isVideo,
                isSponsored: isSponsored,
                aspectRatio: aspectRatio,
                likes: likes,
                comments: comments,
                shares: shares,
                isPublic: isPublic,
                allowComments: allowComments,
                isPending: isPending,
                isLiked: isLiked,
                taggerName: taggerName,
                taggerAvatar: taggerAvatar,
                sourceChannelName: sourceChannelName,
                sourceChannelAvatar: sourceChannelAvatar,
                tagsCount: tagsCount,
                createdAt: createdAt,
                postType: postType,
                metadata: metadata,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelPostsTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelPostsTable,
      ChannelPost,
      $$ChannelPostsTableFilterComposer,
      $$ChannelPostsTableOrderingComposer,
      $$ChannelPostsTableAnnotationComposer,
      $$ChannelPostsTableCreateCompanionBuilder,
      $$ChannelPostsTableUpdateCompanionBuilder,
      (
        ChannelPost,
        BaseReferences<_$ChartDatabase, $ChannelPostsTable, ChannelPost>,
      ),
      ChannelPost,
      PrefetchHooks Function()
    >;
typedef $$ChannelPostTagsTableCreateCompanionBuilder =
    ChannelPostTagsCompanion Function({
      Value<int> id,
      required String postId,
      required String tagName,
      Value<String?> tagValue,
      Value<String?> tagColor,
    });
typedef $$ChannelPostTagsTableUpdateCompanionBuilder =
    ChannelPostTagsCompanion Function({
      Value<int> id,
      Value<String> postId,
      Value<String> tagName,
      Value<String?> tagValue,
      Value<String?> tagColor,
    });

class $$ChannelPostTagsTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelPostTagsTable> {
  $$ChannelPostTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagName => $composableBuilder(
    column: $table.tagName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagValue => $composableBuilder(
    column: $table.tagValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagColor => $composableBuilder(
    column: $table.tagColor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelPostTagsTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelPostTagsTable> {
  $$ChannelPostTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagName => $composableBuilder(
    column: $table.tagName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagValue => $composableBuilder(
    column: $table.tagValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagColor => $composableBuilder(
    column: $table.tagColor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelPostTagsTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelPostTagsTable> {
  $$ChannelPostTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get postId =>
      $composableBuilder(column: $table.postId, builder: (column) => column);

  GeneratedColumn<String> get tagName =>
      $composableBuilder(column: $table.tagName, builder: (column) => column);

  GeneratedColumn<String> get tagValue =>
      $composableBuilder(column: $table.tagValue, builder: (column) => column);

  GeneratedColumn<String> get tagColor =>
      $composableBuilder(column: $table.tagColor, builder: (column) => column);
}

class $$ChannelPostTagsTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelPostTagsTable,
          ChannelPostTag,
          $$ChannelPostTagsTableFilterComposer,
          $$ChannelPostTagsTableOrderingComposer,
          $$ChannelPostTagsTableAnnotationComposer,
          $$ChannelPostTagsTableCreateCompanionBuilder,
          $$ChannelPostTagsTableUpdateCompanionBuilder,
          (
            ChannelPostTag,
            BaseReferences<
              _$ChartDatabase,
              $ChannelPostTagsTable,
              ChannelPostTag
            >,
          ),
          ChannelPostTag,
          PrefetchHooks Function()
        > {
  $$ChannelPostTagsTableTableManager(
    _$ChartDatabase db,
    $ChannelPostTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelPostTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelPostTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelPostTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> postId = const Value.absent(),
                Value<String> tagName = const Value.absent(),
                Value<String?> tagValue = const Value.absent(),
                Value<String?> tagColor = const Value.absent(),
              }) => ChannelPostTagsCompanion(
                id: id,
                postId: postId,
                tagName: tagName,
                tagValue: tagValue,
                tagColor: tagColor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String postId,
                required String tagName,
                Value<String?> tagValue = const Value.absent(),
                Value<String?> tagColor = const Value.absent(),
              }) => ChannelPostTagsCompanion.insert(
                id: id,
                postId: postId,
                tagName: tagName,
                tagValue: tagValue,
                tagColor: tagColor,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelPostTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelPostTagsTable,
      ChannelPostTag,
      $$ChannelPostTagsTableFilterComposer,
      $$ChannelPostTagsTableOrderingComposer,
      $$ChannelPostTagsTableAnnotationComposer,
      $$ChannelPostTagsTableCreateCompanionBuilder,
      $$ChannelPostTagsTableUpdateCompanionBuilder,
      (
        ChannelPostTag,
        BaseReferences<_$ChartDatabase, $ChannelPostTagsTable, ChannelPostTag>,
      ),
      ChannelPostTag,
      PrefetchHooks Function()
    >;
typedef $$ChannelContentTagsTableCreateCompanionBuilder =
    ChannelContentTagsCompanion Function({
      required String id,
      required String postId,
      required String userId,
      required String sourceChannelId,
      required String targetChannelId,
      required String linkChain,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ChannelContentTagsTableUpdateCompanionBuilder =
    ChannelContentTagsCompanion Function({
      Value<String> id,
      Value<String> postId,
      Value<String> userId,
      Value<String> sourceChannelId,
      Value<String> targetChannelId,
      Value<String> linkChain,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ChannelContentTagsTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelContentTagsTable> {
  $$ChannelContentTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceChannelId => $composableBuilder(
    column: $table.sourceChannelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetChannelId => $composableBuilder(
    column: $table.targetChannelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkChain => $composableBuilder(
    column: $table.linkChain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelContentTagsTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelContentTagsTable> {
  $$ChannelContentTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceChannelId => $composableBuilder(
    column: $table.sourceChannelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetChannelId => $composableBuilder(
    column: $table.targetChannelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkChain => $composableBuilder(
    column: $table.linkChain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelContentTagsTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelContentTagsTable> {
  $$ChannelContentTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get postId =>
      $composableBuilder(column: $table.postId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get sourceChannelId => $composableBuilder(
    column: $table.sourceChannelId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetChannelId => $composableBuilder(
    column: $table.targetChannelId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkChain =>
      $composableBuilder(column: $table.linkChain, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChannelContentTagsTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelContentTagsTable,
          ChannelContentTag,
          $$ChannelContentTagsTableFilterComposer,
          $$ChannelContentTagsTableOrderingComposer,
          $$ChannelContentTagsTableAnnotationComposer,
          $$ChannelContentTagsTableCreateCompanionBuilder,
          $$ChannelContentTagsTableUpdateCompanionBuilder,
          (
            ChannelContentTag,
            BaseReferences<
              _$ChartDatabase,
              $ChannelContentTagsTable,
              ChannelContentTag
            >,
          ),
          ChannelContentTag,
          PrefetchHooks Function()
        > {
  $$ChannelContentTagsTableTableManager(
    _$ChartDatabase db,
    $ChannelContentTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelContentTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelContentTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelContentTagsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> postId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> sourceChannelId = const Value.absent(),
                Value<String> targetChannelId = const Value.absent(),
                Value<String> linkChain = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelContentTagsCompanion(
                id: id,
                postId: postId,
                userId: userId,
                sourceChannelId: sourceChannelId,
                targetChannelId: targetChannelId,
                linkChain: linkChain,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String postId,
                required String userId,
                required String sourceChannelId,
                required String targetChannelId,
                required String linkChain,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelContentTagsCompanion.insert(
                id: id,
                postId: postId,
                userId: userId,
                sourceChannelId: sourceChannelId,
                targetChannelId: targetChannelId,
                linkChain: linkChain,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelContentTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelContentTagsTable,
      ChannelContentTag,
      $$ChannelContentTagsTableFilterComposer,
      $$ChannelContentTagsTableOrderingComposer,
      $$ChannelContentTagsTableAnnotationComposer,
      $$ChannelContentTagsTableCreateCompanionBuilder,
      $$ChannelContentTagsTableUpdateCompanionBuilder,
      (
        ChannelContentTag,
        BaseReferences<
          _$ChartDatabase,
          $ChannelContentTagsTable,
          ChannelContentTag
        >,
      ),
      ChannelContentTag,
      PrefetchHooks Function()
    >;
typedef $$ChannelPostCommentsTableCreateCompanionBuilder =
    ChannelPostCommentsCompanion Function({
      required String id,
      required String postId,
      required String channelId,
      required String authorId,
      Value<String?> username,
      Value<String?> profileImageUrl,
      required String message,
      Value<String?> imageUrls,
      Value<int> likes,
      Value<int> isPending,
      Value<int> isLiked,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ChannelPostCommentsTableUpdateCompanionBuilder =
    ChannelPostCommentsCompanion Function({
      Value<String> id,
      Value<String> postId,
      Value<String> channelId,
      Value<String> authorId,
      Value<String?> username,
      Value<String?> profileImageUrl,
      Value<String> message,
      Value<String?> imageUrls,
      Value<int> likes,
      Value<int> isPending,
      Value<int> isLiked,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ChannelPostCommentsTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelPostCommentsTable> {
  $$ChannelPostCommentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelPostCommentsTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelPostCommentsTable> {
  $$ChannelPostCommentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelPostCommentsTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelPostCommentsTable> {
  $$ChannelPostCommentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get postId =>
      $composableBuilder(column: $table.postId, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get imageUrls =>
      $composableBuilder(column: $table.imageUrls, builder: (column) => column);

  GeneratedColumn<int> get likes =>
      $composableBuilder(column: $table.likes, builder: (column) => column);

  GeneratedColumn<int> get isPending =>
      $composableBuilder(column: $table.isPending, builder: (column) => column);

  GeneratedColumn<int> get isLiked =>
      $composableBuilder(column: $table.isLiked, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChannelPostCommentsTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelPostCommentsTable,
          ChannelPostComment,
          $$ChannelPostCommentsTableFilterComposer,
          $$ChannelPostCommentsTableOrderingComposer,
          $$ChannelPostCommentsTableAnnotationComposer,
          $$ChannelPostCommentsTableCreateCompanionBuilder,
          $$ChannelPostCommentsTableUpdateCompanionBuilder,
          (
            ChannelPostComment,
            BaseReferences<
              _$ChartDatabase,
              $ChannelPostCommentsTable,
              ChannelPostComment
            >,
          ),
          ChannelPostComment,
          PrefetchHooks Function()
        > {
  $$ChannelPostCommentsTableTableManager(
    _$ChartDatabase db,
    $ChannelPostCommentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelPostCommentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelPostCommentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ChannelPostCommentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> postId = const Value.absent(),
                Value<String> channelId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String?> imageUrls = const Value.absent(),
                Value<int> likes = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<int> isLiked = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelPostCommentsCompanion(
                id: id,
                postId: postId,
                channelId: channelId,
                authorId: authorId,
                username: username,
                profileImageUrl: profileImageUrl,
                message: message,
                imageUrls: imageUrls,
                likes: likes,
                isPending: isPending,
                isLiked: isLiked,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String postId,
                required String channelId,
                required String authorId,
                Value<String?> username = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                required String message,
                Value<String?> imageUrls = const Value.absent(),
                Value<int> likes = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<int> isLiked = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelPostCommentsCompanion.insert(
                id: id,
                postId: postId,
                channelId: channelId,
                authorId: authorId,
                username: username,
                profileImageUrl: profileImageUrl,
                message: message,
                imageUrls: imageUrls,
                likes: likes,
                isPending: isPending,
                isLiked: isLiked,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelPostCommentsTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelPostCommentsTable,
      ChannelPostComment,
      $$ChannelPostCommentsTableFilterComposer,
      $$ChannelPostCommentsTableOrderingComposer,
      $$ChannelPostCommentsTableAnnotationComposer,
      $$ChannelPostCommentsTableCreateCompanionBuilder,
      $$ChannelPostCommentsTableUpdateCompanionBuilder,
      (
        ChannelPostComment,
        BaseReferences<
          _$ChartDatabase,
          $ChannelPostCommentsTable,
          ChannelPostComment
        >,
      ),
      ChannelPostComment,
      PrefetchHooks Function()
    >;
typedef $$ChannelMessagesTableCreateCompanionBuilder =
    ChannelMessagesCompanion Function({
      required String id,
      required String channelId,
      required String senderId,
      Value<String?> textContent,
      Value<String?> mediaUrl,
      Value<String?> thumbnailUrl,
      Value<String?> mediaType,
      Value<String?> voiceNoteUrl,
      Value<String?> replyToId,
      Value<int> isRead,
      Value<int> isPending,
      Value<String> messageType,
      Value<String?> metadata,
      Value<String?> createdAt,
      Value<int> rowid,
    });
typedef $$ChannelMessagesTableUpdateCompanionBuilder =
    ChannelMessagesCompanion Function({
      Value<String> id,
      Value<String> channelId,
      Value<String> senderId,
      Value<String?> textContent,
      Value<String?> mediaUrl,
      Value<String?> thumbnailUrl,
      Value<String?> mediaType,
      Value<String?> voiceNoteUrl,
      Value<String?> replyToId,
      Value<int> isRead,
      Value<int> isPending,
      Value<String> messageType,
      Value<String?> metadata,
      Value<String?> createdAt,
      Value<int> rowid,
    });

class $$ChannelMessagesTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelMessagesTable> {
  $$ChannelMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voiceNoteUrl => $composableBuilder(
    column: $table.voiceNoteUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replyToId => $composableBuilder(
    column: $table.replyToId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageType => $composableBuilder(
    column: $table.messageType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelMessagesTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelMessagesTable> {
  $$ChannelMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voiceNoteUrl => $composableBuilder(
    column: $table.voiceNoteUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replyToId => $composableBuilder(
    column: $table.replyToId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageType => $composableBuilder(
    column: $table.messageType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelMessagesTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelMessagesTable> {
  $$ChannelMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaUrl =>
      $composableBuilder(column: $table.mediaUrl, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get voiceNoteUrl => $composableBuilder(
    column: $table.voiceNoteUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replyToId =>
      $composableBuilder(column: $table.replyToId, builder: (column) => column);

  GeneratedColumn<int> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<int> get isPending =>
      $composableBuilder(column: $table.isPending, builder: (column) => column);

  GeneratedColumn<String> get messageType => $composableBuilder(
    column: $table.messageType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChannelMessagesTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelMessagesTable,
          ChannelMessage,
          $$ChannelMessagesTableFilterComposer,
          $$ChannelMessagesTableOrderingComposer,
          $$ChannelMessagesTableAnnotationComposer,
          $$ChannelMessagesTableCreateCompanionBuilder,
          $$ChannelMessagesTableUpdateCompanionBuilder,
          (
            ChannelMessage,
            BaseReferences<
              _$ChartDatabase,
              $ChannelMessagesTable,
              ChannelMessage
            >,
          ),
          ChannelMessage,
          PrefetchHooks Function()
        > {
  $$ChannelMessagesTableTableManager(
    _$ChartDatabase db,
    $ChannelMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> channelId = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String?> textContent = const Value.absent(),
                Value<String?> mediaUrl = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<String?> mediaType = const Value.absent(),
                Value<String?> voiceNoteUrl = const Value.absent(),
                Value<String?> replyToId = const Value.absent(),
                Value<int> isRead = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<String> messageType = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelMessagesCompanion(
                id: id,
                channelId: channelId,
                senderId: senderId,
                textContent: textContent,
                mediaUrl: mediaUrl,
                thumbnailUrl: thumbnailUrl,
                mediaType: mediaType,
                voiceNoteUrl: voiceNoteUrl,
                replyToId: replyToId,
                isRead: isRead,
                isPending: isPending,
                messageType: messageType,
                metadata: metadata,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String channelId,
                required String senderId,
                Value<String?> textContent = const Value.absent(),
                Value<String?> mediaUrl = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<String?> mediaType = const Value.absent(),
                Value<String?> voiceNoteUrl = const Value.absent(),
                Value<String?> replyToId = const Value.absent(),
                Value<int> isRead = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<String> messageType = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelMessagesCompanion.insert(
                id: id,
                channelId: channelId,
                senderId: senderId,
                textContent: textContent,
                mediaUrl: mediaUrl,
                thumbnailUrl: thumbnailUrl,
                mediaType: mediaType,
                voiceNoteUrl: voiceNoteUrl,
                replyToId: replyToId,
                isRead: isRead,
                isPending: isPending,
                messageType: messageType,
                metadata: metadata,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelMessagesTable,
      ChannelMessage,
      $$ChannelMessagesTableFilterComposer,
      $$ChannelMessagesTableOrderingComposer,
      $$ChannelMessagesTableAnnotationComposer,
      $$ChannelMessagesTableCreateCompanionBuilder,
      $$ChannelMessagesTableUpdateCompanionBuilder,
      (
        ChannelMessage,
        BaseReferences<_$ChartDatabase, $ChannelMessagesTable, ChannelMessage>,
      ),
      ChannelMessage,
      PrefetchHooks Function()
    >;
typedef $$CommonChannelsTableCreateCompanionBuilder =
    CommonChannelsCompanion Function({
      required String userId,
      required String otherUserId,
      required String channelId,
      Value<int> rowid,
    });
typedef $$CommonChannelsTableUpdateCompanionBuilder =
    CommonChannelsCompanion Function({
      Value<String> userId,
      Value<String> otherUserId,
      Value<String> channelId,
      Value<int> rowid,
    });

class $$CommonChannelsTableFilterComposer
    extends Composer<_$ChartDatabase, $CommonChannelsTable> {
  $$CommonChannelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherUserId => $composableBuilder(
    column: $table.otherUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CommonChannelsTableOrderingComposer
    extends Composer<_$ChartDatabase, $CommonChannelsTable> {
  $$CommonChannelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherUserId => $composableBuilder(
    column: $table.otherUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CommonChannelsTableAnnotationComposer
    extends Composer<_$ChartDatabase, $CommonChannelsTable> {
  $$CommonChannelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get otherUserId => $composableBuilder(
    column: $table.otherUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);
}

class $$CommonChannelsTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $CommonChannelsTable,
          CommonChannel,
          $$CommonChannelsTableFilterComposer,
          $$CommonChannelsTableOrderingComposer,
          $$CommonChannelsTableAnnotationComposer,
          $$CommonChannelsTableCreateCompanionBuilder,
          $$CommonChannelsTableUpdateCompanionBuilder,
          (
            CommonChannel,
            BaseReferences<
              _$ChartDatabase,
              $CommonChannelsTable,
              CommonChannel
            >,
          ),
          CommonChannel,
          PrefetchHooks Function()
        > {
  $$CommonChannelsTableTableManager(
    _$ChartDatabase db,
    $CommonChannelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommonChannelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommonChannelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommonChannelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> otherUserId = const Value.absent(),
                Value<String> channelId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CommonChannelsCompanion(
                userId: userId,
                otherUserId: otherUserId,
                channelId: channelId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String otherUserId,
                required String channelId,
                Value<int> rowid = const Value.absent(),
              }) => CommonChannelsCompanion.insert(
                userId: userId,
                otherUserId: otherUserId,
                channelId: channelId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CommonChannelsTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $CommonChannelsTable,
      CommonChannel,
      $$CommonChannelsTableFilterComposer,
      $$CommonChannelsTableOrderingComposer,
      $$CommonChannelsTableAnnotationComposer,
      $$CommonChannelsTableCreateCompanionBuilder,
      $$CommonChannelsTableUpdateCompanionBuilder,
      (
        CommonChannel,
        BaseReferences<_$ChartDatabase, $CommonChannelsTable, CommonChannel>,
      ),
      CommonChannel,
      PrefetchHooks Function()
    >;
typedef $$ChannelMomentsTableCreateCompanionBuilder =
    ChannelMomentsCompanion Function({
      required String id,
      required String channelId,
      required String authorId,
      Value<String?> authorName,
      Value<String?> authorAvatarUrl,
      required String mediaUrl,
      Value<String> mediaType,
      Value<String?> thumbnailUrl,
      Value<String?> caption,
      Value<DateTime> createdAt,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });
typedef $$ChannelMomentsTableUpdateCompanionBuilder =
    ChannelMomentsCompanion Function({
      Value<String> id,
      Value<String> channelId,
      Value<String> authorId,
      Value<String?> authorName,
      Value<String?> authorAvatarUrl,
      Value<String> mediaUrl,
      Value<String> mediaType,
      Value<String?> thumbnailUrl,
      Value<String?> caption,
      Value<DateTime> createdAt,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });

class $$ChannelMomentsTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelMomentsTable> {
  $$ChannelMomentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorAvatarUrl => $composableBuilder(
    column: $table.authorAvatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelMomentsTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelMomentsTable> {
  $$ChannelMomentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorAvatarUrl => $composableBuilder(
    column: $table.authorAvatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelMomentsTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelMomentsTable> {
  $$ChannelMomentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorAvatarUrl => $composableBuilder(
    column: $table.authorAvatarUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaUrl =>
      $composableBuilder(column: $table.mediaUrl, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$ChannelMomentsTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelMomentsTable,
          ChannelMoment,
          $$ChannelMomentsTableFilterComposer,
          $$ChannelMomentsTableOrderingComposer,
          $$ChannelMomentsTableAnnotationComposer,
          $$ChannelMomentsTableCreateCompanionBuilder,
          $$ChannelMomentsTableUpdateCompanionBuilder,
          (
            ChannelMoment,
            BaseReferences<
              _$ChartDatabase,
              $ChannelMomentsTable,
              ChannelMoment
            >,
          ),
          ChannelMoment,
          PrefetchHooks Function()
        > {
  $$ChannelMomentsTableTableManager(
    _$ChartDatabase db,
    $ChannelMomentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelMomentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelMomentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelMomentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> channelId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String?> authorName = const Value.absent(),
                Value<String?> authorAvatarUrl = const Value.absent(),
                Value<String> mediaUrl = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelMomentsCompanion(
                id: id,
                channelId: channelId,
                authorId: authorId,
                authorName: authorName,
                authorAvatarUrl: authorAvatarUrl,
                mediaUrl: mediaUrl,
                mediaType: mediaType,
                thumbnailUrl: thumbnailUrl,
                caption: caption,
                createdAt: createdAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String channelId,
                required String authorId,
                Value<String?> authorName = const Value.absent(),
                Value<String?> authorAvatarUrl = const Value.absent(),
                required String mediaUrl,
                Value<String> mediaType = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelMomentsCompanion.insert(
                id: id,
                channelId: channelId,
                authorId: authorId,
                authorName: authorName,
                authorAvatarUrl: authorAvatarUrl,
                mediaUrl: mediaUrl,
                mediaType: mediaType,
                thumbnailUrl: thumbnailUrl,
                caption: caption,
                createdAt: createdAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelMomentsTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelMomentsTable,
      ChannelMoment,
      $$ChannelMomentsTableFilterComposer,
      $$ChannelMomentsTableOrderingComposer,
      $$ChannelMomentsTableAnnotationComposer,
      $$ChannelMomentsTableCreateCompanionBuilder,
      $$ChannelMomentsTableUpdateCompanionBuilder,
      (
        ChannelMoment,
        BaseReferences<_$ChartDatabase, $ChannelMomentsTable, ChannelMoment>,
      ),
      ChannelMoment,
      PrefetchHooks Function()
    >;
typedef $$ChannelInvitationsTableCreateCompanionBuilder =
    ChannelInvitationsCompanion Function({
      required String id,
      required String senderId,
      required String sourceChannelId,
      required String targetChannelId,
      Value<String?> createdAt,
      Value<int> isPending,
      Value<int> rowid,
    });
typedef $$ChannelInvitationsTableUpdateCompanionBuilder =
    ChannelInvitationsCompanion Function({
      Value<String> id,
      Value<String> senderId,
      Value<String> sourceChannelId,
      Value<String> targetChannelId,
      Value<String?> createdAt,
      Value<int> isPending,
      Value<int> rowid,
    });

final class $$ChannelInvitationsTableReferences
    extends
        BaseReferences<
          _$ChartDatabase,
          $ChannelInvitationsTable,
          ChannelInvitation
        > {
  $$ChannelInvitationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _senderIdTable(_$ChartDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.channelInvitations.senderId, db.users.id),
  );

  $$UsersTableProcessedTableManager get senderId {
    final $_column = $_itemColumn<String>('sender_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_senderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChannelsTable _sourceChannelIdTable(_$ChartDatabase db) =>
      db.channels.createAlias(
        $_aliasNameGenerator(
          db.channelInvitations.sourceChannelId,
          db.channels.id,
        ),
      );

  $$ChannelsTableProcessedTableManager get sourceChannelId {
    final $_column = $_itemColumn<String>('source_channel_id')!;

    final manager = $$ChannelsTableTableManager(
      $_db,
      $_db.channels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceChannelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChannelsTable _targetChannelIdTable(_$ChartDatabase db) =>
      db.channels.createAlias(
        $_aliasNameGenerator(
          db.channelInvitations.targetChannelId,
          db.channels.id,
        ),
      );

  $$ChannelsTableProcessedTableManager get targetChannelId {
    final $_column = $_itemColumn<String>('target_channel_id')!;

    final manager = $$ChannelsTableTableManager(
      $_db,
      $_db.channels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetChannelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChannelInvitationsTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelInvitationsTable> {
  $$ChannelInvitationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get senderId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.senderId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChannelsTableFilterComposer get sourceChannelId {
    final $$ChannelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceChannelId,
      referencedTable: $db.channels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelsTableFilterComposer(
            $db: $db,
            $table: $db.channels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChannelsTableFilterComposer get targetChannelId {
    final $$ChannelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetChannelId,
      referencedTable: $db.channels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelsTableFilterComposer(
            $db: $db,
            $table: $db.channels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChannelInvitationsTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelInvitationsTable> {
  $$ChannelInvitationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get senderId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.senderId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChannelsTableOrderingComposer get sourceChannelId {
    final $$ChannelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceChannelId,
      referencedTable: $db.channels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelsTableOrderingComposer(
            $db: $db,
            $table: $db.channels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChannelsTableOrderingComposer get targetChannelId {
    final $$ChannelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetChannelId,
      referencedTable: $db.channels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelsTableOrderingComposer(
            $db: $db,
            $table: $db.channels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChannelInvitationsTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelInvitationsTable> {
  $$ChannelInvitationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get isPending =>
      $composableBuilder(column: $table.isPending, builder: (column) => column);

  $$UsersTableAnnotationComposer get senderId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.senderId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChannelsTableAnnotationComposer get sourceChannelId {
    final $$ChannelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceChannelId,
      referencedTable: $db.channels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelsTableAnnotationComposer(
            $db: $db,
            $table: $db.channels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChannelsTableAnnotationComposer get targetChannelId {
    final $$ChannelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetChannelId,
      referencedTable: $db.channels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelsTableAnnotationComposer(
            $db: $db,
            $table: $db.channels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChannelInvitationsTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelInvitationsTable,
          ChannelInvitation,
          $$ChannelInvitationsTableFilterComposer,
          $$ChannelInvitationsTableOrderingComposer,
          $$ChannelInvitationsTableAnnotationComposer,
          $$ChannelInvitationsTableCreateCompanionBuilder,
          $$ChannelInvitationsTableUpdateCompanionBuilder,
          (ChannelInvitation, $$ChannelInvitationsTableReferences),
          ChannelInvitation,
          PrefetchHooks Function({
            bool senderId,
            bool sourceChannelId,
            bool targetChannelId,
          })
        > {
  $$ChannelInvitationsTableTableManager(
    _$ChartDatabase db,
    $ChannelInvitationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelInvitationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelInvitationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelInvitationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String> sourceChannelId = const Value.absent(),
                Value<String> targetChannelId = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelInvitationsCompanion(
                id: id,
                senderId: senderId,
                sourceChannelId: sourceChannelId,
                targetChannelId: targetChannelId,
                createdAt: createdAt,
                isPending: isPending,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String senderId,
                required String sourceChannelId,
                required String targetChannelId,
                Value<String?> createdAt = const Value.absent(),
                Value<int> isPending = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelInvitationsCompanion.insert(
                id: id,
                senderId: senderId,
                sourceChannelId: sourceChannelId,
                targetChannelId: targetChannelId,
                createdAt: createdAt,
                isPending: isPending,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChannelInvitationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                senderId = false,
                sourceChannelId = false,
                targetChannelId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (senderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.senderId,
                                    referencedTable:
                                        $$ChannelInvitationsTableReferences
                                            ._senderIdTable(db),
                                    referencedColumn:
                                        $$ChannelInvitationsTableReferences
                                            ._senderIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sourceChannelId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceChannelId,
                                    referencedTable:
                                        $$ChannelInvitationsTableReferences
                                            ._sourceChannelIdTable(db),
                                    referencedColumn:
                                        $$ChannelInvitationsTableReferences
                                            ._sourceChannelIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (targetChannelId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.targetChannelId,
                                    referencedTable:
                                        $$ChannelInvitationsTableReferences
                                            ._targetChannelIdTable(db),
                                    referencedColumn:
                                        $$ChannelInvitationsTableReferences
                                            ._targetChannelIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ChannelInvitationsTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelInvitationsTable,
      ChannelInvitation,
      $$ChannelInvitationsTableFilterComposer,
      $$ChannelInvitationsTableOrderingComposer,
      $$ChannelInvitationsTableAnnotationComposer,
      $$ChannelInvitationsTableCreateCompanionBuilder,
      $$ChannelInvitationsTableUpdateCompanionBuilder,
      (ChannelInvitation, $$ChannelInvitationsTableReferences),
      ChannelInvitation,
      PrefetchHooks Function({
        bool senderId,
        bool sourceChannelId,
        bool targetChannelId,
      })
    >;
typedef $$ChannelPollsTableCreateCompanionBuilder =
    ChannelPollsCompanion Function({
      required String id,
      required String messageId,
      required String title,
      Value<int> totalPoints,
      Value<int> isClosed,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ChannelPollsTableUpdateCompanionBuilder =
    ChannelPollsCompanion Function({
      Value<String> id,
      Value<String> messageId,
      Value<String> title,
      Value<int> totalPoints,
      Value<int> isClosed,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ChannelPollsTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelPollsTable> {
  $$ChannelPollsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelPollsTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelPollsTable> {
  $$ChannelPollsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelPollsTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelPollsTable> {
  $$ChannelPollsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChannelPollsTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelPollsTable,
          ChannelPoll,
          $$ChannelPollsTableFilterComposer,
          $$ChannelPollsTableOrderingComposer,
          $$ChannelPollsTableAnnotationComposer,
          $$ChannelPollsTableCreateCompanionBuilder,
          $$ChannelPollsTableUpdateCompanionBuilder,
          (
            ChannelPoll,
            BaseReferences<_$ChartDatabase, $ChannelPollsTable, ChannelPoll>,
          ),
          ChannelPoll,
          PrefetchHooks Function()
        > {
  $$ChannelPollsTableTableManager(_$ChartDatabase db, $ChannelPollsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelPollsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelPollsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelPollsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> messageId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> totalPoints = const Value.absent(),
                Value<int> isClosed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelPollsCompanion(
                id: id,
                messageId: messageId,
                title: title,
                totalPoints: totalPoints,
                isClosed: isClosed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String messageId,
                required String title,
                Value<int> totalPoints = const Value.absent(),
                Value<int> isClosed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelPollsCompanion.insert(
                id: id,
                messageId: messageId,
                title: title,
                totalPoints: totalPoints,
                isClosed: isClosed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelPollsTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelPollsTable,
      ChannelPoll,
      $$ChannelPollsTableFilterComposer,
      $$ChannelPollsTableOrderingComposer,
      $$ChannelPollsTableAnnotationComposer,
      $$ChannelPollsTableCreateCompanionBuilder,
      $$ChannelPollsTableUpdateCompanionBuilder,
      (
        ChannelPoll,
        BaseReferences<_$ChartDatabase, $ChannelPollsTable, ChannelPoll>,
      ),
      ChannelPoll,
      PrefetchHooks Function()
    >;
typedef $$ChannelPollOptionsTableCreateCompanionBuilder =
    ChannelPollOptionsCompanion Function({
      required String id,
      required String pollId,
      required String title,
      Value<String?> mediaUrl,
      Value<String?> mediaType,
      Value<int> points,
      Value<String?> suggestedBy,
      Value<int> rowid,
    });
typedef $$ChannelPollOptionsTableUpdateCompanionBuilder =
    ChannelPollOptionsCompanion Function({
      Value<String> id,
      Value<String> pollId,
      Value<String> title,
      Value<String?> mediaUrl,
      Value<String?> mediaType,
      Value<int> points,
      Value<String?> suggestedBy,
      Value<int> rowid,
    });

class $$ChannelPollOptionsTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelPollOptionsTable> {
  $$ChannelPollOptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pollId => $composableBuilder(
    column: $table.pollId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedBy => $composableBuilder(
    column: $table.suggestedBy,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelPollOptionsTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelPollOptionsTable> {
  $$ChannelPollOptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pollId => $composableBuilder(
    column: $table.pollId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedBy => $composableBuilder(
    column: $table.suggestedBy,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelPollOptionsTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelPollOptionsTable> {
  $$ChannelPollOptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pollId =>
      $composableBuilder(column: $table.pollId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get mediaUrl =>
      $composableBuilder(column: $table.mediaUrl, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<String> get suggestedBy => $composableBuilder(
    column: $table.suggestedBy,
    builder: (column) => column,
  );
}

class $$ChannelPollOptionsTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelPollOptionsTable,
          ChannelPollOption,
          $$ChannelPollOptionsTableFilterComposer,
          $$ChannelPollOptionsTableOrderingComposer,
          $$ChannelPollOptionsTableAnnotationComposer,
          $$ChannelPollOptionsTableCreateCompanionBuilder,
          $$ChannelPollOptionsTableUpdateCompanionBuilder,
          (
            ChannelPollOption,
            BaseReferences<
              _$ChartDatabase,
              $ChannelPollOptionsTable,
              ChannelPollOption
            >,
          ),
          ChannelPollOption,
          PrefetchHooks Function()
        > {
  $$ChannelPollOptionsTableTableManager(
    _$ChartDatabase db,
    $ChannelPollOptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelPollOptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelPollOptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelPollOptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> pollId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> mediaUrl = const Value.absent(),
                Value<String?> mediaType = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<String?> suggestedBy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelPollOptionsCompanion(
                id: id,
                pollId: pollId,
                title: title,
                mediaUrl: mediaUrl,
                mediaType: mediaType,
                points: points,
                suggestedBy: suggestedBy,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String pollId,
                required String title,
                Value<String?> mediaUrl = const Value.absent(),
                Value<String?> mediaType = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<String?> suggestedBy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelPollOptionsCompanion.insert(
                id: id,
                pollId: pollId,
                title: title,
                mediaUrl: mediaUrl,
                mediaType: mediaType,
                points: points,
                suggestedBy: suggestedBy,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelPollOptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelPollOptionsTable,
      ChannelPollOption,
      $$ChannelPollOptionsTableFilterComposer,
      $$ChannelPollOptionsTableOrderingComposer,
      $$ChannelPollOptionsTableAnnotationComposer,
      $$ChannelPollOptionsTableCreateCompanionBuilder,
      $$ChannelPollOptionsTableUpdateCompanionBuilder,
      (
        ChannelPollOption,
        BaseReferences<
          _$ChartDatabase,
          $ChannelPollOptionsTable,
          ChannelPollOption
        >,
      ),
      ChannelPollOption,
      PrefetchHooks Function()
    >;
typedef $$ChannelGiftsTableCreateCompanionBuilder =
    ChannelGiftsCompanion Function({
      required String id,
      required String channelId,
      required String giverId,
      required String receiverId,
      required String giftId,
      Value<int> coinValue,
      Value<DateTime?> receivedAt,
      Value<String?> messageId,
      Value<int> rowid,
    });
typedef $$ChannelGiftsTableUpdateCompanionBuilder =
    ChannelGiftsCompanion Function({
      Value<String> id,
      Value<String> channelId,
      Value<String> giverId,
      Value<String> receiverId,
      Value<String> giftId,
      Value<int> coinValue,
      Value<DateTime?> receivedAt,
      Value<String?> messageId,
      Value<int> rowid,
    });

class $$ChannelGiftsTableFilterComposer
    extends Composer<_$ChartDatabase, $ChannelGiftsTable> {
  $$ChannelGiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get giverId => $composableBuilder(
    column: $table.giverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiverId => $composableBuilder(
    column: $table.receiverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get giftId => $composableBuilder(
    column: $table.giftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coinValue => $composableBuilder(
    column: $table.coinValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChannelGiftsTableOrderingComposer
    extends Composer<_$ChartDatabase, $ChannelGiftsTable> {
  $$ChannelGiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get giverId => $composableBuilder(
    column: $table.giverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiverId => $composableBuilder(
    column: $table.receiverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get giftId => $composableBuilder(
    column: $table.giftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coinValue => $composableBuilder(
    column: $table.coinValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelGiftsTableAnnotationComposer
    extends Composer<_$ChartDatabase, $ChannelGiftsTable> {
  $$ChannelGiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get giverId =>
      $composableBuilder(column: $table.giverId, builder: (column) => column);

  GeneratedColumn<String> get receiverId => $composableBuilder(
    column: $table.receiverId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get giftId =>
      $composableBuilder(column: $table.giftId, builder: (column) => column);

  GeneratedColumn<int> get coinValue =>
      $composableBuilder(column: $table.coinValue, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);
}

class $$ChannelGiftsTableTableManager
    extends
        RootTableManager<
          _$ChartDatabase,
          $ChannelGiftsTable,
          ChannelGift,
          $$ChannelGiftsTableFilterComposer,
          $$ChannelGiftsTableOrderingComposer,
          $$ChannelGiftsTableAnnotationComposer,
          $$ChannelGiftsTableCreateCompanionBuilder,
          $$ChannelGiftsTableUpdateCompanionBuilder,
          (
            ChannelGift,
            BaseReferences<_$ChartDatabase, $ChannelGiftsTable, ChannelGift>,
          ),
          ChannelGift,
          PrefetchHooks Function()
        > {
  $$ChannelGiftsTableTableManager(_$ChartDatabase db, $ChannelGiftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelGiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelGiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelGiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> channelId = const Value.absent(),
                Value<String> giverId = const Value.absent(),
                Value<String> receiverId = const Value.absent(),
                Value<String> giftId = const Value.absent(),
                Value<int> coinValue = const Value.absent(),
                Value<DateTime?> receivedAt = const Value.absent(),
                Value<String?> messageId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelGiftsCompanion(
                id: id,
                channelId: channelId,
                giverId: giverId,
                receiverId: receiverId,
                giftId: giftId,
                coinValue: coinValue,
                receivedAt: receivedAt,
                messageId: messageId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String channelId,
                required String giverId,
                required String receiverId,
                required String giftId,
                Value<int> coinValue = const Value.absent(),
                Value<DateTime?> receivedAt = const Value.absent(),
                Value<String?> messageId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelGiftsCompanion.insert(
                id: id,
                channelId: channelId,
                giverId: giverId,
                receiverId: receiverId,
                giftId: giftId,
                coinValue: coinValue,
                receivedAt: receivedAt,
                messageId: messageId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChannelGiftsTableProcessedTableManager =
    ProcessedTableManager<
      _$ChartDatabase,
      $ChannelGiftsTable,
      ChannelGift,
      $$ChannelGiftsTableFilterComposer,
      $$ChannelGiftsTableOrderingComposer,
      $$ChannelGiftsTableAnnotationComposer,
      $$ChannelGiftsTableCreateCompanionBuilder,
      $$ChannelGiftsTableUpdateCompanionBuilder,
      (
        ChannelGift,
        BaseReferences<_$ChartDatabase, $ChannelGiftsTable, ChannelGift>,
      ),
      ChannelGift,
      PrefetchHooks Function()
    >;

class $ChartDatabaseManager {
  final _$ChartDatabase _db;
  $ChartDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$PostsTableTableManager get posts =>
      $$PostsTableTableManager(_db, _db.posts);
  $$ManifestosTableTableManager get manifestos =>
      $$ManifestosTableTableManager(_db, _db.manifestos);
  $$ManifestoCommentsTableTableManager get manifestoComments =>
      $$ManifestoCommentsTableTableManager(_db, _db.manifestoComments);
  $$ChannelsTableTableManager get channels =>
      $$ChannelsTableTableManager(_db, _db.channels);
  $$ChannelMetadataTableTableManager get channelMetadata =>
      $$ChannelMetadataTableTableManager(_db, _db.channelMetadata);
  $$ChannelBrandingTableTableManager get channelBranding =>
      $$ChannelBrandingTableTableManager(_db, _db.channelBranding);
  $$ChannelMembersTableTableManager get channelMembers =>
      $$ChannelMembersTableTableManager(_db, _db.channelMembers);
  $$ChannelStatusesTableTableManager get channelStatuses =>
      $$ChannelStatusesTableTableManager(_db, _db.channelStatuses);
  $$ChannelPresenceTableTableManager get channelPresence =>
      $$ChannelPresenceTableTableManager(_db, _db.channelPresence);
  $$ChannelCreatorTableTableManager get channelCreator =>
      $$ChannelCreatorTableTableManager(_db, _db.channelCreator);
  $$ChannelPostsTableTableManager get channelPosts =>
      $$ChannelPostsTableTableManager(_db, _db.channelPosts);
  $$ChannelPostTagsTableTableManager get channelPostTags =>
      $$ChannelPostTagsTableTableManager(_db, _db.channelPostTags);
  $$ChannelContentTagsTableTableManager get channelContentTags =>
      $$ChannelContentTagsTableTableManager(_db, _db.channelContentTags);
  $$ChannelPostCommentsTableTableManager get channelPostComments =>
      $$ChannelPostCommentsTableTableManager(_db, _db.channelPostComments);
  $$ChannelMessagesTableTableManager get channelMessages =>
      $$ChannelMessagesTableTableManager(_db, _db.channelMessages);
  $$CommonChannelsTableTableManager get commonChannels =>
      $$CommonChannelsTableTableManager(_db, _db.commonChannels);
  $$ChannelMomentsTableTableManager get channelMoments =>
      $$ChannelMomentsTableTableManager(_db, _db.channelMoments);
  $$ChannelInvitationsTableTableManager get channelInvitations =>
      $$ChannelInvitationsTableTableManager(_db, _db.channelInvitations);
  $$ChannelPollsTableTableManager get channelPolls =>
      $$ChannelPollsTableTableManager(_db, _db.channelPolls);
  $$ChannelPollOptionsTableTableManager get channelPollOptions =>
      $$ChannelPollOptionsTableTableManager(_db, _db.channelPollOptions);
  $$ChannelGiftsTableTableManager get channelGifts =>
      $$ChannelGiftsTableTableManager(_db, _db.channelGifts);
}
