import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({super.key});

  static const List<String> _imgList = [
    'https://r.resimlink.com/g-5eUFwuD.webp',
    'https://r.resimlink.com/gmkvRDO.webp',
    'https://r.resimlink.com/pbYv9M.webp',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      margin: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 180.h,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 1,
        ),
        items: _imgList
            .map(
              (item) => ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  item,
                  fit: BoxFit.cover,
                  width: double.infinity,
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
            )
            .toList(),
      ),
    );
  }
}
