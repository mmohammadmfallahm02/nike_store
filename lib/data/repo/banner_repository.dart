import 'package:nike/common/http_clinet.dart';
import 'package:nike/data/banner.dart';
import 'package:nike/data/source/banner_data_source.dart';

final bannerRepository = BannerRepository(BannerRemoteDataSource(httpClient));

abstract class IBannerRepository implements IBannerDataSource {}

class BannerRepository implements IBannerRepository {
  final IBannerDataSource dataSource;

  BannerRepository(this.dataSource);
  @override
  Future<List<BannerEntity>> getAll() => dataSource.getAll();
}
