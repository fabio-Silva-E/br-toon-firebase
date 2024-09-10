import 'package:brtoon/base/base_screen.dart';
import 'package:brtoon/base/binding/navigation_binding.dart';
import 'package:brtoon/followers/binding/follow_binding.dart';
import 'package:brtoon/favorites/binding/favorites_binding.dart';
import 'package:brtoon/group_chats/binding/chat_binding.dart';
import 'package:brtoon/home/binding/home_binding.dart';
import 'package:brtoon/likes/binding/like_binding.dart';
import 'package:brtoon/login/view/sign_in_screen.dart';
import 'package:brtoon/publications/bindings/editing_binding.dart';
import 'package:brtoon/publications/bindings/publish_cape_binding.dart';
import 'package:brtoon/publications/bindings/publish_chapter_binding%20.dart';
import 'package:brtoon/publications/bindings/publish_page_binding.dart';
import 'package:brtoon/publish_screen/binding/publishers_binding.dart';
import 'package:brtoon/screens/screen/chapters/binding/chapter_binding.dart';
import 'package:brtoon/screens/screen/pages/binding/page_binding.dart';
import 'package:brtoon/signup/screens/sign_up_screen.dart';
import 'package:brtoon/splash/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      page: () => const SplashScreen(),
      name: PagesRoutes.splashRoute,
    ),
    GetPage(
      page: () => const SignInScreen(),
      name: PagesRoutes.signInRoute,
    ),
    GetPage(
      page: () => const SignupScreen(),
      name: PagesRoutes.signUpRoute,
    ),
    GetPage(
      page: () => const BaseScreen(),
      name: PagesRoutes.baseRoute,
      bindings: [
        NavigationBinding(),
        HomeBinding(),
        PublishersBinding(),
        ChapterBinding(),
        PagesBinding(),
        PublishChapterBinding(),
        PublishCapeBinding(),
        PublishPageBinding(),
        FavoritesBinding(),
        EditingCapeBinding(),
        LikeBinding(),
        ChatBinding(),
        FollowBinding(),
      ],
    ),
  ];
}

abstract class PagesRoutes {
  static const String productChapterRoute = '/product';
  static const String signInRoute = '/signin';
  static const String signUpRoute = '/signup';
  static const String splashRoute = '/splash';
  static const String baseRoute = '/';
}
