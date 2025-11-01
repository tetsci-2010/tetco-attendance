import 'package:flutter/material.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    this.suffix,
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
    this.isRequired = false,
    this.isDescription = false,
    this.suffixIcon,
  });

  final String? hintText;
  final Widget? suffix;
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
  final bool isRequired;
  final bool isDescription;
  final IconData? suffixIcon;
  final TextInputAction normalInputAction = TextInputAction.done;
  final TextInputAction descInputAction = TextInputAction.newline;

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
        textInputAction: isDescription ? descInputAction : normalInputAction,
        maxLines: isDescription ? 6 : 1,
        decoration: InputDecoration(
          hintText: hintText,
          labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
          label: isRequired
              ? RichText(
                  locale: Localizations.localeOf(context),
                  textDirection: TextDirection.ltr,
                  text: TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red),
                    children: [
                      TextSpan(
                        text: ' $labelText',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                )
              : labelText != null
              ? Text(
                  labelText!,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
                )
              : null,
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
                    : suffixIcon != null
                    ? Icon(suffixIcon, color: Theme.of(context).primaryColor)
                    : suffix
              : suffixIcon != null
              ? Icon(suffixIcon, color: Theme.of(context).primaryColor)
              : suffix,
        ),
      ),
    );
  }
}
