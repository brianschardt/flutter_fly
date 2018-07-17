import 'package:args/args.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
//import 'package:await_to_dart/index';
import './file.dart';


main(){

  Directory current = Directory.current;
  String actDir = current.path+'/lib/';

  Map<String, String> dirNames = {
    "services":actDir+'services',
    "styles"  :actDir+'styles',
    "widgets" :actDir+'widgets',
    "tests"   :actDir+'tests',
  };


  bool check = checkIsFlutter(current.path);

  if(!check){
    print('Error: Not in a flutter project');
    return;
  }

  createDirectories(dirNames);
  createStyleFiles(dirNames);
  createWidget(dirNames, 'homes/test');

}

bool checkIsFlutter(projectPath){
  File fileObj = new File(projectPath+'/pubspec.yaml');
  return fileObj.existsSync();
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
  createFile(styleFileName, getDefaultStyle());
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

  List dir_names =  widgetName.split('/');//to get how many directories down

  print(dir_names.length);
  Map widgetFiles = {
    fileWidgetName+'.widget.dart':getStatelessWidgetContents(fileWidgetName),
    fileWidgetName+'.style.dart' :getStyleContents(dir_names.length),
    fileWidgetName+'.view.dart'  :getViewContents(fileWidgetName, dir_names.length),
  };

  widgetFiles.forEach((key, value){
    String filePath = finalWidgetDirName+'/'+key;
    createFile(filePath, value);
  });

}
