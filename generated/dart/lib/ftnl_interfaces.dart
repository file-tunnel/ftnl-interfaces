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

sealed class ProximityMessage {
  const ProximityMessage();

  factory ProximityMessage.fromJson(Map<String, Object?> json) =>
      switch (json['message_type']) {
        'discovery' => DiscoveryAdvertisement.fromJson(json),
        'hello' => HandshakeHello.fromJson(json),
        'encrypted_frame' => EncryptedFrame.fromJson(json),
        _ => throw const FormatException('unknown proximity message type'),
      };
}

final class DiscoveryAdvertisement extends ProximityMessage {
  const DiscoveryAdvertisement({
    required this.protocolVersion,
    required this.serviceId,
    required this.discoveryId,
    required this.expiresAt,
  });

  final int protocolVersion;
  final String serviceId;
  final String discoveryId;
  final DateTime expiresAt;

  factory DiscoveryAdvertisement.fromJson(Map<String, Object?> json) {
    _requireExactKeys(json, const {
      'message_type',
      'protocol_version',
      'service_id',
      'discovery_id',
      'expires_at',
    });
    return DiscoveryAdvertisement(
      protocolVersion: json['protocol_version']! as int,
      serviceId: json['service_id']! as String,
      discoveryId: json['discovery_id']! as String,
      expiresAt: DateTime.parse(json['expires_at']! as String),
    );
  }
}

final class HandshakeHello extends ProximityMessage {
  const HandshakeHello({
    required this.protocolVersion,
    required this.attemptId,
    required this.role,
    required this.ephemeralPublicKeyB64Url,
    required this.nonceB64Url,
    required this.expiresAt,
  });

  final int protocolVersion;
  final String attemptId;
  final String role;
  final String ephemeralPublicKeyB64Url;
  final String nonceB64Url;
  final DateTime expiresAt;

  factory HandshakeHello.fromJson(Map<String, Object?> json) {
    _requireExactKeys(json, const {
      'message_type',
      'protocol_version',
      'attempt_id',
      'role',
      'ephemeral_public_key_b64url',
      'nonce_b64url',
      'expires_at',
    });
    return HandshakeHello(
      protocolVersion: json['protocol_version']! as int,
      attemptId: json['attempt_id']! as String,
      role: json['role']! as String,
      ephemeralPublicKeyB64Url: json['ephemeral_public_key_b64url']! as String,
      nonceB64Url: json['nonce_b64url']! as String,
      expiresAt: DateTime.parse(json['expires_at']! as String),
    );
  }
}

final class EncryptedFrame extends ProximityMessage {
  const EncryptedFrame({
    required this.protocolVersion,
    required this.sessionId,
    required this.sequence,
    required this.nonceB64Url,
    required this.ciphertextB64Url,
    required this.expiresAt,
  });

  final int protocolVersion;
  final String sessionId;
  final int sequence;
  final String nonceB64Url;
  final String ciphertextB64Url;
  final DateTime expiresAt;

  factory EncryptedFrame.fromJson(Map<String, Object?> json) {
    _requireExactKeys(json, const {
      'message_type',
      'protocol_version',
      'session_id',
      'sequence',
      'nonce_b64url',
      'ciphertext_b64url',
      'expires_at',
    });
    return EncryptedFrame(
      protocolVersion: json['protocol_version']! as int,
      sessionId: json['session_id']! as String,
      sequence: json['sequence']! as int,
      nonceB64Url: json['nonce_b64url']! as String,
      ciphertextB64Url: json['ciphertext_b64url']! as String,
      expiresAt: DateTime.parse(json['expires_at']! as String),
    );
  }
}

sealed class ProximityPayload {
  const ProximityPayload();

  factory ProximityPayload.fromJson(Map<String, Object?> json) =>
      switch (json['payload_type']) {
        'shared_auth_step_up' => SharedAuthStepUpPayload.fromJson(json),
        'peer_info_offer' => PeerInfoOfferPayload.fromJson(json),
        'update_manifest_offer' => UpdateManifestOfferPayload.fromJson(json),
        _ => throw const FormatException('unknown proximity payload type'),
      };
}

