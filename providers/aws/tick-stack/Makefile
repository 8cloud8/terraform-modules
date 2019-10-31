terraform := $(shell which terraform)

## Initialize terraform remote state
init:
	[ -f .terraform/terraform.tfstate ] || $(terraform) $@

## Clean up the project
clean:
	rm -rf .terraform *.tfstate*

## Pass arguments through to terraform which require remote state
apply console destroy graph plan output providers show: init
	@$(terraform) $@

state-list:
	$(terraform) state list

## Pass arguments through to terraform which do not require remote state
get fmt validate version:
	$(terraform) $@

terraform-docs: ## View inputs and outputs within this module
	@$@ .
