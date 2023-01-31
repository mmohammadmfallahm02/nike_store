import 'package:dio/dio.dart';
import 'package:nike/common/response_validator.dart';
import 'package:nike/data/banner.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAll();
}

class BannerRemoteDataSource
    with HttpResponseValidator
    implements IBannerDataSource {
  final Dio httpClient;

  BannerRemoteDataSource(this.httpClient);
  @override
  Future<List<BannerEntity>> getAll() async {
    final response = await httpClient.get('banner/slider');
    validateResponse(response);
    List<BannerEntity> banners = [];
    for (var banner in (response.data as List)) {
      banners.add(BannerEntity.fromJson(banner));
    }
    return banners;
  }
}
