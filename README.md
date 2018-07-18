# Eden
#### Best Flutter Framework for organized and beautiful code

### Description
The purpose of this framework is to encourage organized code, and break files up into their proper function.

This framework can work and be incorporated into any existing project! All you need to do is run the init command 
in the project directory.

We break up the project into 3 main directories.
1. Services - contain logic that is used in multiple widgets. 
2. Styles - contains styles that are used in multiple widgets.
3. Widgets - a directory that contains all the project's widgets

When creating a widget our CLI will automatically create the correct directory structure, 
break the widget into an organized set of files, and import the correct files needed to run.

It creates 3 files
1. Style - contains that particular widget's styles
2. View - contains the view and look of that widget
3. Widget - contains that particular widget logic.

#### For Example:
if you create a widget called login
```$xslt
widgets
--login
----login.style.dart
----login.view.dart
----login.widget.dart
``` 
## Init
initilize existing project to work with existing commands
```$xslt
cd to/flutter/project
eden init
```

creats directories and files for the eden framework
```$xslt
services
styles
--default.style.dart
widgets
--home
----home.style.dart
----home.view.dart
----home.widget.dart
```

## Generate Widget
Create an additional widget. By default this will create a stateless widget
```$xslt
eden generate widget login
```

**or**
### Create a Sateless Widget
```$xslt
eden generate widget:stateless login
```
**Shortcut!**

**gw**: stands for "generate widget", this helps reduce time it takes to type out the full thing.
```$xslt
eden gw:stateless login
```
### Create a Sateful Widget
```$xslt
eden generate widget:stateful login
```
**Shortcut!**
```$xslt
eden gw:stateful login
```



