.PHONY: setup fmt init validate plan-staging plan-production apply-staging apply-production clean test auth pull-env

# Path Variables
STAGING_VARS = environments/staging/staging.tfvars
PROD_VARS    = environments/production/production.tfvars
TF_CMD ?= terraform
AWS_CMD ?= aws
PLAN_OUT ?=
APPLY_PLAN ?=

PLAN_OUT_FLAG = $(if $(PLAN_OUT),-out=$(PLAN_OUT),)
APPLY_PLAN_ARG = $(if $(APPLY_PLAN),$(APPLY_PLAN),)

# --- CORE SETUP COMMAND ---
# Pulls .env and initializes/validates Terraform
setup: pull-env init validate
	@echo "✨ Setup complete!"
	@echo "📍 Terraform: $$($(TF_CMD) --version | head -n 1)"
	@echo "📍 AWS CLI:   $$($(AWS_CMD) --version | head -n 1)"

# --- SECRETS & ENVIRONMENT ---

pull-env:
	@echo "🔐 Pulling .env from secure source..."
	@if [ -f .env.example ]; then \
		cp -n .env.example .env || true; \
		echo "✅ Created .env from example (Add your keys here!)"; \
	else \
		touch .env; \
		echo "✅ Created empty .env file"; \
	fi

auth:
	@echo "🔑 Setting up AWS CLI session..."
	@$(AWS_CMD) configure
	@echo "✅ AWS session configured."

# --- TERRAFORM COMMANDS ---

fmt:
	@echo "🎨 Formatting Terraform files..."
	@$(TF_CMD) fmt -recursive

init:
	@echo "🚀 Initializing Terraform..."
	@$(TF_CMD) init

validate: fmt
	@echo "🔍 Validating configuration..."
	@$(TF_CMD) validate

test:
	@echo "🧪 Running Terraform tests..."
	@$(TF_CMD) test

plan-staging: validate
	@echo "📋 Planning Staging environment..."
	@$(TF_CMD) plan -var-file=$(STAGING_VARS) $(if $(PLAN_OUT_FLAG),$(PLAN_OUT_FLAG),-out=plans/staging-plan)

plan-production: validate
	@echo "📋 Planning Production environment..."
	@$(TF_CMD) plan -var-file=$(PROD_VARS) $(if $(PLAN_OUT_FLAG),$(PLAN_OUT_FLAG),-out=plans/production-plan)

apply-staging: validate
	@echo "🚀 Applying Staging environment..."
	@if [ -n "$(APPLY_PLAN_ARG)" ]; then \
		$(TF_CMD) apply "$(APPLY_PLAN_ARG)"; \
	else \
		$(TF_CMD) apply -var-file=$(STAGING_VARS) -auto-approve; \
	fi

apply-production: validate
	@echo "🚀 Applying Production environment..."
	@if [ -n "$(APPLY_PLAN_ARG)" ]; then \
		$(TF_CMD) apply "$(APPLY_PLAN_ARG)"; \
	else \
		$(TF_CMD) apply -var-file=$(PROD_VARS) -auto-approve; \
	fi

clean:
	@echo "🧹 Cleaning up local terraform files..."
	@rm -rf .terraform .terraform.lock.hcl terraform.tfstate* .env

 