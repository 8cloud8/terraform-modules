
terraform := docker run -it --rm \
	-v "$${HOME}:$${HOME}:ro" \
  -v "$$(pwd):/usr/src/repo" \
  -v /tmp:/tmp \
  --workdir /usr/src/repo \
  --log-driver none \
  -e DIGITALOCEAN_ACCESS_TOKEN \
  -e SSH_AUTH_SOCK \
  hashicorp/terraform

## Initialize terraform remote state
init:
	[ -f .terraform/terraform.tfstate ] || $(terraform) $@

## Clean up the project
clean:
	rm -rf .terraform *.tfstate*

## Pass arguments through to terraform which require remote state
apply console destroy graph plan output providers show: init
	@$(terraform) $@

## Pass arguments through to terraform which do not require remote state
get fmt validate version:
	@$(terraform) $@

terraform-docs: ## View inputs and outputs within this module
	@$@ .
