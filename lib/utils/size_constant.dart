import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Standard responsive size constants based on Material Design 3 spacing
/// and Flutter community conventions.
///
/// Call `ScreenUtilInit` in your app’s root widget (see usage below).
class SizeConstants {
  // Base Spacing (Material 3 standard spacing steps)
  double get spacing2 => 2.w;
  double get spacing4 => 4.w;
  double get spacing8 => 8.w;
  double get spacing12 => 12.w;
  double get spacing16 => 16.w;
  double get spacing20 => 20.w;
  double get spacing24 => 24.w;
  double get spacing32 => 32.w;
  double get spacing40 => 40.w;
  double get spacing48 => 48.w;
  double get spacing56 => 56.w;
  double get spacing64 => 64.w;

  // Font Sizes (typography scale)
  double get fontXS => 10.sp;
  double get fontS => 12.sp;
  double get fontM => 14.sp;
  double get fontL => 16.sp;
  double get fontXL => 20.sp;
  double get fontXXL => 24.sp;
  double get fontXXXL => 32.sp;

  // Icon Sizes
  double get iconS => 16.w;
  double get iconM => 24.w;
  double get iconL => 32.w;
  double get iconXL => 48.w;

  // Border Radius (M3 rounding standard)
  double get radiusSmall => 4.r;
  double get radiusMedium => 8.r;
  double get radiusLarge => 16.r;
  double get radiusXLarge => 28.r;

  // Common widget heights
  double get buttonHeight => 48.h;
  double get inputHeight => 56.h;

  // Screen-aware helpers
  double get screenWidth => 1.sw;
  double get screenHeight => 1.sh;
}

SizeConstants sizeConstants = SizeConstants();
