import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:traveler/data/datasources/local/travel_story.dart';
import 'package:traveler/domain/models/travel_story.dart';
import 'package:traveler/presentation/pages/home/ui/widgets/story_detail_screen.dart';

class SwiperWidget extends StatelessWidget {
  const SwiperWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Swiper(
        scale: 0.9,
        viewportFraction: 0.8,
        pagination: SwiperPagination(),
        itemCount: travel_List.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              var l = travel_List[index];
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryDetail(
                        travelStory: TravelStory(
                            uid: l.uid,
                            userName: l.userName,
                            storyTitle: l.storyTitle,
                            created_at: l.created_at,
                            likes: l.likes,
                            photos: l.photos,
                            travelStory: l.travelStory,
                            destinationRating: l.destinationRating)),
                  ));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey,
              ),
              width: 76,
              height: 110,
              margin: EdgeInsets.all(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      child: Image.network(travel_List[index].photos[0],
                          fit: BoxFit.cover)),
                  Positioned(
                      top: 20,
                      left: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 250,
                            height: 150,
                            child: Text(
                              travel_List[index].storyTitle,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                          Text(travel_List[index].userName),
                        ],
                      )),
                ],
              ),
            ),
          );
        });
  }
}

List netimage = [
  "https://www.businessdestinations.com/wp-content/uploads/2019/08/Vitoria-Gasteiz.jpg",
  "https://www.holidify.com/images/bgImages/PARIS.jpg",
  "https://www.cndenglish.com/sites/default/files/Article/Egipto%201.jpg",
  "https://travellemming.com/wp-content/uploads/2018/12/BestinTravel.jpg",
  "https://hips.hearstapps.com/hmg-prod/images/hbz-untapped-destinations-madagascar-gettyimages-468053398-1560982027.jpg"
];
