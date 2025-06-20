# Project variables
PROJECT = inception
EXERCISE = 42
CONTAINERS = nginx # wordpress mariadb
SECRETS = secrets/credentials.txt secrets/db_password.txt secrets/db_root_password.txt

# Colors
ORANGE = \033[0;33m
GREEN = \033[0;32m
RED = \033[0;31m
RESET = \033[0m

# Dynamic info
SRC_COUNT = 3

all: header build up

header:
	@echo "\033[38;5;39m—————————————————————————————————————————————————————————\033[0m"
	@echo "\033[38;5;33m|   $(PROJECT)   |  $(EXERCISE)   |    make    |   $(SRC_COUNT) services    |\033[0m"
	@echo "\033[38;5;63m—————————————————————————————————————————————————————————\033[0m"
	@echo "$(ORANGE)Starting Inception…$(RESET)"

build:
	@docker-compose -f srcs/docker-compose.yml build && \
	echo "" && \
	echo "➡️  $(GREEN)\033[4mContainers built successfully ✅\033[0m$(RESET)" || \
	echo "$(RED)➡️  Error while building containers$(RESET) ❌"

up:
	@docker-compose -f srcs/docker-compose.yml up -d && \
	echo "" && \
	echo "➡️  $(GREEN)\033[4mContainers started successfully ✅\033[0m$(RESET)" || \
	echo "$(RED)➡️  Error while starting containers$(RESET) ❌"

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
	@echo "$(RED)All Docker resources cleaned$(RESET)"

re: fclean all

.PHONY: all build up down clean fclean re header
