import 'dart:async';

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

class SearchfieldPackage<T> extends StatelessWidget {
  final List<SearchFieldListItem<T>> suggestions;
  final String? hint;
  final VoidCallback onCloseTap;
  final FutureOr<List<SearchFieldListItem<T>>>? Function(String value)? onSearchTextChanged;
  final TextEditingController controller;
  const SearchfieldPackage({
    super.key,
    required this.suggestions,
    this.hint,
    required this.onCloseTap,
    this.onSearchTextChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing12, vertical: sizeConstants.spacing8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SearchField(
              controller: controller,
              suggestions: suggestions,
              searchInputDecoration: SearchInputDecoration(
                hint: hint != null ? Text(hint!) : null,
              ),
              onSearchTextChanged: onSearchTextChanged,
            ),
          ),
          SizedBox(width: sizeConstants.spacing8),
          GestureDetector(
            onTap: onCloseTap,
            child: Container(
              width: sizeConstants.iconLarge,
              height: sizeConstants.iconLarge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sizeConstants.radiusSmall),
                color: kRedColor.withAlpha(100),
              ),
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
