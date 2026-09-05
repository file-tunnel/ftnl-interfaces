namespace FileTunnel.Validation.Server;

model WorkerProductScope {
  @pattern("^individual$|^organization$") scope_kind: string;
  @minLength(1) @maxLength(256) @pattern("^[A-Za-z0-9_.-]+$") scope_id: string;
}

model WorkerWorkload {
  @minValue(1) @maxValue(100000) item_count: uint32;
  @minValue(1) @maxValue(4096) vector_dimensions?: uint16;
}

model WorkerObjectRef {
  @minLength(1) @maxLength(256) @pattern("^[A-Za-z0-9_.-]+$") store_id: string;
  @minLength(1) @maxLength(256) @pattern("^[A-Za-z0-9_.-]+$") object_id: string;
  @minLength(1) @maxLength(256) @pattern("^[A-Za-z0-9_.-]+$") version: string;
  @pattern("^sha256\\x3a[0-9a-f]{64}$") content_digest: string;
  @minValue(1) @maxValue(2147483648) expected_bytes: uint64;
}

model WorkerObjectTarget {
  @minLength(1) @maxLength(256) @pattern("^[A-Za-z0-9_.-]+$") store_id: string;
  @minLength(1) @maxLength(256) @pattern("^[A-Za-z0-9_.-]+$") object_id: string;
  @minLength(1) @maxLength(256) @pattern("^[A-Za-z0-9_.-]+$") version: string;
}

model WorkerJob {
  @pattern("^file-tunnel\\.worker/v1$") protocol: string;
  @minLength(1) @maxLength(256) @pattern("^[A-Za-z0-9_.-]+$") job_id: string;
  @minLength(1) @maxLength(256) @pattern("^[A-Za-z0-9_.-]+$") idempotency_key: string;
  product_scope: WorkerProductScope;
  @pattern("^file_metadata$|^image_metadata$|^image_thumbnail$|^image_transcode$|^embedding_batch$|^regression_batch$|^correlation_discovery$") kind: string;
  workload: WorkerWorkload;
  input: WorkerObjectRef;
  output: WorkerObjectTarget;
  @minValue(0) submitted_at_unix: uint64;
  @minValue(1) deadline_unix: uint64;
  @minValue(1) @maxValue(536870912) max_output_bytes: uint64;
}

model WorkerReceipt {
  @pattern("^file-tunnel\\.worker/v1$") protocol: string;
  @minLength(1) @maxLength(256) @pattern("^[A-Za-z0-9_.-]+$") job_id: string;
  @pattern("^completed$|^retryable_failure$|^terminal_failure$") status: string;
  @minLength(1) @maxLength(128) @pattern("^[a-z][a-z0-9_]*$") code: string;
  @pattern("^sha256\\x3a[0-9a-f]{64}$") output_digest?: string;
  @minValue(1) @maxValue(536870912) bytes_written?: uint64;
}
