import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shop_app/config/responsive.dart';

class DeepLinks extends StatelessWidget {
  final String image;
  final String title;

  const DeepLinks({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 70.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: CachedNetworkImage(
              imageUrl: image,
              placeholder: (context, url) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: const SizedBox(width: 50.0, height: 50.0),
                );
              },
              fit: BoxFit.cover,
              useOldImageOnUrlChange: true,
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          title,
          style: TextStyle(fontSize: Responsive.isMobile(context) ? 11 : 18),
        ),
      ],
    );
  }
}
