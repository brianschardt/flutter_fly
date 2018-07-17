import "./helpers.dart";

String getDefaultStyleImport(number){
  String down = '../';
  for(var i = 0; i<number; i++){
    down += '../';
  }
  return 'import "${down}styles/default.style.dart";';
}

String widgetViewBuildName(widget){
  return '${widget}ViewBuild';
}
String getDefaultStyle(){
  return getDefaultImports();
}
String getDefaultImports(){
  return 'import "package:flutter/material.dart";';
}

String getStyleContents(number){//number is for how many directories is it from home
  return
'''
${getDefaultImports()}
${getDefaultStyleImport(number)}
''';

}

String getWidgetContents(WidgetName){
  return
'''
${getDefaultImports()}
import "./${WidgetName}.view.dart";
''';

}
String getStatelessWidgetContents(WidgetName){
  return
'''
${getWidgetContents(WidgetName)}
class ${cap(WidgetName)} extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ${widgetViewBuildName(WidgetName)}(this);
  }
}
''';

}

String getStatefulWidgetContents(WidgetName){
  String CapName = cap(WidgetName);
  return
'''
${getWidgetContents(WidgetName)}
class ${CapName} extends StatefulWidget {

  @override
  State<StatefulWidget> createState(){
    return new ${CapName}State();
  }
}

class ${CapName}State extends State<${CapName}> {
  
  @override
  Widget build(BuildContext context) {
    return ${widgetViewBuildName(WidgetName)}(this);
  }
}
''';

}

String getViewContents(WidgetName, number){
  return
'''
${getDefaultImports()}
${getDefaultStyleImport(number)}
import "./${WidgetName}.style.dart";

Widget ${widgetViewBuildName(WidgetName)}(wg){
  return Center(child: Text("${WidgetName} created!"));
}
''';
}