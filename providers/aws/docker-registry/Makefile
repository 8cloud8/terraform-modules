DOCKER_IMAGE := hashicorp/terraform:light

TF_FLAGS := -var "foo=bar"  \
		-var "region=eu-west-1"  \

help:
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) -help

install:
	@docker pull $(DOCKER_IMAGE) &>/dev/null

init: ## Initialize terraform empty remote state
	[ -f terraform.tfstate ] || docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) $@ \
		$(TF_FLAGS)

apply console destroy graph plan output providers show: init ## Require remote state
	docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) $@ \
		$(TF_FLAGS)

get fmt version:
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) $@

validate-fmt:
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) fmt -check=true -diff=true

validate:
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) validate -check-variables=false . && echo "[OK] terraform validated"

clean: ## Clean up the project
	rm -rf .terraform *.tfstate*
