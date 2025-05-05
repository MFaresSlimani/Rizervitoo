import 'package:flutter/material.dart';

class AgencyOffer extends StatelessWidget {
  final String agencyName;
  final String agencyImage;

  const AgencyOffer({
    super.key,
    required this.agencyName,
    required this.agencyImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.blue,
        image: DecorationImage(
          image: AssetImage(agencyImage),
          fit: BoxFit.cover,
        ),
      ),
    ));
  }
}
