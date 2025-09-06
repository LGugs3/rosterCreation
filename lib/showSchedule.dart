import 'package:flutter/material.dart';
import 'main.dart';
import 'minizincExec.dart';

class ShowSchedule extends StatefulWidget {
  const ShowSchedule({super.key});

  @override
  State<ShowSchedule> createState() => _ShowScheduleState();
}

class _ShowScheduleState extends State<ShowSchedule> {

  late FutureBuilder<List<List<dynamic>>> _mzTable;

  void _navToHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyApp(),
        )
    );
  }

  @override
  void initState() {
    super.initState();

    _mzTable = buildMZOutput();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Minizinc data")),
        body: Column(
          children: [
            Expanded(
              child: _mzTable,
            ),
            Center(
              child: ElevatedButton(
                onPressed: _navToHome,
                child: const Text("Back"),
              ),
            )
          ],
        )
    );
  }
}