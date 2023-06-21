import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                title: Text("Apple"),
                subtitle: Text("by uday"),
              ),
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
            style: TextStyle(fontSize: 15, fontStyle: FontStyle.normal)),
        actions: [
          TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("posts")
                    .doc(postid)
                    .delete();
                Navigator.pop(context);
              },
              child: Text(
                "Yes",
                style: TextStyle(color: Theme.of(context).errorColor),
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No")),
        ],
      );
    },
  );
}
