import 'package:flutter/material.dart';

class CustomSlidingUpPanel extends StatefulWidget {
  final Widget pannel, body, collapsed;
  const CustomSlidingUpPanel({
    Key? key,
    required this.pannel,
    required this.body,
    required this.collapsed,
  }) : super(key: key);

  @override
  State<CustomSlidingUpPanel> createState() => _CustomSlidingUpPanelState();
}

class _CustomSlidingUpPanelState extends State<CustomSlidingUpPanel> {
  bool _showDetails = false;
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          widget.body,
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanUpdate: (details) => setState(
                () => _showDetails = details.delta.dy < 0,
              ),
              child: AnimatedCrossFade(
                firstChild: widget.collapsed,
                secondChild: widget.pannel,
                crossFadeState: _showDetails
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 100),
              ),
            ),
          )
        ],
      );
}
