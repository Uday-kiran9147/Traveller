import 'package:flutter/material.dart';

class DestinationCard extends StatelessWidget {
  final String imageurl;

  const DestinationCard(
      {Key? key, required this.imageurl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade200,
      ),
      width: 76,
      height: 100,
      margin: const EdgeInsets.only(right: 10, bottom: 10, top: 10),
      child: Container(
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: Image.network(
              imageurl,
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
