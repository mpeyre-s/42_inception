# Project variables
PROJECT = inception
EXERCISE = 42
CONTAINERS = nginx wordpress mariadb

# Colors
ORANGE = \033[0;33m
GREEN = \033[0;32m
RED = \033[0;31m
RESET = \033[0m

# Dynamic info
SRC_COUNT = 3

VOLUMES_PATH = $(HOME)/data
VOLUME_DIRS = wordpress mariadb

all: header setup_volumes build up

header:
	@echo "\033[38;5;39m—————————————————————————————————————————————————————————\033[0m"
	@echo "\033[38;5;33m|   $(PROJECT)   |  $(EXERCISE)   |    make    |   $(SRC_COUNT) services    |\033[0m"
	@echo "\033[38;5;63m—————————————————————————————————————————————————————————\033[0m"
	@echo "$(ORANGE)Starting Inception…$(RESET)"

build:
	@DOCKER_BUILDKIT=1 docker-compose -f srcs/docker-compose.yml build --build-arg BUILDKIT_INLINE_CACHE=1 && \
	echo "" && \
	echo "➡️  $(GREEN)\033[4mContainers built successfully ✅\033[0m$(RESET)" || \
	echo "$(RED)➡️  Error while building containers$(RESET) ❌"

up:
	@docker-compose -f srcs/docker-compose.yml up -d && \
	echo "" && \
	echo "➡️  $(GREEN)\033[4mContainers started successfully ✅\033[0m$(RESET)" || \
	echo "$(RED)➡️  Error while starting containers$(RESET) ❌"

setup_volumes:
	@echo "$(ORANGE)Setting up data volumes...$(RESET)"
	@if [ ! -d "/home/$(USER)/data" ]; then \
		mkdir -p /home/$(USER)/data/wordpress && \
		mkdir -p /home/$(USER)/data/mariadb; \
		mkdir -p /home/$(USER)/data/minecraft; \
	fi
	@sudo chown -R $(USER):$(USER) /home/$(USER)/data/wordpress
	@sudo chown -R $(USER):$(USER) /home/$(USER)/data/mariadb
	@sudo chmod 755 /home/$(USER)/data/wordpress
	@sudo chmod 755 /home/$(USER)/data/mariadb
	@sudo chmod 755 /home/$(USER)/data/minecraft
	@echo "➡️  $(GREEN)Volumes setup complete ✅$(RESET)"

down:
	@docker-compose -f srcs/docker-compose.yml down && \
	echo "" && \
	echo "➡️  $(GREEN)\033[4mContainers stopped and removed 🗑️\033[0m$(RESET)" || \
	echo "$(RED)➡️  Error while stopping containers$(RESET) ❌"

clean: down
	@echo "$(ORANGE)Cleaning volumes and images…$(RESET)"
	@docker system prune -a -f
	@echo ""
	@echo "➡️  $(GREEN)Project cleaned 🗑️$(RESET)"
	@echo ""

fclean: clean
	@echo "$(ORANGE)Removing volume directories...$(RESET)"
	@for dir in $(VOLUME_DIRS); do \
		echo "Removing $$dir volume directory"; \
		sudo rm -rf $(VOLUMES_PATH)/$$dir; \
	done
	@sudo rm -rf $(VOLUMES_PATH)
	@if [ -n "$(shell docker volume ls -q)" ]; then \
		docker volume rm $(shell docker volume ls -q); \
	fi
	@echo "$(RED)All Docker resources cleaned$(RESET)"

re: fclean all

.PHONY: all build up down clean fclean re header setup_volumes
