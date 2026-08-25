//! Reviewable Rust snapshot of the File Tunnel v1 wire contract.

use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum TunnelStatus {
    Waiting,
    Connected,
    Transferring,
    Complete,
    Cancelled,
    Expired,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum FileStatus {
    Declared,
    Uploading,
    Available,
    Downloaded,
    Rejected,
    Cancelled,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub struct CreateTunnelRequest {
    pub application_id: String,
    #[serde(default)]
    pub accept: Vec<String>,
    pub max_files: Option<u16>,
    pub max_file_bytes: Option<u64>,
    pub expires_in_seconds: Option<u32>,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub struct CreateTunnelResponse {
    pub api_version: String,
    pub tunnel_id: Uuid,
    pub status: TunnelStatus,
    pub pairing_uri: String,
    pub desktop_capability: String,
    pub expires_at: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub struct DeclareFileRequest {
    pub name: String,
    pub media_type: String,
    pub size_bytes: u64,
    pub last_modified_ms: Option<u64>,
    pub sha256: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub struct FileDescriptor {
    pub file_id: Uuid,
    pub name: String,
    pub media_type: String,
    pub size_bytes: u64,
    pub bytes_transferred: u64,
    pub status: FileStatus,
    pub created_at: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub struct TunnelEvent {
    pub event_id: Uuid,
    pub sequence: u64,
    pub occurred_at: String,
    pub tunnel_id: Uuid,
    pub kind: String,
    pub file_id: Option<Uuid>,
    pub bytes_transferred: Option<u64>,
    pub reason_code: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(untagged)]
pub enum ProximityMessage {
    Discovery(DiscoveryAdvertisement),
    Hello(HandshakeHello),
    EncryptedFrame(EncryptedFrame),
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct DiscoveryAdvertisement {
    pub message_type: DiscoveryMessageType,
    pub protocol_version: u8,
    pub service_id: String,
    pub discovery_id: String,
    pub expires_at: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum DiscoveryMessageType {
    Discovery,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct HandshakeHello {
    pub message_type: HelloMessageType,
    pub protocol_version: u8,
    pub attempt_id: Uuid,
    pub role: HandshakeRole,
    pub ephemeral_public_key_b64url: String,
    pub nonce_b64url: String,
    pub expires_at: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum HelloMessageType {
    Hello,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum HandshakeRole {
    Initiator,
    Responder,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct EncryptedFrame {
    pub message_type: EncryptedFrameMessageType,
    pub protocol_version: u8,
    pub session_id: Uuid,
    pub sequence: u32,
    pub nonce_b64url: String,
    pub ciphertext_b64url: String,
    pub expires_at: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum EncryptedFrameMessageType {
    EncryptedFrame,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(untagged)]
pub enum ProximityPayload {
    SharedAuthStepUp(SharedAuthStepUpPayload),
    PeerInfoOffer(PeerInfoOfferPayload),
    UpdateManifestOffer(UpdateManifestOfferPayload),
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct SharedAuthStepUpPayload {
    pub payload_type: SharedAuthPayloadType,
    pub exchange_id: Uuid,
    pub recipient_device_fingerprint: String,
    pub opaque_request_b64url: String,
    pub expires_at: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum SharedAuthPayloadType {
    SharedAuthStepUp,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct PeerInfoOfferPayload {
    pub payload_type: PeerInfoPayloadType,
    pub transfer_id: Uuid,
    pub media_type: String,
    pub content_size_bytes: u32,
    pub content_sha256: String,
    pub content_b64url: String,
    pub expires_at: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum PeerInfoPayloadType {
    PeerInfoOffer,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct UpdateManifestOfferPayload {
    pub payload_type: UpdateManifestPayloadType,
    pub application_id: String,
    pub platform: UpdatePlatform,
    pub version: String,
    pub distribution: UpdateDistribution,
    pub manifest_url: String,
    pub manifest_sha256: String,
    pub signature_algorithm: SignatureAlgorithm,
    pub signer_key_id: String,
    pub manifest_signature_b64url: String,
    pub expires_at: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum UpdateManifestPayloadType {
    UpdateManifestOffer,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum UpdatePlatform {
    Android,
    Ios,
    Linux,
    Macos,
    Windows,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum UpdateDistribution {
    AppStore,
    Testflight,
    PlayStore,
    ManagedDistribution,
    DirectSignedPackage,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum SignatureAlgorithm {
    Ed25519,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn unknown_event_kinds_remain_forward_compatible() {
        let event = TunnelEvent {
            event_id: Uuid::nil(),
            sequence: 1,
            occurred_at: "2026-07-29T00:00:00Z".into(),
            tunnel_id: Uuid::nil(),
            kind: "future.kind".into(),
            file_id: None,
            bytes_transferred: None,
            reason_code: None,
        };
        let value = serde_json::to_value(event).unwrap();
        assert_eq!(value["kind"], "future.kind");
    }

    #[test]
    fn proximity_fixtures_match_generated_types() {
        let frame: ProximityMessage =
            serde_json::from_str(include_str!("../../../fixtures/proximity-frame.json")).unwrap();
        assert!(matches!(frame, ProximityMessage::EncryptedFrame(_)));

        let payloads: Vec<ProximityPayload> = serde_json::from_str(include_str!(
            "../../../fixtures/proximity-decrypted-payloads.json"
        ))
        .unwrap();
        assert_eq!(payloads.len(), 3);
    }

    #[test]
    fn proximity_types_reject_unknown_fields() {
        let frame = include_str!("../../../fixtures/proximity-frame.json");
        let mut value: serde_json::Value = serde_json::from_str(frame).unwrap();
        value["access_token"] = "must-not-be-accepted".into();
        assert!(serde_json::from_value::<ProximityMessage>(value).is_err());
    }
}
