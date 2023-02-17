import 'package:nike/common/http_clinet.dart';
import 'package:nike/data/cart_response.dart';
import 'package:nike/data/source/cart_data_source.dart';

final CartRepository cartRepository =
    CartRepository(CartRemoteDataSource(httpClient));

abstract class ICartRepository extends ICartDataSource {}

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;

  CartRepository(this.dataSource);
  @override
  Future<CartResponse> add(int productId) => dataSource.add(productId);

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
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<void> remove(int cartItemId) {
    // TODO: implement remove
    throw UnimplementedError();
  }
}
