import 'package:flutter/material.dart';

class NoPaddingCheckbox extends StatelessWidget {
  final bool isMarked;
  final Function(bool newValue) onChange;
  final double size;

  const NoPaddingCheckbox({
    Key? key,
    required this.isMarked,
    required this.onChange,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: size, maxWidth: size),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Icon(_getIconData(), size: size),
        onPressed: () => onChange(!isMarked),
      ),
    );
  }

  IconData _getIconData() =>
      isMarked ? Icons.check_box : Icons.check_box_outline_blank;
}
