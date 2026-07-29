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

export const pairingSecretFromUri = (uri: string): string | undefined => {
  const fragment = new URL(uri).hash.slice(1);
  return new URLSearchParams(fragment).get("c") ?? undefined;
};
