# 3-Tier AWS Terraform Template

A production-ready, modular Terraform configuration for deploying a highly available 3-Tier application on AWS.

## 🏗 Architecture

This template implements a standard 3-tier architecture:
- **Public Tier**: Standard Internet Gateway (IGW) routing for Web/Load Balancers.
- **Private Tier**: NAT Gateway routing for Application servers.
- **Database Tier**: Isolated subnets for RDS/Data stores.

### Features
- **System CLI Simplicity**: Uses your system-installed Terraform and AWS CLI, no local binary management or downloads required.
- **Unified Test Suite**: Built-in `terraform test` framework with provider mocking for offline architecture validation across staging and production environments.
- **Multi-AZ Distribution**: Automatic round-robin distribution of subnets across provided Availability Zones.
- **Automated Networking**: Dynamic CIDR calculation using `cidrsubnet()` based on an offset strategy (Public: 0, Private: 10, Database: 20).
- **Dual-Database Module**: Support for simultaneous or optional deployment of **RDS Instances** and **Aurora PostgreSQL Clusters** using a unified module with individual toggle flags.
- **Environment Parity**: Pre-configured `staging` and `production` environments with discrete `.tfvars`.

## 📂 Project Structure

```text
.
├── main.tf                 # Root module orchestration
├── makefile                # Operational CLI (OS/Arch detection)
├── tests/                  # HCL Verification suite
│   ├── vpc.tftest.hcl      # Network logic testing
│   └── database.tftest.hcl # Env-specific DB testing
├── environments/           # Environment-specific variables
│   ├── staging/
│   └── production/
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

### Quick Start

1. **Run Architecture Tests:**
  ```bash
  make test
  ```
2. **Plan Environment:**
  ```bash
  make plan-staging
  # OR
  make plan-production
  ```
  This will save a plan file (e.g., `plans/staging-plan`).

3. **Deploy:**
  ```bash
  make apply-staging APPLY_PLAN=plans/staging-plan
  ```
  Or, to apply directly without a plan file:
  ```bash
  make apply-staging
  ```
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
