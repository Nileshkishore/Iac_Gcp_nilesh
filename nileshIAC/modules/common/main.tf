#   resource "google_project_iam_binding" "iac-project" {
#   project = var.project_id
#   role    = var.roles
  
#   members = ["serviceAccount:${var.service_account_email}"]
# }

# resource "google_project_iam_binding" "iac-project" {
#   project = "nileshfirst"
#   role    = "roles/editor"

#   members = [
#     "user:nileshkishore2020@gmail.com",
#     # Add more members if needed
#   ]
# }


resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
}

resource "google_compute_subnetwork" "subnet_1" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr_range
  network       = google_compute_network.vpc_network.id
  region        = var.region
}