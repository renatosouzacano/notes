import 'package:flutter/material.dart';
import 'package:flutter_app/notas.dart';
import 'package:flutter_app/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  _NoteDetailState createState() =>
      _NoteDetailState(this.note, this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  Note note;
  DatabaseHelper databaseHelper = DatabaseHelper();

  var _formKey = GlobalKey<FormState>();

  _NoteDetailState(this.note, this.appBarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    // Setting the text on the TextFields.
    titleController.text = note.title;
    textController.text = note.text;

    // This WillPopScope widget is used to control the device back button
    return WillPopScope(
      // This handler will be invoked when device back button is pressed.
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    style: textStyle,
                    controller: titleController,
                    validator: (String userInput) {
                      return (userInput.isEmpty?'Um título é necessário':null);
                    },
                    decoration: InputDecoration(
                      labelText: "Título",
                      labelStyle: textStyle,
                      hintText: "Entre o título da nota",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    style: textStyle,
                    maxLines: 18,
                    controller: textController,
                    validator: (String userInput) {
                        return (userInput.isEmpty?'É preciso digitar algum texto aqui':null);
                    },
                    decoration: InputDecoration(
                      labelText: "Texto",
                      labelStyle: textStyle,
                      hintText: "Escreva o texto da nota.",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text("Salvar"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              updateText();
                              updateTitle();
                              debugPrint ("saving");
                              save();
                            }
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          child: Text("Apagar"),
                          onPressed: () {
                            delete();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    debugPrint("pop");
    Navigator.pop(context, true); // passing the true value to noteList screen.
  }

  // Update title of note object.
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update description of note object.
  void updateText() {
    note.text = textController.text;
  }

  // Saving data to database.
  void save() async {
    moveToLastScreen();
    note.date =  DateFormat().format(DateTime.now()); // Sets the current date
    debugPrint(note.title);
    debugPrint(note.text);

    int result;
    if (note.id != null) {
      // Update operation
      result = await databaseHelper.updateItem(note);
    } else {
      // Insert operation
      result = await databaseHelper.insertNote(note);
    }

    if (result != 0) {
//      _showAlertDialog('Status', 'Note Saved successfully');
    } else {
      _showAlertDialog(
          'Status', 'Tivemos um problema ao salvar sua nota. Tente novamente.');
    }
  }

  void delete() async {
    moveToLastScreen();
    if (note.id == null) {
      _showAlertDialog('Status', 'Nenhuma nota apagada...');
      return;
    } else {
      int result = await databaseHelper.deleteItem(note.id);
      if (result != 0) {
//        _showAlertDialog('Status', 'Nota apagada');
      } else {
        _showAlertDialog('Status',
            'Tivemos um problema ao apagar sua nota. Tente novamente.');
      }
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }
}


void showSnackBar(BuildContext context, String message) {
  var snackbar = SnackBar(content: Text(message));
  Scaffold.of(context).showSnackBar(snackbar);
}