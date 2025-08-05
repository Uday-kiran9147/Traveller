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
      appBar: AppBar(
        title: Text(
          'Story Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (travelStory.photos.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 260,
                    child: Swiper(
                      autoplay: true,
                      itemCount: travelStory.photos.length,
                      loop: false,
                      pagination: const SwiperPagination(),
                      itemBuilder: (context, index) {
                        return Image.network(
                          travelStory.photos[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) =>
                              progress == null
                                  ? child
                                  : Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),
                ),
              if (kDebugMode)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Photos: ${travelStory.photos.length}',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha:0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        travelStory.storyTitle,
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.blueGrey,
                                child: Icon(Icons.person, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '@${travelStory.userName}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                          Text(
                            DateFormat.yMMMd()
                                .format(DateTime.parse(travelStory.created_at)),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextContainer(
                        text: travelStory.travelStory,
                        selectableText: true,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Text('Rating', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  if (travelStory.destinationRating != null)
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star_rounded,
                          color: index + 1 <= travelStory.destinationRating!
                              ? Colors.amber[700]
                              : Colors.grey[300],
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha:0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (travelStory.uid == curuser.uid)
                    IconButton(
                      tooltip: 'Delete',
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
                      icon: const Icon(Icons.delete_outline_rounded),
                      color: Colors.red[400],
                    ),
                  IconButton(
                    tooltip: 'Share',
                    onPressed: null,
                    icon: const Icon(Icons.share_outlined),
                    color: Colors.blue[400],
                  ),
                  IconButton(
                    tooltip: 'Comment',
                    onPressed: null,
                    icon: const Icon(Icons.comment_outlined),
                    color: Colors.grey[700],
                  ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Like',
                        onPressed: null,
                        icon: const Icon(Icons.favorite_border_outlined),
                        color: Colors.pink[300],
                      ),
                      Text(
                        travelStory.likes.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
