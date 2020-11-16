// List of extension, you need to import this file to use the extension function

// extending Dart Iterable to group items by  item field or key on a map
// source: https://stackoverflow.com/a/60717480
extension MyCollection<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
