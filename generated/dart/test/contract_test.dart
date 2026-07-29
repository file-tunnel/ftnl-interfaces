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
}
