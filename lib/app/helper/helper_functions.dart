import 'dart:io';
import 'dart:math' as math;

import 'package:dbcrypt/dbcrypt.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../modules/main/auth/domain/entities/user.dart';
import '../../modules/main/cart/domain/entities/cart_item.dart';
import '../../modules/main/favourite/presentation/controller/favourite_bloc.dart';
import '../../modules/main/shop/presentation/controller/shop_bloc.dart';
import '../../modules/sub/product/domain/entities/product.dart';
import '../../modules/sub/product/domain/usecases/update_product_use_case.dart';
import '../../modules/sub/product/presentation/controller/product_bloc.dart';
import '../../modules/sub/review/domain/entities/review.dart';
import '../../modules/sub/review/domain/usecases/add_review_use_case.dart';
import '../../modules/sub/review/presentation/controller/review_bloc.dart';
import '../common/models/alert_action_model.dart';
import '../common/widgets/custom_text.dart';
import '../common/widgets/digital_number.dart';
import '../services/services_locator.dart';
import '../utils/constants_manager.dart';
import '../utils/strings_manager.dart';
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
          duration: const Duration(seconds: AppConstants.durationInSec),
          content: Text(
            msg,
            textAlign: TextAlign.center,
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
  static showPopUpLoading(BuildContext context) => showAlert(
        context: context,
        content: const SizedBox(
          height: AppSize.s80,
          child: Center(
            child: CircularProgressIndicator(),
          ),
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
  static AuthUser getSavedUser() {
    var savedData = sl<AppShared>().getVal(AppConstants.userKey);
    return savedData is Map
        ? AuthUser(
            id: savedData['id'],
            name: savedData['name'],
            email: savedData['email'],
            password: savedData['password'],
            pic: savedData['pic'],
            deviceToken: savedData['deviceToken'],
          )
        : savedData;
  }

  //getLastUserName
  static String lastUserName() {
    AuthUser user = getSavedUser();
    return user.name.split(' ').last;
  }

  //get welcome string
  static String welcome() {
    String mark = DateTime.now().toHourMark();
    return mark;
  }

  //add review sheet
  static addReview(BuildContext context, Product product, AuthUser user,
      {bool fromDetails = false}) {
    double rateVal = 0.0;
    String title = '', review = '';
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
              : StatefulBuilder(
                  builder: (context, setState) => Column(
                    children: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => NavigationHelper.pop(context),
                            child: CustomText(
                              data: AppStrings.cancel.tr(),
                              fontSize: 20.sp,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: CustomText(
                                data: AppStrings.writeReview.tr(),
                                fontSize: 25.sp,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.read<ReviewBloc>().add(
                                  AddReviewEvent(
                                    addReviewParameters: AddReviewParameters(
                                      productId: product.id,
                                      rateVal: rateVal,
                                      title: title,
                                      review: review,
                                      userId: user.id,
                                      userName: user.name,
                                    ),
                                  ),
                                ),
                            child: CustomText(
                              data: AppStrings.send.tr(),
                              fontSize: 20.sp,
                            ),
                          ),
                        ],
                      ),
                      RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 20,
                        itemPadding: EdgeInsets.symmetric(horizontal: 8.w),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) => setState(
                          () => rateVal = rating,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      CustomText(
                        data: AppStrings.tapStar.tr(),
                        fontSize: 15.sp,
                      ),
                      const Divider(),
                      TextFormField(
                        onChanged: (value) => setState(() => title = value),
                        decoration: InputDecoration(
                          hintText: AppStrings.title.tr(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 5.h),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                        ),
                      ),
                      const Divider(),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,
                          expands: true,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) => setState(() => review = value),
                          decoration: InputDecoration(
                            hintText: AppStrings.review.tr() +
                                ' ' +
                                '(' +
                                AppStrings.optional.tr() +
                                ')',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 5.h),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

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
}
