import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/shimmer_skeleton.dart';

class ThirdPartyListLoadingTile extends StatelessWidget {
  const ThirdPartyListLoadingTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.grey.shade500,
      baseColor: Colors.grey.shade800,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerSkeleton(
            height: 20,
            width: 275,
          ),
          SizedBox(
            height: 5,
          ),
          ShimmerSkeleton(
            height: 15,
            width: 250,
          ),
        ],
      ),
    );
  }
}
