abstract interface class StorageRepo<ID, T> {
  Future<T?> load(ID id);
  Future<Iterable<ID>> list();
  Future<void> save(ID id, T val);
  Future<void> delete(ID id);
}
