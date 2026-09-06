import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { test } from "node:test";
import Ajv2020 from "ajv/dist/2020.js";
import addFormats from "ajv-formats";

const readJson = async (path) =>
  JSON.parse(await readFile(new URL(`../${path}`, import.meta.url), "utf8"));

test("schemas are Draft 2020-12 and prohibit unknown contract fields", async () => {
  const ajv = new Ajv2020({ allErrors: true, strict: true });
  addFormats(ajv);
  for (const name of [
    "tunnel",
    "events",
    "proximity",
    "desktop-companion",
    "desktop-workspace",
  ]) {
    const schema = await readJson(`schema/${name}.schema.json`);
    assert.equal(schema.$schema, "https://json-schema.org/draft/2020-12/schema");
    assert.doesNotThrow(() => ajv.compile(schema), `${name} schema must compile`);

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

test("legacy proximity and desktop companion fixtures remain valid", async () => {
  const ajv = new Ajv2020({ allErrors: true, strict: true });
  addFormats(ajv);
  for (const [schemaName, fixtureName] of [
    ["proximity", "proximity-frame"],
    ["desktop-companion", "desktop-companion-proximity-v1"],
  ]) {
    const schema = await readJson(`schema/${schemaName}.schema.json`);
    const fixture = await readJson(`fixtures/${fixtureName}.json`);
    const validate = ajv.compile(schema);
    assert.equal(
      validate(fixture),
      true,
      `${fixtureName} must satisfy ${schemaName}: ${JSON.stringify(validate.errors)}`,
    );
  }
});

test("desktop workspace accepts canonical documents and rejects negative vectors", async () => {
  const schema = await readJson("schema/desktop-workspace.schema.json");
  const ajv = new Ajv2020({ allErrors: true, strict: true });
  addFormats(ajv);
  const validate = ajv.compile(schema);

  for (const fixture of [
    "desktop-workspace-parity-v1",
    "desktop-workspace-snapshot-v1",
    "desktop-workspace-encrypted-snapshot-v1",
    "desktop-workspace-commands-v1",
  ]) {
    const document = await readJson(`fixtures/${fixture}.json`);
    assert.equal(
      validate(document),
      true,
      `${fixture} must satisfy the canonical schema: ${JSON.stringify(validate.errors)}`,
    );
  }

  const invalid = await readJson("fixtures/desktop-workspace-invalid-v1.json");
  assert.ok(invalid.length >= 5);
  for (const vector of invalid) {
    assert.equal(validate(vector.document), false, vector.name);
  }
});

test("desktop feature manifests are complete, ordered, unique, and semantically equal", async () => {
  const manifest = await readJson("fixtures/desktop-workspace-parity-v1.json");
  const rust = manifest.rust_desktop.features.map(({ feature_id, status }) => ({
    feature_id,
    status,
  }));
  const flutter = manifest.flutter_desktop.features.map(
    ({ feature_id, status }) => ({ feature_id, status }),
  );
  const ids = rust.map(({ feature_id }) => feature_id);

  assert.deepEqual(rust, flutter);
  assert.deepEqual(ids, [...ids].sort());
  assert.equal(new Set(ids).size, ids.length);
  assert.equal(ids.length, 14);
  assert.equal(ids.at(-1), "proximity.secure_session");
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

test("private worker JSON Schema accepts bounded references and rejects unsafe envelopes", async () => {
  const schema = await readJson("validation/authorities/server/contracts.json");
  const ajv = new Ajv2020({ allErrors: true, strict: true });
  ajv.addKeyword({ keyword: "contractVersion", schemaType: "string" });
  ajv.addKeyword({ keyword: "visibility", schemaType: "string" });
  const validate = ajv.compile(schema);
  const valid = {
    protocol: "file-tunnel.worker/v1",
    job_id: "job_01",
    idempotency_key: "operation_01",
    product_scope: {
      scope_kind: "organization",
      scope_id: "org_01",
    },
    kind: "embedding_batch",
    workload: {
      item_count: 128,
      vector_dimensions: 384,
    },
    input: {
      store_id: "canonical-store",
      object_id: "source-object",
      version: "v1",
      content_digest: `sha256:${"a".repeat(64)}`,
      expected_bytes: 4096,
    },
    output: {
      store_id: "derived-store",
      object_id: "embedding-object",
      version: "v1",
    },
    submitted_at_unix: 100,
    deadline_unix: 200,
    max_output_bytes: 8192,
  };

  assert.equal(
    validate(valid),
    true,
    `canonical worker job must validate: ${JSON.stringify(validate.errors)}`,
  );

  const invalid = [
    {
      name: "remote object URL",
      mutate: (document) => {
        document.input.object_id = "https://storage.example/file";
      },
    },
    {
      name: "inline payload",
      mutate: (document) => {
        document.inline_bytes_b64 = "Zm9yYmlkZGVu";
      },
    },
    {
      name: "unknown operation",
      mutate: (document) => {
        document.kind = "shell_command";
      },
    },
    {
      name: "oversized workload",
      mutate: (document) => {
        document.workload.item_count = 100001;
      },
    },
    {
      name: "uppercase digest",
      mutate: (document) => {
        document.input.content_digest = `sha256:${"A".repeat(64)}`;
      },
    },
    {
      name: "unknown product scope field",
      mutate: (document) => {
        document.product_scope.membership_proof = "forbidden";
      },
    },
  ];

  for (const vector of invalid) {
    const candidate = structuredClone(valid);
    vector.mutate(candidate);
    assert.equal(validate(candidate), false, vector.name);
  }
});

test("private worker definitions never enter browser or edge exports", async () => {
  for (const runtime of ["browser", "edge"]) {
    const entrypoint = await readFile(
      new URL(
        `../generated/final/typescript/runtime/${runtime}/index.ts`,
        import.meta.url,
      ),
      "utf8",
    );
    assert.doesNotMatch(entrypoint, /server/);
    assert.doesNotMatch(entrypoint, /WorkerJob|WorkerReceipt/);
  }

  const nodeEntrypoint = await readFile(
    new URL(
      "../generated/final/typescript/runtime/node/index.ts",
      import.meta.url,
    ),
    "utf8",
  );
  assert.match(nodeEntrypoint, /server/);
  assert.match(nodeEntrypoint, /WorkerJob/);
});
