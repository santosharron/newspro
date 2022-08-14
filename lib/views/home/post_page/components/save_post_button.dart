import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/ads/ad_state_provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/posts/saved_post_controller.dart';
import '../../../../core/models/article.dart';

class SavePostButton extends ConsumerWidget {
  const SavePostButton({
    Key? key,
    required this.article,
    this.iconSize = 18,
  }) : super(key: key);

  final ArticleModel article;
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedPostController);
    bool isSaved = saved.value?.contains(article) ?? false;
    bool isSaving = ref.watch(savedPostController.notifier).isSavingPost;

    return ElevatedButton(
      onPressed: () async {
        ref.read(loadInterstitalAd);
        if (isSaved) {
          await ref
              .read(savedPostController.notifier)
              .removePostFromSaved(article.id);
          Fluttertoast.showToast(msg: 'article_removed_message'.tr());
        } else {
          await ref.read(savedPostController.notifier).addPostToSaved(article);
          Fluttertoast.showToast(msg: 'article_saved_message'.tr());
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        primary: isSaved
            ? AppColors.primary
            : AppColors.cardColorDark.withOpacity(0.5),
        padding: const EdgeInsets.all(4),
        elevation: 0,
      ),
      child: isSaving
          ? const CircularProgressIndicator()
          : Icon(
              isSaved ? IconlyBold.heart : IconlyLight.heart,
              color: Colors.white,
              size: iconSize,
            ),
    );
  }
}
