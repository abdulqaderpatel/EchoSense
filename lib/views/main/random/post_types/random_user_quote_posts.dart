import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/REST_api.dart';
import '../../../../constants/global.dart';
import '../../../../controllers/authController.dart';

class RandomUserQuotePosts extends StatefulWidget {
  final String userId;
  final List userPosts;
  const RandomUserQuotePosts(
      {required this.userId, required this.userPosts, super.key});

  @override
  State<RandomUserQuotePosts> createState() => _RandomUserQuotePostsState();
}

class _RandomUserQuotePostsState extends State<RandomUserQuotePosts> {
  AuthController authController = Get.put(AuthController());
  var likes = [];
  var isLikedByUser = [];
  var isLoading = false;
  var quotePosts = [];
  void getPostsData() async {
    setState(() {
      isLoading = true;
    });
    quotePosts = widget.userPosts
        .where((element) => element["quotedPostId"] != null)
        .toList();

    for (var element in quotePosts) {
      http.Response res = await get("$url/likes/post/${element["id"]}");
      http.Response likedByUserRes = await get(
          "$url/likes/post/likedByUser/${authController.userId.value}/${element["id"]}");

      likes.add(res.body);
      isLikedByUser.add(likedByUserRes.body);
    }
    setState(() {
      isLoading = false;
    });
  }

  void likePost(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/post",
        body: jsonEncode({
          "userId": authController.userId.value,
          "postId": quotePosts[index]["id"]
        }),
        success: () {});

    http.Response res = await get("$url/likes/post/${quotePosts[index]["id"]}");

    likes[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${quotePosts[index]["id"]}");
    isLikedByUser[index] = likedByUserRes.body;

    setState(() {});
  }

  void dislikePost(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/post/remove",
        body: jsonEncode({
          "userId": authController.userId.value,
          "postId": quotePosts[index]["id"]
        }),
        success: () {});

    http.Response res = await get("$url/likes/post/${quotePosts[index]["id"]}");

    likes[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${quotePosts[index]["id"]}");
    isLikedByUser[index] = likedByUserRes.body;

    setState(() {});
  }

  @override
  void initState() {
    getPostsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            )
          : SafeArea(
              child: Container(
              margin: EdgeInsets.only(top: 10),
              child: ListView.builder(
                  itemCount: quotePosts.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  width: Get.width * 0.12,
                                  child: quotePosts[index]["user"]["picture"] ==
                                          null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            'assets/images/profile_picture.png',
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(quotePosts[index]
                                              ["user"]["picture"]),
                                        )),
                              SizedBox(
                                width: Get.width * 0.04,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    quotePosts[index]["user"]["name"],
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  Text(
                                    "@${quotePosts[index]["user"]["username"]}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: Get.width * 0.17),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        quotePosts[index]["description"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                quotePosts[index]["imageurl"] != null
                                    ? Column(
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                maxHeight: Get.height * 0.45,
                                                minWidth: Get.width),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                quotePosts[index][
                                                    "imageurl"], // Replace with the path to your image
                                                fit: BoxFit
                                                    .fill, // Use BoxFit.fill to force the image to fill the container
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                width: Get.width * 0.08,
                                                child: quotePosts[index]["user"]
                                                            ["picture"] ==
                                                        null
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image.asset(
                                                          'assets/images/profile_picture.png', // Replace with the path to your image
                                                          fit: BoxFit
                                                              .fill, // Use BoxFit.fill to force the image to fill the container
                                                        ),
                                                      )
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image.network(
                                                            quotePosts[index][
                                                                        "quotePost"]
                                                                    ["user"]
                                                                ["picture"]),
                                                      )),
                                            SizedBox(
                                              width: Get.width * 0.03,
                                            ),
                                            Text(
                                              quotePosts[index]["quotePost"]
                                                  ["user"]["name"],
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.03,
                                            ),
                                            Text(
                                                "@${quotePosts[index]["quotePost"]["user"]["username"]}",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                quotePosts[index]["quotePost"]
                                                    ["description"],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        quotePosts[index]["quotePost"]
                                                    ["imageurl"] !=
                                                null
                                            ? Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.network(
                                                        quotePosts[index]
                                                                ["quotePost"][
                                                            "imageurl"], // Replace with the path to your image
                                                        fit: BoxFit
                                                            .fill, // Use BoxFit.fill to force the image to fill the container
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                      ],
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          isLikedByUser[index] == "false"
                                              ? likePost(index)
                                              : dislikePost(index);
                                        },
                                        child: Icon(
                                            isLikedByUser[index] == "false"
                                                ? Icons.favorite_outline
                                                : Icons.favorite)),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      likes[index],
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.1,
                                    ),
                                    const Icon(Icons.chat_bubble_outline),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    const Text(
                                      "0",
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.1,
                                    ),
                                    const Icon(Icons.replay_outlined),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    const Text(
                                      "0",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            color: Colors.grey,
                          )
                        ],
                      ),
                    );
                  }),
            )),
    );
  }
}
