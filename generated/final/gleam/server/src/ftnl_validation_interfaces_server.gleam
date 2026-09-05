// Generated only after independent JSON Schema and TypeSpec agreement. DO NOT EDIT.
import gleam/option.{type Option}

pub const contract_version = "ores.validation.v2"

pub type WorkerJob {
  WorkerJob(
    deadline_unix: Int,
    idempotency_key: String,
    input: WorkerObjectRef,
    job_id: String,
    kind: String,
    max_output_bytes: Int,
    output: WorkerObjectTarget,
    product_scope: WorkerProductScope,
    protocol: String,
    submitted_at_unix: Int,
    workload: WorkerWorkload,
  )
}

pub type WorkerObjectRef {
  WorkerObjectRef(
    content_digest: String,
    expected_bytes: Int,
    object_id: String,
    store_id: String,
    version: String,
  )
}

pub type WorkerObjectTarget {
  WorkerObjectTarget(object_id: String, store_id: String, version: String)
}

pub type WorkerProductScope {
  WorkerProductScope(scope_id: String, scope_kind: String)
}

pub type WorkerReceipt {
  WorkerReceipt(
    bytes_written: Option(Int),
    code: String,
    job_id: String,
    output_digest: Option(String),
    protocol: String,
    status: String,
  )
}

pub type WorkerWorkload {
  WorkerWorkload(item_count: Int, vector_dimensions: Option(Int))
}
