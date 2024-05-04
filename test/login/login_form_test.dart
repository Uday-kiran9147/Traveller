import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:traveler/presentation/pages/auth/ui/authentication.dart';
import 'package:traveler/presentation/pages/home/ui/home.dart';
import 'package:traveler/main.dart';

void main() {
  testWidgets('Display AuthenticationScreen when not logged in',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const MyApp(),
      ),
    );

    // Verify that AuthenticationScreen is displayed when not logged in
    expect(find.byType(AuthenticationScreen), findsOneWidget);
    expect(find.byType(HomeBloc), findsNothing);
  });

  // testWidgets('Display HomeBloc when logged in', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: MultiProvider(
  //         providers: [
  //           Provider<SHP>(create: (_) => MockSHP()), // You might need to create a mock SHP class
  //         ],
  //         child: const MyApp(),
  //       ),
  //     ),
  //   );

  //   // Verify that HomeBloc is displayed when logged in
  //   expect(find.byType(AuthenticationScreen), findsNothing);
  //   expect(find.byType(HomeBloc), findsOneWidget);
  // });
}
