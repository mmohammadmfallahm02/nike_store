part of 'comment_list_bloc.dart';

abstract class CommentListEvent extends Equatable {
  const CommentListEvent();

  @override
  List<Object> get props => [];
}
class CommetListStarted extends CommentListEvent{}
