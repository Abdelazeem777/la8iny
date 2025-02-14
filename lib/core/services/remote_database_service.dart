import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RemoteDatabaseService {
  Future<T> get<T>(
    String path,
    T Function(Map<String, dynamic>) fromMap,
  );
  Future<void> set<T>(
    String path,
    T data,
    Map<String, dynamic> Function(T) toMap,
  );
  Future<void> delete(String path);
}

class RemoteDatabaseServiceImpl implements RemoteDatabaseService {
  final FirebaseFirestore _firestore;

  RemoteDatabaseServiceImpl(this._firestore);

  @override
  Future<void> delete(String path) async {
    await _firestore.doc(path).delete();
  }

  @override
  Future<T> get<T>(
    String path,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    final snapshot = await _firestore.doc(path).get();

    if (!snapshot.exists) {
      throw Exception('Document does not exist');
    }

    return fromMap(snapshot.data()!);
  }

  @override
  Future<void> set<T>(
    String path,
    T data,
    Map<String, dynamic> Function(T) toMap,
  ) async {
    await _firestore.doc(path).set(toMap(data));
  }
}
