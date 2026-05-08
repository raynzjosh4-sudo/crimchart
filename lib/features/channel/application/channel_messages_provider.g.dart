// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_messages_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$channelMessagesHash() => r'24ace04c0c5a4850b9e3410b67e9c5d440084542';

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

abstract class _$ChannelMessages
    extends BuildlessAutoDisposeStreamNotifier<List<ChannelMessageEntity>> {
  late final String channelId;

  Stream<List<ChannelMessageEntity>> build(String channelId);
}

/// See also [ChannelMessages].
@ProviderFor(ChannelMessages)
const channelMessagesProvider = ChannelMessagesFamily();

/// See also [ChannelMessages].
class ChannelMessagesFamily
    extends Family<AsyncValue<List<ChannelMessageEntity>>> {
  /// See also [ChannelMessages].
  const ChannelMessagesFamily();

  /// See also [ChannelMessages].
  ChannelMessagesProvider call(String channelId) {
    return ChannelMessagesProvider(channelId);
  }

  @override
  ChannelMessagesProvider getProviderOverride(
    covariant ChannelMessagesProvider provider,
  ) {
    return call(provider.channelId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'channelMessagesProvider';
}

/// See also [ChannelMessages].
class ChannelMessagesProvider
    extends
        AutoDisposeStreamNotifierProviderImpl<
          ChannelMessages,
          List<ChannelMessageEntity>
        > {
  /// See also [ChannelMessages].
  ChannelMessagesProvider(String channelId)
    : this._internal(
        () => ChannelMessages()..channelId = channelId,
        from: channelMessagesProvider,
        name: r'channelMessagesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$channelMessagesHash,
        dependencies: ChannelMessagesFamily._dependencies,
        allTransitiveDependencies:
            ChannelMessagesFamily._allTransitiveDependencies,
        channelId: channelId,
      );

  ChannelMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.channelId,
  }) : super.internal();

  final String channelId;

  @override
  Stream<List<ChannelMessageEntity>> runNotifierBuild(
    covariant ChannelMessages notifier,
  ) {
    return notifier.build(channelId);
  }

  @override
  Override overrideWith(ChannelMessages Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChannelMessagesProvider._internal(
        () => create()..channelId = channelId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        channelId: channelId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<
    ChannelMessages,
    List<ChannelMessageEntity>
  >
  createElement() {
    return _ChannelMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChannelMessagesProvider && other.channelId == channelId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, channelId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChannelMessagesRef
    on AutoDisposeStreamNotifierProviderRef<List<ChannelMessageEntity>> {
  /// The parameter `channelId` of this provider.
  String get channelId;
}

class _ChannelMessagesProviderElement
    extends
        AutoDisposeStreamNotifierProviderElement<
          ChannelMessages,
          List<ChannelMessageEntity>
        >
    with ChannelMessagesRef {
  _ChannelMessagesProviderElement(super.provider);

  @override
  String get channelId => (origin as ChannelMessagesProvider).channelId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
