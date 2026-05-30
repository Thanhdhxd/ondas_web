import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ondas_web/core/storage/secure_storage.dart';
import 'package:ondas_web/app/localization/locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final SecureStorage _storage;

  LocaleCubit(this._storage)
      : super(const LocaleState(Locale('vi', 'VN')));

  /// Gọi ngay sau khi khởi tạo để load locale đã lưu từ storage.
  Future<void> init() async {
    final saved = await _storage.getLocale();
    if (saved != null && saved.isNotEmpty) {
      emit(LocaleState(
        saved == 'en' ? const Locale('en', 'US') : const Locale('vi', 'VN'),
      ));
    }
  }

  /// Chuyển sang locale cụ thể và persist.
  Future<void> setLocale(Locale locale) async {
    await _storage.saveLocale(locale.languageCode);
    emit(LocaleState(locale));
  }

  /// Toggle giữa VI ↔ EN và persist.
  Future<void> toggle() => setLocale(
        state.isVietnamese
            ? const Locale('en', 'US')
            : const Locale('vi', 'VN'),
      );
}
