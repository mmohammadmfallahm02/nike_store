import 'package:nike/common/http_clinet.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/source/product_data_source.dart';

final productRepository =
    ProductRepository(ProductRemoteDataSource(httpClient));

abstract class IProductRepository implements IProductDataSource {}

class ProductRepository implements IProductRepository {
  final IProductDataSource dataSource;

  ProductRepository(this.dataSource);
  @override
  Future<List<ProductEntity>> getAll(int sort) => dataSource.getAll(sort);

  @override
  Future<List<ProductEntity>> search(String searchTerm) =>
      dataSource.search(searchTerm);
}
