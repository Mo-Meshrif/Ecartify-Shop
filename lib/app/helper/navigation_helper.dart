import 'package:flutter/material.dart';

class NavigationHelper {
  static push(BuildContext context, Route route) =>
      Navigator.of(context).push(route);

  static pushNamed(BuildContext context, String routeName, {arguments}) =>
      Navigator.of(context).pushNamed(
        routeName,
        arguments: arguments,
      );

  static pushReplacementNamed(BuildContext context, String routeName,
          {arguments}) =>
      Navigator.of(context).pushReplacementNamed(
        routeName,
        arguments: arguments,
      );

  static pushNamedAndRemoveUntil(BuildContext context, String routeName,
          bool Function(Route route) until,
          {arguments}) =>
      Navigator.of(context).pushNamedAndRemoveUntil(
        routeName,
        until,
        arguments: arguments,
      );

  static pop(BuildContext context) => Navigator.pop(context);
}