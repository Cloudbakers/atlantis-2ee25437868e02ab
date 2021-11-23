resource "google_compute_firewall" "default_firewall" {
  name    = "demo-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["web"]
}

resource "google_compute_instance" "default_compute" {
  name         = "demo"
  machine_type = "n1-highcpu-2"
  zone         = "us-east4-b"

  can_ip_forward            = "true"
  allow_stopping_for_update = "true"

  tags = ["web"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  metadata_startup_script = "sudo apt-get update && sudo apt-get install -yqq nginx"
}

output "address" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.assigned_nat_ip}"
}
