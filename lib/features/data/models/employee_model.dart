import 'package:flutter/material.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';

class EmployeeModel {
  final int id;
  final String name;
  final String fName;
  final AttStatusEnums? status;
  final String? nickName;
  final String? phone;
  final String? image;
  final String? description;
  final Color? imageHolderColor;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.fName,
    this.status,
    this.nickName,
    this.phone,
    this.image,
    this.description,
    this.imageHolderColor,
  });

  EmployeeModel copyWith({
    int? id,
    String? name,
    String? fName,
    AttStatusEnums? status,
    String? nickName,
    String? phone,
    String? image,
    String? description,
    Color? imageHolderColor,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fName: fName ?? this.fName,
      imageHolderColor: imageHolderColor ?? this.imageHolderColor,
      image: image ?? this.image,
      nickName: nickName ?? this.nickName,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      description: description ?? this.description,
    );
  }
}
