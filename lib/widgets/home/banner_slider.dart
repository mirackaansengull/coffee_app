import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_app/data/repositorys/banner_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalMargin = 20.w * 2;
    final bannerWidth = screenWidth - horizontalMargin;
    final bannerHeight = 180.h;
    final imgList = BannerRepository.instance.getBannerImageUrls();

    return Container(
      width: bannerWidth,
      height: bannerHeight,
      margin: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
      child: CarouselSlider(
        options: CarouselOptions(
          height: bannerHeight,
          viewportFraction: 1,
          enlargeCenterPage: false,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
        ),
        items: imgList
            .map(
              (url) => ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: bannerWidth,
                  height: bannerHeight,
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFF2A2A2A),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF2A2A2A),
                      child: Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 24.w,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
