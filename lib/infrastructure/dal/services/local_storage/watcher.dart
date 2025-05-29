// import 'package:dolirest/objectbox.g.dart';

// class ObjectBoxWatcher {
//   /// Watch all items in a box.
//   static Stream<List<T>> watchAll<T>(Box<T> box,
//       {bool triggerImmediately = true}) {
//     final query = box.query();
//     return query
//         .watch(triggerImmediately: triggerImmediately)
//         .map((q) => q.find());
//   }

//   /// Watch a custom query on a box.
//   static Stream<List<T>> watchQuery<T>(
//     Query<T> query, {
//     bool triggerImmediately = true,
//   }) {
//     return query
//         .watch(triggerImmediately: triggerImmediately)
//         .map((q) => q.find());
//   }
// }
