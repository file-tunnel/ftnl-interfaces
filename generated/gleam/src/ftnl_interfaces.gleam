import gleam/list
import gleam/option.{None, Some}
import gleam/uri

pub type TunnelStatus {
  Waiting
  Connected
  Transferring
  Complete
  TunnelCancelled
  Expired
}

pub type FileStatus {
  Declared
  Uploading
  Available
  Downloaded
  Rejected
  FileCancelled
}

pub type HandshakeRole {
  Initiator
  Responder
}

pub type UpdatePlatform {
  Android
  Ios
  Linux
  Macos
  Windows
}

pub type UpdateDistribution {
  AppStore
  Testflight
  PlayStore
  ManagedDistribution
  DirectSignedPackage
}

pub type ProximityMessage {
  DiscoveryAdvertisement(
    protocol_version: Int,
    service_id: String,
    discovery_id: String,
    expires_at: String,
  )
  HandshakeHello(
    protocol_version: Int,
    attempt_id: String,
    role: HandshakeRole,
    ephemeral_public_key_b64url: String,
    nonce_b64url: String,
    expires_at: String,
  )
  EncryptedFrame(
    protocol_version: Int,
    session_id: String,
    sequence: Int,
    nonce_b64url: String,
    ciphertext_b64url: String,
    expires_at: String,
  )
}

pub type ProximityPayload {
  SharedAuthStepUpPayload(
    exchange_id: String,
    recipient_device_fingerprint: String,
    opaque_request_b64url: String,
    expires_at: String,
  )
  PeerInfoOfferPayload(
    transfer_id: String,
    media_type: String,
    content_size_bytes: Int,
    content_sha256: String,
    content_b64url: String,
    expires_at: String,
  )
  UpdateManifestOfferPayload(
    application_id: String,
    platform: UpdatePlatform,
    version: String,
    distribution: UpdateDistribution,
    manifest_url: String,
    manifest_sha256: String,
    signer_key_id: String,
    manifest_signature_b64url: String,
    expires_at: String,
  )
}

pub type TunnelEvent {
  TunnelEvent(
    event_id: String,
    sequence: Int,
    occurred_at: String,
    tunnel_id: String,
    kind: String,
    file_id: String,
    bytes_transferred: Int,
    reason_code: String,
  )
}

pub fn pairing_secret_from_uri(value: String) -> Result(String, Nil) {
  case uri.parse(value) {
    Error(_) -> Error(Nil)
    Ok(parsed) ->
      case parsed.fragment {
        None -> Error(Nil)
        Some(fragment) ->
          case uri.parse_query(fragment) {
            Error(_) -> Error(Nil)
            Ok(pairs) -> list.key_find(pairs, "c")
          }
      }
  }
}
