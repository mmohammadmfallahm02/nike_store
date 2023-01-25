import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/constants/exception.dart';
import 'package:nike/constants/product_sort.dart';
import 'package:nike/data/banner.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/banner_repository.dart';
import 'package:nike/data/repo/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IProductRepository productRepository;
  final IBannerRepository bannerRepository;
  HomeBloc({required this.productRepository, required this.bannerRepository})
      : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is HomeRefresh) {
        try {
          emit(HomeLoading());
          final banners = await bannerRepository.getAll();
          final latestProducts =
              await productRepository.getAll(ProductSort.latest);
          final popularProducts =
              await productRepository.getAll(ProductSort.popular);

          emit(HomeSuccess(
              latestProducts: latestProducts,
              popularProducts: popularProducts,
              banners: banners));
        } catch (e) {
          emit(HomeError(exception: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
