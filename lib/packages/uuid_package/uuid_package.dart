import 'package:uuid/uuid.dart';

class UuidPackage {
  static String generateNumber() {
    Uuid x = Uuid();
    return x.v1();
  }
}
