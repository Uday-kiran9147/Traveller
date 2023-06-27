import 'package:flutter/material.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard({
    Key? key,
    required this.destination,
  }) : super(key: key);
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
      child: Text(destination, textAlign: TextAlign.center,style: Theme.of(context).textTheme.labelMedium,),
    );
  }
}
