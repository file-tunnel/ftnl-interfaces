// Generated only after independent JSON Schema and TypeSpec agreement. DO NOT EDIT.

package interfaces_server

const ContractVersion = "ores.validation.v2"

type WorkerJob struct {
	DeadlineUnix    int64              `json:"deadline_unix"`
	IdempotencyKey  string             `json:"idempotency_key"`
	Input           WorkerObjectRef    `json:"input"`
	JobId           string             `json:"job_id"`
	Kind            string             `json:"kind"`
	MaxOutputBytes  int64              `json:"max_output_bytes"`
	Output          WorkerObjectTarget `json:"output"`
	ProductScope    WorkerProductScope `json:"product_scope"`
	Protocol        string             `json:"protocol"`
	SubmittedAtUnix int64              `json:"submitted_at_unix"`
	Workload        WorkerWorkload     `json:"workload"`
}

type WorkerObjectRef struct {
	ContentDigest string `json:"content_digest"`
	ExpectedBytes int64  `json:"expected_bytes"`
	ObjectId      string `json:"object_id"`
	StoreId       string `json:"store_id"`
	Version       string `json:"version"`
}

type WorkerObjectTarget struct {
	ObjectId string `json:"object_id"`
	StoreId  string `json:"store_id"`
	Version  string `json:"version"`
}

type WorkerProductScope struct {
	ScopeId   string `json:"scope_id"`
	ScopeKind string `json:"scope_kind"`
}

type WorkerReceipt struct {
	BytesWritten *int64  `json:"bytes_written,omitempty"`
	Code         string  `json:"code"`
	JobId        string  `json:"job_id"`
	OutputDigest *string `json:"output_digest,omitempty"`
	Protocol     string  `json:"protocol"`
	Status       string  `json:"status"`
}

type WorkerWorkload struct {
	ItemCount        int64  `json:"item_count"`
	VectorDimensions *int64 `json:"vector_dimensions,omitempty"`
}
