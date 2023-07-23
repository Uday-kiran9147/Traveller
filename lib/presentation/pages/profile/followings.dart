// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

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
    List<UserRegister>? users = await db.getfollowList();
    setState(() {
      followingallusers = users;
    });
  }

  List<UserRegister>? followingallusers;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.index,
      child: Scaffold(
        appBar: AppBar(
          actions: [],
          bottom: TabBar(
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
                child: followingallusers == null
                    ? CircularProgressIndicator()
                    : ListView.builder(
                        itemCount: followingallusers!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(followingallusers![index].username),
                            ),
                          );
                        },
                      ),
              ),
            ),
            Container(
              child: Center(
                child: Text('Followers'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
