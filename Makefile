.PHONY: deploy train

all: deploy

deploy:
	@echo "===== Deploy ====="
	@bash scripts/deploy.sh

train:
	@echo "===== Train ====="
	@bash scripts/train.sh