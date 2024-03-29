import 'package:get/get.dart';
import 'package:social_media/models/post.dart';

// for getting data apart from the current user
class MainController extends GetxController {
  RxList posts = [].obs;
  RxBool isLoading = false.obs;
  RxList likes = [].obs;
  RxList isLikedByUser = [].obs;

  //for user comments
  List commentRepliesCount = [].obs;

  //for user posts
  List postCommentsCount = [].obs;
}
