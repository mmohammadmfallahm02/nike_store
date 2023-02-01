import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/widgets/Error.dart';
import 'package:nike/data/repo/comment_repository.dart';
import 'package:nike/ui/product/comment/bloc/comment_list_bloc.dart';
import 'package:nike/ui/product/comment/comment.dart';

class CommentList extends StatelessWidget {
  final int productId;
  const CommentList({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentListBloc(
          commentRepository: commentRepository, productId: productId)
        ..add(CommetListStarted()),
      child: BlocBuilder<CommentListBloc, CommentListState>(
          builder: (context, state) {
        if (state is CommentListSuccess) {
          return SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => CommentItem(
                        comment: state.comments[index],
                      ),
                  childCount: state.comments.length));
        } else if (state is CommentListError) {
          return SliverToBoxAdapter(
              child: AppErrorWidget(
            exception: state.exception,
            onPressed: () {
              BlocProvider.of<CommentListBloc>(context)
                  .add(CommetListStarted());
            },
          ));
        } else if (state is CommentListLoading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        } else {
          throw Exception('state is not supported');
        }
      }),
    );
  }
}
