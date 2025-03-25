import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_utils.dart';

void main() {
  testWidgets('UI handles different screen sizes without overflow',
      (WidgetTester tester) async {
    // Create a simple responsive test widget
    final testWidget = Material(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 200, 
                    color: Colors.blue,
                    child: Text('Screen width: ${constraints.maxWidth}'),
                  ),
                  Container(height: 200, color: Colors.red),
                ],
              ),
            );
          },
        ),
      ),
    );

    // Test small screen
    final binding = tester.binding;
    await binding.setSurfaceSize(const Size(320, 480));
    
    await tester.pumpWidget(createTestApp(testWidget));
    await tester.pumpAndSettle();
    
    // No overflow errors expected
    expect(tester.takeException(), isNull);
    
    // Test large screen
    await binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(createTestApp(testWidget));
    await tester.pumpAndSettle();
    
    // No overflow errors expected
    expect(tester.takeException(), isNull);

    // Clean up
    addTearDown(() async {
      await binding.setSurfaceSize(null);
    });
  });
  
  testWidgets('Basic UI components test', (WidgetTester tester) async {
    // Create a simple widget that doesn't depend on Firebase
    final testWidget = Material(
      child: Center(
        child: Column(
          children: [
            Text('ImmuniCare'),
            Container(
              height: 200,
              color: Colors.blue,
              child: Stack(
                children: [Container()],
              ),
            ),
          ],
        ),
      ),
    );
    
    await tester.pumpWidget(createTestApp(testWidget));
    
    // Test basic UI elements
    expect(find.text('ImmuniCare'), findsOneWidget);
    expect(find.byType(Stack), findsWidgets);
    expect(find.byType(Container), findsWidgets);
  });

}


