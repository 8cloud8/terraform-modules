DOCKER_IMAGE := hashicorp/terraform:light

all: validate

init:
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) init

fmt:
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) fmt *.tf

version:
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) version

validate-fmt:
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) fmt -check=true -diff=true

lint:
	docker run -it --rm  -w $$PWD -v $$PWD:/data -t wata727/tflint

validate:
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) validate -check-variables=false . && echo "[OK] terraform validated"

clean: ## Clean up this project
	rm -rf .terraform *.tfstate*
