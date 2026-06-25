import 'package:flutter/material.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.disable = false,
    this.hintText,
    this.suffix,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.labelText,
    this.onClearTap,
    this.hideValue,
    this.showClearBtn = false,
    this.focusNode,
    this.textInputType,
    this.isRequired = false,
    this.isDescription = false,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
  });

  final bool disable;
  final String? hintText;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;
  final void Function(String value)? onFieldSubmitted;
  final String? Function(String? value)? validator;
  final String? labelText;
  final VoidCallback? onClearTap;
  final bool? hideValue;
  final bool showClearBtn;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final bool isRequired;
  final bool isDescription;
  final Widget? suffix;
  final IconData? suffixIcon;
  final Widget? prefix;
  final IconData? prefixIcon;
  final TextInputAction normalInputAction = TextInputAction.done;
  final TextInputAction descInputAction = TextInputAction.newline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16),
      child: TextFormField(
        key: GlobalKey(),
        focusNode: focusNode,
        enabled: !disable,
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
          errorStyle: Theme.of(context).textTheme.titleSmall!.copyWith(color: kRedColor),
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
          prefix: prefix,
          prefixIconColor: Theme.of(context).primaryColor,
          prefixIcon: Icon(prefixIcon),
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
