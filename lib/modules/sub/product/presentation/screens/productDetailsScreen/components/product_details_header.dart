import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../../app/helper/dynamic_link_helper.dart';
import '../../../../../../../app/utils/assets_manager.dart';
import '../../../../../../../app/utils/color_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';
import '../../../../domain/entities/product.dart';

class ProductDetailsHeader extends StatefulWidget {
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
  State<ProductDetailsHeader> createState() => _ProductDetailsHeaderState();
}

class _ProductDetailsHeaderState extends State<ProductDetailsHeader> {
  String dynamicLink = '';

  @override
  void initState() {
    DynamicLinkHelper().createDynamicLink(widget.product).then((value) {
      if (value.toString().isNotEmpty) {
        setState(() {
          dynamicLink = value.toString();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SliverAppBar(
      pinned: true,
      expandedHeight: widget.kExpandedHeight,
      title: widget.showTitle
          ? CustomText(
              data: widget.product.name,
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
                  imageUrl: widget.product.image,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -AppSize.s20.h,
            right: AppSize.s20.w,
            child: Visibility(
              visible: !widget.showTitle,
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
                    onTap: () => Share.share(dynamicLink),
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
