import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';

import '../../../modules/sub/notification/presentation/controller/notification_bloc.dart';
import '../../utils/constants_manager.dart';

class CustomRefreshWrapper extends StatelessWidget {
  final ScrollController scrollController;
  final Function()? refreshData;
  final Function()? onListen;
  final Widget Function(
    BuildContext context,
    ScrollViewProperties properties,
  ) builder;
  final bool alwaysVisibleAtOffset;
  const CustomRefreshWrapper({
    Key? key,
    this.refreshData,
    required this.builder,
    this.onListen,
    required this.scrollController,
    this.alwaysVisibleAtOffset = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool arabic = context.locale == AppConstants.arabic;
    ThemeData theme = Theme.of(context);
    return ScrollEdgeListener(
      edge: ScrollEdge.end,
      edgeOffset: 100,
      continuous: false,
      debounce: const Duration(milliseconds: 500),
      dispatch: true,
      listener: onListen ?? () {},
      child: refreshData == null
          ? _customScrollWrapper(arabic, theme)
          : RefreshIndicator(
              color: theme.canvasColor,
              backgroundColor: theme.primaryColor,
              onRefresh: () {
                refreshData!();
                context.read<NotificationBloc>().add(
                      GetUnReadNotificationEvent(),
                    );
                return Future.value();
              },
              child: _customScrollWrapper(arabic, theme),
            ),
    );
  }

  ScrollWrapper _customScrollWrapper(bool arabic, ThemeData theme) =>
      ScrollWrapper(
        scrollController: scrollController,
        alwaysVisibleAtOffset: alwaysVisibleAtOffset,
        promptAlignment: arabic ? Alignment.bottomRight : Alignment.bottomLeft,
        scrollOffsetUntilVisible: 10,
        promptTheme: PromptButtonTheme(
          icon: Icon(
            Icons.arrow_upward,
            color: theme.canvasColor,
          ),
          color: theme.primaryColor,
        ),
        builder: builder,
      );
}
