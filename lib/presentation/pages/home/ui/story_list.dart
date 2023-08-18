import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:traveler/domain/usecases/delete_travelstory.dart';
import '../../../../domain/models/travel_story.dart';
import 'home_screen.dart';
import 'story_detail_screen.dart';

class StoryListScreen extends StatefulWidget {
  const StoryListScreen({super.key});

  @override
  State<StoryListScreen> createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
   Stream<QuerySnapshot> _poststream = FirebaseFirestore.instance
      .collection("travelstory")
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
          stream: _poststream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data.toString().isEmpty) {
              return const Center(child: Text('No posts yet'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingProgress());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            List<DocumentSnapshot> documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return const Center(child: Text('No posts yet'));
            }
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var data = documents[index].data() as Map<String, dynamic>;
                return GestureDetector(
                  onLongPress: ()async{
                    DeleteTravelStory deleteTravelStory = DeleteTravelStory(storyid: data['id']);
                    await deleteTravelStory.deleteStory();
                  },
                  onTap: (){
                    print(data['photos']);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryDetail(
                        travelStory: TravelStory(
                            uid:data['uid'],
                            userName:data['userName'],
                            storyTitle:data['storyTitle'],
                            created_at:data['created_at'],
                            likes:data['likes'],
                            photos:data['photos'],
                            travelStory:data['travelStory'],
                            destinationRating:data['destinationRating'], id: data['id']))));
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      _build_Card(data['photos'].length==0?null:data['photos'][0]),
                      Positioned(
                        top: 30,
                        left: 30,
                        child: CircleAvatar(
                          radius: 30,
                        ),
                      ),
                      _build_Date(),
                      _build_Title_username(index, context,data['storyTitle'],data['userName'])
                    ],
                  ),
                );
              },
            );
          }),
    );
  }

  Positioned _build_Title_username(int index, BuildContext context,String title,String username) {
    return Positioned(
        left: 30,
        bottom: 30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 250,
              height: 150,
              child: Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Text(username),
          ],
        ));
  }

  Positioned _build_Date() {
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

  Padding _build_Card(String? image0) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          height: 380,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child:image0==null?Container(color: Colors.grey,): Image.network(image0, fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
