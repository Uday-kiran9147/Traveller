import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/config/theme/apptheme.dart';
import 'package:traveler/domain/models/user.dart';
import 'package:traveler/domain/usecases/signout.dart';
import 'package:traveler/presentation/pages/home/ui/story_list.dart';
import 'package:traveler/presentation/providers/user_provider.dart';
import '../../../../data/datasources/local/urls.dart';
import '../../../../utils/routes/route_names.dart';
import '../bloc/home_bloc_bloc.dart';
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
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      height: 150,
                      width: 150,
                      child: (user!.profileurl == null ||
                              user!.profileurl!.startsWith('http') == false)
                          ? CircleAvatar(
                              backgroundImage: AssetImage('assets/noimage.png'),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(user!.profileurl!),
                            )),Text(user!.username,textAlign: TextAlign.center,),
                  Divider(),
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
                        Icons.circle,
                        color: Colors.green,
                      ),
                      title: Text(
                        "Stories",
                      )),
                  ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.addstory);
                      },
                      leading: Icon(
                        Icons.add_circle_outline_outlined,
                        color: Colors.green,
                      ),
                      title: Text("Add story")),
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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 148,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Column(children: [
                            Text(
                              'Africa $index',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            DestinationCard(
                              imageurl: netimage[netimage.length - 1 - index],
                            ),
                          ]);
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 7,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                fillColor: AThemes.universalcolor,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                              ),
                            )),
                        Expanded(
                          child: Container(
                            child: Icon(Icons.filter_alt_outlined),
                            decoration: BoxDecoration(),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 400, //392,
                      width: double.maxFinite,
                      // child: SwiperWidget()
                    ),
                  ],
                ),
              ),
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
