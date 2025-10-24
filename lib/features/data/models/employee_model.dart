import 'package:flutter/material.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';

class EmployeeModel {
  final int id;
  final String name;
  final String fName;
  final AttStatusEnums status;
  final String? nickName;
  final String? phone;
  final String? image;
  final String? description;
  final Color? imageHolderColor;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.fName,
    required this.status,
    this.nickName,
    this.phone,
    this.image,
    this.description,
    this.imageHolderColor,
  });
}
