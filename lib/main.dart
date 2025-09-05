import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

void tryRunMinizinc() async {
  try{
    runMinizinc();
  } on FileSystemException catch(e){
    print(e.message);
  }
}

void runMinizinc() async {
  late String mzFile;
  if (Platform.isWindows){
    mzFile = "minizincDistros/windows/minizinc";
  } else if (Platform.isMacOS){
    mzFile = "minizincDistros/macos/Contents/Resources/minizinc"; //TODO:: change to update actual path
  } else{
    throw PlatformException(code: "UNSUPPORTED_PLATFORM", message: "Unsupported platform: ${Platform.operatingSystem}");
  }

  ProcessResult counterProc = await Process.run(mzFile, ["minizinc/config.mpc", "minizinc/schedule.mzn", "-d", "./minizinc/counter.dzn"]);
  ProcessResult driverProc = await Process.run(mzFile, ["minizinc/config.mpc", "minizinc/schedule.mzn", "-d", "./minizinc/driver.dzn"]);

  File outFile = File("minizinc/output.csv");
  File bugFile = File("minizinc/debug.txt");

  if (await bugFile.exists()) {
    await bugFile.delete();
  }
  if (await outFile.exists()) {
    await outFile.delete();
  }


  IOSink outSink = outFile.openWrite();
  IOSink errSink = bugFile.openWrite();
  outSink.writeAll([counterProc.stdout, "\n", driverProc.stdout]);
  errSink.writeAll([counterProc.stderr, "\n", driverProc.stderr]);

  //flush and close sinks
  await outSink.flush();
  await outSink.close();

  await errSink.flush();
  await errSink.close();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: tryRunMinizinc,
          child: const Text("Run Minizinc"),
        ),
      ),
    );
  }
}
