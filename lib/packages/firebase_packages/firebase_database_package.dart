import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/features/data/models/paginate_result_model.dart';

class FirebaseFirestoreService {
  /// CREATE / INSERT
  static Future<void> create(String collectionPath, Map<String, dynamic> data, {String? id}) async {
    try {
      final FirebaseFirestore _db = FirebaseFirestore.instance;
      final ref = _db.collection(collectionPath);
      if (id == null) {
        await ref.add(data); // Auto-ID
      } else {
        await ref.doc(id).set(data); // Custom ID
      }
    } catch (e) {
      throw Exception('Failed to create document: $e');
    }
  }

  /// READ (single document)
  static Future<Map<String, dynamic>?> read(String collectionPath, String id) async {
    try {
      final FirebaseFirestore _db = FirebaseFirestore.instance;
      final doc = await _db.collection(collectionPath).doc(id).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to read document: $e');
    }
  }

  /// READ (all documents in a collection)
  static Future<List<Map<String, dynamic>>> readAll(String collectionPath) async {
    try {
      final FirebaseFirestore _db = FirebaseFirestore.instance;
      final snapshot = await _db.collection(collectionPath).get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // include ID for reference
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to read all documents: $e');
    }
  }

  static Future<PaginateResult<Map<String, dynamic>>> readPaginate(
    String collection, {
    int limit = 30,
    QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc,
    String? searchKey,
    String? status,
  }) async {
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection(collection)
          .orderBy('updated_at', descending: true)
          .orderBy(FieldPath.documentId)
          .limit(limit);

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();

      return PaginateResult(
        items: snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data(),
          };
        }).toList(),
        lastDoc: snapshot.docs.isEmpty ? null : snapshot.docs.last,
      );
    } on FirebaseException catch (e) {
      throw AppException(
        errorMessage: e.message ?? 'Unknown Firebase error',
        statusCode: e.code,
      );
    }
  }

  /// UPDATE (merge true to not overwrite completely)
  static Future<void> update(String collectionPath, String id, Map<String, dynamic> data) async {
    try {
      final FirebaseFirestore _db = FirebaseFirestore.instance;
      await _db.collection(collectionPath).doc(id).update(data);
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  /// DELETE
  static Future<void> delete(String collectionPath, String id) async {
    try {
      final FirebaseFirestore _db = FirebaseFirestore.instance;
      await _db.collection(collectionPath).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  /// LISTEN (real-time updates)
  Stream<List<Map<String, dynamic>>> listen(String collectionPath) {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    return _db.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  static Future<String> uploadUserImage(File file, String userId) async {
    try {
      // create reference (folder 'users' → file name = userId.jpg)
      final ref = FirebaseStorage.instance.ref().child('users/$userId.jpg');

      // upload file
      final uploadTask = await ref.putFile(file);

      // get public download URL
      final url = await uploadTask.ref.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
