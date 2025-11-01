import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/constants.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/data/models/employee_model.dart';
import 'package:tetco_attendance/features/data/providers/employee_provider.dart';
import 'package:tetco_attendance/packages/image_picker_package/image_picker_package.dart';
import 'package:tetco_attendance/utils/dependency_injection.dart';
import 'package:tetco_attendance/utils/popup_helper.dart';
import 'package:tetco_attendance/utils/random_color.dart';
import 'package:tetco_attendance/utils/size_constant.dart';
import 'package:tetco_attendance/widgets/custom_form_field.dart';

class AddEmployeeModalBody extends StatefulWidget {
  const AddEmployeeModalBody({super.key});

  @override
  State<AddEmployeeModalBody> createState() => _AddEmployeeModalBodyState();
}

class _AddEmployeeModalBodyState extends State<AddEmployeeModalBody> {
  late TextEditingController nameController;
  late TextEditingController fNameController;
  late TextEditingController nicknameController;
  late TextEditingController phoneController;
  late TextEditingController descriptionController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    fNameController = TextEditingController();
    nicknameController = TextEditingController();
    phoneController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    fNameController.dispose();
    nicknameController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: Constants.bouncingScrollPhysics,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(sizeConstants.spacing8, sizeConstants.spacing8, sizeConstants.spacing8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.account_circle, color: Theme.of(context).primaryColor),
                          SizedBox(width: sizeConstants.spacing8),
                          Flexible(
                            child: Text(
                              AppLocalizations.of(context)!.newEmployee,
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: sizeConstants.spacing8),
                      Icon(Icons.add, color: Theme.of(context).primaryColor, size: sizeConstants.iconM),
                    ],
                  ),
                ),
                SizedBox(height: sizeConstants.spacing20),
                Selector<EmployeeProvider, String?>(
                  selector: (context, appProvider) => appProvider.pickedImage,
                  builder: (context, pickedImage, child) {
                    return GestureDetector(
                      onTap: () async {
                        try {
                          final image = await ImagePickerPackage.pickImage(context: context);
                          if (image != null) {
                            context.read<EmployeeProvider>().updatePickedImage(image.path);
                          }
                        } catch (_) {}
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: sizeConstants.cardStandardHeight,
                            height: sizeConstants.cardStandardHeight,
                            padding: EdgeInsets.all(sizeConstants.spacing2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).primaryColor),
                            ),
                            alignment: Alignment.center,
                            child: pickedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(1000),
                                    child: Image.file(
                                      height: sizeConstants.cardStandardHeight,
                                      width: sizeConstants.cardStandardHeight,
                                      File(pickedImage),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(Icons.add_a_photo_outlined, color: kGreyColor, size: sizeConstants.iconL),
                          ),
                          if (pickedImage != null)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () {
                                    try {
                                      context.read<EmployeeProvider>().clearPickedImage();
                                    } catch (_) {}
                                  },
                                  child: Icon(CupertinoIcons.clear_circled_solid, size: sizeConstants.iconM, color: kRedColor),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: sizeConstants.spacing20),
                CustomTextFormField(
                  controller: nameController,
                  onClearTap: () {
                    try {
                      nameController.clear();
                      context.read<EmployeeProvider>().clearEmpName();
                    } catch (_) {}
                  },
                  hintText: AppLocalizations.of(context)!.employeeName,
                  labelText: AppLocalizations.of(context)!.employeeName,
                  validator: (value) {
                    if (value == null) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    try {
                      if (value.isNotEmpty) {
                        context.read<EmployeeProvider>().updateEmpName(value.trim());
                      } else {
                        nameController.clear();
                        context.read<EmployeeProvider>().clearEmpName();
                      }
                    } catch (e) {}
                  },
                  isRequired: true,
                  suffixIcon: Icons.account_circle_outlined,
                ),
                SizedBox(height: sizeConstants.spacing12),
                CustomTextFormField(
                  controller: fNameController,
                  onClearTap: () {
                    try {
                      fNameController.clear();
                      context.read<EmployeeProvider>().clearFName();
                    } catch (_) {}
                  },
                  hintText: AppLocalizations.of(context)!.fatherName,
                  labelText: AppLocalizations.of(context)!.fatherName,
                  onChanged: (value) {
                    try {
                      if (value.isNotEmpty) {
                        context.read<EmployeeProvider>().updateFName(value.trim());
                      } else {
                        fNameController.clear();
                        context.read<EmployeeProvider>().clearFName();
                      }
                    } catch (e) {}
                  },
                  validator: (value) {
                    if (value == null) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                  isRequired: true,
                  suffixIcon: Icons.supervisor_account_outlined,
                ),
                SizedBox(height: sizeConstants.spacing12),
                CustomTextFormField(
                  controller: nicknameController,
                  onClearTap: () {
                    try {
                      nicknameController.clear();
                      context.read<EmployeeProvider>().clearNickName();
                    } catch (_) {}
                  },
                  hintText: AppLocalizations.of(context)!.nickName,
                  labelText: AppLocalizations.of(context)!.nickName,
                  onChanged: (value) {
                    try {
                      if (value.isNotEmpty) {
                        context.read<EmployeeProvider>().updateNickName(value.trim());
                      } else {
                        nicknameController.clear();
                        context.read<EmployeeProvider>().clearNickName();
                      }
                    } catch (e) {}
                  },
                  suffixIcon: Icons.person_4_outlined,
                ),
                SizedBox(height: sizeConstants.spacing12),
                CustomTextFormField(
                  controller: phoneController,
                  onClearTap: () {
                    try {
                      phoneController.clear();
                      context.read<EmployeeProvider>().clearPhone();
                    } catch (_) {}
                  },
                  hintText: AppLocalizations.of(context)!.phoneNumber,
                  labelText: AppLocalizations.of(context)!.phoneNumber,
                  onChanged: (value) {
                    try {
                      if (value.isNotEmpty) {
                        context.read<EmployeeProvider>().updatePhone(value.trim());
                      } else {
                        phoneController.clear();
                        context.read<EmployeeProvider>().clearPhone();
                      }
                    } catch (e) {}
                  },
                  suffixIcon: Icons.phone_enabled_outlined,
                  textInputType: TextInputType.numberWithOptions(),
                ),
                SizedBox(height: sizeConstants.spacing12),
                CustomTextFormField(
                  controller: descriptionController,
                  onClearTap: () {
                    try {
                      descriptionController.clear();
                      context.read<EmployeeProvider>().clearDescription();
                    } catch (_) {}
                  },
                  hintText: AppLocalizations.of(context)!.description,
                  labelText: AppLocalizations.of(context)!.description,
                  onChanged: (value) {
                    try {
                      if (value.isNotEmpty) {
                        context.read<EmployeeProvider>().updateDescription(value.trim());
                      } else {
                        descriptionController.clear();
                        context.read<EmployeeProvider>().clearDescription();
                      }
                    } catch (e) {}
                  },
                  isDescription: true,
                  suffixIcon: Icons.description_outlined,
                ),
              ],
            ),
            SizedBox(height: sizeConstants.spacing12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomTextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kRedColor)),
                ),
                CustomTextButton(
                  onPressed: () {
                    try {
                      final id = di<EmployeeProvider>().employees.length;
                      final empProvider = context.read<EmployeeProvider>();
                      String? empName = empProvider.empName;
                      String? fName = empProvider.fName;
                      if (empName != null && fName != null) {
                        EmployeeModel employee = EmployeeModel(
                          id: id + 1,
                          name: empName,
                          fName: fName,
                          image: empProvider.pickedImage,
                          description: empProvider.description,
                          nickName: empProvider.nickname,
                          phone: empProvider.phone,
                          imageHolderColor: randomVibrantColorWithAlpha(),
                        );

                        List<EmployeeModel> emmss = List<EmployeeModel>.from(context.read<EmployeeProvider>().employees);
                        emmss.insert(0, employee);
                        context.read<EmployeeProvider>().updateEmployees(emmss);
                      }
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.submit, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kGreenColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
