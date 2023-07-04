import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../app/helper/shared_helper.dart';

part 'app_config_event.dart';
part 'app_config_state.dart';

class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  final AppShared appShared;
  AppConfigBloc({required this.appShared}) : super(const AppConfigState()) {
    on<GetInitialThemeEvent>(_getInitTheme);
    on<ToggleThemeEvent>(_toggleTheme);
  }

  FutureOr<void> _getInitTheme(
      GetInitialThemeEvent event, Emitter<AppConfigState> emit) {
    if (appShared.getVal('isDark') == null) {
      bool isDark = Theme.of(event.context).brightness == Brightness.dark;
      emit(
        state.copyWith(
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        ),
      );
    } else {
      bool isDark = appShared.getVal('isDark');
      emit(
        state.copyWith(
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        ),
      );
    }
  }

  FutureOr<void> _toggleTheme(
      ToggleThemeEvent event, Emitter<AppConfigState> emit) {
    appShared.setVal('isDark', event.isDark);
    emit(
      state.copyWith(
        themeMode: event.isDark ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
