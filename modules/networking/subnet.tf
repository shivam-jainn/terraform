resource "google_compute_subnetwork" "subnets" {
  for_each = var.subnets

  name          = each.key
  ip_cidr_range = each.value
  region        = var.region
  network       = google_compute_network.vpc_network.id
  private_ip_google_access = true
}
