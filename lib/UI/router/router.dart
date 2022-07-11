import 'package:adtracker/UI/home/components/sign_in_screen.dart';
import 'package:adtracker/UI/records/components/record_detailed_screen.dart';

import '../home/components/data_usage_screen.dart';

import '../home/components/camera_feed_screen.dart';
import '../home/components/first_time_screen.dart';
import '../home/components/no_permission_granted.dart';
import '../home/components/permissions_screen.dart';
import '../home/components/settings_screen.dart';
import '../home/components/splash_screen.dart';
import '../records/records.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? onGenerateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case '/SignInScreen':
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
        );
      case '/HomePage':
        return MaterialPageRoute(
          builder: (_) => const CameraFeedScreen(),
        );
      case '/PermissionsScreen':
        return MaterialPageRoute(
          builder: (_) => const PermissionsScreen(),
        );
      case '/FirstTimeScreen':
        return MaterialPageRoute(
          builder: (_) => const FirstTimeScreen(),
        );
      case '/RecordsDetailedScreen':
        return MaterialPageRoute(
          builder: (_) => const RecordsDetailedScreen(),
        );
      case '/CameraFeedScreen':
        return MaterialPageRoute(
          builder: (_) => const CameraFeedScreen(),
        );
      case '/SettingsScreen':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case '/NoPermissionsGranted':
        return MaterialPageRoute(
          builder: (_) => const NoPermissionsGranted(),
        );

      case '/DataUsageScreen':
        return MaterialPageRoute(
          builder: (_) => const DataUsageScreen(),
        );
      // case '/ProfileOverview':
      //   return MaterialPageRoute(
      //     builder: (_) => ProfileOverview(),
      //   );

      case '/RecordDetailsScreen':
        final args = settings.arguments as RecordDetailsScreen;
        return MaterialPageRoute(
          builder: (_) => RecordDetailsScreen(
            id: args.id,
            latitude: args.latitude,
            longitude: args.longitude,
            speed: args.speed,
            time: args.speed,
            date: args.speed,
            loc: args.loc,
            state: args.state,
          ), //RecordDetailsScreen(args.albumData),
        );

      // case '/AlbumDetailedPage':
      //   final args = settings.arguments as AlbumDetailedPage;
      //   return MaterialPageRoute(
      //     builder: (_) => AlbumDetailedPage(args.albumData),
      //   );

      default:
        return null;
    }
  }
}
