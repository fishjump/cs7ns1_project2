.PHONY: deploy run-remote pull train

all: deploy run-remote pull

deploy:
	@echo "===== Deploy ====="
	@bash scripts/deploy.sh

run-remote:
	@echo "===== Run Remote ====="
	@bash scripts/run-remote.sh

pull:
	@echo "===== Pull ====="
	@bash scripts/pull.sh

train:
	@echo "===== Train ====="
	@bash scripts/train.sh