import 'package:flutter/material.dart';
import 'package:schedule_creator/showSchedule.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: MyHomePage(title: 'Minizinc Roster Home Page'),
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

  void _navToVisual() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ShowSchedule(),
      )
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ShowSchedule(),
    //   )
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Minizinc data")),
      body: Column(
        children: [
          Center(
          child: ElevatedButton(
            onPressed: _navToVisual,
              child: const Text("Run Minizinc"),
            ),
          ),
        ],
      )
    );
  }
}
