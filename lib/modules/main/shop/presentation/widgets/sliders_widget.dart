import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/utils/values_manager.dart';

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
    return CarouselSlider(
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
        3,
        (index) => Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.s15.r),
              child: CachedNetworkImage(
                imageUrl:
                    'https://smartslider3.com/wp-content/uploads/2018/08/whatisaslider-1-780x410.png',
              ),
            ),
            Positioned(
              bottom: 0,
              child: Row(
                children: List.generate(
                  3,
                  (x) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: AppPadding.p5),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
