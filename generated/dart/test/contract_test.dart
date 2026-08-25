import 'dart:convert';
import 'dart:io';

import 'package:ftnl_interfaces/ftnl_interfaces.dart';
import 'package:test/test.dart';

void main() {
  test('pairing secret is fragment-only', () {
    expect(
      pairingSecretFromUri(Uri.parse('https://example.test/t/id#c=secret')),
      'secret',
    );
    expect(
      pairingSecretFromUri(Uri.parse('https://example.test/t/id?c=leaky')),
      isNull,
    );
  });

  test('proximity fixtures match generated discriminated types', () {
    final frame =
        jsonDecode(
              File('../../fixtures/proximity-frame.json').readAsStringSync(),
            )
            as Map<String, Object?>;
    expect(ProximityMessage.fromJson(frame), isA<EncryptedFrame>());

    final payloads =
        jsonDecode(
              File(
                '../../fixtures/proximity-decrypted-payloads.json',
              ).readAsStringSync(),
            )
            as List<Object?>;
    expect(
      payloads.map(
        (payload) => ProximityPayload.fromJson(
          (payload! as Map).cast<String, Object?>(),
        ),
      ),
      containsAll([
        isA<SharedAuthStepUpPayload>(),
        isA<PeerInfoOfferPayload>(),
        isA<UpdateManifestOfferPayload>(),
      ]),
    );
  });

  test('proximity parsers reject credential-shaped extension fields', () {
    final frame =
        (jsonDecode(
                  File(
                    '../../fixtures/proximity-frame.json',
                  ).readAsStringSync(),
                )
                as Map)
            .cast<String, Object?>();
    frame['access_token'] = 'must-not-be-accepted';
    expect(
      () => ProximityMessage.fromJson(frame),
      throwsA(isA<FormatException>()),
    );
  });
}
