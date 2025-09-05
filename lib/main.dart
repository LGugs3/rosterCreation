import 'package:flutter/material.dart';
import 'minizincExec.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minizinc Roster',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Minizinc Roster Home Page'),
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

  FutureBuilder<List<List<dynamic>>> _mzTable = buildMZOutput();

  Future<void> _refreshTable() async {
    await tryRunMinizinc();

    setState(() {
      _mzTable = buildMZOutput();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Minizinc data")),
      body: Column(
        children: [
          Center(
          child: ElevatedButton(
            onPressed: _refreshTable,
              child: const Text("Run Minizinc"),
            ),
          ),
          Expanded(
            child: _mzTable,
          ),
        ],
      )
    );
  }
}
