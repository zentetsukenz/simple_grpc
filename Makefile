.PHONY: clean

container_name=simple_grpc
current_dir=$(shell pwd)

setup: ca client_good
start:
	docker run -d --name $(container_name) \
	-p 8080:80 \
	-v $(current_dir)/nginx.conf:/etc/nginx/nginx.conf:ro \
	-v $(current_dir)/ca.crt:/etc/nginx/server.crt:ro \
	-v $(current_dir)/ca.key:/etc/nginx/server.key:ro \
	nginx:1.14-alpine

ca:
	openssl req -x509 -newkey rsa:1024 -keyout ca.key -out ca.crt -nodes -days 365 -subj "/CN=localhost"

client_good_setup:
	openssl req -newkey rsa:1024 -keyout client_good.key -out client_good.csr -nodes -days 365 -subj "/CN=Good\ Client"

client_good: client_good_setup
	openssl x509 -req -in client_good.csr -CA ca.crt -CAkey ca.key -out client_good.crt -set_serial 1000 -days 90

clean:
	-rm -f *.key *.crt *.csr *.p12
	-docker rm -f $(container_name)