import 'package:dio/dio.dart';
import 'package:nike/common/response_validator.dart';
import 'package:nike/data/product.dart';

abstract class IProductDataSource {
  Future<List<ProductEntity>> getAll(int sort);
  Future<List<ProductEntity>> search(String searchTerm);
}

class ProductRemoteDataSource
    with HttpResponseValidator
    implements IProductDataSource {
  final Dio httpClient;

  ProductRemoteDataSource(this.httpClient);
  @override
  Future<List<ProductEntity>> getAll(int sort) async {
    final response = await httpClient.get('product/list?sort=$sort');
    validateResponse(response);
    List<ProductEntity> products = [];
    for (var product in (response.data as List)) {
      products.add(ProductEntity.fromJson(product));
    }
    return products;
  }

  @override
  Future<List<ProductEntity>> search(String searchTerm) async {
    final response = await httpClient.get('product/search?q=$searchTerm');
    validateResponse(response);
    List<ProductEntity> products = [];
    for (var product in (response.data as List)) {
      products.add(ProductEntity.fromJson(product));
    }
    return products;
  }
}
