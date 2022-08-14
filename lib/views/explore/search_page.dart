import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../core/ads/ad_state_provider.dart';
import '../../core/components/banner_ad.dart';
import '../../core/constants/constants.dart';
import '../../core/controllers/posts/search_post_controller.dart';
import '../../core/models/article.dart';
import '../../core/repositories/posts/post_repository.dart';
import '../../core/utils/app_utils.dart';
import 'components/search_history_list.dart';
import 'components/search_text_field.dart';
import 'components/searched_article_list.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late TextEditingController _query;

  bool _isSearching = false;
  bool _isOnHistory = true;
  List<ArticleModel> _searchedList = [];

  final _formKey = GlobalKey<FormState>();

  _search() async {
    bool isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      AppUtil.dismissKeyboard(context: context);
      _isSearching = true;
      _isOnHistory = false;
      if (mounted) setState(() {});
      final repo = ref.read(postRepoProvider);
      _searchedList = await repo.searchPost(keyword: _query.text);
      ref.read(searchHistoryController.notifier).addEntry(_query.text);
      _isSearching = false;
      if (mounted) setState(() {});
    }
  }

  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _query = TextEditingController();
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          _isOnHistory
              ? const SizedBox()
              : IconButton(
                  onPressed: () => setState(() {
                    _isOnHistory = true;
                    ref.read(loadInterstitalAd);
                  }),
                  icon: const Icon(IconlyLight.timeSquare),
                )
        ],
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              childAnimationBuilder: (widget) => SlideAnimation(
                duration: AppDefaults.duration,
                verticalOffset: 50,
                child: widget,
              ),
              children: [
                SearchTextFieldWithButton(
                  formKey: _formKey,
                  onSubmit: () => _search(),
                  controller: _query,
                ),
                const Divider(),
                const BannerAdWidget(paddingVertical: 0),

                /// Page Swtich Animation
                PageTransitionSwitcher(
                  duration: AppDefaults.duration,
                  transitionBuilder: ((child, primaryAnimation,
                          secondaryAnimation) =>
                      SharedAxisTransition(
                        animation: primaryAnimation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.vertical,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        child: child,
                      )),
                  child: _isOnHistory
                      ? SearchHistoryList(
                          animatedListKey: _animatedListKey,
                          onTap: (v) {
                            _query.text = v;
                            _search();
                          },
                        )
                      : SearchedArticleList(
                          searchedList: _searchedList,
                          isSearching: _isSearching),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
