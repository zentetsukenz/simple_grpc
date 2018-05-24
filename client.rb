$LOAD_PATH.unshift(File.expand_path(".", __dir__))

require "spec_pb"
require "spec_services_pb"

creds = GRPC::Core::ChannelCredentials.new(File.read("ca.crt"), File.read("client.key"), File.read("client.crt"))
stub = SimpleGrpc::HealthCheck::Stub.new('localhost:8080', creds)
response = stub.ping(SimpleGrpc::PingRequest.new)

puts response.stat
