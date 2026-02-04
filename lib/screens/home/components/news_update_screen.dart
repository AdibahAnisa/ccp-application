import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';

class NewsUpdateScreen extends StatefulWidget {
  final List<PromotionMonthlyPassModel> promotionMonthlyPassModel;
  const NewsUpdateScreen({
    super.key,
    required this.promotionMonthlyPassModel,
  });

  @override
  State<NewsUpdateScreen> createState() => _NewsUpdateScreenState();
}

class _NewsUpdateScreenState extends State<NewsUpdateScreen> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.promotionMonthlyPassModel
        .map((item) => ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(item.image!,
                    fit: BoxFit.contain, width: 1000.0),
              ),
            ))
        .toList();
    if (imageSliders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: imageSliders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.production_quantity_limits_outlined,
                      color: kGrey,
                      size: 100,
                    ),
                    spaceVertical(height: 10.0),
                    Text(
                      AppLocalizations.of(context)!.newsDesc,
                      style: textStyleNormal(
                        color: kGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                height: 270,
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Title inside container
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        AppLocalizations.of(context)!.newsUpdate,
                        style: textStyleNormal(
                          color: kBlack,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // ✅ Carousel
                    Expanded(
                      child: CarouselSlider(
                        items: imageSliders,
                        carouselController: _controller,
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.5,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.promotionMonthlyPassModel
                          .asMap()
                          .entries
                          .map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ));
  }
}
