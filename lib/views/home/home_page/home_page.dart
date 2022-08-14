import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/category/categories_controller.dart';
import '../../../core/controllers/notifications/notification_remote.dart';
import '../../../core/controllers/posts/categories_post_controller.dart';
import '../../../core/controllers/posts/feature_post_controller.dart';
import '../../../core/controllers/posts/saved_post_controller.dart';
import '../../../core/models/category.dart';
import '../../../core/repositories/others/internet_state.dart';
import 'components/category_tab_view.dart';
import 'components/home_app_bar.dart';
import 'components/internet_not_available.dart';
import 'components/loading_feature_post.dart';
import 'components/loading_home_page.dart';
import 'components/trending_tab.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  /// you can make api calls and put your categories here, but trending should
  /// be always first as it is
  List<CategoryModel> _feturedCategories = [];

  final _isLoading = StateProvider.autoDispose<bool>((ref) => false);

  /// Set Categories and update the UI
  _setCategories() async {
    ref.read(_isLoading.notifier).state = true;
    try {
      _feturedCategories = await ref
          .read(categoriesController.notifier)
          .getAllFeatureCategories();

      _tabController =
          TabController(length: _feturedCategories.length, vsync: this);
    } on Exception {
      _tabController = TabController(length: 1, vsync: this);
    }
    ref.read(_isLoading.notifier).state = false;
  }

  /// Tabs
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _setCategories();
    ref.read(savedPostController);
    ref.read(authController);
    ref.read(remoteNotificationProvider(context).notifier).handlePermission();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isFetching = ref.watch(_isLoading);
    final featurePost = ref.watch(featurePostController);
    final internetAvailable = ref.watch(internetStateProvider(context));

    if (isFetching) {
      return const LoadingHomePage();
    } else if (!internetAvailable) {
      return const InternetNotAvailablePage();
    } else {
      return NestedScrollView(
        physics: const BouncingScrollPhysics(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerScroller) => [
          HomeAppBarWithTab(
            categories: _feturedCategories,
            tabController: _tabController,
            forceElevated: innerScroller,
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: List.generate(
            _feturedCategories.length,
            (index) {
              if (index == 0) {
                return featurePost.map(
                  data: ((data) => TrendingTabSection(
                        featuredPosts: data.value,
                      )),
                  error: (t) => Text(t.toString()),
                  loading: (t) => const LoadingFeaturePost(),
                );
              } else {
                return Container(
                  color: Theme.of(context).cardColor,
                  child: CategoryTabView(
                    arguments: CategoryPostsArguments(
                      categoryId: _feturedCategories[index].id,
                      isHome: true,
                    ),
                    key: ValueKey(_feturedCategories[index].slug),
                  ),
                );
              }
            },
          ),
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
