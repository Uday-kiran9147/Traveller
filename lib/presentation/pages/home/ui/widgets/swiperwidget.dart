
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
            child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(16.0)),child: Image.network(netimage[index], fit: BoxFit.cover)),
          );
        });
  }
}

List netimage=[
  "https://www.businessdestinations.com/wp-content/uploads/2019/08/Vitoria-Gasteiz.jpg",
  "https://www.holidify.com/images/bgImages/PARIS.jpg",
  "https://www.cndenglish.com/sites/default/files/Article/Egipto%201.jpg",
  "https://travellemming.com/wp-content/uploads/2018/12/BestinTravel.jpg",
  "https://hips.hearstapps.com/hmg-prod/images/hbz-untapped-destinations-madagascar-gettyimages-468053398-1560982027.jpg"

];