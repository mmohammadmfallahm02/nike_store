import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/common/widgets/error.dart';
import 'package:nike/common/widgets/slider.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/banner_repository.dart';
import 'package:nike/data/repo/product_repository.dart';
import 'package:nike/gen/assets.gen.dart';
import 'package:nike/ui/home/bloc/home_bloc.dart';
import 'package:nike/ui/product/product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final ThemeData themeData = Theme.of(context);
    return BlocProvider(
      create: (context) => HomeBloc(
          bannerRepository: bannerRepository,
          productRepository: productRepository)
        ..add(HomeStarted()),
      child: Scaffold(
          // backgroundColor: Colors.yellow,
          body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeSuccess) {
              return ListView.builder(
                  itemCount: 5,
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 100),
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 12),
                          child:
                              Assets.images.nikeLogo.image(height: size / 15),
                        );
                      case 2:
                        return BannerSlider(
                          banners: state.banners,
                        );
                      case 3:
                        return HorizontalProductList(
                          onTap: () {},
                          products: state.latestProducts,
                          title: 'جدیدترین',
                          themeData: themeData,
                        );
                      case 4:
                        return HorizontalProductList(
                            themeData: themeData,
                            title: 'پربازدیدترین',
                            products: state.popularProducts,
                            onTap: () {});
                      default:
                        return Container();
                    }
                  });
            } else if (state is HomeError) {
              return AppErrorWidget(
                exception: state.exception,
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                },
              );
            } else if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              throw Exception('state is not supported');
            }
          },
        ),
      )),
    );
  }
}

class HorizontalProductList extends StatelessWidget {
  final String title;
  final List<ProductEntity> products;
  final GestureTapCallback onTap;
  final ThemeData themeData;
  const HorizontalProductList({
    Key? key,
    required this.themeData,
    required this.title,
    required this.products,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: themeData.textTheme.subtitle1,
              ),
              TextButton(onPressed: onTap, child: const Text('مشاهده همه'))
            ],
          ),
        ),
        ProductList(products: products, themeData: themeData),
      ],
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({
    Key? key,
    required this.products,
    required this.themeData,
  }) : super(key: key);

  final List<ProductEntity> products;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
          itemCount: products.length,
          scrollDirection: Axis.horizontal,
          physics: defaultScrollPhysics,
          padding: const EdgeInsets.all(4),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductItem(
              product: product,
              themeData: themeData,
              borderRadius: BorderRadius.circular(12),
            );
          }),
    );
  }
}
