#include .env

# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOENV=$(GOCMD) env
GOPKG=$(GOCMD) list
GORUN=$(GOCMD) run
GOCLEAN=$(GOCMD) clean
GOFMT=$(GOCMD) fmt
#GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
SOURCE_NAME=$(BINARY_NAME).go
BINARY_NAME=main
CONTAINER_NAME=go-ping
IMAGE_NAME=go-ping
DEP_NAME=github.com/gin-gonic/gin
IMAGE_VERSION=1.0

all: clean format deps build image uploaddh uploadgh exe

## help: Show command help
help: Makefile
	@echo "Usage: make <command>"
	@echo ""
	@echo "COMMANDS"
	@echo ""
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo ""

## clean: Cleans the Go binaries in project directory & docker images 
clean:
	@echo "-------------------------------------------"
	@echo "* Deleting binaries..."
	@$(GOCLEAN) 
	@docker rmi $(IMAGE_NAME)

## deps: Installs missing dependencies 
deps:
	@echo "-------------------------------------------"
	@echo "* Getting dependencies..."
	@$(GOGET) $(DEP_NAME)

## format: Formats the Go source file
format:
	@echo "-------------------------------------------"
	@echo "* Formatting source file..."
	@$(GOFMT) ${SOURCE_NAME}

## run: Executes the Go source file without generating binaries
run:
	@echo "-------------------------------------------"
	@echo "* Execute source file without build..."
	@echo "-------------------------------------------"
	@$(GORUN) ${SOURCE_NAME}

## build: Compiles the Go source file & generates go binaries
build:
	@echo "-------------------------------------------"
	@echo "* Compiling source file..."
	@$(GOBUILD) -o ${BINARY_NAME} ${SOURCE_NAME}

## test: Tests the Go binary 
test:
	@echo "-------------------------------------------"
	@echo "* Testing the binary..."
	@echo "-------------------------------------------"
	@curl -i http://localhost:3000/ping
	@echo "\n"
	@robot get-request.robot
	@echo "-------------------------------------------"

## build-cross: Compiles the Go source file for every OS and Platform Architecture
build-cross:
	@echo "-------------------------------------------"
	@echo "* Compiling for every OS and Platform..."
	@CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BINARY_UNIX) -v
	@GOOS=windows GOARCH=386 go build -o bin/main-windows-386 main.go

## exe: Executes the Go binary
exe:
	@echo "-------------------------------------------"
	@echo "* Executing binary..."
	@echo "-------------------------------------------"
	@./main

## image: Generate docker image
image:
	@echo "-------------------------------------------"
	@echo "* Generating docker image..."
	@echo "-------------------------------------------"
	@docker build --rm . -t $(IMAGE_NAME)
	@docker system prune -f
#	@docker rmi $(docker images -f "dangling=true" -q)

## container: Execute docker image
container:
	@echo "-------------------------------------------"
	@echo "* Executing docker image..."
	@echo "-------------------------------------------"
	@docker run --rm -p 3000:3000 --name $(CONTAINER_NAME) $(IMAGE_NAME)

## upload: Upload docker image on DockerHub
uploaddh:
	@echo "-------------------------------------------"
	@echo "* Uploading docker image to DockerHub..."
	@echo "-------------------------------------------"
	@docker tag $(IMAGE_NAME) ashutoshsinha/$(IMAGE_NAME):$(IMAGE_VERSION)
	@docker login
	@docker push ashutoshsinha/$(IMAGE_NAME):$(IMAGE_VERSION)

## uploadgh: Upload docker image on GitHub
uploadgh:
	@docker images -q $(IMAGE_NAME)
	@docker tag $(IMAGE_NAME) docker.pkg.github.com/ashutoshkumarsinha/k8sexample/$(IMAGE_NAME):$(IMAGE_VERSION)
	@cat GH_TOKEN.txt | docker login docker.pkg.github.com -u ashutoshkumarsinha --password-stdin	
	@docker push docker.pkg.github.com/ashutoshkumarsinha/k8sexample/$(IMAGE_NAME):$(IMAGE_VERSION)