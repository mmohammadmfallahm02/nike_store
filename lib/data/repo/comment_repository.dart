import 'package:nike/common/http_clinet.dart';
import 'package:nike/data/comment.dart';
import 'package:nike/data/source/comment_data_source.dart';

final commentRepository =
    CommentRepository(RemoteCommentDataSource(httpClient));

abstract class ICommentRepository implements ICommentDataSource {}

class CommentRepository implements ICommentRepository {
  final ICommentDataSource dataSource;

  CommentRepository(this.dataSource);
  @override
  Future<List<CommentEntity>> getAll({required int productId}) =>
      dataSource.getAll(productId: productId);
}
