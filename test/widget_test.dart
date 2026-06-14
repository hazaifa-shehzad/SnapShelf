import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mad/core/routes/route_names.dart';
import 'package:mad/features/auth/screens/login_screen.dart';
import 'package:mad/features/home/screens/home_screen.dart';
import 'package:mad/data/models/user_model.dart';
import 'package:mad/providers/album_provider.dart';
import 'package:mad/providers/auth_provider.dart';
import 'package:mad/providers/photo_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('logout from drawer returns to login screen', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'is_logged_in': true,
      'user_email': 'user@example.com',
      'user_name': 'Test User',
      'remember_me': true,
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider.testUser(
              UserModel(
                id: 'test-user',
                name: 'Test User',
                email: 'user@example.com',
                createdAt: DateTime(2026),
              ),
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => AlbumProvider(loadOnCreate: false),
          ),
          ChangeNotifierProvider(
            create: (_) => PhotoProvider(loadOnCreate: false),
          ),
        ],
        child: MaterialApp(
          home: const HomeScreen(),
          routes: <String, WidgetBuilder>{
            RouteNames.login: (_) => const LoginScreen(),
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu_rounded).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Logout'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Logout'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
