import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/shared_helper.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class RecentSearchedWords extends StatefulWidget {
  final List<String> recentSearchedWords;
  final void Function(String) onTapRecentVal;
  const RecentSearchedWords({
    Key? key,
    required this.recentSearchedWords,
    required this.onTapRecentVal,
  }) : super(key: key);

  @override
  State<RecentSearchedWords> createState() => _RecentSearchedWordsState();
}

class _RecentSearchedWordsState extends State<RecentSearchedWords> {
  AppShared appShared = sl<AppShared>();
  @override
  Widget build(BuildContext context) => widget.recentSearchedWords.isEmpty
      ? Center(
          child: CustomText(
            data: AppStrings.noRecentSearch.tr(),
            fontSize: AppSize.s20.sp,
          ),
        )
      : Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p10.w,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.p10.h,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        data: AppStrings.recent.tr(),
                        fontSize: AppSize.s20.sp,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          appShared.removeVal(AppConstants.recentSearchedKey);
                          widget.recentSearchedWords.clear();
                        });
                      },
                      child: CustomText(
                        data: AppStrings.clearAll.tr(),
                        fontSize: AppSize.s20.sp,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Column(
                children: widget.recentSearchedWords
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppPadding.p10.h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => widget.onTapRecentVal(e),
                                child: CustomText(
                                  data: e,
                                  fontSize: AppSize.s20.sp,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    widget.recentSearchedWords.remove(e);
                                    appShared.setVal(
                                      AppConstants.recentSearchedKey,
                                      widget.recentSearchedWords,
                                    );
                                  },
                                );
                              },
                              child: CircleAvatar(
                                radius: AppSize.s16.r,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Icon(
                                  Icons.close,
                                  color: Theme.of(context).canvasColor,
                                  size: AppSize.s20,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        );
}
