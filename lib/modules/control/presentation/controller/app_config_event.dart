part of 'app_config_bloc.dart';

abstract class AppConfigEvent extends Equatable {
  const AppConfigEvent();

  @override
  List<Object> get props => [];
}

class GetInitialThemeEvent extends AppConfigEvent {
  final BuildContext context;
  const GetInitialThemeEvent(this.context);
}

class ToggleThemeEvent extends AppConfigEvent {
  final bool isDark;
  const ToggleThemeEvent(this.isDark);
}
