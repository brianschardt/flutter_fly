import 'package:args/args.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import './file.dart';


main(List<String> arguments){

  Directory current = Directory.current;
  String actDir = current.path+'/lib/';

  Map<String, String> dirNames = {
    "services":actDir+'services',
    "styles"  :actDir+'styles',
    "widgets" :actDir+'widgets',
    "tests"   :actDir+'tests',
  };


  bool check = checkIsFlutter(current.path);

  if(arguments.length<1){
    listOptions();
  }

  final parser = new ArgParser();


  var initHelp = new ArgParser();
  parser.addCommand('help', initHelp);
  initHelp.addOption('set', callback: (mode){
    listOptions();
  });


  var initCommand = new ArgParser();
  parser.addCommand('init', initCommand);
  initCommand.addOption('set', callback: (mode){
    init();
  });

  var initGenerate = new ArgParser();
  parser.addCommand('generate', initGenerate);
  initGenerate.addOption('set', callback: (mode){
    generate(arguments);
  });

  var initGW = new ArgParser();
  parser.addCommand('gw', initGW);
  initGW.addOption('set', callback: (mode){
    gw(arguments);
  });

  var results = parser.parse(arguments);

  if(!check){
    print('Error: Not in a flutter project');
    return;
  }


}

Map<String, String>getDirNames(){
  Directory current = Directory.current;
  String actDir = current.path+'/lib/';

  Map<String, String> dirNames = {
    "services":actDir+'services',
    "styles"  :actDir+'styles',
    "widgets" :actDir+'widgets',
    "tests"   :actDir+'tests',
  };

  return dirNames;
}

void listOptions(){
  print('*********************************');
  print('******** FLY BY FLUTTER *********');
  print('*********************************');
  print('OPTIONS:');
  print('   init                                                   Initilize Project');
  print('   generate widget:<stateless | stateful> <Widget Name>  Creates Widget');
  print('    gw:<stateless | stateful> <Widget Name>               Shortcut: Creates Widget');
  print('   _ _ _');
  print('   help                                                   Lists Commands');
}
void gw(args){
  if(args.length<2){
    print('not enough arguments');
    return;
  }

  List<String> possibleState = args[0].split(':');

  String state = (possibleState.length<2) ? 'stateless': possibleState[1];
  print(state);
}

void generate(args){
  if(args.length < 3){
    print('not enough arguments');
    return;
  };

  String type = args[1];
  String name = args[2];

  List<String> typeArray = type.split(':');

  String actualType = typeArray[0];
  switch(actualType){
    case 'widget':
      String state = (typeArray.length<2) ? 'stateless' : typeArray[1];
      generateWdiget(name, state);
      break;
    default:
      print('type unknown '+actualType);
      break;
  }
}

void generateWdiget(name, state){
  print('Creating widget named: '+name);
  Map<String, String> dirNames = getDirNames();
  createWidget(dirNames, name, state);
}

void init(){
  print('Beginning to initilize Project for Eden');
  Map<String, String> dirNames = getDirNames();

  createDirectories(dirNames);
  createStyleFiles(dirNames);
  createWidget(dirNames, 'homes', 'stateful');
  print('Done');
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
  }else{
    print('Warning! File Already Exists: ${filePath}');
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
      print('created directory ${dirCheck}');
    }else{
      print('Warning! Directory Already Exists: ${dirCheck}');
    }
  });

  return dir_names[dir_names.length-1];
}

void createWidget(Map dirNames, String widgetName, String state){
  String widgetsDirName = dirNames['widgets'];

  String fileWidgetName = createDir(widgetsDirName, widgetName);

  String finalWidgetDirName = widgetsDirName+'/'+widgetName;

  List dir_names =  widgetName.split('/');//to get how many directories down

  String widgetContent;
  if(state == 'stateless'){
    widgetContent = getStatelessWidgetContents(fileWidgetName);
  }else if(state == 'stateful'){
    widgetContent = getStatefulWidgetContents(fileWidgetName);
  }else{
    print('Error state unknown');
    return;
  }
  Map widgetFiles = {
    fileWidgetName+'.widget.dart':widgetContent,
    fileWidgetName+'.style.dart' :getStyleContents(dir_names.length),
    fileWidgetName+'.view.dart'  :getViewContents(fileWidgetName, dir_names.length),
  };

  widgetFiles.forEach((key, value){
    String filePath = finalWidgetDirName+'/'+key;
    createFile(filePath, value);
  });

}
