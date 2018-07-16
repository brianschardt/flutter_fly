import 'package:args/args.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
//import 'package:await_to_dart/index';
import './file.dart';

String imports = "import 'package:flutter/material.dart';";

main(){

  Directory current = Directory.current;
  String actDir = current.path+'/lib/';

  Map<String, String> dirNames = {
    "services":actDir+'services',
    "styles"  :actDir+'styles',
    "widgets" :actDir+'widgets',
    "tests"   :actDir+'tests',
  };

  createDirectories(dirNames);
  createStyleFiles(dirNames);
  createWidget(dirNames, 'homes/test');

}


void createDirectories(Map dirNames){
  dirNames.forEach((key, value) {
    final dir = new Directory(value);
    if (!dir.existsSync()) {
      print('creating directory: ' + value);
      dir.createSync();
    }
  });
}

void createStyleFiles(Map dirNames) async {
  String styleFileName = dirNames['styles']+'/default.style.dart';
  createFile(styleFileName, imports);
}

void createFile(String filePath, String contents) async{
  File fileObj = new File(filePath);
  if(!fileObj.existsSync()){
    try {
      await fileObj.writeAsString(contents);
      print('file created! ' + filePath);
    } catch (e) {
      print('Error: file not created!');
      print(e);
    }
  }
}

String createDir(String knownDir, String dirName){
  List dir_names = dirName.split('/');
  String dirCheck = knownDir;
  dir_names.forEach((dir_name){
    dirCheck += '/'+dir_name;
    final dir = new Directory(dirCheck);
    if(!dir.existsSync()){
      dir.createSync();
      print('created directory'+dirCheck);
    }
  });

  return dir_names[dir_names.length-1];
}

void createWidget(Map dirNames, String widgetName){
  String widgetsDirName = dirNames['widgets'];

  String fileWidgetName = createDir(widgetsDirName, widgetName);

  String finalWidgetDirName = widgetsDirName+'/'+widgetName;


  print(finalWidgetDirName);
  Map widgetFiles = {
    fileWidgetName+'.widget.dart':'',
    fileWidgetName+'.style.dart':imports,
    fileWidgetName+'.view.dart':'',
  };

  widgetFiles.forEach((key, value){
    String filePath = finalWidgetDirName+'/'+key;
    print(filePath);
    createFile(filePath, value);
  });

  print(fileWidgetName);
}
