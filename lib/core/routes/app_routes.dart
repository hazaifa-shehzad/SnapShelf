import 'package:flutter/material.dart';

import '../../features/albums/screens/album_detail_screen.dart';
import '../../features/albums/screens/all_albums_screen.dart';
import '../../features/albums/screens/empty_album_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/verification_screen.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/photos/screens/all_photos_screen.dart';
import '../../features/photos/screens/photo_detail_screen.dart';
import '../../features/photos/widgets/photo_image_data.dart';
import '../../features/profile/screens/change_password_screen.dart';
import '../../features/profile/screens/privacy_policy_screen.dart';
import '../../features/profile/screens/profile_setting_screen.dart';
import '../../features/profile/screens/terms_conditions_screen.dart';
import '../../features/upload/screens/choose_album_screen.dart';
import '../../features/upload/screens/upload_photo_screen.dart';
import 'route_names.dart';

class AppRoutes {
  AppRoutes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.welcome:
        return _buildRoute(const WelcomeScreen(), settings);
      case RouteNames.login:
        return _buildRoute(const LoginScreen(), settings);
      case RouteNames.signup:
        return _buildRoute(const SignupScreen(), settings);
      case RouteNames.forgotPassword:
        return _buildRoute(const ForgotPasswordScreen(), settings);
      case RouteNames.verification:
        return _buildRoute(
          VerificationScreen(email: _verificationEmail(settings.arguments)),
          settings,
        );
      case RouteNames.resetPassword:
        return _buildRoute(const ResetPasswordScreen(), settings);
      case RouteNames.home:
        return _buildRoute(const HomeScreen(), settings);
      case RouteNames.uploadPhoto:
        return _buildRoute(const UploadPhotoScreen(), settings);
      case RouteNames.chooseAlbum:
        return _buildRoute(const ChooseAlbumScreen(), settings);
      case RouteNames.allAlbums:
        return _buildRoute(const AllAlbumsScreen(), settings);
      case RouteNames.albumDetail:
        return _buildRoute(const AlbumDetailScreen(), settings);
      case RouteNames.emptyAlbum:
        return _buildRoute(const EmptyAlbumScreen(), settings);
      case RouteNames.allPhotos:
        return _buildRoute(const AllPhotosScreen(), settings);
      case RouteNames.photoDetail:
        final photoDetailArgs = _photoDetailArguments(settings.arguments);
        return _buildRoute(
          PhotoDetailScreen(
            photos: photoDetailArgs.photos,
            initialIndex: photoDetailArgs.initialIndex,
          ),
          settings,
        );
      case RouteNames.profileSettings:
        return _buildRoute(const ProfileSettingScreen(), settings);
      case RouteNames.changePassword:
        return _buildRoute(const ChangePasswordScreen(), settings);
      case RouteNames.privacyPolicy:
        return _buildRoute(const PrivacyPolicyScreen(), settings);
      case RouteNames.termsConditions:
        return _buildRoute(const TermsConditionsScreen(), settings);
      default:
        return _buildRoute(_UnknownRouteScreen(routeName: settings.name), settings);
    }
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return generateRoute(settings);
  }

  static PageRouteBuilder<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<Offset>(
          begin: const Offset(0.04, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    );
  }

  static String _verificationEmail(Object? arguments) {
    if (arguments is String) return arguments;

    if (arguments is Map) {
      final email = arguments['email'];
      if (email is String) return email;
    }

    return '';
  }

  static _PhotoDetailRouteArgs _photoDetailArguments(Object? arguments) {
    if (arguments is Map) {
      final photos = arguments['photos'];
      final initialIndex = arguments['initialIndex'];

      return _PhotoDetailRouteArgs(
        photos: photos is List<PhotoImageData>
            ? photos
            : photos is List
                ? List<PhotoImageData>.from(photos, growable: false)
                : const <PhotoImageData>[],
        initialIndex: initialIndex is int ? initialIndex : 0,
      );
    }

    return const _PhotoDetailRouteArgs(
      photos: <PhotoImageData>[],
      initialIndex: 0,
    );
  }
}

class _PhotoDetailRouteArgs {
  const _PhotoDetailRouteArgs({
    required this.photos,
    required this.initialIndex,
  });

  final List<PhotoImageData> photos;
  final int initialIndex;
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen({this.routeName});

  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Unknown route: ${routeName ?? 'null'}'),
      ),
    );
  }
}
