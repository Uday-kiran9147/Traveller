// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:intl/intl.dart';
import 'package:traveler/domain/models/travel_story.dart';
import 'package:traveler/domain/usecases/delete_travelstory.dart';
import 'package:traveler/presentation/pages/home/cubit/home_cubit_cubit.dart';
import 'package:traveler/presentation/pages/home/ui/widgets/text_container.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';

class StoryDetail extends StatelessWidget {
  TravelStory travelStory;
  StoryDetail({Key? key, required this.travelStory}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var curuser = BlocProvider.of<HomeCubitCubit>(context).state.user;
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(5),
            children: [
              if (travelStory.photos.isNotEmpty)
                  SizedBox(
                      height: 300,
                      child: Swiper(
                        autoplay: true,
                        itemCount: travelStory.photos.length,
                        loop: false,
                        itemBuilder: (context, index) {
                          return Image.network(travelStory.photos[index]);
                        },
                      ),
                    ),
             if(kDebugMode)
                Text(
                travelStory.photos.length.toString(),
                textAlign: TextAlign.end,
                ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey.shade300)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(travelStory.storyTitle,textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 30)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('@${travelStory.userName}',
                              style: Theme.of(context).textTheme.labelMedium),
                          Text(
                            DateFormat.yMd()
                                .format(DateTime.parse(travelStory.created_at)),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextContainer(
                        text: travelStory.travelStory,
                        selectableText: true,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Rating'),
              ),
              travelStory.destinationRating == null
                  ? Container()
                  : SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Icon(Icons.star,
                              color: index + 1 <= travelStory.destinationRating!
                                  ? Colors.amber[700]
                                  : Colors.grey);
                        },
                      ),
                    ),
              const SizedBox(
                height: 66,
              )
            ],
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width * 0.025,
            right: MediaQuery.of(context).size.width * 0.025,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: 66,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  travelStory.uid == curuser.uid
                      ? Expanded(
                          child: IconButton(
                              onPressed: () async {
                                DeleteTravelStory deleteTravelStory =
                                    DeleteTravelStory(storyid: travelStory.id);
                                await deleteTravelStory
                                    .deleteStory()
                                    .then((value) => customSnackbarMessage(
                                        value, context, Colors.green.shade300))
                                    .catchError((e) {
                                  customSnackbarMessage(
                                      e.toString(), context, Colors.red);
                                  Navigator.pop(context);
                                });
                              },
                              icon: const Icon(Icons.delete_outlined),
                              color: Colors.red),
                        )
                      : Container(),
                  Expanded(
                    child: IconButton(
                        onPressed: null,
                        icon: const Icon(Icons.share_outlined),
                        color: Colors.blue),
                  ),
                  Expanded(
                    child: IconButton(
                        onPressed: null,
                        icon: const Icon(Icons.comment_outlined)),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: null,
                            icon: const Icon(Icons.favorite_border_outlined)),
                        Text(
                          travelStory.likes.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
