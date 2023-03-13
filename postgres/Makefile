start-docker:
	docker-compose up -d
	docker cp ./data/prices.csv postgres_itmo:/; docker cp ./data/cars.csv postgres_itmo:/; docker cp ./data/rent_conditions.csv postgres_itmo:/

migrate-new:
	@echo "Enter migration name: "; \
	read MIGRATION_NAME; \
	sql-migrate new $$MIGRATION_NAME

migrate-up:
	sql-migrate up -limit=1 -dryrun
	sql-migrate up -limit=1

migrate-down:
	sql-migrate down -limit=1 -dryrun
	sql-migrate down -limit=1

migrate-status:
	sql-migrate status

install-migrator:
	go install github.com/rubenv/sql-migrate/...@latest