import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_note/core/color_const.dart';
import 'package:keep_note/model/note_model.dart';
import 'package:keep_note/screen/note/note_form_screen.dart';

class NoteCardData extends StatelessWidget {
  final Note note;
  final bool isTappable;
  const NoteCardData({super.key, required this.note, required this.isTappable});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isTappable) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteFormScreen(
                isNew: false,
                note: note,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorList[note.colorIndex],
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: colorList[note.colorIndex].withOpacity(0.1),
        ),
        // width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                note.description,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  DateFormat('d MMMM y').format(note.date).toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
