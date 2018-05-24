from __future__ import print_function

import grpc

import spec_pb2
import spec_pb2_grpc


def run():
    cert = open('ca.crt', 'rb').read()
    cert_chain = open('client.crt', 'rb').read()
    key = open('client.key', 'rb').read()
    creds = grpc.ssl_channel_credentials(root_certificates=cert, private_key=key, certificate_chain=cert_chain)

    channel = grpc.secure_channel('localhost:8080', creds)
    stub = spec_pb2_grpc.HealthCheckStub(channel)

    response = stub.Ping(spec_pb2.PingRequest())
    print("HealthCheck client received: " + response.stat)

run()
