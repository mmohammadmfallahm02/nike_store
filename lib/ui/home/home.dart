import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/repo/banner_repository.dart';
import 'package:nike/data/repo/product_repository.dart';
import 'package:nike/gen/assets.gen.dart';
import 'package:nike/ui/home/bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => HomeBloc(
          bannerRepository: bannerRepository,
          productRepository: productRepository)
        ..add(HomeStarted()),
      child: Scaffold(body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeSuccess) {
              return ListView.builder(
                  itemCount: 5,
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 100),
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 1:
                        return Assets.images.nikeLogo.image(height: size / 12);
                      default:
                        return Container();
                    }
                  });
            } else if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.exception.message),
                    ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                        },
                        child: const Text('تلاش دوباره'))
                  ],
                ),
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
