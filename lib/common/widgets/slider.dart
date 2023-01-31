import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nike/common/widgets/image.dart';
import 'package:nike/data/banner.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({
    Key? key,
    required this.banners,
  }) : super(key: key);
  final List<BannerEntity> banners;

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        children: [
          CarouselSlider.builder(
              itemCount: widget.banners.length,
              itemBuilder: (context, index, realIndex) {
                final banner = widget.banners[index];
                return _Slide(banner: banner);
              },
              options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  viewportFraction: 1,
                  aspectRatio: 2,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlay: true)),
          Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: Center(
                child: AnimatedSmoothIndicator(
                  axisDirection: Axis.horizontal,
                  activeIndex: currentPage,
                  count: widget.banners.length,
                  effect: WormEffect(
                      spacing: 4,
                      radius: 4,
                      dotWidth: 20,
                      dotHeight: 3,
                      paintStyle: PaintingStyle.fill,
                      strokeWidth: 1.5,
                      dotColor: Colors.grey.shade400,
                      activeDotColor: themeData.colorScheme.onBackground),
                ),
              ))
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    Key? key,
    required this.banner,
  }) : super(key: key);

  final BannerEntity banner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: ImageLoadingService(
        imageUrl: banner.imageUrl,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
