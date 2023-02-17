import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/common/widgets/image.dart';
import 'package:nike/constants/theme.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/product/bloc/product_bloc.dart';
import 'package:nike/ui/product/comment/comment_list.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductEntity product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  StreamSubscription<ProductState>? stateSubscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void dispose() {
    stateSubscription?.cancel();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return BlocProvider<ProductBloc>(
      create: (context) {
        final bloc = ProductBloc(cartRepository);
        stateSubscription = bloc.stream.listen((state) {
          if (state is ProductAddToCartSuccess) {
            _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                content: Text('با موفقیت به سبد خرید شما اضافه شد')));
          } else if (state is ProductAddToCartError) {
            _scaffoldKey.currentState?.showSnackBar(
                SnackBar(content: Text(state.exception.message)));
          }
        });
        return bloc;
      },
      child: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          floatingActionButton: SizedBox(
            width: MediaQuery.of(context).size.width - 60,
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return FloatingActionButton.extended(
                    onPressed: () {
                      BlocProvider.of<ProductBloc>(context)
                          .add(CartAddButtonClicked(widget.product.id));
                    },
                    label: state is ProductAddToCartLoading
                        ? CupertinoActivityIndicator(
                            color: themeData.colorScheme.onSecondary,
                          )
                        : Text('افزودن به سبد خرید'));
              },
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: CustomScrollView(
            physics: defaultScrollPhysics,
            slivers: [
              SliverAppBar(
                foregroundColor: LightThemeColors.primaryTextColor,
                actions: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(CupertinoIcons.heart)),
                ],
                expandedHeight: MediaQuery.of(context).size.width * 0.8,
                flexibleSpace:
                    ImageLoadingService(imageUrl: widget.product.imageUrl),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(
                            widget.product.title,
                            style: themeData.textTheme.headline6!
                                .copyWith(fontSize: 18),
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.product.previousPrice.withPriceLabel,
                                style: themeData.textTheme.caption!.apply(
                                    decoration: TextDecoration.lineThrough),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(widget.product.price.withPriceLabel)
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا هیج فشار مخربی رو نمیذارد به پا و زانوان شما انتقال داده شود.',
                        style: themeData.textTheme.bodyText2!
                            .copyWith(height: 1.5),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'نظرات کاربران',
                            style: themeData.textTheme.subtitle1,
                          ),
                          TextButton(
                              onPressed: () {}, child: const Text('ثبت نظر'))
                        ],
                      ),
                      Divider(
                        color: themeData.dividerColor,
                        height: 10,
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
              CommentList(productId: widget.product.id)
            ],
          ),
        ),
      ),
    );
  }
}
