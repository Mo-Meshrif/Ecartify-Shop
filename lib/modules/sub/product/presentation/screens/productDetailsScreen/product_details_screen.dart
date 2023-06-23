import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../app/helper/enums.dart';
import '../../../../../../app/utils/strings_manager.dart';
import '../../../../../../app/utils/values_manager.dart';
import '../../../../../main/shop/presentation/controller/shop_bloc.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/update_product_use_case.dart';
import '../../controller/product_bloc.dart';
import 'components/add_to_cart_widget.dart';
import 'components/product_details_body.dart';
import 'components/product_details_header.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ScrollController _scrollController;
  bool showTitle = false;
  double kExpandedHeight = 400.h;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // executes after build
          setState(() {
            showTitle = _isSliverAppBarExpanded;
          });
        });
      });
  }

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state.updateProductStatus == Status.loaded) {
            context.read<ShopBloc>().add(
                  UpdateShopProductsEvent(
                    productParameters: ProductParameters(
                      product: state.productDetails!,
                    ),
                  ),
                );
          }
        },
        builder: (context, state) {
          Product? product = state.productDetails;
          return Scaffold(
            appBar: product == null ? AppBar() : null,
            body:
                product == null || state.productDetailsStatus == Status.loading
                    ? Center(
                        child: state.productDetailsStatus == Status.loading
                            ? const CircularProgressIndicator.adaptive()
                            : CustomText(
                                data: AppStrings.noDetails.tr(),
                                fontSize: AppSize.s20.sp,
                              ),
                      )
                    : NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder: (context, innerBoxIsScrolled) => [
                          //image ,favourite and share
                          ProductDetailsHeader(
                            product: product,
                            kExpandedHeight: kExpandedHeight,
                            showTitle: showTitle,
                          ),
                        ],
                        body: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: ProductDetailsBody(
                                  showTitle: showTitle,
                                  product: product,
                                ),
                              ),
                            ),
                            const AddToCartWidget(),
                          ],
                        ),
                      ),
          );
        },
      );
}
