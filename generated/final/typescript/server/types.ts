// Generated only after independent JSON Schema and TypeSpec agreement. DO NOT EDIT.

export const contractVersion = "ores.validation.v2" as const;
export const contractScope = "server" as const;

export interface WorkerJob {
  readonly deadline_unix: number;
  readonly idempotency_key: string;
  readonly input: WorkerObjectRef;
  readonly job_id: string;
  readonly kind: string;
  readonly max_output_bytes: number;
  readonly output: WorkerObjectTarget;
  readonly product_scope: WorkerProductScope;
  readonly protocol: string;
  readonly submitted_at_unix: number;
  readonly workload: WorkerWorkload;
}

export interface WorkerObjectRef {
  readonly content_digest: string;
  readonly expected_bytes: number;
  readonly object_id: string;
  readonly store_id: string;
  readonly version: string;
}

export interface WorkerObjectTarget {
  readonly object_id: string;
  readonly store_id: string;
  readonly version: string;
}

export interface WorkerProductScope {
  readonly scope_id: string;
  readonly scope_kind: string;
}

export interface WorkerReceipt {
  readonly bytes_written?: number;
  readonly code: string;
  readonly job_id: string;
  readonly output_digest?: string;
  readonly protocol: string;
  readonly status: string;
}

export interface WorkerWorkload {
  readonly item_count: number;
  readonly vector_dimensions?: number;
}