final class SharedAuthStepUpPayload extends ProximityPayload {
  const SharedAuthStepUpPayload({
    required this.exchangeId,
    required this.recipientDeviceFingerprint,
    required this.opaqueRequestB64Url,
    required this.expiresAt,
  });

  final String exchangeId;
  final String recipientDeviceFingerprint;
  final String opaqueRequestB64Url;
  final DateTime expiresAt;

  factory SharedAuthStepUpPayload.fromJson(Map<String, Object?> json) {
    _requireExactKeys(json, const {
      'payload_type',
      'exchange_id',
      'recipient_device_fingerprint',
      'opaque_request_b64url',
      'expires_at',
    });
    return SharedAuthStepUpPayload(
      exchangeId: json['exchange_id']! as String,
      recipientDeviceFingerprint:
          json['recipient_device_fingerprint']! as String,
      opaqueRequestB64Url: json['opaque_request_b64url']! as String,
      expiresAt: DateTime.parse(json['expires_at']! as String),
    );
  }
}

final class PeerInfoOfferPayload extends ProximityPayload {
  const PeerInfoOfferPayload({
    required this.transferId,
    required this.mediaType,
    required this.contentSizeBytes,
    required this.contentSha256,
    required this.contentB64Url,
    required this.expiresAt,
  });

  final String transferId;
  final String mediaType;
  final int contentSizeBytes;
  final String contentSha256;
  final String contentB64Url;
  final DateTime expiresAt;

  factory PeerInfoOfferPayload.fromJson(Map<String, Object?> json) {
    _requireExactKeys(json, const {
      'payload_type',
      'transfer_id',
      'media_type',
      'content_size_bytes',
      'content_sha256',
      'content_b64url',
      'expires_at',
    });
    return PeerInfoOfferPayload(
      transferId: json['transfer_id']! as String,
      mediaType: json['media_type']! as String,
      contentSizeBytes: json['content_size_bytes']! as int,
      contentSha256: json['content_sha256']! as String,
      contentB64Url: json['content_b64url']! as String,
      expiresAt: DateTime.parse(json['expires_at']! as String),
    );
  }
}

final class UpdateManifestOfferPayload extends ProximityPayload {
  const UpdateManifestOfferPayload({
    required this.applicationId,
    required this.platform,
    required this.version,
    required this.distribution,
    required this.manifestUrl,
    required this.manifestSha256,
    required this.signerKeyId,
    required this.manifestSignatureB64Url,
    required this.expiresAt,
  });

  final String applicationId;
  final String platform;
  final String version;
  final String distribution;
  final Uri manifestUrl;
  final String manifestSha256;
  final String signerKeyId;
  final String manifestSignatureB64Url;
  final DateTime expiresAt;

  factory UpdateManifestOfferPayload.fromJson(Map<String, Object?> json) {
    _requireExactKeys(json, const {
      'payload_type',
      'application_id',
      'platform',
      'version',
      'distribution',
      'manifest_url',
      'manifest_sha256',
      'signature_algorithm',
      'signer_key_id',
      'manifest_signature_b64url',
      'expires_at',
    });
    if (json['signature_algorithm'] != 'ed25519') {
      throw const FormatException('unsupported manifest signature algorithm');
    }
    return UpdateManifestOfferPayload(
      applicationId: json['application_id']! as String,
      platform: json['platform']! as String,
      version: json['version']! as String,
      distribution: json['distribution']! as String,
      manifestUrl: Uri.parse(json['manifest_url']! as String),
      manifestSha256: json['manifest_sha256']! as String,
      signerKeyId: json['signer_key_id']! as String,
      manifestSignatureB64Url: json['manifest_signature_b64url']! as String,
      expiresAt: DateTime.parse(json['expires_at']! as String),
    );
  }
}

void _requireExactKeys(Map<String, Object?> json, Set<String> expectedKeys) {
  final actualKeys = json.keys.toSet();
  if (!actualKeys.containsAll(expectedKeys) ||
      !expectedKeys.containsAll(actualKeys)) {
    throw const FormatException(
      'proximity object has missing or unknown fields',
    );
  }
}

String? pairingSecretFromUri(Uri uri) =>
    uri.fragment.isEmpty ? null : Uri.splitQueryString(uri.fragment)['c'];
