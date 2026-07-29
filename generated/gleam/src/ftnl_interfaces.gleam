import gleam/list
import gleam/option.{None, Some}
import gleam/uri

pub type TunnelStatus {
  Waiting
  Connected
  Transferring
  Complete
  TunnelCancelled
  Expired
}

pub type FileStatus {
  Declared
  Uploading
  Available
  Downloaded
  Rejected
  FileCancelled
}

pub type TunnelEvent {
  TunnelEvent(
    event_id: String,
    sequence: Int,
    occurred_at: String,
    tunnel_id: String,
    kind: String,
    file_id: String,
    bytes_transferred: Int,
    reason_code: String,
  )
}

pub fn pairing_secret_from_uri(value: String) -> Result(String, Nil) {
  case uri.parse(value) {
    Error(_) -> Error(Nil)
    Ok(parsed) ->
      case parsed.fragment {
        None -> Error(Nil)
        Some(fragment) ->
          case uri.parse_query(fragment) {
            Error(_) -> Error(Nil)
            Ok(pairs) -> list.key_find(pairs, "c")
          }
      }
  }
}
