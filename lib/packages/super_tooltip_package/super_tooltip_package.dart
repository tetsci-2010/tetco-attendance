import 'package:flutter/cupertino.dart';
import 'package:super_tooltip/super_tooltip.dart';

class SuperTooltipPackage {
  static SuperTooltip showMsgTooltip(String message) {
    return SuperTooltip(content: Text(message));
  }
}
