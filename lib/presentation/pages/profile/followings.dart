// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:traveler/config/theme/apptheme.dart';

import 'package:traveler/domain/models/user.dart';
import 'package:traveler/data/repository/database.dart';
import 'package:traveler/domain/usecases/get_follow_user.dart';
import 'package:traveler/presentation/widgets/loading_indicator.dart';
import 'package:traveler/utils/routes/route_names.dart';


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
    GetFollow getFollow = GetFollow(userid: widget.userid);
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
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          automaticallyImplyLeading: true, // hides leading widget (Back button)
          title: Text(
            widget.username,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          bottom: TabBar(
            padding: const EdgeInsets.only(
                left: 30, right: 30), // padding Around Left and Right Tab
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: '   Following   '),
              Tab(text: '   Followers   '),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Center(
                child: biglist![0] == null
                    ? const LoadingProgress()
                    : biglist![0]!.isEmpty
                        ? const Center(
                            child: Text('No following yet'),
                          )
                        : FollowList(followers_followings: biglist![0]),
              ),
            ),
            Container(
              child: Center(
                child: biglist![1] == null
                    ? const LoadingProgress()
                    : biglist![1]!.isEmpty
                        ? const Center(
                            child: Text('No followers yet'),
                          )
                        : FollowList(followers_followings: biglist![1]),
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
    required this.followers_followings,
  });

  final List<UserRegister>? followers_followings;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: followers_followings!.length,
      itemBuilder: (context, index) {
        var user = followers_followings![index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () => Navigator.pushNamed(
                context,
                RouteName.profilescreen,
                arguments: user.uid,
              ),
              leading: user.profileurl!.startsWith('http') == false
                  ? const CircleAvatar(
                      backgroundImage: AssetImage('assets/noimage.png'),
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(user.profileurl!),
                    ),
              title: Text(followers_followings![index].username),
              subtitle: Text(followers_followings![index].bio!.isEmpty
                  ? "--"
                  : followers_followings![index].bio!),
            ),
          ),
        );
      },
    );
  }
}
