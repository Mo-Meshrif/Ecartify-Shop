part of 'app_config_bloc.dart';

class AppConfigState extends Equatable {
  final ThemeMode themeMode;

  const AppConfigState({
    this.themeMode = ThemeMode.system,
  });

  AppConfigState copyWith({
    ThemeMode? themeMode,
  }) =>
      AppConfigState(
        themeMode: themeMode ?? this.themeMode,
      );

  @override
  List<Object?> get props => [themeMode];
}
