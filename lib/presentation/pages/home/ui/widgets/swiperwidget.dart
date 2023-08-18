// import 'package:flutter/material.dart';
// import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
// import 'package:traveler/domain/models/travel_story.dart';
// import 'package:traveler/presentation/pages/home/ui/story_detail_screen.dart';

// class SwiperWidget extends StatelessWidget {
//   const SwiperWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Swiper(
//         scale: 0.9,
//         viewportFraction: 0.8,
//         pagination: SwiperPagination(),
//         itemCount: travell_List.length,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () {
//               var l = travell_List[index];
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => StoryDetail(
//                         travelStory: TravelStory(
//                             uid: l.uid,
//                             userName: l.userName,
//                             storyTitle: l.storyTitle,
//                             created_at: l.created_at,
//                             likes: l.likes,
//                             photos: l.photos,
//                             travelStory: l.travelStory,
//                             destinationRating: l.destinationRating)),
//                   ));
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 color: Colors.grey,
//               ),
//               width: 76,
//               height: 110,
//               margin: EdgeInsets.all(10),
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   ClipRRect(
//                       borderRadius: BorderRadius.all(Radius.circular(16.0)),
//                       child: Image.network(travell_List[index].photos[0],
//                           fit: BoxFit.cover)),
//                   Positioned(
//                       top: 20,
//                       left: 10,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: 250,
//                             height: 150,
//                             child: Text(
//                               travell_List[index].storyTitle,
//                               maxLines: 3,
//                               overflow: TextOverflow.ellipsis,
//                               style:
//                                   Theme.of(context).textTheme.headlineLarge,
//                             ),
//                           ),
//                           Text(travell_List[index].userName),
//                         ],
//                       )),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }


