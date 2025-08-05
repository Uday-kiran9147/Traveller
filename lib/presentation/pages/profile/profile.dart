// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/domain/models/user.dart';
import 'package:traveler/presentation/pages/home/ui/home_screen.dart';
import 'package:traveler/presentation/pages/profile/cubit/profile_cubit.dart';
import 'package:traveler/presentation/pages/profile/followings.dart';
import 'package:traveler/presentation/pages/profile/widgets/travel_list_container.dart';
import 'package:traveler/utils/routes/route_names.dart';
import '../../../domain/usecases/follow_user.dart';
import '../../widgets/dialogs.dart';

class ProfileScreen extends StatefulWidget {
  String? userid;
  ProfileScreen(this.userid, {super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    tabController = TabController(
        length: 3,
        vsync:
            this); // extended this class with [SingleTickerProviderStateMixin] to get [vsync] attribute
    super.initState();
  }

  UserRegister? randomuser;

  String owner = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      body: StreamBuilder<UserRegister>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userid ?? owner)
              .snapshots()
              .map((event) => UserRegister.fromMap(event)),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            if (snapshot.hasData) {
              var randomuser = snapshot.data;
              bool isowner = randomuser!.uid == owner ? true : false;
              return BlocConsumer<ProfileCubit, ProfileState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        width: double.infinity,
                        color: Colors.blue.shade400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              randomuser.username,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isowner)
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RouteName.editprofile);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white),
                                ),
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 20),
                      // Avatar and user info
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 20,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                shape: BoxShape.circle,
                                image: (randomuser.profileurl == null ||
                                        randomuser.profileurl!
                                                .startsWith('http') ==
                                            false)
                                    ? const DecorationImage(
                                        // opacity: 0.75,
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/noimage.png'),
                                      )
                                    : DecorationImage(
                                        // opacity: 0.75,
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          randomuser.profileurl!,
                                        ),
                                      ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  randomuser.username,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${randomuser.tag!}",
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(width: 4),
                                    Icon(Icons.circle,
                                        color: Colors.blue, size: 8),
                                  ],
                                ),
                                Text(
                                  randomuser.bio!.isEmpty
                                      ? '-Bio-'
                                      : randomuser.bio!,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      isowner
                          ? Text(
                              randomuser.email,
                              textAlign: TextAlign.center,
                            )
                          : TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blueAccent,
                              ),
                              onPressed: () async {
                                FollowUser follow = FollowUser(
                                    userid: randomuser.uid,
                                    random_User_Followers:
                                        randomuser.followers);
                                await follow.follow();
                              },
                              child: randomuser.followers.contains(owner)
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          Icon(
                                            Icons.person_remove_alt_1,
                                            size: 20,
                                            color: Colors.teal,
                                          ),
                                          Text('  unfollow'),
                                        ])
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          Icon(
                                            Icons.person_add_alt_1,
                                            size: 20,
                                            color: Colors.blue,
                                          ),
                                          Text('  follow'),
                                        ])),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Upcoming....."),
                            isowner
                                ? TextButton(
                                    onPressed: () {
                                      String? destination;
                                      destinationDialog(context, destination);
                                    },
                                    child: const Text('Add'))
                                : Container()
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: randomuser.upcomingtrips.isEmpty
                            ? SizedBox(
                                height: 30,
                                width: 300,
                                child: Text(
                                  '-----No upcoming plans-----',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ))
                            : SizedBox(
                                height: 90,
                                child: TravelListWIdget(
                                    randomuser: randomuser, isowner: isowner),
                              ),
                      ),
                      // Buttons Grid
                      Wrap(
                        spacing: 18,
                        runSpacing: 18,
                        children: [
                          _buildProfileButton(Icons.calendar_today, "Following",
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FollowingScreen(
                                  index: 0,
                                  userid: randomuser.uid,
                                  username: randomuser.username,
                                ),
                              ),
                            );
                          }),
                          _buildProfileButton(Icons.group, "Followers", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FollowingScreen(
                                  index: 1,
                                  userid: randomuser.uid,
                                  username: randomuser.username,
                                ),
                              ),
                            );
                          }),
                          _buildProfileButton(
                            Icons.favorite_border,
                            "Reputation",
                            () {},
                          ),
                          _buildProfileButton(
                            Icons.list_alt,
                            "Upcoming Trips",
                            () {},
                            
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }
            return const Center(child: LoadingProgress());
          }),
    );
  }

  GridView posts(UserRegister user) {
    return GridView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 30 / 13,
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10),
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FollowingScreen(
                        index: 1,
                        userid: user.uid,
                        username: user.username,
                      ))),
          child: _countContainer(
              Icons.follow_the_signs, user.followers.length, "followers"),
        ),
        InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FollowingScreen(
                        index: 0,
                        userid: user.uid,
                        username: user.username,
                      ))),
          child: _countContainer(
              Icons.follow_the_signs, user.following.length, "following"),
        ),
        _countContainer(Icons.favorite, user.reputation, "reputation"),
        _countContainer(Icons.density_large_rounded, user.upcomingtrips.length,
            "upcoming trips"),
      ],
    );
  }

  Widget _buildProfileButton(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool highlight = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: highlight ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

Container _countContainer(IconData icon, int count, String text) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.red),
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    ),
    width: 70,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(icon), Text(count.toString()), Text(text)],
    ),
  );
}

class DecoratedContainer extends StatelessWidget {
  const DecoratedContainer({
    Key? key,
    this.url,
    required this.text,
  }) : super(key: key);

  final String? url;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.white, blurRadius: 12)],
          color: Colors.cyan,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      height: 160,
      // width: MediaQuery.of(context).size.width * 0.90,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.purple,
                  Colors.red,
                ]),
                boxShadow: [BoxShadow(color: Colors.white)],
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            width: double.infinity,
            child: const ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              // child: Image.network(
              //   "https://wallpapers.com/images/featured/ibk7fgrvtvhs7qzg.jpg",
              //   fit: BoxFit.cover,
              // )
            ),
          ),
          Positioned(
              bottom: 30,
              left: 20,
              child: Text(
                text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
