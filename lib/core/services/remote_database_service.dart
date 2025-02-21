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
  Future<void> update(String path, Map<String, dynamic> data);
  Future<DocumentSnapshot<Map<String, dynamic>>?> getDocument(String path);
  Stream<Map<String, dynamic>?> watchDocument(String path);
  Stream<List<T>> watchCollection<T>(
    String path,
    T Function(Map<String, dynamic>) fromMap, {
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
        queryBuilder,
  });
  Future<List<T>> getCollectionPaginated<T>(
    String path,
    T Function(Map<String, dynamic>) fromMap, {
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
        queryBuilder,
    DocumentSnapshot<Map<String, dynamic>>? startAfterDocument,
  });
  Future<void> runTransaction(
    Future<void> Function(Transaction) action,
  );
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

  @override
  Future<void> update(String path, Map<String, dynamic> data) async {
    await _firestore.doc(path).update(data);
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>?> getDocument(
      String path) async {
    return _firestore.doc(path).get();
  }

  @override
  Stream<Map<String, dynamic>?> watchDocument(String path) {
    return _firestore.doc(path).snapshots().map((snapshot) => snapshot.data());
  }

  @override
  Stream<List<T>> watchCollection<T>(
    String path,
    T Function(Map<String, dynamic>) fromMap, {
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
        queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => fromMap(doc.data())).toList());
  }

  @override
  Future<List<T>> getCollectionPaginated<T>(
    String path,
    T Function(Map<String, dynamic>) fromMap, {
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
        queryBuilder,
    DocumentSnapshot<Map<String, dynamic>>? startAfterDocument,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => fromMap(doc.data())).toList();
  }

  @override
  Future<void> runTransaction(Future<void> Function(Transaction) action) {
    return _firestore.runTransaction(action);
  }
}
