import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../../app/common/widgets/custom_count_down_timer.dart';
import '../../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../../app/common/widgets/image_builder.dart';
import '../../../../../../../app/helper/dynamic_link_helper.dart';
import '../../../../../../../app/helper/helper_functions.dart';
import '../../../../../../../app/services/services_locator.dart';
import '../../../../../../../app/utils/assets_manager.dart';
import '../../../../../../../app/utils/color_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';
import '../../../../../../main/cart/presentation/controller/cart_bloc.dart';
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
  late DateTime? date = widget.product.offerEndDate?.add(
    const Duration(days: 1),
  );
  late ThemeData theme = Theme.of(context);
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
  Widget build(BuildContext context) => SliverAppBar(
        pinned: true,
        expandedHeight: widget.kExpandedHeight,
        title: widget.showTitle
            ? CustomText(
                data: widget.product.name,
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
                  child: ImageBuilder(
                    imageUrl: widget.product.image,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -AppSize.s20.h,
              right: AppSize.s20.w,
              left: AppSize.s20.w,
              child: Visibility(
                visible: !widget.showTitle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: date != null,
                      child: Container(
                        margin: EdgeInsets.only(top: AppPadding.p10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.s10.r),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: CustomCountdownTimer(
                          date: date,
                          padding: const EdgeInsets.all(AppSize.s8),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            int index = state.cartItems.indexWhere(
                              (e) => e.prodId == widget.product.id,
                            );
                            return index > -1
                                ? GestureDetector(
                                    onTap: () => sl<CartBloc>().add(
                                      DeleteItemEvent(
                                        prodId: widget.product.id,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: theme.primaryColor,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: AppPadding.p5.h,
                                        ),
                                        child: SvgPicture.asset(
                                          IconAssets.cart,
                                          color: ColorManager.kRed,
                                        ),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => HelperFunctions.handleFavFun(
                                      context,
                                      widget.product,
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: theme.primaryColor,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: AppPadding.p5.h,
                                        ),
                                        child: SvgPicture.asset(
                                          IconAssets.favourite,
                                          color: widget.product.isFavourite
                                              ? ColorManager.kRed
                                              : theme.canvasColor,
                                        ),
                                      ),
                                    ),
                                  );
                          },
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
                  ],
                ),
              ),
            )
          ],
        ),
      );
}
