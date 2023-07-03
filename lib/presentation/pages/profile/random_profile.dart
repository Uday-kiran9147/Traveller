// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:traveler/domain/models/user.dart';
import 'package:traveler/domain/repositories/database.dart';
import 'package:traveler/utils/routes/route_names.dart';

import '../../../config/theme/apptheme.dart';
import '../../providers/user_provider.dart';
import '../../widgets/dialogs.dart';

class RandomProfile extends StatefulWidget {
  final String uid;
  const RandomProfile({
    Key? key,
    required this.uid,
  }) : super(key: key);
  @override
  State<RandomProfile> createState() => _RandomProfile();
}

class _RandomProfile extends State<RandomProfile>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    tabController = TabController(
        length: 3,
        vsync:
            this); // extended this class with [SingleTickerProviderStateMixin] to get [vsync] attribute
    super.initState();
    getRandomuser();
  }

  UserRegister? user;

  getRandomuser() async {
    print("get user");
    UserRegister getuser = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((value) => UserRegister.fromMap(value));
    setState(() {
      user = getuser;
    });
    print("getuser done");
  }

  String owner = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context).user;
    bool isowner = widget.uid == owner ? true : false;
    print(user);
    return user == null
        ? Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: AThemes.universalcolor,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Text(
                    "${user!.username}",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(color: Colors.grey, blurRadius: 12)
                                ],
                                border: Border.all(color: Colors.orange),
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                    opacity: 0.75,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      user!.profileurl!,
                                    ))),
                          ),
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
                            text: user!.tag!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.greenAccent,
                                ),
                          ),
                          TextSpan(
                              text: ' • ${user!.username}',
                              style: Theme.of(context).textTheme.bodyMedium!),
                        ],
                      ),
                    ),
                  ),
                  isowner
                      ? Text(
                          user!.email,
                          textAlign: TextAlign.center,
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Upcoming.."),
                      isowner
                          ? TextButton(
                              onPressed: () {
                                String? destination;
                                destinationDialog(context, destination);
                              },
                              child: Text('Add'))
                          : Container()
                    ],
                  ),
                  user!.upcomingtrips.length == 0
                      ? Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.5, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          height: 20,
                          width: 300,
                          child: Text(
                            '-----No upcoming plans-----',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ))
                      : SizedBox(
                          height: 90,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: user!.upcomingtrips.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(141, 67, 67, 67),
                                          border: Border.all(
                                              width: 1, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height: 70,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                              width: 150,
                                              child:
                                                  Text.rich(TextSpan(children: [
                                                TextSpan(
                                                    text: "Next\n",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark)),
                                                TextSpan(
                                                    text:
                                                        "${user!.upcomingtrips[index]}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorLight)),
                                              ])
                                                      // maxLines: 3,
                                                      )),
                                          Text("on \nDec 2021",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColorDark))
                                        ],
                                      ),
                                    ),
                                    isowner
                                        ? Positioned(
                                            right: 2,
                                            top: 2,
                                            child: GestureDetector(
                                                onTap: () async {
                                                  var destination = user!
                                                      .upcomingtrips[index];
                                                  DatabaseService db =
                                                      DatabaseService();
                                                  await db.deleteTravelList(
                                                      destination);
                                                  await Provider.of<
                                                              UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .getuser();
                                                },
                                                child: Icon(Icons.close)),
                                          )
                                        : Container()
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                  Container(
                    height: 70,
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
                      posts(user!),
                      Text('1'),
                      Text('2'),
                    ]),
                  ),
                ],
              ),
            ),
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
        countContainer(
            Icons.follow_the_signs, user.followers.length, "folowers"),
        countContainer(
            Icons.follow_the_signs, user.following.length, "following"),
        countContainer(Icons.show_chart_rounded, user.reputation, "count"),
        countContainer(
            Icons.nature, user.upcomingtrips.length, "upcoming trips"),
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
        children: [Icon(Icons.person_2), Text(count.toString()), Text(text)],
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
