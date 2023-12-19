import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/common/widgets/custom_refresh_wrapper.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/usecases/get_orders_use_case.dart';
import '../controller/order_bloc.dart';
import '../widgets/order_item_widget.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    tabController = TabController(
      length: 2,
      vsync: this,
    )..addListener(
        () {
          if (tabController.indexIsChanging) {
            getPageContent();
          }
        },
      );
    getPageContent();
    super.initState();
  }

  getPageContent({int? start}) => sl<OrderBloc>().add(
        GetOrdersEvent(
          orderParmeters: OrderParmeters(
            orderType: tabController.index == 0
                ? OrderType.ongoing
                : OrderType.completed,
            start: start ?? 0,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.orders.tr(),
          ),
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: List.generate(
                  2,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppPadding.p10.h,
                    ),
                    child: CustomText(
                      data: index == 0
                          ? AppStrings.ongoing.tr()
                          : AppStrings.completed.tr(),
                      fontSize: AppSize.s17.sp,
                      textAlign: TextAlign.center,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) => CustomRefreshWrapper(
                    scrollController: scrollController,
                    refreshData: getPageContent,
                    onListen: () => getPageContent(
                      start: state.orders.length,
                    ),
                    builder: (context, properties) =>
                        state.getOrderListStatus == Status.initial
                            ? Center(
                                child: Lottie.asset(
                                  JsonAssets.loading,
                                  height: AppSize.s200,
                                  width: AppSize.s200,
                                ),
                              )
                            : ListView.separated(
                                controller: scrollController,
                                padding: const EdgeInsets.all(15),
                                itemCount: state.orders.length,
                                itemBuilder: (context, index) {
                                  var order = state.orders[index];
                                  return tabController.index == 0
                                      ? ClipRect(
                                          child: Banner(
                                            location: BannerLocation.topEnd,
                                            message: order.status.tr(),
                                            child: OrderItem(
                                              order: order,
                                            ),
                                          ),
                                        )
                                      : OrderItem(
                                          order: order,
                                          isCompleted: true,
                                        );
                                },
                                separatorBuilder: (_, __) => SizedBox(
                                  height: 15.h,
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
