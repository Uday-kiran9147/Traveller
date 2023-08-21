// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/domain/models/user.dart';
import 'package:traveler/domain/usecases/delete_travel_list.dart';
import 'package:traveler/presentation/pages/home/ui/home_screen.dart';
import 'package:traveler/presentation/pages/profile/followings.dart';
import 'package:traveler/utils/routes/route_names.dart';
import '../../../config/theme/apptheme.dart';
import '../../../domain/usecases/follow_user.dart';
import '../../providers/user_provider.dart';
import '../../widgets/dialogs.dart';

class Profile extends StatefulWidget {
  String? userid;
  Profile(this.userid);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
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

  Future<UserRegister> getRandomuser() async {
    if (widget.userid == null) {
      print('available user');
      randomuser = Provider.of<UserProvider>(context).user;
      return randomuser!;
    } else {
      UserRegister getuser = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userid)
          .get()
          .then((value) => UserRegister.fromMap(value));
      setState(() {
        randomuser = getuser;
      });
      return getuser;
    }
  }

  String owner = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AThemes.universalcolor,
      body: FutureBuilder<UserRegister>(
          future: getRandomuser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }

            if (snapshot.hasData) {
              var randomuser = snapshot.data;
              bool isowner = randomuser!.uid == owner ? true : false;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Text(
                      "${randomuser.username}",
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
                                        ? DecorationImage(
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
                                    icon: Icon(Icons.edit))
                                : Container()
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: <TextSpan>[
                            TextSpan(
                                text: '${randomuser.username} • ',
                                style: Theme.of(context).textTheme.bodyMedium!),
                            TextSpan(
                              text: '${randomuser.tag!}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.greenAccent,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(randomuser.bio!.isEmpty ? '-Bio-' : randomuser.bio!,
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
                              backgroundColor: Colors.grey[800],
                            ),
                            onPressed: () async {
                              FollowUser follow = FollowUser(
                                  userid: randomuser.uid,
                                  random_User_Followers: randomuser.followers);
                              await follow.follow();
                              await Provider.of<UserProvider>(context,
                                      listen: false)
                                  .getuser();
                            },
                            child: randomuser.followers.contains(owner)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person_remove_alt_1,size: 20,color: Colors.teal,),
                                      Text('  unfollow'),
                                    ]):Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Icon(Icons.person_add_alt_1,size: 20,color: Colors.blue,),
                                        Text('  follow'),
                                      ])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Upcoming....."),
                       isowner? TextButton(
                            onPressed: () {
                              String? destination;
                              destinationDialog(context, destination);
                            },
                            child: Text('Add')):Container()
                      ],
                    ),
                    randomuser.upcomingtrips.length == 0
                        ? Container(
                            height: 30,
                            width: 300,
                            child: Text(
                              '-----No upcoming plans-----',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ))
                        : SizedBox(
                            height: 90,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: randomuser.upcomingtrips.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                141, 135, 134, 134),
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.black54,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 70,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                                width: 150,
                                                child: Text.rich(
                                                    TextSpan(children: [
                                                  TextSpan(
                                                      text: "Next\n",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color: Colors
                                                                  .black)),
                                                  TextSpan(
                                                      text:
                                                          "${randomuser.upcomingtrips[index]}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                              color: Colors
                                                                  .white)),
                                                ])
                                                    // maxLines: 3,
                                                    )),
                                            Text("Destination",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        color: Colors.black))
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        right: 2,
                                        top: 2,
                                        child: GestureDetector(
                                            onTap: () async {
                                              var destination = randomuser
                                                  .upcomingtrips[index];
                                              DeleteTravelListItem db =
                                                  DeleteTravelListItem(
                                                      destination: destination);
                                              await db.deleteTravelList();
                                              await Provider.of<UserProvider>(
                                                      context,
                                                      listen: false)
                                                  .getuser();
                                            },
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: Colors.black45,
                                            )),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                    Container(
                      height: 60,
                      width: double.maxFinite,
                      child: Align(
                        alignment: Alignment.center,
                        child: TabBar(
                          isScrollable: true,
                          unselectedLabelColor: Colors.grey,
                          indicator: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(50), // Creates border
                              color: Colors.greenAccent),
                          automaticIndicatorColorAdjustment: true,
                          tabs: [
                            Tab(
                              icon: Icon(
                                Icons.grid_on,
                                color: Theme.of(context).tabBarTheme.labelColor,
                              ),
                            ),
                            Tab(
                              icon: Icon(Icons.person_pin),
                            ),
                            Tab(
                              icon: Icon(Icons.bookmark_border),
                            ),
                          ],
                          controller: tabController,
                        ),
                      ),
                    ),
                    Container(
                      height: 400,
                      child: TabBarView(controller: tabController, children: [
                        posts(randomuser),
                        Center(child: Text('Empty,\nComing soon!')),
                        Center(child: Text('Empty,\nComing soon!')),
                      ]),
                    ),
                  ],
                ),
              );
            }
            return Center(child: LoadingProgress());
          }),
    );
  }

  GridView posts(UserRegister user) {
    return GridView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 30 / 13,
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10),
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FollowingScreen(index: 1,userid: user.uid,username: user.username,))),
          child: countContainer(
              Icons.follow_the_signs, user.followers.length, "followers"),
        ),
        InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FollowingScreen(index: 0,userid: user.uid,username: user.username,))),
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
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
  DecoratedContainer({
    Key? key,
    this.URL,
    required this.text,
  }) : super(key: key);

  final String? URL;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.white, blurRadius: 12)],
          color: Colors.cyan,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      height: 160,
      // width: MediaQuery.of(context).size.width * 0.90,
      child: Stack(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              // child: Image.network(
              //   "https://wallpapers.com/images/featured/ibk7fgrvtvhs7qzg.jpg",
              //   fit: BoxFit.cover,
              // )
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.purple,
                  Colors.red,
                ]),
                boxShadow: [BoxShadow(color: Colors.white)],
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            width: double.infinity,
          ),
          Positioned(
              bottom: 30,
              left: 20,
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
