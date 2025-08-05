  import 'package:flutter/material.dart';

import '../../../../../domain/usecases/signout.dart';
import '../../../../../utils/routes/route_names.dart';
import '../../cubit/home_cubit_cubit.dart';
import '../drawer/story_list.dart';

ListView buildDrawer(BuildContext context, HomeCubitState state) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 99,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: (state.user.profileurl == null ||
                        state.user.profileurl!.startsWith('http') == false)
                    ? const CircleAvatar(
                        radius: 53,
                        backgroundImage: AssetImage('assets/noimage.png'),
                      )
                    : CircleAvatar(
                        radius: 53,
                        backgroundImage: NetworkImage(state.user.profileurl!)),
              ),
              const SizedBox(height: 10),
              Text(
                state.user.username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            onTap: () async {
              bool isSignout = await SignOut.signoutuser();
              if (isSignout) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.authentication,
                  (route) => true,
                );
              } // remove the drawer
            },
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(8),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoryListScreen(),
              ),
            );
          },
          leading: const Icon(
            Icons.bubble_chart,
            color: Colors.blue,
          ),
          title: const Text(
            "Stories",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(8),
          onTap: () {
            Navigator.pushNamed(context, RouteName.addstory);
          },
          leading: const Icon(
            Icons.add_circle,
            color: Colors.green,
          ),
          title: const Text(
            "Add Story",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
