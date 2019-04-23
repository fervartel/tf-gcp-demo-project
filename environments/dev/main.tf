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
    distribution_policy_zones  = ["us-east1-c", "us-east1-d"]
}

# resource "google_compute_instance_template" "main" {
#   name           = "tf-vm-template"
#   machine_type   = "f1-micro"
#   can_ip_forward = false

#   # tags = ["foo", "bar"]

#   disk {
#     source_image = "${data.google_compute_image.debian_9.self_link}"
#   }

#   network_interface {
#     # network = "default"
#     subnetwork    = "${module.dev-vpc.subnets_self_links[0]}"
#     access_config = {
#       // Ephemeral IP
#     }
#   }

#   metadata_startup_script = <<SCRIPT
#     sudo apt-get -y update
#     sudo apt-get -y dist-upgrade
#     sudo apt-get -y install nginx
#     SCRIPT

#   # service_account {
#   #   scopes = ["userinfo-email", "compute-ro", "storage-ro"]
#   # }
# }

# resource "google_compute_forwarding_rule" "default" {
#   project               = "${var.project}"
#   name                  = "tf-forwarding-rule"
#   target                = "${google_compute_target_pool.main.self_link}"
#   load_balancing_scheme = "EXTERNAL"
#   port_range            = "80"
# }

# # resource "google_compute_http_health_check" "default" {
# #   name               = "default"
# #   request_path       = "/"
# #   check_interval_sec = 5
# #   timeout_sec        = 5
# # }

# resource "google_compute_http_health_check" "default" {
#   project      = "${var.project}"
#   name         = "tf-healthcheck"
#   request_path = "/"
#   port         = "80"
# }

# resource "google_compute_target_pool" "main" {
#   name = "tf-target-pool"
  
#   session_affinity = "NONE"

#   health_checks = [
#   "${google_compute_http_health_check.default.name}",
#   ]
# }

# resource "google_compute_region_instance_group_manager" "main" {
#   name = "tf-igm"
#   region = "${var.region}"
#   distribution_policy_zones  = ["us-east1-c", "us-east1-d"]
#   # zone = "${var.zone}"

#   instance_template  = "${google_compute_instance_template.main.self_link}"

#   target_pools       = ["${google_compute_target_pool.main.self_link}"]
#   target_size  = 2
#   base_instance_name = "tf-vm"
# }

# resource "google_compute_autoscaler" "main" {
#   name   = "tf-autoscaler"
#   zone   = "${var.zone}"
#   target = "${google_compute_region_instance_group_manager.main.self_link}"

#   autoscaling_policy {
#     max_replicas    = 4
#     min_replicas    = 2
#     cooldown_period = 60

#     cpu_utilization {
#       target = 0.5
#     }
#   }
# }