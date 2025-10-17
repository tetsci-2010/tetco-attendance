import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatelessWidget {
  const LottieWidget({
    super.key,
    this.height,
    required this.lottieImage,
    this.repeat,
    this.reverse,
    this.boxFit,
  });
  final double? height;
  final String lottieImage;
  final bool? repeat;
  final bool? reverse;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      lottieImage,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('${error.toString()} - ${stackTrace}');
        return Icon(Icons.broken_image);
      },
      height: height,
      fit: boxFit,
      repeat: repeat,
      reverse: reverse,
    );
  }
}
