import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { test } from "node:test";

const readJson = async (path) =>
  JSON.parse(await readFile(new URL(`../${path}`, import.meta.url), "utf8"));

test("schemas are Draft 2020-12 and prohibit unknown contract fields", async () => {
  for (const name of ["tunnel", "events", "proximity", "desktop-companion"]) {
    const schema = await readJson(`schema/${name}.schema.json`);
    assert.equal(schema.$schema, "https://json-schema.org/draft/2020-12/schema");

    for (const definition of Object.values(schema.$defs ?? {})) {
      if (definition.type === "object") {
        assert.equal(definition.additionalProperties, false);
      }
    }
  }
  const tunnel = await readJson("schema/tunnel.schema.json");
  assert.equal(tunnel.$defs.createTunnelRequest.additionalProperties, false);
  assert.equal(tunnel.$defs.createTunnelResponse.additionalProperties, false);
});

test("proximity keeps identity proofs and update binaries off the radio", async () => {
  const proximity = await readJson("schema/proximity.schema.json");
  const payloads = await readJson("fixtures/proximity-decrypted-payloads.json");
  const payloadTypes = payloads.map((payload) => payload.payload_type).sort();

  assert.deepEqual(payloadTypes, [
    "peer_info_offer",
    "shared_auth_step_up",
    "update_manifest_offer",
  ]);
  assert.equal(
    proximity.$defs.sharedAuthStepUpPayload.properties.opaque_request_b64url.maxLength,
    2731,
  );
  assert.equal(
    proximity.$defs.peerInfoOfferPayload.properties.content_size_bytes.maximum,
    32768,
  );
  assert.equal(
    proximity.$defs.updateManifestOfferPayload.properties.manifest_url.pattern,
    "^https://",
  );

  const forbiddenProperties = new Set([
    "access_token",
    "assurance_level",
    "authorization",
    "bearer_token",
    "factor_result",
    "otp",
    "password",
    "private_key",
    "refresh_token",
  ]);
  const propertyNames = [];
  const visit = (value) => {
    if (Array.isArray(value)) {
      value.forEach(visit);
    } else if (value && typeof value === "object") {
      if (value.properties) propertyNames.push(...Object.keys(value.properties));
      Object.values(value).forEach(visit);
    }
  };
  visit(proximity);
  assert.deepEqual(
    propertyNames.filter((name) => forbiddenProperties.has(name)),
    [],
  );
});

test("desktop contract changes account for Rust and Flutter", async () => {
  const schema = await readJson("schema/desktop-companion.schema.json");
  const parity = await readJson("fixtures/desktop-companion-proximity-v1.json");

  assert.deepEqual(
    Object.keys(schema.properties.implementations.properties).sort(),
    ["flutter_desktop", "rust_desktop"],
  );
  assert.deepEqual(Object.keys(parity.implementations).sort(), [
    "flutter_desktop",
    "rust_desktop",
  ]);
  for (const impact of Object.values(parity.implementations)) {
    assert.ok(["implemented", "not_affected", "blocked"].includes(impact.status));
    if (impact.status !== "implemented") {
      assert.ok(Date.parse(`${impact.review_expires_on}T23:59:59Z`) >= Date.now());
    }
  }
});

test("fixtures cover pairing and monotonic event sequencing", async () => {
  const created = await readJson("fixtures/tunnel-created.json");
  assert.equal(created.api_version, "v1");
  assert.match(created.pairing_uri, /#c=/);
  assert.ok(!created.pairing_uri.includes("?c="));

  const events = await readJson("fixtures/events.json");
  assert.ok(events.length >= 2);
  for (let index = 1; index < events.length; index += 1) {
    assert.ok(events[index].sequence > events[index - 1].sequence);
  }

  const frame = await readJson("fixtures/proximity-frame.json");
  assert.equal(frame.message_type, "encrypted_frame");
  assert.equal(frame.protocol_version, 1);
  assert.ok(frame.ciphertext_b64url.length <= 49152);
});

test("HTTP and realtime contracts reference canonical schemas", async () => {
  const openapi = await readFile(
    new URL("../openapi/ftnl.openapi.yaml", import.meta.url),
    "utf8",
  );
  const asyncapi = await readFile(
    new URL("../asyncapi/ftnl.asyncapi.yaml", import.meta.url),
    "utf8",
  );
  assert.match(openapi, /tunnel\.schema\.json/);
  assert.match(asyncapi, /events\.schema\.json/);
  assert.match(openapi, /event-tickets/);
});
