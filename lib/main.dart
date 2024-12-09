import 'package:drop_down/custom_dropdown.dart';
import 'package:drop_down/user_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User> user = [
    User(id: '1', name: 'test'),
    User(id: '2', name: 'test 2'),
    User(id: '3', name: 'test 3'),
    User(id: '4', name: 'test 4'),
    User(id: '5', name: 'test 5 df dsf sdf sdf'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: CustomDropdownField<User>(
        items: user,
        dropDownColor: Colors.grey,
        selectedItem: User(id: '98', name: 'name is 98'),
        itemAsString: (item) => item.name,
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
