import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../../app/utils/assets_manager.dart';
import '../../../../../../../app/utils/color_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';
import '../../../../domain/entities/product.dart';

class ProductDetailsHeader extends StatelessWidget {
  final Product product;
  final double kExpandedHeight;
  final bool showTitle;
  const ProductDetailsHeader(
      {Key? key,
      required this.kExpandedHeight,
      required this.showTitle,
      required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SliverAppBar(
      pinned: true,
      expandedHeight: kExpandedHeight,
      title: showTitle
          ? CustomText(
              data: product.name,
              color: theme.primaryColor,
            )
          : null,
      flexibleSpace: Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          FlexibleSpaceBar(
            background: SafeArea(
              child: Container(
                width: 1.sw,
                color: ColorManager.kGrey.withOpacity(0.3),
                child: CachedNetworkImage(
                  imageUrl: product.image,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -AppSize.s20.h,
            right: AppSize.s20.w,
            child: Visibility(
              visible: !showTitle,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      backgroundColor: theme.primaryColor,
                      child: Padding(
                        padding: EdgeInsets.only(top: AppPadding.p5.h),
                        child: SvgPicture.asset(
                          IconAssets.favourite,
                          color: theme.canvasColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.s10.w),
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      backgroundColor: theme.primaryColor,
                      child: Icon(
                        Icons.share,
                        color: theme.canvasColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
