terraform {
  backend "s3" {
    bucket = "congnt-terraform"
    key    = "f_state.state"
  }
}
