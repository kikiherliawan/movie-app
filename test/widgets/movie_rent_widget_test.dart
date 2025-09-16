import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/screens/rentscreen/rentscreen.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
  });

  testWidgets('Menampilkan CircularProgressIndicator saat loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: RentListScreen(firestore: fakeFirestore)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Menampilkan pesan kosong saat tidak ada data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: RentListScreen(firestore: fakeFirestore)),
    );

    await tester.pump();

    expect(find.text('Belum ada film yang disewa'), findsOneWidget);
  });
}
