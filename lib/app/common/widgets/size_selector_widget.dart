import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/values_manager.dart';
import 'custom_text.dart';

class SizeSelectorWidget extends StatefulWidget {
  final List<String> sizeList;
  final String? selectedSize;
  final void Function(String size) getSelectedSize;
  const SizeSelectorWidget({
    Key? key,
    required this.sizeList,
    required this.getSelectedSize,
    this.selectedSize,
  }) : super(key: key);

  @override
  State<SizeSelectorWidget> createState() => _SizeSelectorWidgetState();
}

class _SizeSelectorWidgetState extends State<SizeSelectorWidget> {
  int selectedSizeIndex = 0;
  @override
  Widget build(BuildContext context) => SizedBox(
        height: AppSize.s30,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: widget.sizeList.length,
          itemBuilder: (context, index) {
            bool isMark = widget.selectedSize != null
                ? widget.selectedSize == widget.sizeList[index]
                : index == selectedSizeIndex;
            return GestureDetector(
              onTap: () {
                setState(
                  () => selectedSizeIndex = index,
                );
                widget.getSelectedSize(widget.sizeList[index]);
              },
              child: isMark
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppSize.s10.r,
                      ),
                      child: Banner(
                        message: '',
                        location: BannerLocation.bottomEnd,
                        child: _itemSizeWidget(
                          context,
                          widget.sizeList[index],
                        ),
                      ),
                    )
                  : _itemSizeWidget(
                      context,
                      widget.sizeList[index],
                    ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(width: 10.w),
        ),
      );

  Widget _itemSizeWidget(BuildContext context, String data) => Container(
        width: AppSize.s30,
        alignment: Alignment.center,
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
