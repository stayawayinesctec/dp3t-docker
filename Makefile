
#tag := $(shell git rev-parse --abbrev-ref HEAD)
tag := latest

build:
	docker build -t stayawayinesctec/dp3t-backendws:$(tag) ./backendws
	docker build -t stayawayinesctec/dp3t-authcodews:$(tag) ./authcodews
	docker build -t stayawayinesctec/dp3t-keycloak:$(tag) ./keycloak
	docker build -t stayawayinesctec/dp3t-frontend:$(tag) ./frontend

