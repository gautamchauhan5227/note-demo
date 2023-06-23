import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_note/core/color_const.dart';
import 'package:keep_note/core/string_const.dart';
import 'package:keep_note/model/note_model.dart';
import 'package:keep_note/screen/home/home_screen.dart';
import 'package:keep_note/service/note/note_service.dart';
import 'package:keep_note/widget/note_card.dart';
import 'package:keep_note/widget/primary_button.dart';
import 'package:keep_note/widget/text_field_widget.dart';
import 'package:provider/provider.dart';

class NoteFormScreen extends StatelessWidget {
  final bool isNew;
  final Note note;
  const NoteFormScreen({super.key, required this.isNew, required this.note});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteServiceModel()
        ..setDateTime(note.date)
        ..setColorIndex(note.colorIndex)
        ..setAllData(note),
      child: Consumer<NoteServiceModel>(builder: (context, noteModel, child) {
        Future<void> showMyDialog() async {
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(StringConsatant.deleteNote),
                content: const Text(StringConsatant.areYouSure),
                actions: <Widget>[
                  TextButton(
                      child: const Text(StringConsatant.yes),
                      onPressed: () async {
                        await noteModel
                            .saveForm(isDeleteNote: true)
                            .then((value) {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        });
                      }),
                  TextButton(
                    child: const Text(StringConsatant.no),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }

        Future<void> selectDate(BuildContext context) async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: noteModel.dateTime,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (picked != null && picked != noteModel.dateTime) {
            noteModel.setDateTime(picked);
          }
        }

        return Scaffold(
            body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                const Spacer(),
                Text(
                  isNew ? StringConsatant.newNote : StringConsatant.editNote,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (!isNew)
                  IconButton(
                    onPressed: () {
                      showMyDialog();
                    },
                    icon: const Icon(Icons.delete),
                  )
                else
                  const SizedBox(width: 50)
              ],
            ),
            NoteCardData(
              note: noteModel.note,
              isTappable: false,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.60,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormFieldCustom(
                        labelText: StringConsatant.title,
                        initialValue: note.title,
                        onChanged: (val) => noteModel.setTitle(val),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16)
                          .copyWith(top: 16),
                      child: TextFormFieldCustom(
                        initialValue: note.description,
                        labelText: StringConsatant.description,
                        maxLines: 5,
                        onChanged: (val) => noteModel.setDescription(val),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16)
                          .copyWith(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          selectDate(context);
                        },
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month_rounded),
                                const SizedBox(width: 15),
                                Text(DateFormat('d MMMM y')
                                    .format(noteModel.dateTime)
                                    .toString())
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16)
                          .copyWith(top: 20),
                      child: Card(
                        elevation: 2,
                        child: SizedBox(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: colorList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: ((context, index) => Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: GestureDetector(
                                      onTap: () =>
                                          noteModel.setColorIndex(index),
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          color: colorList[index],
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width:
                                                  index == noteModel.colorIndex
                                                      ? 3
                                                      : 0,
                                              color:
                                                  index == noteModel.colorIndex
                                                      ? ColorConstants.primary
                                                      : Colors.transparent),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryButton(
                isProgress: noteModel.isProgress,
                title: StringConsatant.save,
                onTap: () async {
                  await noteModel.saveForm(
                      isNewNote: isNew ? true : false,
                      isUpdateNote: isNew ? false : true);
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ));
      }),
    );
  }
}
