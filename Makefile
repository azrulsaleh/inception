NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	$(COMPOSE) up --build

up:
	$(COMPOSE) up --build

down:
	$(COMPOSE) down

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

restart:
	$(COMPOSE) restart

logs:
	$(COMPOSE) logs

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down -v

fclean:
	$(COMPOSE) down -v --rmi all

re: fclean all

.PHONY: all up down start stop restart logs ps clean fclean re