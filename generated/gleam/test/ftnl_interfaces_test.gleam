import ftnl_interfaces
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn fragment_secret_test() {
  ftnl_interfaces.pairing_secret_from_uri(
    "https://upload.file-tunnel.dev/t/id#c=secret",
  )
  |> should.equal(Ok("secret"))
}
