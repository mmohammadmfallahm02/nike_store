import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/common/widgets/image.dart';
import 'package:nike/data/product.dart';
import 'package:nike/ui/product/details.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(
      {Key? key,
      required this.product,
      required this.themeData,
      required this.borderRadius})
      : super(key: key);

  final ProductEntity product;
  final ThemeData themeData;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                    product: product,
                  )));
        },
        child: SizedBox(
          width: 176,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                      aspectRatio: 0.93,
                      child: ImageLoadingService(
                        imageUrl: product.imageUrl,
                        borderRadius: borderRadius,
                      )),
                  Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        height: 32,
                        width: 32,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const Icon(
                          CupertinoIcons.heart,
                          size: 20,
                        ),
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                child: Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  product.previousPrice.withPriceLabel,
                  style: themeData.textTheme.caption!
                      .apply(decoration: TextDecoration.lineThrough),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Text(product.price.withPriceLabel),
              )
            ],
          ),
        ),
      ),
    );
  }
}
