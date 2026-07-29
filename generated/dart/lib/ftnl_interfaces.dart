enum TunnelStatus {
  waiting,
  connected,
  transferring,
  complete,
  cancelled,
  expired,
}

enum FileStatus {
  declared,
  uploading,
  available,
  downloaded,
  rejected,
  cancelled,
}

final class CreateTunnelRequest {
  const CreateTunnelRequest({
    required this.applicationId,
    this.accept = const ['image/*'],
    this.maxFiles = 10,
    this.maxFileBytes = 50 * 1024 * 1024,
    this.expiresInSeconds = 600,
  });

  final String applicationId;
  final List<String> accept;
  final int maxFiles;
  final int maxFileBytes;
  final int expiresInSeconds;

  Map<String, Object> toJson() => {
    'application_id': applicationId,
    'accept': accept,
    'max_files': maxFiles,
    'max_file_bytes': maxFileBytes,
    'expires_in_seconds': expiresInSeconds,
  };
}

final class TunnelEvent {
  const TunnelEvent({
    required this.eventId,
    required this.sequence,
    required this.occurredAt,
    required this.tunnelId,
    required this.kind,
    this.fileId,
    this.bytesTransferred,
    this.reasonCode,
  });

  final String eventId;
  final int sequence;
  final DateTime occurredAt;
  final String tunnelId;
  final String kind;
  final String? fileId;
  final int? bytesTransferred;
  final String? reasonCode;

  factory TunnelEvent.fromJson(Map<String, Object?> json) => TunnelEvent(
    eventId: json['event_id']! as String,
    sequence: json['sequence']! as int,
    occurredAt: DateTime.parse(json['occurred_at']! as String),
    tunnelId: json['tunnel_id']! as String,
    kind: json['kind']! as String,
    fileId: json['file_id'] as String?,
    bytesTransferred: json['bytes_transferred'] as int?,
    reasonCode: json['reason_code'] as String?,
  );
}

String? pairingSecretFromUri(Uri uri) =>
    uri.fragment.isEmpty ? null : Uri.splitQueryString(uri.fragment)['c'];
