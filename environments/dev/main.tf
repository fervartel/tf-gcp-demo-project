provider "google" {
  credentials = "${file("${var.credentials}")}"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}

module "dev-vpc" {
    source      = "../../../tf-modules/gcp-vpc"
    
    name = "tf-vpc"
    auto_create_subnetworks = "false"
    vpc_cidr = "192.168.0.0/24"
    subnet_cidr = ["192.168.1.0/26", "192.168.1.64/26"]
    subnet_region = "us-east1"
}

module "dev-autoscaler" {
    source = "../../../tf-modules/gcp-autoscaler"
    
    subnet              = "${module.dev-vpc.subnets_self_links[0]}"
    project             = "${var.project}"
    region              = "${var.region}"
}