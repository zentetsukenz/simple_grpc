FROM python:3.6-slim

MAINTAINER "Wiwatta Mongkhonchit" <zentetsukenz@gmail.com>

ENV BUILD_PACKAGES="build-essential python-dev wget"

RUN apt-get update && \
    apt-get install -y $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists/*

ENV HOME=/home
ENV APP=/home/app

WORKDIR $APP

ADD server.py $APP
ADD spec_pb2.py $APP
ADD spec_pb2_grpc.py $APP

RUN python -m pip install --upgrade pip && \
    python -m pip install grpcio protobuf

RUN apt-get remove --purge -y $BUILD_PACKAGES && \
apt-get autoremove -y

EXPOSE 50051

CMD ["python", "server.py"]
