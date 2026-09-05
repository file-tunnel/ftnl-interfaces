//! Generated only after independent JSON Schema and TypeSpec agreement. DO NOT EDIT.

#[derive(Clone, Debug, PartialEq)]
pub struct WorkerJob {
    pub deadline_unix: i64,
    pub idempotency_key: String,
    pub input: WorkerObjectRef,
    pub job_id: String,
    pub kind: String,
    pub max_output_bytes: i64,
    pub output: WorkerObjectTarget,
    pub product_scope: WorkerProductScope,
    pub protocol: String,
    pub submitted_at_unix: i64,
    pub workload: WorkerWorkload,
}

#[derive(Clone, Debug, PartialEq)]
pub struct WorkerObjectRef {
    pub content_digest: String,
    pub expected_bytes: i64,
    pub object_id: String,
    pub store_id: String,
    pub version: String,
}

#[derive(Clone, Debug, PartialEq)]
pub struct WorkerObjectTarget {
    pub object_id: String,
    pub store_id: String,
    pub version: String,
}

#[derive(Clone, Debug, PartialEq)]
pub struct WorkerProductScope {
    pub scope_id: String,
    pub scope_kind: String,
}

#[derive(Clone, Debug, PartialEq)]
pub struct WorkerReceipt {
    pub bytes_written: Option<i64>,
    pub code: String,
    pub job_id: String,
    pub output_digest: Option<String>,
    pub protocol: String,
    pub status: String,
}

#[derive(Clone, Debug, PartialEq)]
pub struct WorkerWorkload {
    pub item_count: i64,
    pub vector_dimensions: Option<i64>,
}
