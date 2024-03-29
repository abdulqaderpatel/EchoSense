import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/authController.dart';

import '../../../controllers/userController.dart';
import 'image_post_list.dart';

class ImagePosts extends StatefulWidget {
  const ImagePosts({super.key});

  @override
  State<ImagePosts> createState() => _ImagePostsState();
}

class _ImagePostsState extends State<ImagePosts> {
  UserController userController = Get.put(UserController());
  List<dynamic> imagePosts = [];
  @override
  void initState() {
    for (int i = 0; i < userController.currentUserPosts.value.length; i++) {
      if (userController.currentUserPosts.value[i]["imageurl"] != null &&
          userController.currentUserPosts.value[i]["quotedPostId"] == null) {
        setState(() {
          imagePosts.add(userController.currentUserPosts.value[i]);
        });
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GridView.builder(
          itemCount: imagePosts.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ImagePostList(imagePosts, index);
                }));
              },
              child: Container(
                margin: const EdgeInsets.only(
                    top: 3, bottom: 3, left: 1.5, right: 1.5),
                child: Image.network(
                  imagePosts[index]
                      ["imageurl"], // Replace with the path to your image
                  fit: BoxFit
                      .fill, // Use BoxFit.fill to force the image to fill the container
                ),
              ),
            );
          }),
    );
  }
}
