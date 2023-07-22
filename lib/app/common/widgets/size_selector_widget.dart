import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants_manager.dart';
import '../../utils/values_manager.dart';
import 'custom_text.dart';

class SizeSelectorWidget extends StatefulWidget {
  final List<String> sizeList;
  final void Function(String size) getSelectedSize;
  const SizeSelectorWidget({
    Key? key,
    required this.sizeList,
    required this.getSelectedSize,
  }) : super(key: key);

  @override
  State<SizeSelectorWidget> createState() => _SizeSelectorWidgetState();
}

class _SizeSelectorWidgetState extends State<SizeSelectorWidget> {
  late bool arabic = context.locale == AppConstants.arabic;
  int selectedSizeIndex = 0;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.sizeList.length,
          (index) => GestureDetector(
            onTap: () {
              setState(
                () => selectedSizeIndex = index,
              );
              widget.getSelectedSize(widget.sizeList[index]);
            },
            child: index == selectedSizeIndex
                ? ClipRect(
                    child: Banner(
                      message: '',
                      location: BannerLocation.bottomEnd,
                      child: _itemSizeWidget(
                        context,
                        arabic,
                        widget.sizeList[index],
                      ),
                    ),
                  )
                : _itemSizeWidget(
                    context,
                    arabic,
                    widget.sizeList[index],
                  ),
          ),
        ),
      ),
    );

  Widget _itemSizeWidget(BuildContext context, bool arabic, String data) =>
      Container(
        width: AppSize.s30,
        height: AppSize.s30,
        alignment: Alignment.center,
        margin: arabic
            ? EdgeInsets.only(left: AppPadding.p10.w)
            : EdgeInsets.only(right: AppPadding.p10.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(
            AppSize.s10.r,
          ),
        ),
        child: CustomText(data: data),
      );
}
