import 'package:flutter/material.dart';
import 'package:notebook/utils/skeleton_type.dart';
import 'package:shimmer/shimmer.dart';

class ListSkeleton extends StatelessWidget {
  final SkeletonType skeletonType;

  const ListSkeleton({Key? key, required this.skeletonType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 3, 16, 16),
      itemCount: 10, // TODO: generate this quantity based on screen size
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: queryData.size.width ~/ 190,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) => Skeleton(skeletonType: skeletonType),
    );
  }
}

class Skeleton extends StatelessWidget {
  final SkeletonType skeletonType;

  const Skeleton({Key? key, required this.skeletonType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Shimmer.fromColors(
          baseColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[600]!
              : Colors.grey[100]!,
          highlightColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]!
              : Colors.grey[300]!,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 23,
                  height: 15,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                height: 23,
                color: Colors.white,
              ),
              if (skeletonType == SkeletonType.COLLECTION) SizedBox(height: 4),
              if (skeletonType == SkeletonType.COLLECTION)
                Container(
                  width: constraints.maxWidth * 0.6,
                  height: 23,
                  color: Colors.white,
                ),
              if (skeletonType == SkeletonType.DASHBOARD) SizedBox(height: 6),
              if (skeletonType == SkeletonType.DASHBOARD)
                Container(
                  width: double.infinity,
                  height: 15,
                  color: Colors.white,
                ),
              if (skeletonType == SkeletonType.DASHBOARD) SizedBox(height: 4),
              if (skeletonType == SkeletonType.DASHBOARD)
                Container(
                  width: constraints.maxWidth * 0.6,
                  height: 15,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
