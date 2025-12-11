.PHONY: help format validate test clean install-tools lint docs plan apply destroy test-basic test-asg test-advanced

# Default target
.DEFAULT_GOAL := help

# Colors for output
CYAN := \033[0;36m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m

help: ## Show this help message
	@echo "$(CYAN)Terraform AWS EC2 Compute Module$(NC)"
	@echo ""
	@echo "$(GREEN)Available targets:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-20s$(NC) %s\n", $$1, $$2}'

install-tools: ## Install required tools (terraform-docs, tflint)
	@echo "$(GREEN)Installing terraform-docs...$(NC)"
	@command -v terraform-docs >/dev/null 2>&1 || \
		(curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.17.0/terraform-docs-v0.17.0-$$(uname)-amd64.tar.gz && \
		tar -xzf terraform-docs.tar.gz && \
		chmod +x terraform-docs && \
		sudo mv terraform-docs /usr/local/bin/ && \
		rm terraform-docs.tar.gz)
	@echo "$(GREEN)Installing tflint...$(NC)"
	@command -v tflint >/dev/null 2>&1 || \
		(curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash)
	@echo "$(GREEN)All tools installed!$(NC)"

format: ## Format all Terraform files
	@echo "$(GREEN)Formatting Terraform files...$(NC)"
	@terraform fmt -recursive
	@echo "$(GREEN)Done!$(NC)"

format-check: ## Check if Terraform files are formatted
	@echo "$(GREEN)Checking Terraform formatting...$(NC)"
	@terraform fmt -recursive -check || (echo "$(RED)Files need formatting! Run 'make format'$(NC)" && exit 1)
	@echo "$(GREEN)All files properly formatted!$(NC)"

validate: ## Validate all modules and examples
	@echo "$(GREEN)Validating modules...$(NC)"
	@$(MAKE) validate-modules
	@echo ""
	@echo "$(GREEN)Validating examples...$(NC)"
	@$(MAKE) validate-examples
	@echo ""
	@echo "$(GREEN)All validations passed!$(NC)"

validate-modules: ## Validate all modules
	@echo "$(CYAN)Validating basic_instance...$(NC)"
	@cd modules/basic_instance && terraform init -backend=false >/dev/null && terraform validate
	@echo "$(CYAN)Validating asg...$(NC)"
	@cd modules/asg && terraform init -backend=false >/dev/null && terraform validate
	@echo "$(CYAN)Validating advanced_instance...$(NC)"
	@cd modules/advanced_instance && terraform init -backend=false >/dev/null && terraform validate

validate-examples: ## Validate all examples
	@echo "$(CYAN)Validating single-instance example...$(NC)"
	@cd examples/single-instance && terraform init -backend=false >/dev/null && terraform validate
	@echo "$(CYAN)Validating asg example...$(NC)"
	@cd examples/asg && terraform init -backend=false >/dev/null && terraform validate

lint: ## Run tflint on all modules
	@echo "$(GREEN)Running tflint...$(NC)"
	@tflint --init >/dev/null 2>&1 || true
	@tflint --recursive || echo "$(YELLOW)tflint found issues$(NC)"

docs: ## Generate documentation using terraform-docs
	@echo "$(GREEN)Generating documentation...$(NC)"
	@terraform-docs markdown table --output-file README.md --output-mode inject modules/basic_instance
	@terraform-docs markdown table --output-file README.md --output-mode inject modules/asg
	@terraform-docs markdown table --output-file README.md --output-mode inject modules/advanced_instance
	@echo "$(GREEN)Documentation generated!$(NC)"

test: ## Run all tests (terratest)
	@echo "$(GREEN)Running terratest...$(NC)"
	@cd test/terratest && go test -v -timeout 30m

test-basic: ## Run basic instance tests only
	@echo "$(GREEN)Running basic instance tests...$(NC)"
	@cd test/terratest && go test -v -timeout 30m -run TestBasicInstance

test-asg: ## Run ASG tests only
	@echo "$(GREEN)Running ASG tests...$(NC)"
	@cd test/terratest && go test -v -timeout 30m -run TestASG

test-advanced: ## Run advanced instance tests only
	@echo "$(GREEN)Running advanced instance tests...$(NC)"
	@cd test/terratest && go test -v -timeout 30m -run TestAdvanced

init-basic: ## Initialize basic instance example
	@echo "$(GREEN)Initializing basic instance example...$(NC)"
	@cd examples/single-instance && terraform init

init-asg: ## Initialize ASG example
	@echo "$(GREEN)Initializing ASG example...$(NC)"
	@cd examples/asg && terraform init

plan-basic: init-basic ## Plan basic instance example
	@echo "$(GREEN)Planning basic instance...$(NC)"
	@cd examples/single-instance && terraform plan

plan-asg: init-asg ## Plan ASG example
	@echo "$(GREEN)Planning ASG...$(NC)"
	@cd examples/asg && terraform plan

apply-basic: init-basic ## Apply basic instance example
	@echo "$(YELLOW)Applying basic instance...$(NC)"
	@cd examples/single-instance && terraform apply

apply-asg: init-asg ## Apply ASG example
	@echo "$(YELLOW)Applying ASG...$(NC)"
	@cd examples/asg && terraform apply

destroy-basic: ## Destroy basic instance example
	@echo "$(RED)Destroying basic instance...$(NC)"
	@cd examples/single-instance && terraform destroy

destroy-asg: ## Destroy ASG example
	@echo "$(RED)Destroying ASG...$(NC)"
	@cd examples/asg && terraform destroy

clean: ## Clean up terraform files and artifacts
	@echo "$(GREEN)Cleaning up...$(NC)"
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	@find . -type f -name "terraform.tfstate*" -delete 2>/dev/null || true
	@echo "$(GREEN)Cleanup complete!$(NC)"

pre-commit: format-check validate lint ## Run pre-commit checks (format, validate, lint)
	@echo "$(GREEN)All pre-commit checks passed!$(NC)"

ci: format-check validate lint ## Run CI pipeline checks
	@echo "$(GREEN)CI checks passed!$(NC)"

all: format validate lint test ## Run all checks and tests
	@echo "$(GREEN)All checks and tests passed!$(NC)"
