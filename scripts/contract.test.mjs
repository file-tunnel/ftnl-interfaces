import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { test } from "node:test";

const readJson = async (path) =>
  JSON.parse(await readFile(new URL(`../${path}`, import.meta.url), "utf8"));

test("schemas are Draft 2020-12 and prohibit unknown wire fields", async () => {
  for (const name of ["tunnel", "events"]) {
    const schema = await readJson(`schema/${name}.schema.json`);
    assert.equal(schema.$schema, "https://json-schema.org/draft/2020-12/schema");
  }
  const tunnel = await readJson("schema/tunnel.schema.json");
  assert.equal(tunnel.$defs.createTunnelRequest.additionalProperties, false);
  assert.equal(tunnel.$defs.createTunnelResponse.additionalProperties, false);
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
