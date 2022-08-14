import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/components/list_view_responsive.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/posts/categories_post_controller.dart';
import '../../../../core/models/article.dart';
import 'loading_posts_responsive.dart';

class CategoryTabView extends ConsumerWidget {
  const CategoryTabView({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  final CategoryPostsArguments arguments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsProvider = ref.watch(categoryPostController(arguments));
    final controller = ref.watch(categoryPostController(arguments).notifier);

    if (postsProvider.refershError) {
      return Center(
        child: Text(postsProvider.errorMessage),
      );

      /// on Initial State it will be empty
    } else if (postsProvider.initialLoaded == false) {
      return const LoadingPostsResponsive(isInSliver: false);
    } else if (postsProvider.posts.isEmpty) {
      return const CategoiesPostEmpty();
    } else {
      return RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              CategoryPostListView(
                data: postsProvider.posts,
                handlePagination: controller.handleScrollWithIndex,
                onRefresh: controller.onRefresh,
              ),
              if (postsProvider.isPaginationLoading)
                const SliverToBoxAdapter(
                  child: LinearProgressIndicator(),
                )
            ],
          ),
        ),
      );
    }
  }
}

class CategoryPostListView extends StatelessWidget {
  const CategoryPostListView({
    Key? key,
    required this.data,
    required this.handlePagination,
    required this.onRefresh,
  }) : super(key: key);

  final List<ArticleModel> data;
  final void Function(int) handlePagination;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: SliverPadding(
        padding: const EdgeInsets.only(
          top: AppDefaults.padding,
          left: AppDefaults.padding,
          right: AppDefaults.padding,
        ),
        sliver: ResponsiveListView(
          data: data,
          handleScrollWithIndex: handlePagination,
          isMainPage: true,
        ),
      ),
    );
  }
}

class CategoiesPostEmpty extends StatelessWidget {
  const CategoiesPostEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Image.asset(AppImages.emptyPost),
          ),
          AppSizedBox.h16,
          Text(
            'Ooh! It\'s empty here',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          AppSizedBox.h10,
          Text(
            'You can explore other categories as well',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
