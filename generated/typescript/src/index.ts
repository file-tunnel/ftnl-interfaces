export type TunnelStatus =
  | "waiting"
  | "connected"
  | "transferring"
  | "complete"
  | "cancelled"
  | "expired";

export type FileStatus =
  | "declared"
  | "uploading"
  | "available"
  | "downloaded"
  | "rejected"
  | "cancelled";

export interface CreateTunnelRequest {
  application_id: string;
  accept?: string[];
  max_files?: number;
  max_file_bytes?: number;
  expires_in_seconds?: number;
}

export interface CreateTunnelResponse {
  api_version: "v1";
  tunnel_id: string;
  status: TunnelStatus;
  pairing_uri: string;
  desktop_capability: string;
  expires_at: string;
}

export interface DeclareFileRequest {
  name: string;
  media_type: string;
  size_bytes: number;
  last_modified_ms?: number;
  sha256?: string;
}

export interface FileDescriptor {
  file_id: string;
  name: string;
  media_type: string;
  size_bytes: number;
  bytes_transferred: number;
  status: FileStatus;
  created_at: string;
}

export interface TunnelSnapshot {
  tunnel_id: string;
  status: TunnelStatus;
  expires_at: string;
  files: FileDescriptor[];
}

export interface TunnelEvent {
  event_id: string;
  sequence: number;
  occurred_at: string;
  tunnel_id: string;
  kind: string;
  file_id?: string;
  bytes_transferred?: number;
  reason_code?: string;
}

export type ProximityMessage =
  | DiscoveryAdvertisement
  | HandshakeHello
  | EncryptedFrame;

export interface DiscoveryAdvertisement {
  message_type: "discovery";
  protocol_version: 1;
  service_id: "66746e6c-0001-4b4c-8000-66746e6c0001";
  discovery_id: string;
  expires_at: string;
}

export interface HandshakeHello {
  message_type: "hello";
  protocol_version: 1;
  attempt_id: string;
  role: "initiator" | "responder";
  ephemeral_public_key_b64url: string;
  nonce_b64url: string;
  expires_at: string;
}

export interface EncryptedFrame {
  message_type: "encrypted_frame";
  protocol_version: 1;
  session_id: string;
  sequence: number;
  nonce_b64url: string;
  ciphertext_b64url: string;
  expires_at: string;
}

export type ProximityPayload =
  | SharedAuthStepUpPayload
  | PeerInfoOfferPayload
  | UpdateManifestOfferPayload;

export interface SharedAuthStepUpPayload {
  payload_type: "shared_auth_step_up";
  exchange_id: string;
  recipient_device_fingerprint: string;
  opaque_request_b64url: string;
  expires_at: string;
}

export interface PeerInfoOfferPayload {
  payload_type: "peer_info_offer";
  transfer_id: string;
  media_type: string;
  content_size_bytes: number;
  content_sha256: string;
  content_b64url: string;
  expires_at: string;
}

export interface UpdateManifestOfferPayload {
  payload_type: "update_manifest_offer";
  application_id: string;
  platform: "android" | "ios" | "linux" | "macos" | "windows";
  version: string;
  distribution:
    | "app_store"
    | "testflight"
    | "play_store"
    | "managed_distribution"
    | "direct_signed_package";
  manifest_url: string;
  manifest_sha256: string;
  signature_algorithm: "ed25519";
  signer_key_id: string;
  manifest_signature_b64url: string;
  expires_at: string;
}

export const pairingSecretFromUri = (uri: string): string | undefined => {
  const fragment = new URL(uri).hash.slice(1);
  return new URLSearchParams(fragment).get("c") ?? undefined;
};
