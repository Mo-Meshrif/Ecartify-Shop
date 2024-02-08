import 'dart:io';
import 'dart:math' as math;

import 'package:dbcrypt/dbcrypt.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../modules/main/auth/data/models/user_model.dart';
import '../../modules/main/auth/domain/entities/user.dart';
import '../../modules/main/cart/domain/entities/cart_item.dart';
import '../../modules/main/favourite/presentation/controller/favourite_bloc.dart';
import '../../modules/main/shop/presentation/controller/shop_bloc.dart';
import '../../modules/sub/order/domain/usecases/add_order_review_use_case.dart';
import '../../modules/sub/order/presentation/controller/order_bloc.dart';
import '../../modules/sub/product/domain/entities/product.dart';
import '../../modules/sub/product/domain/usecases/update_product_use_case.dart';
import '../../modules/sub/product/presentation/controller/product_bloc.dart';
import '../../modules/sub/review/domain/entities/review.dart';
import '../../modules/sub/review/domain/usecases/add_review_use_case.dart';
import '../../modules/sub/review/presentation/controller/review_bloc.dart';
import '../common/models/alert_action_model.dart';
import '../common/widgets/custom_text.dart';
import '../common/widgets/digital_number.dart';
import '../common/widgets/review_widget.dart';
import '../services/services_locator.dart';
import '../utils/constants_manager.dart';
import '../utils/values_manager.dart';
import 'enums.dart';
import 'extensions.dart';
import 'navigation_helper.dart';
import 'shared_helper.dart';

