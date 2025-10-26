abstract interface class ROStorageRepo<ID, T> {
  Future<T?> load(ID id);
  Future<Iterable<ID>> list();
}

abstract interface class StorageRepo<ID, T> implements ROStorageRepo<ID, T> {
  Future<void> save(ID id, T val);
  Future<void> delete(ID id);
}
