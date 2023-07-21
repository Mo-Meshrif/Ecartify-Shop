import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/common/widgets/custom_intrinsic_grid_view.dart';
import '../../../../../app/common/widgets/custom_refresh_wrapper.dart';
import '../../../../../app/common/widgets/custom_search_bar_widget.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/category.dart';
import '../controller/explore_bloc.dart';
import '../widgets/category_widget.dart';

class ExploreScreen extends StatefulWidget {
  final String? title;
  const ExploreScreen({Key? key, this.title}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();
  bool hasData = true;
  List<Category> items = [];
  Status status = Status.sleep;

  @override
  void initState() {
    getPageContent();
    super.initState();
  }

  getPageContent() {
    if (widget.title == null) {
      context.read<ExploreBloc>().add(GetCategoriesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          data: widget.title ?? AppStrings.findProds.tr(),
        ),
        actions: [
          Visibility(
            visible: widget.title != null,
            child: IconButton(
              onPressed: () {},
              splashRadius: AppSize.s30.r,
              icon: SvgPicture.asset(
                IconAssets.cart,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ExploreBloc, ExploreState>(
        builder: (context, state) => CustomRefreshWrapper(
            scrollController: scrollController,
            refreshData: widget.title != null ? null : getPageContent,
            builder: (context, properties) => CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.p15.w,
                          vertical: AppPadding.p5.h,
                        ),
                        child: Column(
                          children: [
                            const CustomSearchBarWidget(),
                            Expanded(
                              child: BlocConsumer<ExploreBloc, ExploreState>(
                                listener: (context, state) {
                                  if (widget.title == null) {
                                    items = state.cats;
                                    if (state.catStatus == Status.loaded) {
                                      if (items.isEmpty) {
                                        hasData = false;
                                        updateKeepAlive();
                                      }
                                    } else if (state.catStatus ==
                                        Status.error) {
                                      hasData = false;
                                      updateKeepAlive();
                                    }
                                  } else {
                                    items = state.subCats;
                                  }
                                },
                                builder: (context, state) {
                                  status = widget.title == null
                                      ? state.catStatus
                                      : state.subCatStatus;
                                  return status == Status.loading
                                      ? Center(
                                          child: Lottie.asset(
                                            JsonAssets.loading,
                                            height: AppSize.s200,
                                            width: AppSize.s200,
                                          ),
                                        )
                                      : items.isEmpty
                                          ? Center(
                                              child: Lottie.asset(
                                                  JsonAssets.empty),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: AppPadding.p10.h,
                                              ),
                                              child: CustomIntrinsicGridView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                direction: Axis.vertical,
                                                horizontalSpace: AppSize.s10.w,
                                                verticalSpace: AppSize.s10.h,
                                                children: List.generate(
                                                  items.length,
                                                  (index) => SizedBox(
                                                    width: 1.sw / 2,
                                                    child: CategoryWidget(
                                                      isParent:
                                                          widget.title == null,
                                                      category: items[index],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => hasData;
}
