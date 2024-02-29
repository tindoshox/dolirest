import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/shimmer_skeleton.dart';

class InvoiceListLoadingTile extends StatelessWidget {
  const InvoiceListLoadingTile({
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ShimmerSkeleton(
                  height: 20,
                  width: 160,
                ),
              ),
              Flexible(
                child: SizedBox(
                  width: 50,
                ),
              ),
              Flexible(
                child: ShimmerSkeleton(
                  height: 20,
                  width: 145,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ShimmerSkeleton(
                  height: 15,
                  width: 150,
                ),
              ),
              Flexible(
                child: SizedBox(
                  width: 120,
                ),
              ),
              Flexible(
                child: ShimmerSkeleton(
                  height: 15,
                  width: 100,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          ShimmerSkeleton(
            height: 15,
            width: 150,
          )
        ],
      ),
    );
  }
}
