import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  late MockClient client;
  late MockClientState clientState;
  late MockChannel channel;
  late MockChannelState channelState;
  const methodChannel =
      MethodChannel('dev.fluttercommunity.plus/connectivity_status');

  setUpAll(() {
    client = MockClient();
    clientState = MockClientState();
    channel = MockChannel();
    channelState = MockChannelState();
    final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
    when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
    when(() => channel.state).thenReturn(channelState);
    when(() => channel.client).thenReturn(client);
    when(() => channel.isMuted).thenReturn(false);
    when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
    when(() => channel.extraDataStream).thenAnswer(
      (i) => Stream.value({
        'name': 'test',
      }),
    );
    when(() => channel.extraData).thenReturn({
      'name': 'test',
    });
  });

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (MethodCall methodCall) async {
      if (methodCall.method == 'listen') {
        try {
          await TestDefaultBinaryMessengerBinding
              .instance.defaultBinaryMessenger
              .handlePlatformMessage(
            methodChannel.name,
            methodChannel.codec.encodeSuccessEnvelope(['wifi']),
            (_) {},
          );
        } catch (e) {
          print(e);
        }
      }
      return null;
    });
  });

  testWidgets(
    'it should show channel typing',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: PopScope(
                onPopInvokedWithResult: (bool didPop, res) async => false,
                child: Scaffold(
                  appBar: StreamGalleryHeader(
                    attachment: MockAttachment(),
                    message: Message(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.byType(StreamSvgIcon), findsNWidgets(2));
    },
  );

  goldenTest(
    'golden test for GalleryHeader',
    fileName: 'gallery_header_0',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    builder: () {
      return MaterialAppWrapper(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: PopScope(
              onPopInvokedWithResult: (bool didPop, res) async => false,
              child: Scaffold(
                appBar: StreamGalleryHeader(
                  userName: 'User',
                  sentAt: '12:02 AM',
                  message: Message(),
                  attachment: MockAttachment(),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
  });
}
