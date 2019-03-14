DOCKER_IMAGE := hashicorp/terraform:light

all: validate

fmt:
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) fmt *.tf

version:
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) version

validate-fmt:
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) fmt -check=true -diff=true

validate:
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) validate -check-variables=false . && echo "[OK] terraform validated"
