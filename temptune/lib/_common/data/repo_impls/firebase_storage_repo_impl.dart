import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/foundation.dart";
import "package:temptune/_common/domain/repos/storage_repo.dart";

sealed class _FirebaseStorageRepoImpl<U, V> implements StorageRepo<String, U> {
  _FirebaseStorageRepoImpl(String collection, {required String uuid})
    : _storage = FirebaseFirestore.instance
          .collection("temptune")
          .doc(collection)
          .collection(uuid);
  final CollectionReference<Map<String, dynamic>> _storage;

  @override
  Future<Iterable<String>> list() async {
    try {
      final docs = (await _storage.get()).docs;
      return docs.map((doc) => doc.id);
    } on FirebaseException {
      return const Iterable.empty();
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _storage.doc(id).delete();
    } on FirebaseException {
      // ignore
    }
  }

  Future<V?> _load(String id) async {
    try {
      final snapshot = await _storage.doc(id).get();
      final data = snapshot.data();
      if (data == null) return null;

      return data["data"] as V;
    } on FirebaseException {
      return null;
    }
  }

  Future<void> _save(String id, V val) async {
    try {
      await _storage.doc(id).set({"data": val});
    } on FirebaseException {
      throw Exception("Saving failed!");
    }
  }
}

final class TextFirebaseStorageRepoImpl
    extends _FirebaseStorageRepoImpl<String, String> {
  TextFirebaseStorageRepoImpl(super.collection, {required super.uuid});

  @override
  Future<String?> load(String id) => _load(id);
  @override
  Future<void> save(String id, String val) => _save(id, val);
}

final class BinFirebaseStorageRepoImpl
    extends _FirebaseStorageRepoImpl<Uint8List, Blob> {
  BinFirebaseStorageRepoImpl(super.collection, {required super.uuid});

  @override
  Future<Uint8List?> load(String id) => _load(id).then((blob) => blob?.bytes);
  @override
  Future<void> save(String id, Uint8List val) => _save(id, Blob(val));
}
