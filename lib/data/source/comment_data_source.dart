import 'package:dio/dio.dart';
import 'package:nike/common/response_validator.dart';
import 'package:nike/data/comment.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required int productId});
}

class RemoteCommentDataSource
    with HttpResponseValidator
    implements ICommentDataSource {
  final Dio httpClient;

  RemoteCommentDataSource(this.httpClient);
  @override
  Future<List<CommentEntity>> getAll({required int productId}) async {
    final response = await httpClient.get('comment/list?product_id=$productId');
    validateResponse(response);
    final List<CommentEntity> comments = [];
    for (var comment in (response.data as List)) {
      comments.add(CommentEntity.fromJson(comment));
    }
    return comments;
  }
}
