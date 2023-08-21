import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/config/theme/apptheme.dart';
import 'package:traveler/domain/models/user.dart';
import 'package:traveler/domain/usecases/signout.dart';
import 'package:traveler/presentation/pages/home/ui/story_list.dart';
import 'package:traveler/presentation/providers/user_provider.dart';
import '../../../../data/datasources/local/urls.dart';
import '../../../../domain/models/travel_story.dart';
import '../../../../utils/routes/route_names.dart';
import '../bloc/home_bloc_bloc.dart';
import 'story_detail_screen.dart';
import 'widgets/destination_box.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeBlocBloc homeBlocBloc;
  HomeScreen({
    Key? key,
    required this.homeBlocBloc,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isloading = false;
  UserRegister? user;
  /* 
   initialization based on inherited widgets can be placed in the didChangeDependencies method,
   which is called after initState and whenever the dependencies change thereafter.
   */
  @override
  void didChangeDependencies() {
    getuser();
    super.didChangeDependencies();
  }

  StoryListScreen storyListScreen = StoryListScreen();
  Stream<QuerySnapshot> _travelstorytstream =
      FirebaseFirestore.instance.collection("travelstory").snapshots();
  getuser() async {
    Provider.of<UserProvider>(context, listen: true).getuser();
    user = Provider.of<UserProvider>(context).user;
  }

  @override
  Widget build(BuildContext context) {
    return isloading || user == null || user!.username.isEmpty
        ? Scaffold(
            backgroundColor: AThemes.universalcolor,
            body: Center(
              child: LoadingProgress(),
            ),
          )
        : Scaffold(
            endDrawer: Drawer(
              backgroundColor: Colors.grey.shade200,
              elevation: 15,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    child: Column(
                      children: [
                        (user!.profileurl == null ||
                                user!.profileurl!.startsWith('http') == false)
                            ? CircleAvatar(
                                radius: 55,
                                backgroundImage:
                                    AssetImage('assets/noimage.png'),
                              )
                            : CircleAvatar(
                                radius: 55,
                                backgroundImage:
                                    NetworkImage(user!.profileurl!)),
                        Text(
                          user!.username,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                      onTap: () async {
                        bool isSignout = await SignOut.signoutuser();
                        if (isSignout) {
                          Navigator.pushNamedAndRemoveUntil(context,
                              RouteName.authentication, (route) => false);
                        } // remove the drawer
                      },
                      leading: Icon(
                        Icons.logout_outlined,
                        color: Colors.red,
                      ),
                      title: Text("logout",
                          style: TextStyle(
                            color: Colors.red,
                          ))),
                  ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryListScreen(),
                            ));
                      },
                      leading: Icon(
                        Icons.bubble_chart,
                        color: Colors.blue,
                      ),
                      title: Text(
                        "Stories",
                        style: TextStyle(color: Colors.blue),
                      )),
                  ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.addstory);
                      },
                      leading: Icon(
                        Icons.bubble_chart,
                        color: Colors.blue,
                      ),
                      title: Text(
                        "Add story",
                        style: TextStyle(color: Colors.blue),
                      )),
                ],
              ),
            ),
            appBar: AppBar(
              // backgroundColor: AThemes.universalcolor,
              title: Text(
                "Hi, ${user?.username}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            // backgroundColor: AThemes.universalcolor,
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        Text(
                          '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        DestinationCard(
                          imageurl: netimage[netimage.length - 1 - index],
                        ),
                      ]);
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        ' Recent stories.....',
                        textStyle: TextStyle(
                          fontSize: 30.0,
                        ),
                        colors: [
                          Colors.blue,
                          Colors.yellow,
                          Colors.green
                        ],
                      ),
                    ],
                    isRepeatingAnimation: true,
                    onTap: () {},
                  ),
                ),
                Container(
                  height: 390,
                  width: double.infinity,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _travelstorytstream,
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data.toString().isEmpty) {
                          return const Center(child: Text('No posts yet'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: LoadingProgress());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong'));
                        }
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        if (documents.isEmpty) {
                          return const Center(child: Text('No posts yet'));
                        }
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            var data =
                                documents[index].data() as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StoryDetail(
                                            travelStory: TravelStory(
                                                uid: data['uid'],
                                                userName: data['userName'],
                                                storyTitle: data['storyTitle'],
                                                created_at: data['created_at'],
                                                likes: data['likes'],
                                                photos: data['photos'],
                                                travelStory:
                                                    data['travelStory'],
                                                destinationRating:
                                                    data['destinationRating'],
                                                id: data['id']))));
                              },
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  storyListScreen.build_Card(
                                      data['photos'].length == 0
                                          ? null
                                          : data['photos'][0]),
                                  // Positioned(
                                  //   top: 30,
                                  //   left: 30,
                                  //   child: CircleAvatar(
                                  //     radius: 30,
                                  //   ),
                                  // ),
                                  storyListScreen.build_Date(),
                                  storyListScreen.build_Title_username(
                                      index,
                                      context,
                                      data['storyTitle'],
                                      data['userName'])
                                ],
                              ),
                            );
                          },
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(onTap: () =>{
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryListScreen(),
                            ))},
                      child: Text('Load more stories?',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),textAlign: TextAlign.center,)),
                )
              ],
            ),
          );
  }
}

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Colors.greenAccent,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }
}
