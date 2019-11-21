class Note {
  String title, text, date;
  int id;

  Note.update(this.title, this.text, this.date, this.id);

  Note(this.title, this.text, this.date);

  Note.map(dynamic obj) {
    this.title = obj['title'];
    this.text = obj['text'];
    this.date = obj['date'];
    this.id = obj['id'];
  }

  Note.fromMap(Map<String, dynamic> map) {
    this.title = map['title'];
    this.text = map['text'];
    this.date = map['date'];
    this.id = map['id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['title'] = this.title;
    map['text'] = this.text;
    map['date'] = this.date;
    if (id != null) map['id'] = this.id;
    return map;
  }
}
