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
}
