import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/constants/exception.dart';
import 'package:nike/data/comment.dart';
import 'package:nike/data/repo/comment_repository.dart';

part 'comment_list_event.dart';
part 'comment_list_state.dart';

class CommentListBloc extends Bloc<CommentListEvent, CommentListState> {
  final ICommentRepository commentRepository;
  final int productId;
  CommentListBloc({required this.commentRepository, required this.productId})
      : super(CommentListLoading()) {
    on<CommentListEvent>((event, emit) async {
      if (event is CommetListStarted) {
        emit(CommentListLoading());
        try {
          final comments = await commentRepository.getAll(productId: productId);
          emit(CommentListSuccess(comments));
        } catch (e) {
          emit(CommentListError(e is AppException ? e : AppException()));
        }
      }
    });
  }
}
