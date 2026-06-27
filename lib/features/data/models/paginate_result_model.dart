import 'package:cloud_firestore/cloud_firestore.dart';

class PaginateResult<T> {
  final List<T> items;
  final QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc;

  const PaginateResult({
    required this.items,
    required this.lastDoc,
  });
}
