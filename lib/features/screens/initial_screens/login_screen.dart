import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/constants.dart';
import 'package:tetco_attendance/constants/images_paths.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/main_home_screen.dart';
import 'package:tetco_attendance/helpers/direction_helper.dart';
import 'package:tetco_attendance/helpers/helpers.dart';
import 'package:tetco_attendance/helpers/orientation_helper.dart';
import 'package:tetco_attendance/packages/toast_package/toast_package.dart';
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
  late ValueNotifier<bool> showPass;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    lockPortrait();
    emailController = TextEditingController(text: 'amir@gmail.com');
    passController = TextEditingController(text: 'password');
    showPass = ValueNotifier<bool>(false);
    formKey = GlobalKey();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    showPass.dispose();
    formKey.currentState?.dispose();
    releaseOrientationLock();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              physics: Constants.bouncingScrollPhysics,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: getMediaQueryWidth(context),
                    height: getMediaQueryHeight(context, 0.5),
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
                              height: sizeConstants.imageLarge,
                              boxFit: BoxFit.cover,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.hi,
                                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: kWhiteColor),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.waving_hand_rounded, color: kOrangeAccentColor),
                                SizedBox(width: 10),
                                Text(
                                  AppLocalizations.of(context)!.welcome,
                                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: kWhiteColor),
                                ),
                              ],
                            ),
                            SizedBox(height: sizeConstants.spacing12),
                            Text(
                              AppLocalizations.of(context)!.pleaseLoginBeforeContinue,
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
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: getMediaQueryHeight(context, 0.1)),
                        ValueListenableBuilder(
                          valueListenable: emailController,
                          builder: (context, email, child) {
                            return CustomTextFormField(
                              textInputType: TextInputType.emailAddress,
                              controller: emailController,
                              labelText: AppLocalizations.of(context)!.emailAddress,
                              suffixIcon: Icon(Icons.email_outlined, color: kPrimaryColor),
                              onChanged: (value) {},
                              hintText: AppLocalizations.of(context)!.enterEmailAddress,
                              showClearBtn: emailController.text.isNotEmpty,
                              onClearTap: () {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.thisFieldIsRequired;
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        SizedBox(height: sizeConstants.spacing12),
                        ValueListenableBuilder(
                          valueListenable: showPass,
                          builder: (context, showPasss, child) {
                            return ValueListenableBuilder(
                              valueListenable: passController,
                              builder: (context, password, child) {
                                return CustomTextFormField(
                                  controller: passController,
                                  labelText: AppLocalizations.of(context)!.password,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      try {
                                        showPass.value = !showPass.value;
                                      } catch (_) {}
                                    },
                                    child: Icon(showPasss ? Icons.lock_open_rounded : Icons.lock_outline_rounded, color: kPrimaryColor),
                                  ),
                                  onChanged: (value) {},
                                  hintText: AppLocalizations.of(context)!.enterPassword,
                                  showClearBtn: password.text.isNotEmpty,
                                  hideValue: !showPasss,
                                  onClearTap: () {},

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!.thisFieldIsRequired;
                                    }
                                    return null;
                                  },
                                );
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
                                onPressed: () {
                                  try {
                                    if (formKey.currentState!.validate()) {
                                      context.go(MainHomeScreen.id);
                                    } else {
                                      Helpers.hapticFeedback();
                                      ToastPackage.showWarningToast(
                                        message: AppLocalizations.of(context)!.pleaseFillAllRequiredFields,
                                        dragToClose: true,
                                        closeDuration: const Duration(seconds: 5),
                                        toastAlignment: Alignment.bottomCenter,
                                        showProgressBar: true,
                                      );
                                    }
                                  } catch (e) {}
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.login,
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
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Text(
              '© 2025 TETCO Labs. All rights reserved.',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(color: kBlackColor, fontFamily: 'Poppins'),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
    this.hideValue,
    this.showClearBtn = false,
    this.focusNode,
    this.textInputType,
  });

  final String? hintText;
  final Widget suffixIcon;
  final TextEditingController controller;
  final void Function(String value)? onChanged;
  final void Function(String value)? onFieldSubmitted;
  final String? Function(String? value)? validator;
  final String? labelText;
  final VoidCallback onClearTap;
  final bool? hideValue;
  final bool showClearBtn;
  final FocusNode? focusNode;
  final TextInputType? textInputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        obscureText: hideValue ?? false,
        keyboardType: textInputType,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: kPrimaryColor),
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kPrimaryColor.withAlpha(80), fontWeight: FontWeight.bold),
          suffixIcon: showClearBtn
              ? hideValue == null
                    ? GestureDetector(
                        onTap: onClearTap,
                        child: Icon(
                          Icons.clear,
                          color: kRedColor,
                        ),
                      )
                    : suffixIcon
              : suffixIcon,
        ),
      ),
    );
  }
}
