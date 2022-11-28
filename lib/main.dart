import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([E? Function(T?)? transform]) => map(
        transform ?? (e) => e,
      ).where((e) => e != null).cast();
}
//CompactMap removes any null values and return only non-null

// void testIt() {
//   final value = [1, 2, null, 3]; //List<int?> value
//   final nonNull = [1, 2, 3]; //List<int> nonNull
//   final compactValue =
//       value.compactMap((e) => (e != null && e > 0) ? e : null); //Iterable<int>
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

const url = 'https://bit.ly/3qYOtDm';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //! Causes image flicker due to continuous image re-downloading
    // final image = useFuture(
    //     //Future<Image> foo
    //     NetworkAssetBundle(Uri.parse(url))
    //         .load(url)
    //         .then((data) => data.buffer.asUint8List())
    //         .then((data) => Image.memory(data)));
    //

    // AsyncSnapshot<Image> future
    // final future = useMemoized(() => useFuture(Net...);

    //----
    // Future<Image> future
    final future = useMemoized(() =>
        //Future<Image> foo
        NetworkAssetBundle(Uri.parse(url))
            .load(url)
            .then((data) => data.buffer.asUint8List())
            .then((data) => Image.memory(data)));

    final snapshot = useFuture(future);
    //here future is holding a Future and snaphot is consuming that future
    //----

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          children: [
            snapshot.data,
          ].compactMap().toList(),
        ),
      ),
    );
  }
}
