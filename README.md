# 3-Tier AWS Terraform Template

A production-ready, modular Terraform configuration for deploying a highly available 3-Tier application on AWS.

## 🏗 Architecture

This template implements a standard 3-tier architecture:
- **Public Tier**: Standard Internet Gateway (IGW) routing for Web/Load Balancers.
- **Private Tier**: NAT Gateway routing for Application servers.
- **Database Tier**: Isolated subnets for RDS/Data stores.

### Features
- **System CLI Simplicity**: Uses your system-installed Terraform and AWS CLI, no local binary management or downloads required.
- **Remote State + Locking**: S3 backend for shared state storage with DynamoDB table-based state locking.
- **Unified Test Suite**: Built-in `terraform test` framework with provider mocking for offline architecture validation across staging and production environments.
- **Multi-AZ Distribution**: Automatic round-robin distribution of subnets across provided Availability Zones.
- **Automated Networking**: Dynamic CIDR calculation using `cidrsubnet()` based on an offset strategy (Public: 0, Private: 10, Database: 20).
- **Dual-Database Module**: Support for simultaneous or optional deployment of **RDS Instances** and **Aurora PostgreSQL Clusters** using a unified module with individual toggle flags.
- **Environment Parity**: Pre-configured `staging` and `production` environments with discrete `.tfvars`.

## 📂 Project Structure

```text
.
├── main.tf                 # Root module orchestration
├── makefile                # Operational CLI (plan/apply/init helpers)
├── tests/                  # HCL Verification suite
│   ├── vpc.tftest.hcl      # Network logic testing
│   └── database.tftest.hcl # Env-specific DB testing
├── environments/           # Environment-specific variables
│   ├── staging/
│   │   ├── staging.tfvars
│   │   └── backend.hcl.example
│   └── production/
│       ├── production.tfvars
│       └── backend.hcl.example
└── modules/                # Reusable Logic
    ├── vpc/                # Networking, IGW, NATG, Subnets
    ├── security/           # Tiered Security Groups
    ├── ec2/                # Frontend & Backend instances
    └── database/           # RDS & Aurora RDS Clusters
```

## 🚀 Getting Started

### Prerequisites
- **AWS CLI** installed and configured with valid credentials.
- **Terraform** installed (v1.5+ recommended; matches your system version).
- **Pre-created S3 bucket and DynamoDB table** for Terraform backend.

### Quick Start

0. **Configure Remote Backend (one-time per environment):**
  ```bash
  cp environments/staging/backend.hcl.example environments/staging/backend.hcl
  cp environments/production/backend.hcl.example environments/production/backend.hcl
  ```
  Update `bucket`, `dynamodb_table`, and `region` values in each `backend.hcl`.

1. **Initialize Backend:**
  ```bash
  make init-staging
  # OR
  make init-production
  ```

2. **Run Architecture Tests:**
  ```bash
  make test
  ```
3. **Plan Environment:**
  ```bash
  make plan-staging
  # OR
  make plan-production
  ```
  This will save a plan file (e.g., `plans/staging-plan`).

4. **Deploy:**
  ```bash
  make apply-staging APPLY_PLAN=plans/staging-plan
  ```
  Or, to apply directly without a plan file:
  ```bash
  make apply-staging
  ```

You can also pass an explicit backend config path:
```bash
make init BACKEND_CONFIG=environments/staging/backend.hcl
```

## 🗃 Remote State

Terraform backend is configured as partial `s3` backend in [providers.tf](providers.tf). Values are supplied at init time via `-backend-config` files.

Required backend settings:
- `bucket`: S3 bucket name for state storage
- `key`: State object path per environment (for example `staging/terraform.tfstate`)
- `region`: AWS region for the backend
- `dynamodb_table`: DynamoDB table name for state locking
- `encrypt = true`: S3 server-side encryption for state
## 🛑 Validation

- The system enforces that `db_username` cannot be `admin` (reserved by AWS RDS/Aurora for PostgreSQL). If you use this value, Terraform will fail at plan time with a clear error.


## ⚙️ Configuration

The system is designed as a **Naming Template**. You only need to provide names in your `.tfvars`, and the system handles the heavy lifting.

### Database Configuration (Dual-Stack)
You can enable either or both in your `.tfvars`:
```hcl
enable_rds    = true
enable_aurora = true

rds_config = {
  engine = "postgres", instance_class = "db.t3.micro", ...
}

aurora_config = {
  engine = "aurora-postgresql", instance_count = 3, ...
}
```

Example `subnets` configuration:
```hcl
subnets = {
  public_names   = ["web-1", "web-2"]
  private_names  = ["app-1", "app-2"]
  database_names = ["db-1", "db-2"]
}
```

## 🛡 Security
- **Isolation**: High-tier security groups are restricted to only allow traffic from lower tiers (e.g., Backend only allows traffic from Frontend).
- **No Public Access**: Database and Application tiers are kept in private subnets with no direct ingress from the internet.

## 📄 License
MIT
