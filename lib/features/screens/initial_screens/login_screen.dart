import 'package:flutter/material.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/constants.dart';
import 'package:tetco_attendance/constants/images_paths.dart';
import 'package:tetco_attendance/helpers/direction_helper.dart';
import 'package:tetco_attendance/utils/my_media_query.dart';
import 'package:tetco_attendance/utils/size_constant.dart';
import 'package:tetco_attendance/widgets/lottie_widget.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login_screen';
  static const String name = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: Constants.bouncingScrollPhysics,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: getMediaQueryWidth(context),
              height: getMediaQueryHeight(context, 0.4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(sizeConstants.radiusXLarge),
                  bottomRight: Radius.circular(sizeConstants.radiusXLarge),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0D47A1), // Dark Blue
                    Color(0xFF1565C0), // Medium Dark Blue
                    Color(0xFF00838F), // Dark Teal
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: Constants.bouncingScrollPhysics,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LottieWidget(
                        lottieImage: ImagesPaths.loginJson,
                        repeat: false,
                        height: sizeConstants.imageLarge,
                        boxFit: BoxFit.cover,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('سلام', style: Theme.of(context).textTheme.headlineLarge),
                          SizedBox(width: 5),
                          Icon(Icons.waving_hand_rounded, color: kOrangeAccentColor),
                          SizedBox(width: 10),
                          Text('خوش آمدید!', style: Theme.of(context).textTheme.headlineLarge),
                        ],
                      ),
                      SizedBox(height: sizeConstants.spacing12),
                      Text(
                        'لطفا برای ادامه وارد حساب خود شوید',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(color: kWhiteColor, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: sizeConstants.spacing20),
                    ],
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                Form(
                  child: Column(
                    children: [
                      SizedBox(height: getMediaQueryHeight(context, 0.1)),
                      ValueListenableBuilder(
                        valueListenable: emailController,
                        builder: (context, email, child) {
                          return CustomTextFormField(
                            controller: emailController,
                            labelText: 'ایمیل آدرس',
                            suffixIcon: Icon(Icons.email_outlined, color: kPrimaryColor),
                            onChanged: (value) {},
                            hintText: 'ایمیل را وارد کنید *',
                            showClearBtn: email.text.isNotEmpty,
                            onClearTap: () {},
                            validator: (value) {
                              return null;
                            },
                          );
                        },
                      ),
                      SizedBox(height: sizeConstants.spacing12),
                      ValueListenableBuilder(
                        valueListenable: passController,
                        builder: (context, password, child) {
                          return CustomTextFormField(
                            controller: passController,
                            labelText: 'رمز عبور',
                            suffixIcon: Icon(Icons.lock_outline_rounded, color: kPrimaryColor),
                            onChanged: (value) {},
                            hintText: 'رمز عبور را وارد کنید *',
                            showClearBtn: password.text.isNotEmpty,
                            onClearTap: () {},

                            validator: (value) {
                              return null;
                            },
                          );
                        },
                      ),
                      SizedBox(height: sizeConstants.spacing40),
                      Stack(
                        children: [
                          SizedBox(
                            width: getMediaQueryWidth(context, 0.9),
                            height: sizeConstants.buttonHeight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                                ),
                                overlayColor: kWhiteColor,
                                backgroundColor: kPrimaryColor,
                              ),
                              onPressed: () {},
                              child: Text(
                                'ورود',
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: kWhiteColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            top: 0,
                            right: isRTLDirection(context) ? sizeConstants.spacing16 : null,
                            left: isRTLDirection(context) ? null : sizeConstants.spacing16,
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: sizeConstants.iconS,
                              color: kWhiteColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 3,
                  left: 0,
                  right: 0,
                  child: Text(
                    '© 2025 TETCO Labs. All rights reserved.',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(color: kPrimaryColor),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    required this.suffixIcon,
    required this.controller,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.labelText,
    required this.onClearTap,
    this.hideValue = false,
    this.showClearBtn = false,
    this.focusNode,
  });

  final String? hintText;
  final Widget suffixIcon;
  final TextEditingController controller;
  final void Function(String value)? onChanged;
  final void Function(String value)? onFieldSubmitted;
  final String? Function(String? value)? validator;
  final String? labelText;
  final VoidCallback onClearTap;
  final bool hideValue;
  final bool showClearBtn;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16),
      child: TextFormField(
        focusNode: focusNode,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        obscureText: hideValue,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: kPrimaryColor),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kPrimaryColor.withAlpha(80), fontWeight: FontWeight.bold),
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
          suffixIcon: showClearBtn
              ? GestureDetector(
                  onTap: onClearTap,
                  child: Icon(
                    Icons.clear,
                    color: kRedColor,
                  ),
                )
              : suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
            borderSide: BorderSide(color: kSecondaryColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
            borderSide: BorderSide(color: kPrimaryColor),
          ),
        ),
      ),
    );
  }
}
