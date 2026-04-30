import 'package:injectable/injectable.dart';
import 'chart_native_ffi.dart';
import '../db/chart_native_db.dart';

@module
abstract class NativeModule {
  @lazySingleton
  ChartNativeFFI get nativeFFI => ChartNativeFFI();

  @lazySingleton
  ChartNativeDB get nativeDB => ChartNativeDB.instance;
}





























