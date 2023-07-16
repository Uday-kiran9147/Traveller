import 'package:flutter/material.dart';

class DestinationCard extends StatelessWidget {
  final String imageurl;

  const DestinationCard(
      {Key? key, required this.destination, required this.imageurl})
      : super(key: key);
  final String destination;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color.fromARGB(255, 88, 3, 85),
      ),
      width: 76,
      height: 110,
      margin: EdgeInsets.only(right: 10, bottom: 10, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Image.network(
                  imageurl,
                  fit: BoxFit.fitWidth,
                )),
          ),
          Text(
            destination,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
