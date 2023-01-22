import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
    (response.data as List)
        .forEach((banner) => banners.add(BannerEntity.fromJson(banner)));
    return banners;
  }
}
