// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:traveler/config/theme/apptheme.dart';

import 'package:traveler/domain/models/user.dart';
import 'package:traveler/domain/repositories/database.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  DatabaseService db = DatabaseService();
  @override
  void initState() {
    super.initState();
    getus();
  }

  getus() async {
    List<List<UserRegister>?> users = await db.getfollowList();
    print(users);
    setState(() {
      biglist = users;
    });
  }

  List<List<UserRegister>?>? biglist = [[], []];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.index,
      child: Scaffold(
        backgroundColor: AThemes.universalcolor,
        appBar: AppBar(
          backgroundColor: AThemes.universalcolor,
          bottom: TabBar(
            // indicator: BoxDecoration(
            //     borderRadius: BorderRadius.circular(50), // Creates border
            //     color: Colors.greenAccent),
            tabs: [
              Tab(text: 'Following'),
              Tab(text: 'Followers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Center(
                child: biglist![0] == null
                    ? CircularProgressIndicator()
                    : biglist![0]!.isEmpty
                        ? Center(
                            child: Text('No following yet'),
                          )
                        : FollowList(biglist: biglist![0]),
              ),
            ),
            Container(
              child: Center(
                child: biglist![1] == null
                    ? CircularProgressIndicator()
                    : biglist![1]!.isEmpty
                        ? Center(
                            child: Text('No followers yet'),
                          )
                        : FollowList(biglist: biglist![1]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FollowList extends StatelessWidget {
  const FollowList({
    super.key,
    required this.biglist,
  });

  final List<UserRegister>? biglist;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: biglist!.length,
      itemBuilder: (context, index) {
        var user = biglist![index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AThemes.universalcolor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red,
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.profileurl!),
              ),
              title: Text(biglist![index].username),
            ),
          ),
        );
      },
    );
  }
}
