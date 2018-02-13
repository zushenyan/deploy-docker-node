CONFIG_DEV = docker-compose.dev.yml
CONFIG_TEST = docker-compose.test.yml

APP_CONTAINER = deploydockernode_app_1

all: dev

run:
	docker-compose -f $(FILE) up -d --build

log:
	docker-compose -f $(FILE) logs -f

down:
	docker-compose -f $(FILE) down

dev: FILE = $(CONFIG_DEV)
dev: run log

dev-down: FILE = $(CONFIG_DEV)
dev-down: down

test: FILE = $(CONFIG_TEST)
test: run log

test-down: FILE = $(CONFIG_TEST)
test-down: down

db-migrate:
	docker exec $(APP_CONTAINER) yarn run sequelize db:migrate

db-seed:
	docker exec $(APP_CONTAINER) yarn run sequelize db:seed:all

db-seed-undo:
	docker exec $(APP_CONTAINER) yarn run sequelize db:seed:undo:all
