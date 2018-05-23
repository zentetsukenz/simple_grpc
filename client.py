from __future__ import print_function

import grpc

import spec_pb2
import spec_pb2_grpc


def run():
    channel = grpc.insecure_channel('localhost:8080')
    stub = spec_pb2_grpc.HealthCheckStub(channel)
    response = stub.Ping(spec_pb2.PingRequest())
    print("HealthCheck client received: " + response.stat)

run()
