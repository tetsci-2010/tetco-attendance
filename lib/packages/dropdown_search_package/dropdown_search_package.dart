import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/utils/my_media_query.dart';
import 'package:tetco_attendance/utils/size_constant.dart';
import 'package:tetco_attendance/widgets/custom_text_field.dart';

class DropdownSearchPackage {
  static Widget dropdownSearch<T>({
    required BuildContext context,
    void Function(T? item)? onChanged,
    Widget Function(BuildContext context, T? item)? dropdownBuilder,
    bool enabled = true,
    String Function(T item)? itemAsString,
    Mode mode = Mode.form,
    T? selectedItem,
    String? Function(T? item)? validator,
    Widget Function(BuildContext context, T item, bool isDisabled, bool isSelected)? itemBuilder,
    FutureOr<List<T>> Function(String filter, LoadProps? loadProps)? items,
    bool showSearchBox = true,
    String? hintText,
  }) {
    try {
      return DropdownSearch<T>(
        compareFn: (item1, item2) => item1 == item2,
        decoratorProps: DropDownDecoratorProps(
          baseStyle: Theme.of(context).textTheme.bodySmall,
          decoration: InputDecoration(hintText: hintText),
        ),
        items: items,
        popupProps: PopupProps.menu(
          containerBuilder: (context, popupWidget) {
            return Container(
              decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
              child: popupWidget,
            );
          },
          showSearchBox: showSearchBox,
          emptyBuilder: (context, searchEntry) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search),
                  Text('جستجو کنید'),
                ],
              ),
            );
          },
          itemBuilder: itemBuilder,
          loadingBuilder: (context, searchEntry) {
            return Center(child: CircularProgressIndicator());
          },
        ),
        dropdownBuilder: dropdownBuilder,
        enabled: enabled,
        itemAsString: itemAsString,
        mode: mode,
        selectedItem: selectedItem,
        validator: validator,
      );
    } catch (e) {
      return SizedBox();
    }
  }

  static Widget multiDropdownSearch<T>({
    required BuildContext context,
    void Function(List<T>)? onChanged,
    Widget Function(BuildContext context, List<T> selectedItems)? dropdownBuilder,
    bool enabled = true,
    bool Function(T item1, T item2)? compareFn,
    String Function(T item)? itemAsString,
    Mode mode = Mode.form,
    Widget Function(BuildContext context, T item, bool isDisabled, bool isSelected)? itemBuilder,
    FutureOr<List<T>> Function(String filter, LoadProps? loadProps)? items,
    bool showSearchBox = true,
    List<T>? selectedItems,
    TextEditingController? controller,
    Widget? title,
    void Function(List<T> selectedItems, T addedItem)? onItemAdded,
    Key? key,
  }) {
    try {
      return DropdownSearch<T>.multiSelection(
        key: key,
        compareFn: compareFn,
        decoratorProps: DropDownDecoratorProps(
          baseStyle: Theme.of(context).textTheme.bodySmall,
          decoration: InputDecoration(suffixIcon: Icon(Icons.clear, color: kRedColor)),
        ),
        items: items,
        selectedItems: selectedItems ?? [],
        onSelected: onChanged,
        popupProps: MultiSelectionPopupProps.modalBottomSheet(
          onItemAdded: onItemAdded,
          searchFieldProps: TextFieldProps(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'جستجو کنید',
              suffixIcon: controller != null
                  ? ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (context, searchCont, child) {
                        return searchCont.text.isNotEmpty
                            ? ClearButton(
                                onClearTap: () {
                                  try {
                                    controller.clear();
                                  } catch (_) {}
                                },
                              )
                            : SizedBox.shrink();
                      },
                    )
                  : null,
            ),
          ),
          modalBottomSheetProps: ModalBottomSheetProps(
            constraints: BoxConstraints(maxHeight: getMediaQueryHeight(context, 0.9), minHeight: getMediaQueryHeight(context, 0.3)),
            showDragHandle: true,
            enableDrag: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(sizeConstants.radiusMedium),
                topRight: Radius.circular(sizeConstants.radiusMedium),
              ),
            ),
          ),
          constraints: BoxConstraints(maxHeight: getMediaQueryHeight(context, 0.8), minHeight: getMediaQueryHeight(context, 0.4)),
          title: title,
          errorBuilder: (context, searchEntry, exception) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('خطایی در هنگام بارگیری اطلاعات رخ داده است'),
                  Icon(Icons.error, color: kRedColor, size: sizeConstants.iconXL),
                ],
              ),
            );
          },
          emptyBuilder: (context, searchEntry) {
            return Center(child: Text('دیتایی وجود ندارد', style: Theme.of(context).textTheme.bodyMedium));
          },
          checkBoxBuilder: (context, item, isDisabled, isSelected) {
            return SizedBox();
          },
          showSearchBox: showSearchBox,
          itemBuilder: itemBuilder,
          searchDelay: const Duration(milliseconds: 500),
          showSelectedItems: true,
          textDirection: TextDirection.rtl,
        ),
        dropdownBuilder: dropdownBuilder,
        enabled: enabled,
        itemAsString: itemAsString,
        mode: mode,
      );
    } catch (e) {
      return SizedBox();
    }
  }
}
