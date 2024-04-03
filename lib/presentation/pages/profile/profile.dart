// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/domain/models/user.dart';
import 'package:traveler/presentation/pages/home/ui/home_screen.dart';
import 'package:traveler/presentation/pages/profile/cubit/profile_cubit.dart';
import 'package:traveler/presentation/pages/profile/followings.dart';
import 'package:traveler/presentation/pages/profile/widgets/travel_list_container.dart';
import 'package:traveler/utils/routes/route_names.dart';
import '../../../config/theme/apptheme.dart';
import '../../../domain/usecases/follow_user.dart';
import '../../widgets/dialogs.dart';

class ProfileScreen extends StatefulWidget {
  String? userid;
  ProfileScreen(this.userid, {super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
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

  // Future<UserRegister> getRandomuser() async {
  //   if (widget.userid == null) {
  //     randomuser = BlocProvider.of<HomeCubitCubit>(context).state.user;
  //     return randomuser!;
  //   } else {
  //     UserRegister getuser = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(widget.userid)
  //         .get()
  //         .then((value) => UserRegister.fromMap(value));
  //     setState(() {
  //       randomuser = getuser;
  //     });
  //     return getuser;
  //   }
  // }
  String owner = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocConsumer<ProfileCubit, ProfileState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Text(
                          randomuser.username,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(20),
                                        image: (randomuser.profileurl == null ||
                                                randomuser.profileurl!
                                                        .startsWith('http') ==
                                                    false)
                                            ? const DecorationImage(
                                                // opacity: 0.75,
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'assets/noimage.png'),
                                              )
                                            : DecorationImage(
                                                // opacity: 0.75,
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  randomuser.profileurl!,
                                                )))),
                                isowner
                                    ? IconButton.filled(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, RouteName.editprofile);
                                        },
                                        icon: const Icon(Icons.edit))
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 150,minWidth: 80),
                            child: Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '${randomuser.username} • ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!),
                                  TextSpan(
                                    text: randomuser.tag!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: AThemes.appThemeOrange,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                            randomuser.bio!.isEmpty ? '-Bio-' : randomuser.bio!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium!),
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
                        Row(
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
                        randomuser.upcomingtrips.isEmpty
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
                                child: TravelListWIdget(randomuser: randomuser, isowner: isowner),
                              ),
                        SizedBox(
                          height: 40,
                          width: double.maxFinite,
                          child: Align(
                            alignment: Alignment.center,
                            child: TabBar(
                              isScrollable: true,
                              unselectedLabelColor: Colors.grey,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      50), // Creates border
                                  color: AThemes.primaryColor.withOpacity(0.1)),
                              automaticIndicatorColorAdjustment: true,
                              tabs: [
                                Tab(
                                  icon: Icon(
                                    Icons.grid_on,
                                    color: Theme.of(context)
                                        .tabBarTheme
                                        .labelColor,
                                  ),
                                ),
                                const Tab(
                                  icon: Icon(Icons.person_pin),
                                ),
                                const Tab(
                                  icon: Icon(Icons.bookmark_border),
                                ),
                              ],
                              controller: tabController,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 400,
                          child:
                              TabBarView(controller: tabController, children: [
                            posts(randomuser),
                            const Center(child: Text('Empty,\nComing soon!')),
                            const Center(child: Text('Empty,\nComing soon!')),
                          ]),
                        ),
                      ],
                    );
                  },
                ),
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
          child: countContainer(
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
          child: countContainer(
              Icons.follow_the_signs, user.following.length, "following"),
        ),
        countContainer(Icons.favorite, user.reputation, "reputation"),
        countContainer(Icons.density_large_rounded, user.upcomingtrips.length,
            "upcoming trips"),
      ],
    );
  }

  Container countContainer(IconData icon, int count, String text) {
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
