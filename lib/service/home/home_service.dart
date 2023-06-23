import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/note_model.dart';

class HomeServiceModel with ChangeNotifier {
  late bool _isProgress = false;
  List<Note> _notes = [];

  bool get isProgress => _isProgress;
  List<Note> get notes => _notes;

  void setProgress(bool progress) {
    _isProgress = progress;
    notifyListeners();
  }

  void setNotes(List<Note> note) {
    _notes = note;
    notifyListeners();
  }

  Future getNotes() async {
    setProgress(true);
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('notes').get();
      // ignore: unused_local_variable

      // ignore: unused_local_variable
      for (var doc in querySnapshot.docs) {
        List<Note> data = querySnapshot.docs
            .map((e) => Note.fromJson(e.data() as Map<String, dynamic>))
            .where(
              (element) => element.id == FirebaseAuth.instance.currentUser!.uid,
            )
            .toList();
        setNotes(data);
      }
      setProgress(false);
    } catch (e) {
      setProgress(false);
      return false;
    }
  }

  Future deleteNote({required Note note}) async {
    try {
      CollectionReference noteCollection =
          FirebaseFirestore.instance.collection('notes');
      await noteCollection.doc(note.docId).delete();
      await getNotes();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
