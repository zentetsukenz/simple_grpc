.PHONY: clean

container_name=simple_grpc
current_dir=$(shell pwd)

setup: ca client_good build

ca:
	openssl req -x509 -newkey rsa:1024 -keyout ca.key -out ca.crt -nodes -days 365 -subj "/CN=localhost"

client_good:
	openssl req -newkey rsa:1024 -keyout client_good.key -out client_good.csr -nodes -days 365 -subj "/CN=Good\ Client"
	openssl x509 -req -in client_good.csr -CA ca.crt -CAkey ca.key -out client_good.crt -set_serial 1000 -days 90

build:
	docker build -t cheab/simple_grpc:1.0.0 .

clean:
	-rm -f *.key *.crt *.csr *.p12
	-docker rm -f $(container_name)