class HelperFunctions {
  //isEmailValid
  static bool isEmailValid(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  //encrptPassword
  static String encrptPassword(String password) => DBCrypt().hashpw(
        password,
        DBCrypt().gensalt(),
      );

  static bool checkPassword(String plaintext, String hashed) =>
      DBCrypt().checkpw(plaintext, hashed);

  //showSnackBar
  static showSnackBar(BuildContext context, String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).canvasColor,
          duration: const Duration(seconds: AppConstants.durationInSec),
          content: CustomText(
            data: msg,
            textAlign: TextAlign.center,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );

  //showAlert
  static showAlert(
      {required BuildContext context,
      String? title,
      required Widget content,
      List<AlertActionModel>? actions,
      bool forceAndroidStyle = false}) {
    Platform.isAndroid || forceAndroidStyle
        ? showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s10)),
              contentPadding: EdgeInsets.fromLTRB(
                24,
                title == null ? 20 : 10,
                24,
                5,
              ),
              title: title == null ? null : Text(title),
              content: content,
              actions: actions == null
                  ? []
                  : actions
                      .map((action) => TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: action.color,
                            ),
                            onPressed: action.onPressed,
                            child: Text(action.title),
                          ))
                      .toList(),
            ),
          )
        : showCupertinoDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: title == null ? null : Text(title),
              content: content,
              actions: actions == null
                  ? []
                  : actions
                      .map((action) => CupertinoDialogAction(
                            textStyle: TextStyle(
                              color: action.color,
                            ),
                            child: Text(action.title),
                            onPressed: action.onPressed,
                          ))
                      .toList(),
            ),
          );
  }

  //show popUp loading
  static showPopUpLoading(BuildContext context) => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

  //Rotate value
  static double rotateVal(BuildContext context, {bool rotate = true}) {
    if (rotate && context.locale == AppConstants.arabic) {
      return math.pi;
    } else {
      return math.pi * 2;
    }
  }

  //change language
  static toggleLanguage(BuildContext context) {
    if (context.locale == AppConstants.arabic) {
      context.setLocale(AppConstants.english);
    } else {
      context.setLocale(AppConstants.arabic);
    }
  }

  //getSavedUser
  static AuthUser? getSavedUser() {
    var savedData = sl<AppShared>().getVal(AppConstants.userKey);
    return savedData == null ? null : UserModel.fromJson(savedData);
  }

  //getLastUserName
  static String lastUserName() {
    AuthUser? user = getSavedUser();
    return user?.name.split(' ').last ?? '';
  }

  //get welcome string
  static String welcome() {
    String mark = DateTime.now().toHourMark();
    return mark;
  }

  //add review sheet
  static addProductReview(BuildContext context, Product product, AuthUser user,
      {bool fromDetails = false}) {
    double rateVal = 0.0;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      builder: (context) => BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state.addreviewStatus == Status.loaded) {
            NavigationHelper.pop(context);
            if (fromDetails) {
              context.read<ProductBloc>().add(
                    UpdateProductEvent(
                      productParameters: ProductParameters(
                        product: product.copyWith(
                          avRateValue: rateVal,
                        ),
                      ),
                    ),
                  );
            }
          }
        },
        builder: (context, state) => SizedBox(
          height: 1.sh * 0.75,
          child: state.addreviewStatus == Status.loading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : ReviewWidget(
                  onSend: (title, review, rate) {
                    rateVal = rate;
                    context.read<ReviewBloc>().add(
                          AddReviewEvent(
                            addReviewParameters: AddReviewParameters(
                              productId: product.id,
                              rateVal: rate,
                              title: title,
                              review: review,
                              userId: user.id,
                              userName: user.name,
                            ),
                          ),
                        );
                  },
                ),
        ),
      ),
    );
  }

  static addOrderReview(BuildContext context, String orderId) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
        ),
        builder: (context) => BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state.addOrderReviewStatus == Status.loaded) {
              NavigationHelper.pop(context);
            }
          },
          builder: (context, state) => SizedBox(
            height: 1.sh * 0.75,
            child: state.addOrderReviewStatus == Status.loading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : ReviewWidget(
                    showTitle: false,
                    onSend: (_, review, rate) {
                      context.read<OrderBloc>().add(
                            AddOrderReviewEvent(
                              orderReviewParameters: OrderReviewParameters(
                                orderId: orderId,
                                note: review,
                                rate: rate,
                              ),
                            ),
                          );
                    },
                  ),
          ),
        ),
      );

  //Get av rate
  static String getAvRate(List<Review> reviews) {
    if (reviews.isEmpty) {
      return '0.0';
    } else {
      double sum = 0.0;
      for (var i = 0; i < reviews.length; i++) {
        sum += reviews[i].rateVal;
      }
      return (sum / (reviews.length)).toString();
    }
  }

  //Get total rate of index
  static double rateRatioByIndex(List<Review> reviews, int index) {
    List<Review> tempList =
        reviews.where((element) => element.rateVal == index).toList();
    double sum = 0.0;
    for (var i = 0; i < tempList.length; i++) {
      sum += tempList[i].rateVal;
    }
    return sum == 0.0 ? 0.0 : (sum / (reviews.length * index)) * 100;
  }

  //convertToDigtial
  static Widget convertToDigtial(BuildContext context, String num) {
    bool arabic = context.locale == AppConstants.arabic;
    var checkNum = int.parse(num) < 10 ? '0$num' : num;
    var temp = arabic ? checkNum.split('').reversed : checkNum.split('');
    return Row(
      children: temp
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(right: 3),
              child: DigitalNumber(
                value: int.parse(e),
                height: 16,
                color: Colors.red,
              ),
            ),
          )
          .toList(),
    );
  }

  //Check isFavourite
  static bool checkIsFavourite(String id) {
    List temp = sl<AppShared>().getVal('Fav-key') ?? [];
    return temp.isEmpty
        ? false
        : temp.indexWhere((element) => element == id) > -1;
  }

  //handle favFun
  static void handleFavFun(BuildContext context, Product product) {
    FavouriteBloc favouriteBloc = context.read<FavouriteBloc>();
    if (product.isFavourite) {
      favouriteBloc.add(
        SetUnFavourite(prod: product),
      );
    } else {
      favouriteBloc.add(
        SetFavourite(prod: product),
      );
    }
    var tempProdPrameters = ProductParameters(
      isRemote: false,
      product: product.copyWith(
        isFavourite: !product.isFavourite,
      ),
    );
    context.read<ShopBloc>().add(
          UpdateShopProductsEvent(
            productParameters: tempProdPrameters,
          ),
        );
    context.read<ProductBloc>().add(
          UpdateProductEvent(
            productParameters: tempProdPrameters,
          ),
        );
  }

  //refactor cartItem length
  static int refactorCartItemLength(List<CartItem> items) {
    int count = 0;
    for (var item in items) {
      for (var element in item.statistics) {
        count += int.parse(element.quantity);
      }
    }
    return count;
  }

  //getTotalPriceOfCart
  static double getTotalPriceOfCart(List<CartItem> items) {
    double total = 0.0;
    for (var item in items) {
      if (item.product != null) {
        for (var element in item.statistics) {
          total +=
              int.parse(element.quantity) * double.parse(item.product!.price);
        }
      }
    }
    return total;
  }

  //getSelectedCurrency
  static String getSelectedCurrencyBase() {
    final AppShared appShared = sl<AppShared>();
    return appShared.getVal('currency-base') ?? 'USD';
  }

  //setCurrency
  static String setCurrencyBase(String currencyBase) {
    final AppShared appShared = sl<AppShared>();
    appShared.setVal(
      'currency-base',
      currencyBase,
    );
    AppConstants.currencyBase = currencyBase;
    return currencyBase;
  }

  //getSelectedCurrency
  static String getSelectedCurrencyRate() {
    final AppShared appShared = sl<AppShared>();
    return appShared.getVal('currency-rate') ?? '1';
  }

  //setCurrency
  static String setCurrencyRate(String currencyRate) {
    final AppShared appShared = sl<AppShared>();
    appShared.setVal(
      'currency-rate',
      currencyRate,
    );
    AppConstants.currencyRate = currencyRate;
    return currencyRate;
  }

  //getPriceAfterRate
  static String getPriceAfterRate(String originalPrice) {
    if (originalPrice.isEmpty) {
      return originalPrice;
    } else {
      String rate = AppConstants.currencyRate;
      double tempPrice = double.parse(originalPrice) * double.parse(rate);
      return tempPrice.toStringAsFixed(2);
    }
  }

  //getCurrencyMarkFromBase
  static String getCurrencyMark() => (AppConstants.currencyBase + '-S').tr();
}
