import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/theme/apptheme.dart';
import '../pages/profile/cubit/profile_cubit.dart';

Future<dynamic> destinationDialog(BuildContext context, String? destination) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Next Destination",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: AThemes.comment_Box)),
        content: CupertinoTextField(
          onChanged: (val) {
            destination = val;
          },
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.grey.shade100,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                if (destination != null || destination!.isNotEmpty) {
                  print(destination);
                  await BlocProvider.of<ProfileCubit>(context,).addDestinationList(destination!);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Add",
                style: TextStyle(color: Colors.green),
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Back",
                style: TextStyle(),
              ))
        ],
      );
    },
  );
}

Future<dynamic> showBottomSheetCustom(
    BuildContext context, String description, String postid) {
  return showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      backgroundColor: Theme.of(context).canvasColor,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                  title: Text("Delete",
                      style: TextStyle(
                        color: Colors.red,
                      )),
                  subtitle: Text(description),
                  onTap: () async {
                    showDialogCustom(context, postid);
                  }),
            ],
          ),
        );
      });
}

Future<dynamic> showDialogCustom(BuildContext context, String postid) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Are you sure you want to delete this post?",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color:  Theme.of(context).colorScheme.error)),
        actions: [
          TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("posts")
                    .doc(postid)
                    .delete();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                "Yes",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style: TextStyle(color: Colors.green),
              )),
        ],
      );
    },
  );
}
