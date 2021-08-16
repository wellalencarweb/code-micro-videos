.PHONY: *

.DEFAULT_GOAL := help

run: force-build ## Roda projeto
	@docker-compose up --force-recreate -d

down: ## Apaga containers
	@docker-compose down

build: init ## Builda imagens
	@docker-compose build

force-build: init ## Força build da imagem sem usar o cache local
	@docker-compose build --no-cache --force-rm

start: ## Inicia containers
	@docker-compose start

stop: ## Para containers
	@docker-compose stop

logs: ## Visualiza logs dos containers
	@docker-compose logs --follow

bash: ## Inicia um terminal no container
	@docker exec -it micro-videos-app /bin/bash


require: ## Instala pacote do Composer informado no argumento pkg
	@docker exec -it micro-videos-app /bin/bash -c "composer require $(pkg)"

remove: ## Remove pacote do Composer informado no argumento pkg
	@docker exec -it micro-videos-app /bin/bash -c "cd /app && composer remove $(pkg)"

migrate: ## Roda migrations
	@docker exec -it micro-videos-app /bin/bash -c "php artisan migrate && php artisan doctrine:migrations:migrate"

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# test: ## Roda todos os testes
# 	@docker exec -it micro-videos-app /bin/bash -c "XDEBUG_MODE=coverage ./vendor/bin/phpunit"

# test-unit: ## Roda suite de testes Unitários
# 	@docker exec -it micro-videos-app /bin/bash -c "XDEBUG_MODE=coverage ./vendor/bin/phpunit --testsuite Unit"

# test-feature: ## Roda suite de testes Integração
# 	@docker exec -it micro-videos-app /bin/bash -c "XDEBUG_MODE=coverage ./vendor/bin/phpunit --testsuite Feature"

# tinker: ## Inicia um terminal REPL PHP no container micro-videos-app
# 	@docker exec -it micro-videos-app /bin/bash -c "php artisan tinker" || true

# queue: ## Inicia daemon da fila
# 	@docker exec -it micro-videos-app /bin/bash -c "php /app/artisan queue:work" || true
