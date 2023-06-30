import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/config/theme/apptheme.dart';
import 'package:traveler/domain/models/user.dart';
import 'package:traveler/presentation/providers/user_provider.dart';
import '../../../../domain/repositories/authentication.dart';
import '../../../../utils/routes/route_names.dart';
import '../bloc/home_bloc_bloc.dart';
import 'widgets/destination_box.dart';
import 'widgets/swiperwidget.dart';

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
    setState(() {
      isloading = true;
    });
    Provider.of<UserProvider>(context).getuser();
    user = Provider.of<UserProvider>(context).user;

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading || user == null
        ? Scaffold(
            backgroundColor: AThemes.universalcolor,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AThemes.universalcolor,
              actions: [
                IconButton(
                    onPressed: () async {
                      GoogleAuth auth = GoogleAuth();
                      bool isSignout = await auth.signoutuser();
                      if (isSignout) {
                        Navigator.pushNamedAndRemoveUntil(context,
                            RouteName.authentication, (route) => false);
                      }
                    },
                    icon: Icon(Icons.logout))
              ],
              title: Text(
                "${user?.username}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            backgroundColor: AThemes.universalcolor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return DestinationCard(
                            destination: 'Africa $index',
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: TextField(
                            scrollPadding: EdgeInsets.all(8),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'search country or list',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Icon(Icons.filter_alt_outlined),
                            decoration: BoxDecoration(),
                          ),
                        )
                      ],
                    ),
                    Container(
                        height: 330, //392,
                        width: double.maxFinite,
                        // decoration: BoxDecoration(color: Colors.green),
                        child: SwiperWidget()),
                    Text(user!.reputation.toString() == null
                        ? "hsldfh"
                        : user!.reputation.toString()),
                    Text(user!.tag.toString()),
                    Text(user!.bio.toString()),
                  ],
                ),
              ),
            ),
          );
  }
}
