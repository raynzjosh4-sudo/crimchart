// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_channels_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commonChannelsHash() => r'a755dfa579102420c0883abe3efe943682b993a3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [commonChannels].
@ProviderFor(commonChannels)
const commonChannelsProvider = CommonChannelsFamily();

/// See also [commonChannels].
class CommonChannelsFamily extends Family<AsyncValue<List<ChartChannel>>> {
  /// See also [commonChannels].
  const CommonChannelsFamily();

  /// See also [commonChannels].
  CommonChannelsProvider call(String otherUserId) {
    return CommonChannelsProvider(otherUserId);
  }

  @override
  CommonChannelsProvider getProviderOverride(
    covariant CommonChannelsProvider provider,
  ) {
    return call(provider.otherUserId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'commonChannelsProvider';
}

/// See also [commonChannels].
class CommonChannelsProvider
    extends AutoDisposeStreamProvider<List<ChartChannel>> {
  /// See also [commonChannels].
  CommonChannelsProvider(String otherUserId)
    : this._internal(
        (ref) => commonChannels(ref as CommonChannelsRef, otherUserId),
        from: commonChannelsProvider,
        name: r'commonChannelsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$commonChannelsHash,
        dependencies: CommonChannelsFamily._dependencies,
        allTransitiveDependencies:
            CommonChannelsFamily._allTransitiveDependencies,
        otherUserId: otherUserId,
      );

  CommonChannelsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.otherUserId,
  }) : super.internal();

  final String otherUserId;

  @override
  Override overrideWith(
    Stream<List<ChartChannel>> Function(CommonChannelsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CommonChannelsProvider._internal(
        (ref) => create(ref as CommonChannelsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        otherUserId: otherUserId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ChartChannel>> createElement() {
    return _CommonChannelsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommonChannelsProvider && other.otherUserId == otherUserId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherUserId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CommonChannelsRef on AutoDisposeStreamProviderRef<List<ChartChannel>> {
  /// The parameter `otherUserId` of this provider.
  String get otherUserId;
}

class _CommonChannelsProviderElement
    extends AutoDisposeStreamProviderElement<List<ChartChannel>>
    with CommonChannelsRef {
  _CommonChannelsProviderElement(super.provider);

  @override
  String get otherUserId => (origin as CommonChannelsProvider).otherUserId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
