import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/presentation/pages/explore/ui/following_screen.dart';
import 'package:traveler/presentation/pages/home/ui/drawer/add_story_screen.dart';
import 'package:traveler/presentation/pages/home/ui/drawer/fab_icons.dart';
import 'package:traveler/presentation/pages/home/ui/drawer/story_list.dart';
import '../../../../domain/models/user.dart';
import '../../explore/ui/newpost_screen.dart';
import '../cubit/home_cubit_cubit.dart';
import 'widgets/drawer.dart';

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
              child: buildDrawer(context, state),
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  scrolledUnderElevation: 20,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  title: FutureBuilder(
                      future: state.getuser(),
                      builder: (context, AsyncSnapshot<UserRegister> snapshot) {
                        final counterstate = context
                            .select((HomeCubitCubit value) => value.state.user);
                        return Text(
                          "Hi, ${counterstate.username}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      }),
                  elevation: 5,
                  floating: true, snap: true,
                  // onStretchTrigger:// for refreshing page
                ),
                // SliverToBoxAdapter(
                //   child: SizedBox(
                //     height: 50,
                //     child: AnimatedTextKit(
                //       animatedTexts: [
                //         ColorizeAnimatedText(
                //           ' Recent stories.....',
                //           textStyle: Theme.of(context).textTheme.bodyLarge!,
                //           colors: [
                //             Colors.blue,
                //             Colors.yellow,
                //             Colors.grey,
                //           ],
                //         ),
                //       ],
                //       isRepeatingAnimation: true,
                //       onTap: () {},
                //     ),
                //   ),
                // ),
                SliverToBoxAdapter(child: ExploreScreen()),
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
                        child: Container(
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
                        ),
                      )),
                )
              ],
            ),
            floatingActionButton: ExpandableFab(
              distance: 60.0,
              children: [
                ActionButton(key:Key('new_post'),
                  onPressed: () {
                     Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return const NewPostScreen();
                    })));
                  },
                  icon: const Icon(Icons.add_a_photo),
                ),
                ActionButton(
                  key: Key('new_story'),
                  onPressed: () {
                     Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return const AddStoryScreen();
                    })));
                  },
                  icon: const Icon(Icons.text_fields_rounded),
                ),
              ],
              initialOpen: false,
            ));
      },
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
