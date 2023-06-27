import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/common/widgets/image_builder.dart';
import '../../../../../app/common/widgets/skeleton.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../sub/product/domain/usecases/get_product_details_use_case.dart';
import '../../../../sub/product/presentation/controller/product_bloc.dart';
import '../../domain/entities/slider_banner.dart';
import '../controller/shop_bloc.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({Key? key}) : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        bool isLoading = state.bestSellerProdStatus == Status.loading ||
            state.bestSellerProdStatus == Status.sleep;
        return isLoading
            ? Padding(
                padding: EdgeInsets.only(
                  top: AppPadding.p15.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(
                      height: AppSize.s250.h,
                      borderRadius: BorderRadius.circular(AppSize.s15.r),
                    ),
                    SizedBox(height: AppSize.s10.h),
                    Skeleton(
                      height: AppSize.s5.h,
                      width: AppSize.s60.w,
                      borderRadius: BorderRadius.circular(AppSize.s5.r),
                    ),
                  ],
                ),
              )
            : Visibility(
                visible: state.sliderBanners.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: AppPadding.p15.h,
                  ),
                  child: Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 1,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          initialPage: 0,
                          autoPlay: true,
                          onPageChanged: (index, _) => setState(
                            () => currentPage = index,
                          ),
                        ),
                        items: List.generate(
                          state.sliderBanners.length,
                          (index) {
                            SliderBanner slider = state.sliderBanners[index];
                            return GestureDetector(
                              onTap: () async {
                                if (slider.type == 'inner') {
                                  if (slider.urlType == 'product') {
                                    context.read<ProductBloc>().add(
                                          GetProductDetailsEvent(
                                            productDetailsParmeters:
                                                ProductDetailsParmeters(
                                              productId: slider.url,
                                            ),
                                          ),
                                        );
                                    NavigationHelper.pushNamed(
                                      context,
                                      Routes.productDetailsRoute,
                                    );
                                  }
                                } else {
                                  String url = slider.urlType == 'whatsApp'
                                      ? 'https://wa.me/20' '${slider.url}'
                                      : slider.url;
                                  Uri uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(
                                      uri,
                                      mode: Platform.isIOS
                                          ? LaunchMode.platformDefault
                                          : LaunchMode
                                              .externalNonBrowserApplication,
                                    );
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorManager.kGrey.withOpacity(0.3),
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s15.r),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s15.r),
                                  child: ImageBuilder(
                                    imageUrl: slider.image,
                                    width: 1.sw,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: AppSize.s10.h),
                      Row(
                        children: List.generate(
                          state.sliderBanners.length,
                          (x) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(
                              right: AppPadding.p5,
                            ),
                            height: 3,
                            width: AppSize.s60.w,
                            decoration: BoxDecoration(
                              color: currentPage >= x
                                  ? primaryColor
                                  : Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(AppSize.s3),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }
}
