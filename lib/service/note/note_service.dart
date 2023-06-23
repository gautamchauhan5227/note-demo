import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../model/note_model.dart';

class NoteServiceModel with ChangeNotifier {
  late bool _isProgress = false;
  String _title = '';
  String _description = '';
  int _colorIndex = 0;
  DateTime _dateTime = DateTime.now();
  Note _note = Note.initial();

  bool get isProgress => _isProgress;
  String get title => _title;
  String get description => _description;
  int get colorIndex => _colorIndex;
  DateTime get dateTime => _dateTime;
  Note get note => _note;

  void setProgress(bool progress) {
    _isProgress = progress;
    notifyListeners();
  }

  void setTitle(String title) {
    _title = title;
    _note.title = title;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    _note.description = description;
    notifyListeners();
  }

  void setColorIndex(int index) {
    _colorIndex = index;
    _note.colorIndex = index;
    notifyListeners();
  }

  void setDateTime(DateTime date) {
    _dateTime = date;
    _note.date = date;
    notifyListeners();
  }

  void setAllData(Note note) {
    setProgress(true);
    _note = note;
    notifyListeners();
    setProgress(false);
  }

  Future saveForm({
    bool? isNewNote,
    bool? isUpdateNote,
    bool? isDeleteNote,
  }) async {
    setProgress(true);
    try {
      CollectionReference noteCollection =
          FirebaseFirestore.instance.collection('notes');
      if (isNewNote ?? false) {
        var uuid = const Uuid();
        String id = uuid.v1();
        final newNote = Note(
          id: FirebaseAuth.instance.currentUser!.uid,
          docId: id,
          title: _title,
          description: _description,
          date: _dateTime,
          colorIndex: _colorIndex,
        );
        await noteCollection.doc(id).set(newNote.toJson());
        setProgress(false);
      } else if (isUpdateNote ?? false) {
        await noteCollection.doc(_note.docId).update(_note.toJson());
        setProgress(false);
      } else {
        await noteCollection.doc(_note.docId).delete();
        setProgress(false);
      }
    } catch (e) {
      setProgress(false);
      return false;
    }
  }
}
