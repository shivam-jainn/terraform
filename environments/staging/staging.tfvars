project_id = "YOUR-STAGING-GCP-PROJECT-ID"

subnets = [
  {
    subnet_name   = "staging-public"
    subnet_ip     = "10.255.88.0/26"
    subnet_region = "us-central1"
  },
  {
    subnet_name   = "staging-app"
    subnet_ip     = "10.255.90.0/22"
    subnet_region = "us-central1"
  },
  {
    subnet_name   = "staging-db"
    subnet_ip     = "10.255.92.0/26"
    subnet_region = "us-central1"
  }
]
