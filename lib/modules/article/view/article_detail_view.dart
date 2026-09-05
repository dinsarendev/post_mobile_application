import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/constants/url_constant.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/models/post/Content.dart';
import 'package:post_mobile_application/core/models/post/PostDetailResponse.dart';
import 'package:post_mobile_application/core/models/post/Reactions.dart';
import 'package:post_mobile_application/widgets/app_snackbar.dart';
import 'package:post_mobile_application/widgets/appbar_custom_widget.dart';

class ArticleDetailView extends StatefulWidget {
  final int articleId;
  final Content? initial;
  const ArticleDetailView({super.key, required this.articleId, this.initial});

  @override
  State<ArticleDetailView> createState() => _ArticleDetailViewState();
}

class _ArticleDetailViewState extends State<ArticleDetailView> {
  final ApiService apiService = Get.find<ApiService>();

  Content? content;
  bool loading = true;
  bool liking = false;
  bool disliking = false;

  @override
  void initState() {
    super.initState();
    content = widget.initial;
    loading = content == null;
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    var response = await apiService.get(UrlConstants.publicPostDetailPath(widget.articleId));
    if (!mounted) return;
    setState(() => loading = false);
    if (response != null) {
      var responseBody = PostDetailResponse.fromJson(jsonDecode(response));
      if (responseBody.data != null) {
        setState(() => content = responseBody.data);
      }
    }
  }

  Future<void> _onLike() async {
    if (liking || content == null) return;
    setState(() => liking = true);
    var result = await apiService.post(UrlConstants.publicPostLikePath(widget.articleId), {});
    if (!mounted) return;
    setState(() => liking = false);
    if (result != null) {
      if (result['data'] != null) {
        setState(() => content = Content.fromJson(result['data']));
      } else {
        setState(() {
          content!.reactions ??= Reactions();
          content!.reactions!.likes = (content!.reactions!.likes ?? 0) + 1;
        });
      }
    } else {
      AppSnackbar.error("Failed to like the article");
    }
  }

  Future<void> _onDislike() async {
    if (disliking || content == null) return;
    setState(() => disliking = true);
    var result = await apiService.post(UrlConstants.publicPostDislikePath(widget.articleId), {});
    if (!mounted) return;
    setState(() => disliking = false);
    if (result != null) {
      if (result['data'] != null) {
        setState(() => content = Content.fromJson(result['data']));
      } else {
        setState(() {
          content!.reactions ??= Reactions();
          content!.reactions!.dislikes = (content!.reactions!.dislikes ?? 0) + 1;
        });
      }
    } else {
      AppSnackbar.error("Failed to dislike the article");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustomWidget(title: content?.title ?? "Article"),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
          : content == null
              ? Center(
                  child: Text("Article not found", style: TextStyle(color: Colors.grey.shade600)),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((content!.image ?? "").isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              content!.image!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(height: 16),
                        if (content!.postCategory?.name != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.cyan.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              content!.postCategory!.name!,
                              style: const TextStyle(
                                color: Colors.cyan,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          content!.title ?? "",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.visibility_outlined, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              "${content!.views ?? 0} views",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          (content!.body?.isNotEmpty == true) ? content!.body! : (content!.description ?? ""),
                          style: const TextStyle(fontSize: 15, height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: liking ? null : _onLike,
                                icon: liking
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.thumb_up_alt_outlined),
                                label: Text("Like (${content!.reactions?.likes ?? 0})"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: disliking ? null : _onDislike,
                                icon: disliking
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.thumb_down_alt_outlined),
                                label: Text("Dislike (${content!.reactions?.dislikes ?? 0})"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
