import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  double? height, width;
  ShimmerWidget({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        direction: ShimmerDirection.ltr,
        child: Container(
          height: height ?? 50,
          width: width ?? MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10)),
        ),
      );
  }
}