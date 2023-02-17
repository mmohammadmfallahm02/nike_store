import 'package:dio/dio.dart';
import 'package:nike/common/response_validator.dart';
import 'package:nike/data/cart_response.dart';

abstract class ICartDataSource {
  Future<CartResponse> add(int productId);
  Future<CartResponse> changeCount(int productId, int count);
  Future<void> remove(int cartItemId);
  Future<int> count();
  Future<List<CartListResponse>> getAll();
}

class CartRemoteDataSource
    with HttpResponseValidator
    implements ICartDataSource {
  final Dio httpClient;

  CartRemoteDataSource(this.httpClient);
  @override
  Future<CartResponse> add(int productId) async {
    final response =
        await httpClient.post('cart/add', data: {'product_id': productId});
    validateResponse(response);
    return CartResponse.fromJson(response.data);
  }

  @override
  Future<CartResponse> changeCount(int productId, int count) {
    // TODO: implement changeCount
    throw UnimplementedError();
  }

  @override
  Future<int> count() {
    // TODO: implement count
    throw UnimplementedError();
  }

  @override
  Future<List<CartListResponse>> getAll() {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<void> remove(int cartItemId) {
    // TODO: implement remove
    throw UnimplementedError();
  }
}
