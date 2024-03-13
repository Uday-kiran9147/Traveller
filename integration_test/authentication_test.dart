import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:traveler/main.dart' as myapp;
import 'package:traveler/presentation/pages/auth/ui/widgets/account_ui.dart';
import 'package:traveler/presentation/pages/auth/ui/widgets/loginform.dart';
import 'package:traveler/presentation/pages/profile/profile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

group('Driver test', () {
    testWidgets("Load Authentication screen and perform login operation",
      (WidgetTester tester) async {
    myapp.main();
    await tester.pumpAndSettle();
    expect(find.byType(myapp.MyApp), findsOneWidget);
    expect(find.byType(AuthAccounts), findsOneWidget);

    await tester.tap(find.byKey(const Key('loginButton')));

    await tester.pumpAndSettle();

    expect(find.byType(LoginForm), findsOneWidget);

    await tester.enterText(
        find.byType(TextField).at(0), 'udaykiran9147@gmail.com');
    await Future.delayed(const Duration(seconds: 2));

    await tester.enterText(find.byType(TextField).at(1), '12345678');
    await tester.tap(find.byKey(const Key('login')));
    // await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.byType(myapp.MyApp), findsWidgets);
  });

  testWidgets("Navigate to Edit profile screen and then Edit profile", (tester) async {
    myapp.main();
    await tester.pumpAndSettle();
    // expect(find.byType(myapp.MyApp), findsOneWidget);
    // expect(find.byType(AuthAccounts), findsOneWidget);

    // await tester.tap(find.byKey(const Key('loginButton')));

    // await tester.pumpAndSettle();

    // expect(find.byType(LoginForm), findsOneWidget);

    // await tester.enterText(find.byType(TextField).at(0), 'udaykiran9147@gmail.com');
    // await Future.delayed(const Duration(seconds: 2));

    // await tester.enterText(find.byType(TextField).at(1), '12345678');
    // await tester.tap(find.byKey(const Key('login')));
    // await Future.delayed(const Duration(seconds: 3));
    // await tester.pumpAndSettle();
    expect(find.byType(myapp.MyApp), findsWidgets);

    // Navigate to profile bar
    await tester.tap(find.byIcon(Icons.person_2_rounded));
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byType(Profile), findsWidgets);
    await Future.delayed(const Duration(seconds: 3));
    // Navigate to edit profile
    await tester.tap(find.byIcon(Icons.edit));
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 5));

    // update tag in edit profile screen section
    await tester.enterText(find.byType(TextField).at(1),'update tag in edit profile screen section');
    await Future.delayed(const Duration(seconds: 5));
    // await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('submit')));
    await Future.delayed(const Duration(seconds: 10));
  });
 });
}
