// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../../helpers/helpers.dart';

class MockImage extends Mock implements ui.Image {}

class MockAsset extends Mock implements Asset {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DesktopDraggableResizableImage', () {
    late ui.Image image;
    late Asset asset;

    setUp(() {
      image = MockImage();
      asset = MockAsset();

      when(() => image.width).thenReturn(200);
      when(() => image.height).thenReturn(222);
      when(() => asset.image).thenReturn(image);
      when(() => asset.bytes).thenReturn(Uint8List.fromList(transparentImage));
    });

    testWidgets('renders image as draggable point', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DesktopDraggableResizableImage(
            image: asset.bytes,
            height: asset.image.height.toDouble(),
          ),
        ),
      );
      expect(
        find.byKey(Key('draggableResizableAsset_image_draggablePoint')),
        findsOneWidget,
      );
    });

    testWidgets('image is draggable', (tester) async {
      final onUpdateCalls = <DragUpdate>[];
      await tester.pumpWidget(
        MaterialApp(
          home: DesktopDraggableResizableImage(
            image: asset.bytes,
            height: asset.image.height.toDouble(),
            onUpdate: onUpdateCalls.add,
          ),
        ),
      );
      final firstLocation = tester.getCenter(
        find.byKey(Key('draggableResizableAsset_image_draggablePoint')),
      );
      await tester.dragFrom(firstLocation, const Offset(200.0, 300.0));
      await tester.pump(kThemeAnimationDuration);
      final destination = tester.getCenter(
        find.byKey(Key('draggableResizableAsset_image_draggablePoint')),
      );
      expect(firstLocation == destination, false);
      expect(onUpdateCalls, isNotEmpty);
    });

    testWidgets(
        'top left corner as draggable point renders '
        'when canTransform is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DesktopDraggableResizableImage(
            image: asset.bytes,
            height: asset.image.height.toDouble(),
            canTransform: true,
          ),
        ),
      );
      expect(
        find.byKey(Key('draggableResizableAsset_topLeft_resizePoint')),
        findsOneWidget,
      );
    });

    testWidgets(
        'top left corner as draggable point does not render '
        'when canTransform is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DesktopDraggableResizableImage(
            image: asset.bytes,
            height: asset.image.height.toDouble(),
            canTransform: false,
          ),
        ),
      );
      expect(
        find.byKey(Key('draggableResizableAsset_topLeft_resizePoint')),
        findsNothing,
      );
    });

    testWidgets('top left corner point can resize image', (tester) async {
      final onUpdateCalls = <DragUpdate>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: DesktopDraggableResizableImage(
                  image: asset.bytes,
                  height: asset.image.height.toDouble(),
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                ),
              ),
            ],
          ),
        ),
      );
      final resizePointFinder = find.byKey(
        Key('draggableResizableAsset_topLeft_resizePoint'),
      );
      final imageFinder = find.byType(Image);
      final originalSize = tester.getSize(imageFinder);
      final firstLocation = tester.getCenter(resizePointFinder);
      await tester.dragFrom(
        firstLocation,
        Offset(firstLocation.dx - 1, firstLocation.dy - 1),
      );
      await tester.pump(kThemeAnimationDuration);
      final newSize = tester.getSize(imageFinder);
      expect(originalSize == newSize, false);
      expect(onUpdateCalls, isNotEmpty);
    });

    testWidgets(
        'top right corner as draggable point renders '
        'when canTransform is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: DesktopDraggableResizableImage(
                  image: asset.bytes,
                  height: asset.image.height.toDouble(),
                  canTransform: true,
                ),
              ),
            ],
          ),
        ),
      );
      expect(
        find.byKey(Key('draggableResizableAsset_topRight_resizePoint')),
        findsOneWidget,
      );
    });

    testWidgets(
        'top right corner as draggable point does not render '
        'when canTransform is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: DesktopDraggableResizableImage(
                  image: asset.bytes,
                  height: asset.image.height.toDouble(),
                  canTransform: false,
                ),
              ),
            ],
          ),
        ),
      );
      expect(
        find.byKey(Key('draggableResizableAsset_topRight_resizePoint')),
        findsNothing,
      );
    });

    testWidgets('top right corner point can resize image', (tester) async {
      final onUpdateCalls = <DragUpdate>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: DesktopDraggableResizableImage(
                  image: asset.bytes,
                  height: asset.image.height.toDouble(),
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                ),
              ),
            ],
          ),
        ),
      );
      final resizePointFinder = find.byKey(
        Key('draggableResizableAsset_topRight_resizePoint'),
      );
      final imageFinder = find.byType(Image);
      final originalSize = tester.getSize(imageFinder);
      final firstLocation = tester.getCenter(resizePointFinder);
      await tester.dragFrom(
        firstLocation,
        Offset(firstLocation.dx + 10, firstLocation.dy + 10),
      );
      await tester.pump(kThemeAnimationDuration);
      final newSize = tester.getSize(imageFinder);
      expect(originalSize == newSize, false);
      expect(onUpdateCalls, isNotEmpty);
    });

    testWidgets(
        'bottom right corner as draggable point renders '
        'when canTransform is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: DesktopDraggableResizableImage(
                  image: asset.bytes,
                  height: asset.image.height.toDouble(),
                  canTransform: true,
                ),
              ),
            ],
          ),
        ),
      );
      expect(
        find.byKey(Key('draggableResizableAsset_bottomRight_resizePoint')),
        findsOneWidget,
      );
    });

    testWidgets(
        'bottom right corner as draggable point does not render '
        'when canTransform is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: DesktopDraggableResizableImage(
                  image: asset.bytes,
                  height: asset.image.height.toDouble(),
                  canTransform: false,
                ),
              ),
            ],
          ),
        ),
      );
      expect(
        find.byKey(Key('draggableResizableAsset_bottomRight_resizePoint')),
        findsNothing,
      );
    });

    testWidgets('bottom right corner point can resize image', (tester) async {
      final onUpdateCalls = <DragUpdate>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: DesktopDraggableResizableImage(
                  image: asset.bytes,
                  height: asset.image.height.toDouble(),
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                ),
              ),
            ],
          ),
        ),
      );
      final resizePointFinder = find.byKey(
        Key('draggableResizableAsset_bottomRight_resizePoint'),
      );
      final imageFinder = find.byType(Image);
      final originalSize = tester.getSize(imageFinder);
      final firstLocation = tester.getCenter(resizePointFinder);
      await tester.dragFrom(
        firstLocation,
        Offset(firstLocation.dx + 10, firstLocation.dy + 10),
      );
      await tester.pump(kThemeAnimationDuration);
      final newSize = tester.getSize(imageFinder);
      expect(originalSize == newSize, false);
      expect(onUpdateCalls, isNotEmpty);
    });

    testWidgets(
        'bottom left corner as draggable point renders '
        'when canTransform is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: DesktopDraggableResizableImage(
                  image: asset.bytes,
                  height: asset.image.height.toDouble(),
                  canTransform: true,
                ),
              ),
            ],
          ),
        ),
      );
      expect(
        find.byKey(Key('draggableResizableAsset_bottomLeft_resizePoint')),
        findsOneWidget,
      );
    });

    testWidgets(
        'bottom left corner as draggable point does not render '
        'when canTransform is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: DesktopDraggableResizableImage(
                  image: asset.bytes,
                  height: asset.image.height.toDouble(),
                  canTransform: false,
                ),
              ),
            ],
          ),
        ),
      );
      expect(
        find.byKey(Key('draggableResizableAsset_bottomLeft_resizePoint')),
        findsNothing,
      );
    });

    testWidgets('bottom left corner point can resize image', (tester) async {
      final onUpdateCalls = <DragUpdate>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: DesktopDraggableResizableImage(
                  image: asset.bytes,
                  height: asset.image.height.toDouble(),
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                ),
              ),
            ],
          ),
        ),
      );
      final resizePointFinder = find.byKey(
        Key('draggableResizableAsset_bottomLeft_resizePoint'),
      );
      final imageFinder = find.byType(Image);
      final originalSize = tester.getSize(imageFinder);
      final firstLocation = tester.getCenter(resizePointFinder);
      await tester.dragFrom(
        firstLocation,
        Offset(firstLocation.dx + 10, firstLocation.dy + 10),
      );
      await tester.pump(kThemeAnimationDuration);
      final newSize = tester.getSize(imageFinder);
      expect(originalSize == newSize, false);
      expect(onUpdateCalls, isNotEmpty);
    });

    testWidgets(
        'delete button does not render when canTransform is false'
        'and there is not delete callback', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DesktopDraggableResizableImage(
            image: asset.bytes,
            height: asset.image.height.toDouble(),
            canTransform: false,
          ),
        ),
      );
      expect(
        find.byKey(Key('draggableResizableAsset_delete_image')),
        findsNothing,
      );
    });

    testWidgets(
        'delete button renders when canTransform is true and '
        'has delete callback', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DesktopDraggableResizableImage(
            image: asset.bytes,
            height: asset.image.height.toDouble(),
            canTransform: true,
            onDelete: () {},
          ),
        ),
      );
      expect(
        find.byKey(Key('draggableResizableAsset_delete_image')),
        findsOneWidget,
      );
    });
  });
}