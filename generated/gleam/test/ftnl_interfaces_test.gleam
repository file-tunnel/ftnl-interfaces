import ftnl_interfaces
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn fragment_secret_test() {
  ftnl_interfaces.pairing_secret_from_uri(
    "https://upload.file-tunnel.dev/t/id#c=secret",
  )
  |> should.equal(Ok("secret"))
}

pub fn proximity_payload_type_test() {
  let payload =
    ftnl_interfaces.SharedAuthStepUpPayload(
      exchange_id: "00000000-0000-4000-8000-000000000011",
      recipient_device_fingerprint: "fingerprint",
      opaque_request_b64url: "opaque",
      expires_at: "2026-08-24T18:05:00Z",
    )

  payload
  |> should.equal(ftnl_interfaces.SharedAuthStepUpPayload(
    exchange_id: "00000000-0000-4000-8000-000000000011",
    recipient_device_fingerprint: "fingerprint",
    opaque_request_b64url: "opaque",
    expires_at: "2026-08-24T18:05:00Z",
  ))
}
