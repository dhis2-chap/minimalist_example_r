# Docker image configuration
IMAGE := ghcr.io/mortenoh/r-docker-images/my-r-base:latest
DOCKER_RUN := docker run --rm -v $(PWD):/app -w /app $(IMAGE)

# Default target
.PHONY: all
all: help

# Run the complete pipeline (train + predict)
.PHONY: run
run:
	@mkdir -p output
	$(DOCKER_RUN) Rscript isolated_run.r

# Train the model
.PHONY: train
train:
	@mkdir -p output
	$(DOCKER_RUN) Rscript train.r input/trainData.csv output/model.bin

# Make predictions (requires trained model)
.PHONY: predict
predict:
	@mkdir -p output
	$(DOCKER_RUN) Rscript predict.r output/model.bin input/trainData.csv input/futureClimateData.csv output/predictions.csv

# Clean output files
.PHONY: clean
clean:
	rm -f output/model.bin output/predictions.csv

# Pull the Docker image
.PHONY: pull
pull:
	docker pull $(IMAGE)

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  make run      - Run complete pipeline (train + predict)"
	@echo "  make train    - Train the model only"
	@echo "  make predict  - Make predictions (requires trained model)"
	@echo "  make clean    - Remove output files"
	@echo "  make pull     - Pull the Docker image"
	@echo "  make help     - Show this help"
