import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

/// Entry point of the script.
main(List<String> args) async {

  String path = "./version.txt";
  String recipient = "";
  String eclipseUrl = "https://eclipse.org/downloads/eclipse-packages/";
  String oldVersion = "";

  /// Parse the given arguments.
  if (args.length == 3) {
    if (args[0] == "--file" || args[0] == "-f") {
      path = args[1];
      recipient = args[2];
    } else {
      help();
    }
  } else if (args.length == 1){
    if (args[0] == "--help" || args[0] == "-h") {
      help();
    } else {
      recipient = args[0];
    }
  } else if (args.length == 0) {
    help();
  }

  if (!recipient.contains("@")) {
    print("No correct mail address given.");
    exit(-1);
  }

  http.Response response = await http.get(eclipseUrl);

  if (response.body.trim().isEmpty) {
    print("Website not available");
    exit(1);
  }

  Document document = parser.parse(response.body);

  String version = document.getElementById("descriptionText").text;

  if (version.trim().isEmpty) {
    print("No version information available.");
    exit(1);
  }

  if (!version.contains("(") || !version.contains(")")) {
    print("Version format seems to have changed.");
    print("Version string: $version");
    exit(2);
  }

  version = version.split("(")[1].split(")")[0].trim();

  File file = new File(path);

  if (await file.exists()) {
    oldVersion = await file.readAsString();

    oldVersion = oldVersion.trim();
  } else {
    oldVersion = "";
  }

  if (oldVersion == version) {
    print("No version change");
    exit(0);
  }

  file.writeAsString(version);

  print("A new version is available!");

  /// Send mail using the mail command.
  await Process.run(
      "mail",
      ["-s", "New Eclipse Version: $version", recipient],
      runInShell: true
  );

}

/// Print the help text and exit the program.
help() {
  print("""
Eclipse Version Scraping
2017 (c) Marcel Kapfer
Licensed under GNU GPL v3

dart bin/main.dart [options] recipient

  -h | --help   Print this help and exit
  -f | --file   File to use for saving the version.""");

  exit(0);
}