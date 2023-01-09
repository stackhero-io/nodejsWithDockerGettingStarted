.DEFAULT_GOAL := help

# Colors
CYAN := "\e[0;36m"
NC := "\e[0m"
INFO := @bash -c 'printf $(CYAN); echo "$$1"; printf $(NC)' MESSAGE


# Help
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Available targets:"
	@sed -n 's/^## HELP://p' Makefile

# Environment files loading
define environments-load
	$(eval include secrets/global.$(1))
	$(eval export $(shell sed -ne 's/ *#.*$$//; /./ s/=.*$$// p' secrets/global.$(1)))
endef


# Development platform

development-start-detached:
	$(call environments-load,development)
	@UID=`id -u` GID=`id -g` docker-compose -f docker/docker-compose.yml -f docker/docker-compose.development.yml up --build -d

## HELP: development-start    : Start development platform (locally)
development-start:
	$(call environments-load,development)
	@UID=`id -u` GID=`id -g` docker-compose -f docker/docker-compose.yml -f docker/docker-compose.development.yml up --build

## HELP: development-stop     : Stop development platform (locally)
development-stop:
	$(call environments-load,development)
	@UID=`id -u` GID=`id -g` docker-compose -f docker/docker-compose.yml -f docker/docker-compose.development.yml down

## HELP: development-shell    : Start a shell on development to use CLI tools
development-shell: dev-start-detached
	$(call environments-load,development)
	${INFO} "💻 Starting shell..."
	@docker exec -it my-app /bin/sh



## HELP: production-deploy    : Deploy to production
production-deploy:
	$(call environments-load,production)
	${INFO} "🚀 Deploying to ${DOCKER_CONTEXT}"
	@docker-compose -f docker/docker-compose.yml -f docker/docker-compose.production.yml up --build --remove-orphans -d
	${INFO} "✅ Successfully deployed!"

## HELP: production-logs-live : Logs in realtime from production
production-logs-live:
	$(call environments-load,production)
	${INFO} "🕵️  Showing realtime logs"
	@docker-compose -f docker/docker-compose.yml -f docker/docker-compose.production.yml logs --since 10s --follow

## HELP: production-logs      : Logs dump from production
production-logs:
	$(call environments-load,production)
	${INFO} "🕵️  Showing all logs"
	@docker-compose -f docker/docker-compose.yml -f docker/docker-compose.production.yml logs --timestamps

## HELP: production-shell     : Start a shell on production to use CLI tools
production-shell:
	$(call environments-load,production)
	${INFO} "💻 Starting shell..."
	@docker exec -it my-app /bin/sh

## HELP: production           : Deploy to production and show realtime logs
production: production-deploy production-logs-live





# Staging platform

# ## HELP: staging-deploy       : Deploy to staging
# staging-deploy:
# 	$(call environments-load,staging)
# 	${INFO} "🚀 Deploying to ${DOCKER_CONTEXT}"
# 	@docker-compose -f docker/docker-compose.yml -f docker/docker-compose.staging.yml up --build --remove-orphans -d
# 	${INFO} "✅ Successfully deployed!"

# ## HELP: staging-logs-live    : Logs in realtime from staging
# staging-logs-live:
# 	$(call environments-load,staging)
# 	${INFO} "🕵️  Showing realtime logs"
# 	@docker-compose -f docker/docker-compose.yml -f docker/docker-compose.staging.yml logs --since 10s --follow

# ## HELP: staging-logs         : Logs dump from staging
# staging-logs:
# 	$(call environments-load,staging)
# 	${INFO} "🕵️  Showing all logs"
# 	@docker-compose -f docker/docker-compose.yml -f docker/docker-compose.staging.yml logs --timestamps

# ## HELP: staging-shell        : Start a shell on staging to use CLI tools
# staging-shell:
# 	$(call environments-load,staging)
# 	${INFO} "💻 Starting shell..."
# 	@docker exec -it my-app /bin/sh

# ## HELP: staging              : Deploy to staging and show realtime logs
# staging: staging-deploy staging-logs-live
