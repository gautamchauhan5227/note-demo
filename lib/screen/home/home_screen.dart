import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keep_note/core/color_const.dart';
import 'package:keep_note/core/image_const.dart';
import 'package:keep_note/core/string_const.dart';
import 'package:keep_note/model/note_model.dart';
import 'package:keep_note/screen/note/note_form_screen.dart';
import 'package:keep_note/screen/profile/profile_screen.dart';
import 'package:keep_note/service/home/home_service.dart';
import 'package:keep_note/widget/note_card.dart';
import 'package:keep_note/widget/primary_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeServiceModel()..getNotes(),
      child: Consumer<HomeServiceModel>(builder: (context, homeModel, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(50.0), // here the desired height
            child: Padding(
              padding: const EdgeInsets.only(top: 40, right: 16),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset(
                      ImageConstants.noteLogo,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  const Text(
                    StringConsatant.noteKeeper,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.primary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyProfileScren()));
                    },
                    child: CircleAvatar(
                      radius: 25,
                      child: Text(
                        FirebaseAuth.instance.currentUser!.email![0]
                            .toUpperCase(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteFormScreen(
                    isNew: true,
                    note: Note.initial(),
                  ),
                ),
              );
            },
            child: const CircleAvatar(
              radius: 30,
              backgroundColor: ColorConstants.primary,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: homeModel.isProgress || homeModel.notes.isEmpty
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              crossAxisAlignment:
                  homeModel.isProgress || homeModel.notes.isEmpty
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
              children: [
                homeModel.isProgress
                    ? const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : homeModel.notes.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 40.0),
                                  child:
                                      Lottie.asset(ImageConstants.noDataLottie),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: PrimaryButton(
                                      title: StringConsatant.getStart,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                NoteFormScreen(
                                              isNew: true,
                                              note: Note.initial(),
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              ],
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: homeModel.notes.length,
                              itemBuilder: (context, index) => NoteCardData(
                                note: homeModel.notes[index],
                                isTappable: true,
                              ),
                            ),
                          ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
