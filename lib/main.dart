import 'package:flutter/material.dart';
import 'package:flutter_app/firebase_analytics.dart';
import 'package:flutter_app/notas.dart';
import 'package:flutter_app/database_helper.dart';
import 'package:flutter_app/detail.dart';
import 'observer.dart';

// based on https://github.com/mohak1283/NoteKeeper/

FirebaseAnalytics analytics1 = FirebaseAnalytics();

void main() {
  runApp(MaterialApp(
    title: "Bloco de Notas",
    home: NotesList(),
   navigatorObservers: [
     FirebaseAnalyticsObserver(analytics: analytics1),
   ],

  ));
}

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notas;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (_notas == null) {
      List<Note> _notas;

      updateListView();
    }
    return new Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Bloco de Notas"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a new screen
          navigateToDetail(Note('', '', ''), 'Nova nota');
        },
        child: Icon(Icons.add),
        tooltip: "Cria nova nota",
      ),
    );
  }

  Widget getNoteListView() {
    //TextStyle style = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          //elevation: 2.0,
          child: ListTile(
//            leading: CircleAvatar(),
            title:
                Text(_notas[position].title, overflow: TextOverflow.ellipsis),
            subtitle: Text(_notas[position].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                debugPrint("Delete tapped");
                _delete(context, _notas[position]);
              },
            ),
            onTap: () {
              debugPrint("ListTile item tapped");
              navigateToDetail(_notas[position], 'Editar Nota');
            },
          ),
        );
      },
    );
  }

  void navigateToDetail(Note note, String title) async {
    // By prefixing await keyword, we are simple awaiting the response from noteDetail Screen.
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await _databaseHelper.deleteItem(note.id);
    if (result != 0) {
      showSnackBar(context, 'Nota apagada');
      updateListView();
    }
  }


  void updateListView() async {
    var database = await _databaseHelper.db; //_databaseHelper.initDB();
    List<Note> listaDeNotas = await _databaseHelper.getNotesList();
    setState(() {
      this._notas = listaDeNotas;
      this.count = listaDeNotas.length;
    });
  }
}

