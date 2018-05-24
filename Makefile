.PHONY: clean

container_name=simple_grpc
current_dir=$(shell pwd)

setup: ca server_cert client_cert build

ca:
	openssl genrsa -out ca.key 1024
	openssl req -new -x509 -sha256 -days 365 -key ca.key -out ca.crt -subj "/CN=cheab"

server_cert: ca
	openssl genrsa -out server.key 1024
	openssl req -new -key server.key -sha256 -out server.csr -subj "/CN=localhost"
	openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 1 -out server.crt

client_cert: ca
	openssl genrsa -out client.key 1024
	openssl req -new -key client.key -sha256 -out client.csr -subj "/CN=client"
	openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 2 -out client.crt

build:
	docker build -t cheab/simple_grpc:1.0.0 .

clean:
	-rm -f *.key *.crt *.csr *.p12
	-docker rm -f $(container_name)
