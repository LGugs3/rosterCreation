import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

const String outputCSVFile = "minizinc/output.csv";
const String minizincDebugFile = "minizinc/debug.txt";

Future<void> tryRunMinizinc() async {
  try{
    runMinizinc();
  } on FileSystemException catch(e){
    if (kDebugMode) {
      print(e.message);
    }
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

  //solver commands
  ProcessResult counterProc = await Process.run(mzFile, ["minizinc/config.mpc", "minizinc/schedule.mzn", "-d", "./minizinc/counter.dzn"]);
  ProcessResult driverProc = await Process.run(mzFile, ["minizinc/config.mpc", "minizinc/schedule.mzn", "-d", "./minizinc/driver.dzn"]);

  File outFile = File(outputCSVFile);
  File bugFile = File(minizincDebugFile);

  //remove old files
  if (await bugFile.exists()) {
    await bugFile.delete();
  }
  if (await outFile.exists()) {
    await outFile.delete();
  }
  print("files deleted");


  IOSink outSink = outFile.openWrite();
  IOSink errSink = bugFile.openWrite();
  outSink.writeAll([counterProc.stdout, "\n", driverProc.stdout]);
  errSink.writeAll([counterProc.stderr, "\n", driverProc.stderr]);

  print("new files generated");

  //flush and close sinks
  await outSink.flush();
  await outSink.close();

  await errSink.flush();
  await errSink.close();
}

FutureBuilder<List<List<dynamic>>> buildMZOutput() {
  print("new table generated");
  return FutureBuilder<List<List<dynamic>>>(
    future: loadCsv(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) { //still waiting
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) { //error loading/parsing data
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) { //data block is empty
        return Center(child: const Text("no data found."));
      } else {
        return showMZOutput(snapshot.data!);
      }
    },
  );
}


GridView showMZOutput(List<List<dynamic>> csvTable) {
  List<dynamic> header = csvTable[0];
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: header.length,
        childAspectRatio: 1.0
    ),
    itemCount: csvTable.length * header.length,
    shrinkWrap: true,
    itemBuilder: (context, index) {
      int rowIdx  = index ~/ header.length;
      int colIdx = index % header.length;
      return Card(
        child: Center(
          child: Text(
            csvTable[rowIdx][colIdx].toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    },
  );
}

Future<List<List<dynamic>>> loadCsv() async {
  print("csv file read");
  final String rawCsv = await rootBundle.loadString(outputCSVFile);

  List<List<dynamic>> csvTable = CsvToListConverter().convert(rawCsv, fieldDelimiter: '|');
  return csvTable;
}