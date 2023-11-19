#!/usr/bin/make

# choco install make

.DEFAULT_GOAL := help

##@ Docs

help: ## Print the makefile help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

keys: ## Generate secret keys
	docker compose exec infcad-nginx bash -c "su -c 'php artisan key:generate' application"
	docker compose exec infcad-nginx bash -c "su -c 'php artisan jwt:secret --force' application"

##@ Docker actions

dev: ## Start containers detached
	docker compose up -d

logs: ## Show the output logs
	docker compose logs

log: ## Open the logs and follow the news
	docker compose logs --follow

restart: ## Restart the app container
	docker compose down
	docker compose up -d

unlog: ## Clear the logs
	docker compose exec infcad-nginx bash -c "echo '' > storage/logs/laravel.log"


##@ Bash controls

hyperf: ## Start nginx bash
	docker compose run hyperf bash
	#docker container exec -it hyperf php bin/hyperf.php gen:migration create_users_table

mysql: ## Start mysql bash
	docker compose exec infcad-mysql bash


##@ Database tools

migration: ## Create migration file
	docker compose exec infcad-nginx bash -c "su -c \"php artisan make:migration $(name)\" application"

migrate: ## Perform migrations
	docker compose exec infcad-nginx php artisan migrate

fresh: ## Perform fresh migrations
	docker compose exec infcad-nginx php artisan migrate:fresh

rollback: ## Rollback migration
	docker compose exec infcad-nginx php artisan migrate:rollback

reapply: ## Reapply the last migrations
	docker compose exec infcad-nginx php artisan migrate:rollback
	docker compose exec infcad-nginx php artisan migrate

backup: ## Export database
	docker compose exec infcad-mysql bash -c "mysqldump -u root -p database > /var/www/app/database/dumps/backup.sql"
	docker compose exec infcad-mysql bash -c "chown 1000:1000 /var/www/app/database/dumps/backup.sql"

restore: ## Import database
	docker compose exec infcad-mysql bash -c "mysql -u root -p database < /var/www/app/database/dumps/backup.sql"


##@ Composer

install: ## Composer install dependencies
	docker compose exec infcad-nginx bash -c "su -c \"composer install\" application"

autoload: ## Run the composer dump
	docker compose exec infcad-nginx bash -c "su -c \"composer dump-autoload\" application"
