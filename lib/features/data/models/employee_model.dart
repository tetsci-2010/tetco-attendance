import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';

class EmployeeModel {
  final String id;
  final String name;
  final String fName;
  final AttStatusEnums? status;
  final String? nickName;
  final String? phone;
  final String? image;
  final String? description;
  final Color? imageHolderColor;
  final String? createdAt;
  final String? updatedAt;

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
    this.createdAt,
    this.updatedAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    Timestamp ca = json['created_at'];
    Timestamp ua = json['updated_at'];
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      fName: json['fName'],
      description: json['description'],
      nickName: json['nick_name'],
      phone: json['phone'],
      status: json['status'],
      createdAt: ca.toDate().toIso8601String(),
      updatedAt: ua.toDate().toIso8601String(),
    );
  }

  EmployeeModel copyWith({
    String? id,
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
