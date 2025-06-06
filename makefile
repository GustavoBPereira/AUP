up:
	docker compose up -d

down:
	docker compose down

build:
	docker compose build

logs:
	docker compose logs -f

ps:
	docker compose ps

migrate:
	docker compose exec web python manage.py migrate

makemigrations:
	docker compose exec web python manage.py makemigrations

shell:
	docker compose exec web python manage.py shell

collectstatic:
	docker compose exec web python manage.py collectstatic --noinput

docker-runserver:
	docker compose exec web python manage.py runserver 0.0.0.0:8000

docker-migrate:
	docker compose exec web python manage.py migrate

docker-makemigrations:
	docker compose exec web python manage.py makemigrations

docker-shell:
	docker compose exec web python manage.py shell

populate-db:
	docker compose exec -T db psql -U postgres -d aup_db < populate_data.sql
