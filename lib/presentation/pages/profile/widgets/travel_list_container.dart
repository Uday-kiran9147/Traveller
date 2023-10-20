
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/domain/models/user.dart';
import 'package:traveler/presentation/pages/profile/cubit/profile_cubit.dart';

class TravelListWIdget extends StatelessWidget {
  const TravelListWIdget({
    super.key,
    required this.randomuser,
    required this.isowner,
  });

  final UserRegister? randomuser;
  final bool isowner;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: randomuser!.upcomingtrips.length,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              const EdgeInsets.only(right: 8.0),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        141, 135, 134, 134),
                    border: Border.all(
                      width: 1,
                      color: Colors.black54,
                    ),
                    borderRadius:
                        BorderRadius.circular(10)),
                height: 70,
                width: MediaQuery.of(context)
                        .size
                        .width *
                    0.8,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: 150,
                        child: Text.rich(
                            TextSpan(children: [
                          TextSpan(
                              text: "Next\n",
                              style: Theme.of(
                                      context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Colors
                                          .black)),
                          TextSpan(
                              text:
                                  "${randomuser!.upcomingtrips[index]}",
                              style: Theme.of(
                                      context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Colors
                                          .white)),
                        ])
                            // maxLines: 3,
                            )),
                    Text("Destination",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                color:
                                    Colors.black))
                  ],
                ),
              ),
             isowner? Positioned(
                right: 2,
                top: 2,
                child: GestureDetector(
                    onTap: () async {
                      var destination = randomuser!
                          .upcomingtrips[index];
                      await context
                          .read<ProfileCubit>()
                          .deleteDestination(
                              destination)
                          .then((value) {
                        print(value);
                      });
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.black45,
                    )),
              ):Container()
            ],
          ),
        );
      },
    );
  }
}
