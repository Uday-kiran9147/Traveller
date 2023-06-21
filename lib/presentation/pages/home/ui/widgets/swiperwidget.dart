
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

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
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.pink,
            ),
            width: 76,
            height: 110,
            margin: EdgeInsets.all(10),
            child: Text("destination",
                textAlign: TextAlign.center),
          );
        });
  }
}