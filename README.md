# Nasca-RestApi

Микросервис на Flask, предоставляющий REST API для управления списком пользователей.

#Тех Стек
Язык программирования - python 3.12
Framework - Flask
Контейнеризация - Docker, Docker Compose 
Развертывание - Ansible
## Структура проекта

Nasca-RestApi/
├── app/
│   ├── tests/                # Папка с тестами приложения
│   │   └── test_app.py       # Тесты для проверки эндпоинтов Flask
│   ├── main.py               # Запуск Flask-приложения и эндпоинты
│   ├── requirements.txt      # Зависимости проекта (Flask)
│   ├── Dockerfile            # Инструкция для сборки Docker-образа
│   └── docker-compose.yml    # Конфигурация Docker Compose для запуска
├── .github
│   └── workflows
│       └── build.yml
├── ansible/                  # Сценарии автоматизации развертывания
│   ├── inventory.ini         # Список целевых серверов (хостов)
│   ├── playbook.yml          # Главный сценарий развертывания
│   ├── app/tasks/             
│   │           └── main.yml  # Деплой приложения
│   └── docker/tasks/
│               └── main.yml  # Установка docker
├── scripts/
│   └── server-info.sh        # Скрипт для сбора информации о системе
└── README.md                 # Документация проекта

🚀 Быстрый старт
1. Локальный запуск приложения

Для запуска приложения напрямую в вашей операционной системе выполните:
Bash

pip install -r app/requirements.txt
python app/main.py

Приложение станет доступно по адресу: http://localhost:5000

2. Запуск через Docker Compose

Чтобы собрать образы и запустить контейнеры в фоновом режиме, перейдите в папку проекта и выполните:
Bash

docker-compose up -d

Проверить статус контейнеров и здоровье (Health check):
Bash

docker compose ps

API Endpoints (Примеры использования c URL)

    Проверка здоровья (Health Check):
    Bash

    curl -X GET http://localhost:5000/health

    Получить список всех пользователей:
    Bash

    curl -X GET http://localhost:5000/api/users

    Получить пользователя по ID:
    Bash

    curl -X GET http://localhost:5000/api/users/1

    Добавить нового пользователя:
    Bash

    curl -X POST http://localhost:5000/api/users \
      -H "Content-Type: application/json" \
      -d '{"name": "Viktor", "email": "viktor@example.com"}'

    Удалить пользователя по ID:
    Bash

    curl -X DELETE http://localhost:5000/api/users/1

Тестирование

Для запуска тестов используется фреймворк pytest.

    Запуск тестов локально/через Makefile:
    Bash

    pytest app/tests/ -v

    или:
    Bash

    make test

    Запуск тестов внутри Docker-контейнера:
    Bash

    docker compose exec app pytest app/tests/tests/ -v

Bash-скрипт диагностики

Скрипт server-info.sh собирает информацию о состоянии системы (процессор, память, диски) и проверяет доступность веб-сервера.

    Выдача прав на выполнение:
    Bash

    chmod +x scripts/server-info.sh

    Пример использования:
    Bash

    ./scripts/server-info.sh http://localhost:5000/health


Ansible развертывание

Сценарий автоматизирует подготовку чистого Ubuntu-сервера и развертывание приложения на нем.

    Проверка синтаксиса плейбука:
    Bash

    ansible-playbook --syntax-check -i ansible/inventory.ini ansible/playbook.yml

    Тестовый запуск (Dry-run) без реальных изменений:
    Bash

    ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --check

    Реальный запуск развертывания:
    Bash

    ansible-playbook -i ansible/inventory.ini ansible/playbook.yml

    Запуск с подробным логированием (Verbose):
    Bash

    ansible-playbook -i ansible/inventory.ini ansible/playbook.yml -vvv


🛠 Troubleshooting (Решение проблем)
1. Ошибка: Bind for 0.0.0.0:5000 failed: port is already allocated

    Причина: Порт 5000 занят другим процессом или зависшим контейнером.

    Решение: Остановите старый контейнер командой docker compose down или найдите процесс через sudo lsof -i :5000 и завершите его.

2. Ошибка: ModuleNotFoundError: No module named 'app' при запуске тестов

    Причина: Python не видит корневую директорию проекта при импортах.

    Решение: Добавьте переменную окружения перед командой: PYTHONPATH=. pytest app/tests/tests/ -v или используйте make test.

3. Контейнер запускается, но статус равен unhealthy

    Причина: Приложение внутри контейнера упало, либо контейнер не имеет утилиты curl для внутренней проверки здоровья.

    Решение: Проверьте логи командой docker compose logs app. Убедитесь, что в main.py Flask слушает хост 0.0.0.0 (а не 127.0.0.1).