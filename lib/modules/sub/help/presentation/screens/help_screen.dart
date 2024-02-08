import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../main/auth/presentation/widgets/custom_or_divider.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController(),
      email = TextEditingController(),
      message = TextEditingController();

  List<String> socialList = [
    'facebook',
    'linkedin',
    'whatsapp',
  ];

  _sendMessage() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      //TODO sendMessage 
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(data: AppStrings.help.tr()),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 20.h,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      value!.isEmpty ? AppStrings.enterName.tr() : null,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: AppStrings.username.tr(),
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: email,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value!.isEmpty
                      ? AppStrings.email.tr()
                      : !HelperFunctions.isEmailValid(value)
                          ? AppStrings.invaildEmail.tr()
                          : null,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: AppStrings.email.tr(),
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: message,
                  maxLines: 5,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  onFieldSubmitted: (_) => _sendMessage(),
                  validator: (value) =>
                      value!.isEmpty ? AppStrings.messageContent.tr() : null,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: AppStrings.messageContent.tr(),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomElevatedButton(
                  width: AppSize.s1.sw,
                  padding: EdgeInsets.symmetric(vertical: AppPadding.p15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15.r,
                    ),
                  ),
                  onPressed: _sendMessage,
                  child: CustomText(
                    data: AppStrings.send.tr(),
                    fontSize: 18.sp,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
                SizedBox(height: 20.h),
                CustomOrDivider(
                  text: AppStrings.or.tr(),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    socialList.length,
                    (index) => InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        //TODO toSocial
                      },
                      child: Image.asset(
                        'assets/images/${socialList[index]}.png',
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
