import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/add_to_cart_widget.dart';
import 'components/product_details_body.dart';
import 'components/product_details_header.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  const ProductDetailsScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

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
        setState(() {
          showTitle = _isSliverAppBarExpanded;
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
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  //image ,favourite and share
                  ProductDetailsHeader(
                    kExpandedHeight: kExpandedHeight,
                    showTitle: showTitle,
                  ),
                  //product detals body
                  ProductDetailsBody(showTitle: showTitle)
                ],
              ),
            ),
            const AddToCartWidget(),
          ],
        ),
      );
}
