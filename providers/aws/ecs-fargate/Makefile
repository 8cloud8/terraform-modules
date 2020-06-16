TERRAFORM_VERSION := 0.12.25
-include include.mk

## Initialize terraform remote state
init:
	[ -d .terraform ] || terraform $@

## Pass arguments through to terraform which require remote state
apply console destroy graph plan output providers show validate: init
	@terraform $@

## Pass arguments through to terraform which do not require remote state
get fmt version:
	@terraform $@

.PHONY: test
test:
	@[ -f ./test/test.sh ] && ./test/test.sh || true

## Clean up the project
clean:
	@find . -type d -name '.terraform' | xargs rm -rf
	@find . -type f -name 'terraform.tfstate*' -exec rm -f {} \;
