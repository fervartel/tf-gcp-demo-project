variable credentials {}
variable project {}
variable region {
  default = "us-east1"
}
variable zone {
  default = "us-east1-b"
}
data "google_compute_image" "debian_9" {
    family  = "debian-9"
    project = "debian-cloud"
}