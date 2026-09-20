import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/card_image/fallback_file_service.dart';
import 'package:data/src/datasource/card_image/image_fallback.dart';
import 'package:data/src/datasource/card_image/image_load_monitor.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockImageLoadMonitor extends Mock implements ImageLoadMonitor {}

class FakeRequest extends Fake implements http.BaseRequest {}

const _url = 'https://r2.example.com/A.jpg';
const _subUrl = 'https://sub.example.com/A.jpg';

void main() {
  late MockHttpClient client;
  late MockImageLoadMonitor monitor;
  late FallbackFileService service;

  setUpAll(() {
    registerFallbackValue(FakeRequest());
  });

  setUp(() {
    client = MockHttpClient();
    monitor = MockImageLoadMonitor();
    service = FallbackFileService(monitor: monitor, client: client);
  });

  /// [url] への送信の結果を決める。[status] が null なら [error] を投げる。
  void stubSend(String url, {int? status, Object? error}) {
    when(
      () => client.send(
        any(that: isA<http.BaseRequest>().having((r) => '${r.url}', 'url', url)),
      ),
    ).thenAnswer((_) async {
      if (status == null) {
        throw error!;
      }
      return http.StreamedResponse(
        Stream.value([1, 2, 3]),
        status,
        request: http.Request('GET', Uri.parse(url)),
      );
    });
  }

  Future<FileServiceResponse> get() {
    return service.get(_url, headers: ImageFallback.headers(_subUrl));
  }

  test('主系で取れたら、それを返す。代わりの配信元は使わず、計測もしない', () async {
    stubSend(_url, status: 200);

    expect((await get()).statusCode, 200);
    verifyNever(() => client.send(any(that: _requestTo(_subUrl))));
    verifyNever(
      () => monitor.recordFailure(
        url: any(named: 'url'),
        error: any(named: 'error'),
        recovered: any(named: 'recovered'),
      ),
    );
  });

  test('主系が遮断されていたら、代わりの配信元から取り、救えたものとして計測する', () async {
    stubSend(_url, error: const HandshakeException('WRONG_VERSION_NUMBER'));
    stubSend(_subUrl, status: 200);

    expect((await get()).statusCode, 200);
    verify(
      () => monitor.recordFailure(
        url: _url,
        error: any(named: 'error', that: isA<HandshakeException>()),
        recovered: true,
      ),
    ).called(1);
  });

  test('主系がエラーの状態なら、代わりの配信元から取る', () async {
    stubSend(_url, status: 503);
    stubSend(_subUrl, status: 200);

    expect((await get()).statusCode, 200);
    verify(
      () => monitor.recordFailure(
        url: _url,
        error: any(named: 'error', that: isA<HttpExceptionWithStatus>()),
        recovered: true,
      ),
    ).called(1);
  });

  test('代わりの配信元でも取れなければ、主系の結果を返して失敗として計測する', () async {
    stubSend(_url, status: 404);
    stubSend(_subUrl, status: 500);

    expect((await get()).statusCode, 404);
    verify(
      () => monitor.recordFailure(
        url: _url,
        error: any(named: 'error'),
        recovered: false,
      ),
    ).called(1);
  });

  test('主系が応答せず代わりの配信元でも取れなければ、主系の例外を投げる', () async {
    const cause = SocketException('Failed host lookup');
    stubSend(_url, error: cause);
    stubSend(_subUrl, error: const SocketException('だめ'));

    await expectLater(get(), throwsA(same(cause)));
    verify(
      () => monitor.recordFailure(
        url: _url,
        error: cause,
        recovered: false,
      ),
    ).called(1);
  });

  test('代わりの配信元の URL を運ぶヘッダは、送信するリクエストに載せない', () async {
    stubSend(_url, status: 200);

    await service.get(_url, headers: {
      ...ImageFallback.headers(_subUrl),
      'x-other': 'value',
    });

    final request = verify(() => client.send(captureAny())).captured.single
        as http.BaseRequest;
    expect(request.headers.containsKey(ImageFallback.headerKey), isFalse);
    expect(request.headers['x-other'], 'value');
  });
}

Matcher _requestTo(String url) {
  return isA<http.BaseRequest>().having((r) => '${r.url}', 'url', url);
}
