help:  ## This help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

## Initialize terraform remote state
init: create-db
	[ -f .terraform/terraform.tfstate ] || terraform $@

## Clean up the project
clean:
	rm -rf .terraform *.tfstate*
	@./test/test-pg.sh clean-db

## Pass arguments through to terraform which require remote state
apply console destroy graph plan output providers show: init
	terraform $@

## Pass arguments through to terraform which do not require remote state
get fmt validate version:
	terraform $@

# https://hub.docker.com/_/postgres

create-db: ## Create db with Docker
	@./test/test-pg.sh $@

clean-db pg_shell pg_settings pg_extensions pg_available_extensions pg_stat_activity pg_database_size shell: create-db ## Requires running container
	@./test/test-pg.sh $@

pgadmin4: create-db ## Use admin tool
	docker run -p 8080:80 \
		-e "PGADMIN_DEFAULT_EMAIL=user@domain.com" \
		-e "PGADMIN_DEFAULT_PASSWORD=SuperSecret" \
		-d dpage/pgadmin4 && echo "http://localhost:8080"
