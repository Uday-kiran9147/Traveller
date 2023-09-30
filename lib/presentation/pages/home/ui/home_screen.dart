import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/domain/usecases/signout.dart';
import 'package:traveler/presentation/pages/home/ui/story_list.dart';
import '../../../../data/datasources/local/urls.dart';
import '../../../../domain/models/travel_story.dart';
import '../../../../domain/models/user.dart';
import '../../../../utils/routes/route_names.dart';
import '../cubit/home_cubit_cubit.dart';
import 'story_detail_screen.dart';
import 'widgets/destination_box.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isloading = false;
  /* 
   initialization based on inherited widgets can be placed in the didChangeDependencies method,
   which is called after initState and whenever the dependencies change thereafter.
   */
  @override
  void initState() {
    getuser();
    super.initState();
  }

  StoryListScreen storyListScreen = StoryListScreen();
  final Stream<QuerySnapshot> _travelstorytstream =
      FirebaseFirestore.instance.collection("travelstory").snapshots();
  getuser() async {
    await BlocProvider.of<HomeCubitCubit>(context, listen: false)
        .state
        .getuser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubitCubit, HomeCubitState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          endDrawer: Drawer(
            backgroundColor: Colors.grey.shade200,
            elevation: 15,
            child: _buildDrawer(context, state),
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(scrolledUnderElevation: 20,backgroundColor: Theme.of(context).primaryColor,
                title:  FutureBuilder(
                future: state.getuser(),
                builder: (context, AsyncSnapshot<UserRegister> snapshot) {
                  final counterstate = context.select((HomeCubitCubit value) => value.state.user);
                  return Text(
                    "Hi, ${counterstate.username}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                }),
                elevation: 5,
                floating: true,snap: true,
                // onStretchTrigger:// for refreshing page
              ),
              SliverToBoxAdapter(
                child: SizedBox(
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
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        ' Recent stories.....',
                        textStyle: const TextStyle(
                          fontSize: 30.0,
                        ),
                        colors: [Colors.blue,Colors.purple,Colors.indigo,Colors.orange,],
                      ),
                    ],
                    isRepeatingAnimation: true,
                    onTap: () {},
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 450,
                  width: double.infinity,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _travelstorytstream,
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data.toString().isEmpty) {
                          return const Center(child: Text('No posts yet'));
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
                          physics: const NeverScrollableScrollPhysics(),
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
                                                travelStory: data['travelStory'],
                                                destinationRating:
                                                    data['destinationRating'],
                                                id: data['id']))));
                              },
                              child: Stack(
                                children: [
                                  const SizedBox(
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
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryListScreen(),
                                ))
                          },
                      child:Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.blue,
                      ),
                      child: Text(
                        'Load more stories?',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),)
                ),
              )
            ],
          ),
        );
      },
    );
  }

  ListView _buildDrawer(BuildContext context, HomeCubitState state) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.grey.shade300),
          child: Column(
            children: [
              (state.user.profileurl == null ||
                      state.user.profileurl!.startsWith('http') == false)
                  ? const CircleAvatar(
                      radius: 53,
                      backgroundImage: AssetImage('assets/noimage.png'),
                    )
                  : CircleAvatar(
                      radius: 53,
                      backgroundImage: NetworkImage(state.user.profileurl!)),
              Text(
                state.user.username,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        ListTile(
            onTap: () async {
              bool isSignout = await SignOut.signoutuser();
              if (isSignout) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteName.authentication, (route) => false);
              } // remove the drawer
            },
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
            title: const Text("logout",
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
            leading: const Icon(
              Icons.bubble_chart,
              color: Colors.blue,
            ),
            title: const Text(
              "Stories",
              style: TextStyle(color: Colors.blue),
            )),
        ListTile(
            onTap: () {
              Navigator.pushNamed(context, RouteName.addstory);
            },
            leading: const Icon(
              Icons.bubble_chart,
              color: Colors.blue,
            ),
            title: const Text(
              "Add story",
              style: TextStyle(color: Colors.blue),
            )),
      ],
    );
  }
}

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      backgroundColor: Colors.greenAccent,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }
}
