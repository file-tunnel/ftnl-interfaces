import assert from "node:assert/strict";
import { test } from "node:test";
import { pairingSecretFromUri } from "../dist/index.js";

test("pairing credentials are read from the fragment", () => {
  const uri = "https://upload.file-tunnel.dev/t/id#c=secret";
  assert.equal(pairingSecretFromUri(uri), "secret");
});

test("query credentials are not accepted", () => {
  const uri = "https://upload.file-tunnel.dev/t/id?c=leaky";
  assert.equal(pairingSecretFromUri(uri), undefined);
});
