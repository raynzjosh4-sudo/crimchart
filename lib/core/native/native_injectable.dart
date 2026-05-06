import 'package:injectable/injectable.dart';
import 'chart_native_ffi.dart';

@module
abstract class NativeModule {
  @lazySingleton
  ChartNativeFFI get nativeFFI => ChartNativeFFI();
}
