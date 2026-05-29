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

ls:
	@echo "--- NETWORKS ---"
	@docker network ls
	@echo "\n--- VOLUMES ---"
	@docker volume ls
	@echo -n "\n--- IMAGES ---"
	@docker image ls -a
	@echo "\n--- CONTAINERS ---"
	@docker ps -a

reset:
	@echo "--- STOPPING CONTAINERS ---"
	-@docker stop $$(docker ps -qa) 2>/dev/null || true
	@echo "\n--- REMOVING CONTAINERS ---"
	-@docker rm $$(docker ps -qa) 2>/dev/null || true
	@echo "\n--- REMOVING IMAGES ---"
	-@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@echo "\n--- REMOVING VOLUMES ---"
	-@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@echo "\n--- REMOVING NETWORKS ---"
	-@docker network rm $$(docker network ls -q) 2>/dev/null || true

.PHONY: all up down start stop restart logs ps clean fclean re ls reset