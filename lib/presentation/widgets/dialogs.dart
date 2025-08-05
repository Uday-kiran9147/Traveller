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
        backgroundColor: AppTheme.accentColor,
        title: Text("Next Destination",
            style: Theme.of(context)
                .textTheme
                .bodyMedium),
        content: CupertinoTextField(
          onChanged: (val) {
            destination = val;
          },
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.grey.shade100,
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () async {
                if (destination != null || destination!.isNotEmpty) {
                  print(destination);
                  await BlocProvider.of<ProfileCubit>(
                    context,
                  ).addDestinationList(destination!);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Add",
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Back",
                style: TextStyle(color: Colors.redAccent),
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
  backgroundColor: Colors.transparent,
  context: context,
  builder: (context) {
    return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(24),
      topRight: Radius.circular(24),
      ),
      boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 16,
        offset: Offset(0, -4),
      ),
      ],
    ),
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.delete, color: Colors.redAccent),
        title: const Text(
        "Delete",
        style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        ),
        subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          description,
          style: const TextStyle(fontSize: 15),
        ),
        ),
        onTap: () async {
        Navigator.pop(context);
        await Future.delayed(const Duration(milliseconds: 200));
        showDialogCustom(context, postid);
        },
      ),
      const SizedBox(height: 8),
      ],
    ),
    );
  },
  );
}

Future<dynamic> showDialogCustom(BuildContext context, String postid) {
  return showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) {
    return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    title: Row(
      children: [
      Icon(Icons.warning_amber_rounded,
        color: Theme.of(context).colorScheme.error),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
        "Delete Post",
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ],
    ),
    content: const Text(
      "Are you sure you want to delete this post? This action cannot be undone.",
      style: TextStyle(fontSize: 16),
    ),
    actions: [
      TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[700],
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("Cancel"),
      ),
      ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: const Icon(Icons.delete_forever),
      label: const Text("Delete"),
      onPressed: () async {
        await FirebaseFirestore.instance
          .collection("posts")
          .doc(postid)
          .delete();
        Navigator.pop(context);
      },
      ),
    ],
    );
  },
  );
}
