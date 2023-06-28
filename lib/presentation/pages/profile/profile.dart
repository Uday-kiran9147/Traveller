import 'package:flutter/material.dart';

import '../../../config/theme/apptheme.dart';

class Profile extends StatefulWidget {
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
            this); // extended this class with SingleTickerProviderStateMixin to get vsync attribute

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AThemes.universalcolor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text(
              "Profile",
              style: TextStyle(fontSize: 30),
            ),
            DecoratedContainer(
              text: 'iamuday',
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
                      borderRadius: BorderRadius.circular(50), // Creates border
                      color: Colors.greenAccent),
                  automaticIndicatorColorAdjustment: true,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.grid_on,
                        color: Colors.amber,
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
                posts(),
                Text('1'),
                Text('2'),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  GridView posts() {
    return GridView(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 30 / 13,
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10),
      children: [
        countContainer(),
        countContainer(),
        countContainer(),
        countContainer(),
      ],
    );
  }

  Container countContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.person_2), Text("2853"), Text("likes")],
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
                child: Image.network(
                  "https://wallpapers.com/images/featured/ibk7fgrvtvhs7qzg.jpg",
                  fit: BoxFit.cover,
                )),
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
