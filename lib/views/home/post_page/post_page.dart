import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../config/ad_config.dart';
import '../../../config/wp_config.dart';
import '../../../core/components/app_video.dart';
import '../../../core/components/banner_ad.dart';
import '../../../core/components/network_image.dart';
import '../../../core/constants/constants.dart';
import '../../../core/models/article.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/utils/responsive.dart';
import 'components/more_related_post.dart';
import 'components/post_page_body.dart';
import 'components/save_post_button.dart';

class PostPage extends StatelessWidget {
  const PostPage({
    Key? key,
    required this.article,
    this.isHeroDisabled = false,
  }) : super(key: key);
  final ArticleModel article;
  final bool isHeroDisabled;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        top: article.tags.contains(WPConfig.videoTagID),
        child: Scrollbar(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              /// AppBar
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                leadingWidth: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width * 0.2
                    : MediaQuery.of(context).size.width * 0.1,
                leading: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    primary: AppColors.cardColorDark.withOpacity(0.3),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Icon(
                    Icons.adaptive.arrow_back_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async => await Share.share(article.link),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      primary: AppColors.cardColorDark.withOpacity(0.3),
                      elevation: 0,
                    ),
                    child: const Icon(
                      IconlyLight.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  SavePostButton(article: article),
                ],
                expandedHeight: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.height * 0.3
                    : MediaQuery.of(context).size.height * 0.5,
                flexibleSpace: article.tags.contains(WPConfig.videoTagID)
                    ? CustomVideoRenderer(article: article)
                    : FlexibleSpaceBar(
                        background: AspectRatio(
                          aspectRatio: AppDefaults.aspectRatio,
                          child: isHeroDisabled
                              ? NetworkImageWithLoader(
                                  article.featuredImage,
                                  fit: BoxFit.cover,
                                  borderRadius: BorderRadius.zero,
                                )
                              : Hero(
                                  tag: article.heroTag,
                                  child: NetworkImageWithLoader(
                                    article.featuredImage,
                                    fit: BoxFit.cover,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                        ),
                      ),
              ),
              SliverToBoxAdapter(
                child: PostPageBody(article: article),
              ),

              SliverStack(
                children: [
                  SliverPositioned.fill(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor))),
                  MoreRelatedPost(
                    categoryID: article.categories.isNotEmpty
                        ? article.categories.first
                        : 0,
                    currentArticleID: article.id,
                  ),
                ],
              ),

              const SliverToBoxAdapter(
                  child: AdConfig.isAdOn ? BannerAdWidget() : SizedBox()),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('go_back'.tr()),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('.'),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer(builder: (context, ref, child) {
        return FloatingActionButton.extended(
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.comment, arguments: article);
          },
          label: Text('load_comments'.tr()),
          icon: const Icon(Icons.comment_rounded),
        );
      }),
    );
  }
}

/// Used for rendering vidoe on top
class CustomVideoRenderer extends StatelessWidget {
  const CustomVideoRenderer({
    Key? key,
    required this.article,
  }) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.zero,
      stretchModes: const [StretchMode.blurBackground],
      background: Html(
        data: article.content,
        tagsList: const ['html', 'body', 'figure', 'video'],
        style: {
          'body': Style(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          ),
          'figure': Style(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          ),
        },
        onLinkTap: (String? url, RenderContext renderCtx,
            Map<String, String> attributes, _) {
          if (url != null) {
            AppUtil.openLink(url);
          } else {
            Fluttertoast.showToast(msg: 'Cannot launch this url');
          }
        },
        customRender: {
          'video': (RenderContext renderContext, Widget child) {
            return AppVideo(
              url: renderContext.tree.element!.attributes['src'].toString(),
            );
          },
        },
      ),
    );
  }
}
