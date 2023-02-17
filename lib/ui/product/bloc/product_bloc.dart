import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/constants/exception.dart';
import 'package:nike/data/repo/cart_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ICartRepository productRepository;
  ProductBloc(this.productRepository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is CartAddButtonClicked) {
        emit(ProductAddToCartLoading());
        await Future.delayed(const Duration(seconds: 1));
        try {
          await productRepository.add(event.productId);
          emit(ProductAddToCartSuccess());
        } on DioError catch (e) {
          emit(ProductAddToCartError(AppException(
              message: e.response?.data['message'] ?? AppException())));
        }
      }
    });
  }
}
