project_id = "YOUR-PROD-GCP-PROJECT-ID"

subnets = [
  {
    subnet_name   = "prod-public-subnet"
    subnet_ip     = "10.200.0.0/26"
  },
  {
    subnet_name   = "prod-app-subnet"
    subnet_ip     = "10.200.1.0/22"
  },
  {
    subnet_name   = "prod-db-subnet"
    subnet_ip     = "10.200.5.0/26"
  }
]