BLUE='\033[0;34m'
NC='\033[0m' # No Color (сброс цвета)

echo -e "${BLUE}=== ДИАГНОСТИКА СЕРВЕРА ===${NC}"

# 1. Дата и время
echo -e "\n${BLUE}[1. Дата и время]${NC}"
date

# 2. Информация о ядре OS
echo -e "\n${BLUE}[2. Версия ядра OS]${NC}"
uname -r

# 3. Использование дискового пространства
echo -e "\n${BLUE}[3. Дисковое пространство (свободно/занято)]${NC}"
df -h / | awk 'NR==1 || NR==2'

# 4. Использование оперативной памяти (RAM)
echo -e "\n${BLUE}[4. Оперативная память]${NC}"
if command -v free &> /dev/null; then
    free -h
else
    echo "Команда 'free' недоступна (возможно, запуск не на Linux)"
fi

# 5. Проверка доступности нашего Flask-приложения
echo -e "\n${BLUE}[5. Проверка статуса API]${NC}"
URL="http://localhost:5000/health"

# Делаем быстрый запрос через curl, вытаскиваем только HTTP-код ответа
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL || echo "000")

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "Сервер Flask работает отлично! Статус: 200 OK"
else
    echo "Внимание! Не удалось достучаться до Flask по адресу $URL (HTTP код: $HTTP_STATUS)"
fi

echo -e "\n${BLUE}===========================${NC}"

