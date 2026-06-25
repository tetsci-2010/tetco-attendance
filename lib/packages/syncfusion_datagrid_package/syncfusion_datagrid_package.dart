import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SyncfusionDatagridPackage {
  static SfDataGrid syncfusionDataGrid({
    required DataGridSource dataGridSource,
    required List<GridColumn> columns,
    bool allowEditing = false,
    bool allowColumnsDragging = false,
    bool allowColumnsResizing = false,
    DataGridController? controller,
    Widget? footer,
    GridLinesVisibility? headerGridLinesVisibility,
    void Function(DataGridCellTapDetails details)? onCellTap,
    Widget? placeholder,
    int? rowsPerPage,
    double? headerRowHeight,
    bool Function(ColumnResizeUpdateDetails details)? onColumnResizeUpdate,
    bool allowPullToRefresh = true,
  }) {
    return SfDataGrid(
      headerRowHeight: headerRowHeight ?? 40,
      source: dataGridSource,
      columns: columns,
      allowPullToRefresh: allowPullToRefresh,
      allowEditing: allowEditing,
      allowColumnsDragging: allowColumnsDragging,
      allowColumnsResizing: allowColumnsResizing,
      columnResizeMode: ColumnResizeMode.onResize,
      // allowSwiping: true,
      verticalScrollPhysics: BouncingScrollPhysics(),
      horizontalScrollPhysics: BouncingScrollPhysics(),
      onColumnResizeUpdate: onColumnResizeUpdate,
      controller: controller,
      footer: footer,
      headerGridLinesVisibility: headerGridLinesVisibility ?? GridLinesVisibility.both,
      gridLinesVisibility: GridLinesVisibility.both,
      isScrollbarAlwaysShown: true,
      showVerticalScrollbar: true,
      onCellTap: onCellTap,
      placeholder: placeholder,
      showHorizontalScrollbar: true,
      rowsPerPage: rowsPerPage,
      showSortNumbers: true,
    );
  }
}
