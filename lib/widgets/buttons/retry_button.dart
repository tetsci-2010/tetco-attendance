import 'package:flutter/material.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

class RetryIcon extends StatelessWidget {
  const RetryIcon({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          SizedBox(height: sizeConstants.spacing12),
          InkWell(
            borderRadius: BorderRadius.circular(1000),
            onTap: onRetry,
            child: Container(
              padding: EdgeInsets.all(sizeConstants.spacing12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).iconTheme.color!),
              ),
              child: Icon(Icons.refresh_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
