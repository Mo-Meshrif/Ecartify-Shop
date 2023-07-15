import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/models/filter_parameters.dart';
import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/product.dart';
import 'filter_item_widget.dart';

class ProductFilterWidget extends StatefulWidget {
  final List<Product> prods;
  final FilterParameters? filterParameters;
  final void Function(
    List<Product> filteredProds,
    FilterParameters? newParameters,
  ) onApply;
  const ProductFilterWidget({
    Key? key,
    required this.prods,
    this.filterParameters,
    required this.onApply,
  }) : super(key: key);

  @override
  State<ProductFilterWidget> createState() => _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends State<ProductFilterWidget> {
  List<String> categories = [];
  late RangeValues _priceRange;
  late FilterParameters selectedParameters;
  late var theme = Theme.of(context);

  @override
  void initState() {
    getFilterContent();
    super.initState();
  }

  getFilterContent() {
    categories = [
      ...{
        ...widget.prods
            .where((e) => e.catName.isNotEmpty)
            .map((e) => e.catName)
            .toList()
      }
    ];
    late Product min = widget.prods.reduce((curr, next) =>
        double.parse(curr.price) < double.parse(next.price) ? curr : next);
    late Product max = widget.prods.reduce((curr, next) =>
        double.parse(curr.price) > double.parse(next.price) ? curr : next);
    _priceRange = RangeValues(double.parse(min.price), double.parse(max.price));
    setState(() {
      if (widget.filterParameters == null) {
        selectedParameters = FilterParameters(
          category: '',
          priceRange: _priceRange,
          productSort: ProductSort.notDetermined,
          rate: 0,
        );
      } else {
        selectedParameters = widget.filterParameters!;
      }
    });
  }

  onApply() {
    if (selectedParameters.count > 0) {
      List<Product> filteredProds = widget.prods.where((element) {
        bool hasPass =
            double.parse(element.price) <= selectedParameters.priceRange.end &&
                    double.parse(element.price) >=
                        selectedParameters.priceRange.start &&
                    selectedParameters.rate == 0
                ? true
                : element.avRateValue.toInt() == selectedParameters.rate;
        return selectedParameters.category.isEmpty
            ? hasPass
            : element.catName == selectedParameters.category && hasPass;
      }).toList();
      if (selectedParameters.productSort != ProductSort.notDetermined) {
        filteredProds.sort(
          (a, b) => selectedParameters.productSort != ProductSort.hl
              ? double.parse(a.price).compareTo(
                  double.parse(b.price),
                )
              : double.parse(b.price).compareTo(
                  double.parse(a.price),
                ),
        );
      }
      widget.onApply(
        filteredProds,
        selectedParameters.copyWith(
          hasNewData: false,
        ),
      );
    } else {
      widget.onApply(
        [],
        null,
      );
    }
  }

  onRest() {
    setState(() {
      selectedParameters = FilterParameters(
        category: '',
        priceRange: _priceRange,
        productSort: ProductSort.notDetermined,
        rate: 0,
        hasNewData: widget.filterParameters != null,
      );
    });
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p15.w,
          vertical: AppPadding.p10.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CustomText(
                data: AppStrings.filters.tr(),
                fontSize: AppSize.s25.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Visibility(
              visible: categories.length > 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    data: AppStrings.categories.tr(),
                    fontSize: AppSize.s20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: AppSize.s10.w,
                          children: List.generate(
                            categories.length,
                            (index) => FilterItem(
                              theme: theme,
                              selected: selectedParameters.category ==
                                  categories[index],
                              data: categories[index],
                              onTap: () => setState(
                                () {
                                  if (selectedParameters.category ==
                                      categories[index]) {
                                    selectedParameters =
                                        selectedParameters.copyWith(
                                      count: selectedParameters.count - 1,
                                      category: '',
                                      hasNewData: true,
                                    );
                                  } else {
                                    selectedParameters =
                                        selectedParameters.copyWith(
                                      count:
                                          selectedParameters.category.isNotEmpty
                                              ? selectedParameters.count
                                              : selectedParameters.count + 1,
                                      category: categories[index],
                                      hasNewData: true,
                                    );
                                  }
                                  if (selectedParameters.count == 0) {
                                    onRest();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: selectedParameters.category.isNotEmpty,
                        child: IconButton(
                          onPressed: () {
                            setState(
                              () => selectedParameters =
                                  selectedParameters.copyWith(
                                count: selectedParameters.count - 1,
                                category: '',
                                hasNewData: true,
                              ),
                            );
                            if (selectedParameters.count == 0) {
                              onRest();
                            }
                          },
                          splashRadius: AppSize.s30.r,
                          icon: const Icon(Icons.restore),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomText(
              data: AppStrings.priceRange.tr(),
              fontSize: AppSize.s20.sp,
              fontWeight: FontWeight.bold,
            ),
            SliderTheme(
              data: const SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: RangeSlider(
                values: selectedParameters.priceRange,
                min: _priceRange.start,
                max: _priceRange.end,
                labels: RangeLabels(
                  selectedParameters.priceRange.start.toStringAsFixed(2),
                  selectedParameters.priceRange.end.toStringAsFixed(2),
                ),
                onChanged: (value) {
                  if (selectedParameters.priceRange != value) {
                    setState(() {
                      selectedParameters = selectedParameters.copyWith(
                        count: _priceRange == value
                            ? selectedParameters.count - 1
                            : selectedParameters.priceRange == _priceRange
                                ? selectedParameters.count + 1
                                : selectedParameters.count,
                        priceRange: value,
                        hasNewData: true,
                      );
                    });
                    if (selectedParameters.count == 0) {
                      onRest();
                    }
                  }
                },
              ),
            ),
            CustomText(
              data: AppStrings.sortBy.tr(),
              fontSize: AppSize.s20.sp,
              fontWeight: FontWeight.bold,
            ),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: AppSize.s10.w,
                    children: List.generate(
                      2,
                      (index) => FilterItem(
                        theme: theme,
                        selected:
                            selectedParameters.productSort == ProductSort.hl &&
                                    index == 0
                                ? true
                                : selectedParameters.productSort ==
                                        ProductSort.lh &&
                                    index == 1,
                        data: index == 0
                            ? AppStrings.priceHigh.tr()
                            : AppStrings.priceLow.tr(),
                        onTap: () {
                          var productSort =
                              index == 0 ? ProductSort.hl : ProductSort.lh;
                          setState(
                            () {
                              if (selectedParameters.productSort ==
                                  productSort) {
                                selectedParameters =
                                    selectedParameters.copyWith(
                                  count: selectedParameters.count - 1,
                                  productSort: ProductSort.notDetermined,
                                  hasNewData: true,
                                );
                              } else {
                                selectedParameters =
                                    selectedParameters.copyWith(
                                  count: selectedParameters.productSort !=
                                          ProductSort.notDetermined
                                      ? selectedParameters.count
                                      : selectedParameters.count + 1,
                                  productSort: productSort,
                                  hasNewData: true,
                                );
                              }
                              if (selectedParameters.count == 0) {
                                onRest();
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: selectedParameters.productSort !=
                      ProductSort.notDetermined,
                  child: IconButton(
                    onPressed: () {
                      setState(
                        () => selectedParameters = selectedParameters.copyWith(
                          count: selectedParameters.count - 1,
                          productSort: ProductSort.notDetermined,
                          hasNewData: true,
                        ),
                      );
                      if (selectedParameters.count == 0) {
                        onRest();
                      }
                    },
                    splashRadius: AppSize.s30.r,
                    icon: const Icon(Icons.restore),
                  ),
                ),
              ],
            ),
            CustomText(
              data: AppStrings.rating.tr(),
              fontSize: AppSize.s20.sp,
              fontWeight: FontWeight.bold,
            ),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: AppSize.s10.w,
                    children: List.generate(
                      5,
                      (index) => FilterItem(
                        isRating: true,
                        theme: theme,
                        selected: selectedParameters.rate == 5 - index,
                        data: '${5 - index}',
                        onTap: () => setState(
                          () {
                            if (selectedParameters.rate == 5 - index) {
                              selectedParameters = selectedParameters.copyWith(
                                count: selectedParameters.count - 1,
                                rate: 0,
                                hasNewData: true,
                              );
                            } else {
                              selectedParameters = selectedParameters.copyWith(
                                count: selectedParameters.rate != 0
                                    ? selectedParameters.count
                                    : selectedParameters.count + 1,
                                rate: 5 - index,
                                hasNewData: true,
                              );
                            }
                            if (selectedParameters.count == 0) {
                              onRest();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: selectedParameters.rate != 0,
                  child: IconButton(
                    onPressed: () {
                      setState(
                        () => selectedParameters = selectedParameters.copyWith(
                          count: selectedParameters.count - 1,
                          rate: 0,
                          hasNewData: true,
                        ),
                      );
                      if (selectedParameters.count == 0) {
                        onRest();
                      }
                    },
                    splashRadius: AppSize.s30.r,
                    icon: const Icon(Icons.restore),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.s10.h),
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    padding: EdgeInsets.symmetric(vertical: AppPadding.p15.h),
                    onPressed: selectedParameters.count == 0 ? null : onRest,
                    child: CustomText(
                      data: AppStrings.rest.tr(),
                    ),
                  ),
                ),
                SizedBox(width: AppSize.s10.w),
                Expanded(
                  child: CustomElevatedButton(
                    padding: EdgeInsets.symmetric(vertical: AppPadding.p15.h),
                    onPressed: !selectedParameters.hasNewData
                        ? null
                        : () {
                            NavigationHelper.pop(context);
                            onApply();
                          },
                    child: CustomText(
                      data: AppStrings.apply.tr(),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: AppSize.s20.h),
          ],
        ),
      );
}
