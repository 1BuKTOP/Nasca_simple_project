.PHONY: help install lint test run server-info docker-build docker-run compose-up compose-down compose-logs ansible-check ansible-dry ansible-run

help:  
	@echo "Доступные команды:"
	@echo "  install       - Установить зависимости приложения и линтеры"
	@echo "  lint          - Проверить качество кода (flake8 для Python, shellcheck для Bash)"
	@echo "  test          - Запустить тесты (через pytest/unittest)"
	@echo "  run           - Запустить приложение локально (без Docker)"
	@echo "  server-info   - Запустить Bash-скрипт диагностики сервера"
	@echo "  docker-build  - Собрать Docker-образ приложения"
	@echo "  docker-run    - Запустить одиночный Docker-контейнер"
	@echo "  compose-up    - Запустить Docker Compose в фоновом режиме"
	@echo "  compose-down  - Остановить и удалить контейнеры Docker Compose"
	@echo "  compose-logs  - Просмотреть логи Docker Compose"

install:
	pip install -r app/requirements.txt
	pip install flake8 shellcheck-py pytest ansible

lint:
	flake8 app/
	shellcheck scripts/server-info.sh

test:
	PYTHONPATH=. pytest app/tests/tests/test_app.py -v

run:
	python app/main.py

server-info:
	chmod +x scripts/server-info.sh
	./scripts/server-info.sh

docker-build:
	docker build -t nasca-app:latest ./app

docker-run:
	docker run -d -p 5000:5000 --name nasca-flask-app nasca-app:latest

compose-up:
	docker compose -f app/docker-compose.yml up -d

compose-down:
	docker compose -f app/docker-compose.yml down

compose-logs:
	docker compose -f app/docker-compose.yml logs -f