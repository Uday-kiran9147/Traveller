// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:traveler/config/theme/apptheme.dart';

import 'package:traveler/domain/models/user.dart';
import 'package:traveler/data/repository/database.dart';
import 'package:traveler/domain/usecases/get_follow_user.dart';

import '../home/ui/home_screen.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({
    Key? key,
    required this.index,
    required this.userid,
    required this.username,
  }) : super(key: key);
  final int index;
  final String userid;
  final String username;

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
    GetFollow getFollow =GetFollow(userid: widget.userid);
    List<List<UserRegister>?> users = await getFollow.getfollowList();
    setState(() {
      biglist = users;
    });
  }

  List<List<UserRegister>?>? biglist = [[], []];

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context).user.username;
    return DefaultTabController(
      length: 2,
      initialIndex: widget.index,
      child: Scaffold(
        backgroundColor: AThemes.universalcolor,
        appBar: AppBar(
          backgroundColor: AThemes.universalcolor,
          automaticallyImplyLeading: false, // hides leading widget (Back button)
          title: Text(
            widget.username,textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          bottom: TabBar(labelColor: Colors.teal,
            indicator: BoxDecoration(
                gradient: LinearGradient(colors: [
                Colors.grey.shade300,
                Colors.blue.shade300,
                ]),
                // borderRadius: BorderRadius.circular(40), // Creates border
                ),
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
                    ? LoadingProgress()
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
                    ? LoadingProgress()
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
              gradient: LinearGradient(colors: [
                Colors.grey.shade300,
                Colors.blue.shade300,
              ]),
              color: AThemes.universalcolor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green,
              ),
            ),
            child: ListTile(
              leading: user.profileurl!.startsWith('http') == false
                  ? CircleAvatar(
                      backgroundImage: AssetImage('assets/noimage.png'),
                    )
                  : CircleAvatar(
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
