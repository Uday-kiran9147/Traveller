import 'package:flutter/material.dart';
import 'package:traveler/presentation/pages/home/ui/widgets/swiperwidget.dart';

class StoryListScreen extends StatelessWidget {
  const StoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: 70,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              SizedBox(
                height: 5,
              ),
              _build_Card(),
              Positioned(
                top: 30,
                left: 30,
                child: CircleAvatar(
                  radius: 30,
                ),
              ),
              _build_avatar(),
              _build_Title_user(context),
            ],
          );
        },
      ),
    );
  }

  Positioned _build_Title_user(BuildContext context) {
    return Positioned(
              left: 30,
              bottom: 30,
              child: Column(
                children: [
                  Text('@uday_krn'),
                  Text(
                    'Cevin Sephora',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
            );
  }

  Positioned _build_avatar() {
    return Positioned(
              right: 30,
              top: 30,
              child: Container(
                width: 50,
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('14'), Text('Dec')],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
  }

  Padding _build_Card() {
    return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 380,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(netimage[2], fit: BoxFit.cover)),
                ),
              ),
            );
  }
}
