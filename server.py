from concurrent import futures
import time
import datetime

import grpc

import spec_pb2
import spec_pb2_grpc

_ONE_DAY_IN_SECONDS = 60 * 60 * 24

class Ping(spec_pb2_grpc.HealthCheckServicer):
    def Ping(self, request, context):
        print("HealthCheck server received: " + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
        return spec_pb2.PingResponse(stat='Pong!')

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    spec_pb2_grpc.add_HealthCheckServicer_to_server(Ping(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    try:
        while True:
            time.sleep(_ONE_DAY_IN_SECONDS)
    except KeyboardInterrupt:
        server.stop(0)

serve()
