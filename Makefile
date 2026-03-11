SHELL := /bin/bash

-include .env
export $(shell sed -ne 's/^\([^#= ]\+\)=.*/\1/p' .env)

# Select environment: staging or production
ENV ?= staging
TF_DIR := environments/$(ENV)

.PHONY: init plan apply fmt validate

init:
	cd $(TF_DIR) && terraform init

plan:
	cd $(TF_DIR) && terraform plan

apply:
	cd $(TF_DIR) && terraform apply

fmt:
	terraform fmt -recursive

validate:
	cd $(TF_DIR) && terraform validate

