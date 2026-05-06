// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/data/sources/auth_local_source.dart' as _i51;
import '../../features/auth/data/sources/auth_remote_source.dart' as _i164;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/channel/data/repositories/channel_repository_impl.dart'
    as _i346;
import '../../features/channel/data/repositories/moment_repository_impl.dart'
    as _i396;
import '../../features/channel/data/sources/channel_remote_source.dart'
    as _i279;
import '../../features/channel/domain/repositories/channel_repository.dart'
    as _i699;
import '../../features/channel/domain/repositories/moment_repository.dart'
    as _i669;
import '../../features/feed/data/repositories/feed_repository_impl.dart'
    as _i452;
import '../../features/feed/data/sources/feed_local_source.dart' as _i223;
import '../../features/feed/data/sources/feed_remote_source.dart' as _i507;
import '../../features/feed/domain/repositories/feed_repository.dart' as _i430;
import '../../features/media/data/repositories/media_repository_impl.dart'
    as _i110;
import '../../features/media/domain/repositories/media_repository.dart'
    as _i459;
import '../../features/media/domain/use_cases/compress_video.dart' as _i172;
import '../../posting/application/posting_service.dart' as _i858;
import '../db/chart_db.dart' as _i187;
import '../db/chart_native_db.dart' as _i435;
import '../native/chart_native_ffi.dart' as _i610;
import '../native/native_injectable.dart' as _i93;
import '../network/api_client.dart' as _i557;
import '../network/cloud_media_service.dart' as _i887;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final nativeModule = _$NativeModule();
    gh.factory<_i51.AuthLocalSource>(() => _i51.AuthLocalSource());
    gh.singleton<_i557.ApiClient>(() => _i557.ApiClient());
    gh.lazySingleton<_i187.ChartDatabase>(() => _i187.ChartDatabase());
    gh.lazySingleton<_i610.ChartNativeFFI>(() => nativeModule.nativeFFI);
    gh.lazySingleton<_i887.CloudMediaService>(() => _i887.CloudMediaService());
    gh.lazySingleton<_i279.ChannelRemoteSource>(
      () => _i279.ChannelRemoteSource(),
    );
    gh.factory<_i164.AuthRemoteSource>(
      () => _i164.AuthRemoteSource(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i435.ChartNativeDB>(
      () => _i435.ChartNativeDB(gh<_i187.ChartDatabase>()),
    );
    gh.lazySingleton<_i459.MediaRepository>(() => _i110.MediaRepositoryImpl());
    gh.lazySingleton<_i669.MomentRepository>(
      () => _i396.MomentRepositoryImpl(),
    );
    gh.factory<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i164.AuthRemoteSource>(),
        gh<_i51.AuthLocalSource>(),
      ),
    );
    gh.factory<_i172.CompressVideo>(
      () => _i172.CompressVideo(gh<_i459.MediaRepository>()),
    );
    gh.lazySingleton<_i699.ChannelRepository>(
      () => _i346.ChannelRepositoryImpl(gh<_i279.ChannelRemoteSource>()),
    );
    gh.factory<_i507.FeedRemoteSource>(
      () => _i507.FeedRemoteSource(gh<_i557.ApiClient>()),
    );
    gh.factory<_i223.FeedLocalSource>(
      () => _i223.FeedLocalSource(gh<_i435.ChartNativeDB>()),
    );
    gh.factory<_i430.FeedRepository>(
      () => _i452.FeedRepositoryImpl(
        gh<_i507.FeedRemoteSource>(),
        gh<_i223.FeedLocalSource>(),
      ),
    );
    gh.lazySingleton<_i858.PostingService>(
      () => _i858.PostingService(
        gh<_i430.FeedRepository>(),
        gh<_i887.CloudMediaService>(),
      ),
    );
    return this;
  }
}

class _$NativeModule extends _i93.NativeModule {}
